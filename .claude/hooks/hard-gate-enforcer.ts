/**
 * Hard Gate Enforcer Hook
 *
 * Enforces hard gates in the superpowers workflow:
 * - NO implementation before design approval
 * - NO code before plan approval
 * - NO completion claims without verification
 *
 * Hook Type: PreToolUse
 * Trigger: Before Edit/Write tools execute
 */

import { readFileSync, existsSync } from 'fs';
import { join } from 'path';

interface WorkflowState {
  currentStage: string;
  designApproved: boolean;
  planApproved: boolean;
  specDocumentPath?: string;
  planDocumentPath?: string;
}

const STATE_FILE = join(process.env.CLAUDE_PROJECT_DIR || '', '.claude', 'hooks', 'state', 'workflow-state.json');

// Load workflow state
function loadState(): WorkflowState | null {
  if (!existsSync(STATE_FILE)) {
    return null;
  }

  try {
    return JSON.parse(readFileSync(STATE_FILE, 'utf-8'));
  } catch {
    return null;
  }
}

// Check if tool should be blocked
function shouldBlockTool(toolName: string, input: any): { block: boolean; reason?: string } {
  const state = loadState();

  if (!state) {
    // No state yet, allow but warn
    return { block: false };
  }

  // Block Edit/Write tools if design not approved
  if ((toolName === 'Edit' || toolName === 'Write' || toolName === 'MultiEdit') && !state.designApproved) {
    return {
      block: true,
      reason: 'Hard Gate: Design approval required before implementation'
    };
  }

  // Block Edit/Write tools if plan not approved (unless creating design docs)
  if ((toolName === 'Edit' || toolName === 'Write' || toolName === 'MultiEdit') &&
      !state.planApproved &&
      state.currentStage !== 'brainstorming') {

    // Allow creating spec documents
    if (input.file_path && input.file_path.includes('specs/')) {
      return { block: false };
    }

    // Allow creating plan documents
    if (input.file_path && input.file_path.includes('plans/')) {
      return { block: false };
    }

    return {
      block: true,
      reason: 'Hard Gate: Implementation plan approval required before coding'
    };
  }

  return { block: false };
}

// Main hook logic
const toolName = process.env.HOOK_TOOL_NAME || '';
const toolInput = process.env.HOOK_TOOL_INPUT ? JSON.parse(process.env.HOOK_TOOL_INPUT) : {};

const check = shouldBlockTool(toolName, toolInput);

if (check.block) {
  console.error('\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
  console.error('🚫 HARD GATE VIOLATION');
  console.error('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');
  console.error(`Reason: ${check.reason}\n`);
  console.error('The superpowers workflow requires:');
  console.error('1. brainstorming (design refinement)');
  console.error('2. writing-plans (implementation plan)');
  console.error('3. execution (with subagent-driven-development)');
  console.error('4. verification (evidence before claims)');
  console.error('\nPlease follow the workflow stages in order.');
  console.error('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');

  // Exit with error code to block the tool
  process.exit(2);
}

export {};
