/**
 * Workflow Stage Tracker Hook
 *
 * Tracks the current stage in the superpowers workflow to ensure
 * stages are followed in order and hard gates are respected.
 *
 * Hook Type: UserPromptSubmit
 * Trigger: Before user prompt is processed
 */

import { readFileSync, existsSync, mkdirSync, writeFileSync } from 'fs';
import { join, dirname } from 'path';

interface WorkflowState {
  currentStage: 'idle' | 'brainstorming' | 'writing-plans' | 'executing' | 'verification';
  lastStage: string;
  gatesPassed: string[];
  designApproved: boolean;
  planApproved: boolean;
  specDocumentPath?: string;
  planDocumentPath?: string;
}

const STATE_DIR = join(process.env.CLAUDE_PROJECT_DIR || '', '.claude', 'hooks', 'state');
const STATE_FILE = join(STATE_DIR, 'workflow-state.json');

// Ensure state directory exists
if (!existsSync(STATE_DIR)) {
  mkdirSync(STATE_DIR, { recursive: true });
}

// Load or initialize state
let state: WorkflowState;
if (existsSync(STATE_FILE)) {
  try {
    state = JSON.parse(readFileSync(STATE_FILE, 'utf-8'));
  } catch {
    state = {
      currentStage: 'idle',
      lastStage: '',
      gatesPassed: [],
      designApproved: false,
      planApproved: false
    };
  }
} else {
  state = {
    currentStage: 'idle',
    lastStage: '',
    gatesPassed: [],
    designApproved: false,
    planApproved: false
  };
}

// Detect user intent from prompt
function detectWorkflowIntent(prompt: string): { stage: string; action: string } | null {
  const lowerPrompt = prompt.toLowerCase();

  // Brainstorming triggers
  if (/\b(design|plan|approach|architecture|brainstorm|how should|what do you think)\b/.test(lowerPrompt)) {
    return { stage: 'brainstorming', action: 'start' };
  }

  // Writing-plans triggers
  if (/\b(implementation plan|break down|task breakdown|plan tasks|execute plan)\b/.test(lowerPrompt)) {
    if (!state.designApproved) {
      return { stage: 'brainstorming', action: 'required_first' };
    }
    return { stage: 'writing-plans', action: 'start' };
  }

  // Execution triggers
  if (/\b(implement|execute|code|write|create|add|build)\b/.test(lowerPrompt)) {
    if (!state.planApproved) {
      if (!state.designApproved) {
        return { stage: 'brainstorming', action: 'required_first' };
      }
      return { stage: 'writing-plans', action: 'required_first' };
    }
    return { stage: 'executing', action: 'start' };
  }

  // Verification triggers
  if (/\b(done|complete|finished|passing|ready|verified|works)\b/.test(lowerPrompt)) {
    return { stage: 'verification', action: 'start' };
  }

  return null;
}

// Check stage transitions
function validateTransition(intent: { stage: string; action: string }): string[] {
  const warnings: string[] = [];

  if (intent.action === 'required_first') {
    warnings.push(`⚠️  You must complete the ${intent.stage} stage first.`);
    warnings.push(`The superpowers workflow requires: design → plan → execute → verify`);
    return warnings;
  }

  if (intent.stage === 'executing' && !state.planApproved) {
    warnings.push('⚠️  You must create an implementation plan before executing.');
    warnings.push('Use the writing-plans skill to create a detailed plan.');
  }

  if (intent.stage === 'verification' && state.currentStage !== 'executing') {
    warnings.push('⚠️  Verification should come after execution.');
    warnings.push('Make sure you have completed all implementation tasks.');
  }

  return warnings;
}

// Update state based on stage
function updateState(stage: string) {
  state.lastStage = state.currentStage;
  state.currentStage = stage;

  // Mark gates as passed
  if (stage === 'writing-plans') {
    state.designApproved = true;
    state.gatesPassed.push('design-approval');
  }
  if (stage === 'executing') {
    state.planApproved = true;
    state.gatesPassed.push('plan-approval');
  }
  if (stage === 'verification') {
    state.gatesPassed.push('execution-complete');
  }

  // Save state
  writeFileSync(STATE_FILE, JSON.stringify(state, null, 2));
}

// Main hook logic
const prompt = process.env.HOOK_PROMPT || '';
const intent = detectWorkflowIntent(prompt);

if (intent) {
  const warnings = validateTransition(intent);

  if (warnings.length > 0) {
    console.log('\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    console.log('🚧 WORKFLOW STAGE TRACKER');
    console.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');

    warnings.forEach(warning => console.log(warning));

    console.log(`\nCurrent Stage: ${state.currentStage}`);
    console.log(`Stages Completed: ${state.gatesPassed.join(', ') || 'none'}`);

    if (state.currentStage === 'idle') {
      console.log('\n💡 Tip: Start with the brainstorming skill to refine your idea.');
    }

    console.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');
  } else {
    // Valid transition, update state
    updateState(intent.stage);

    console.log(`\n✓ Workflow Stage: ${intent.stage}`);
  }
}

export {};
