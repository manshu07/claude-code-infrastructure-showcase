---
name: subagent-driven-development
description: Use when executing implementation plans with independent tasks in the current session. Dispatches fresh subagent per task with two-stage review (spec compliance then code quality). Prevents context pollution, ensures spec compliance, catches quality issues early. Critical for: feature implementation, plan execution, multi-task workflows. Requires writing-plans skill first.
---

# Subagent-Driven Development

## Purpose

Execute implementation plans by dispatching fresh subagents per task, with two-stage review after each: spec compliance review first, then code quality review.

## When to Use This Skill

**Use AFTER:**
- writing-plans skill has created a plan
- Plan has been reviewed and approved
- User has chosen subagent-driven execution

**Use WHEN:**
- Executing implementation plans with independent tasks
- Staying in the current session (no context switch)
- Tasks are mostly independent (can be executed separately)

**Don't use for:**
- Tightly coupled tasks that must be done together
- Parallel session execution (use executing-plans instead)
- Tasks requiring deep context inheritance

---

## Core Principles

**Why subagents:**
- Delegate tasks to specialized agents with isolated context
- Precisely craft their instructions and context
- Ensure they stay focused and succeed
- They never inherit your session's context or history
- Preserve your own context for coordination work

**Core principle:** Fresh subagent per task + two-stage review (spec then quality) = high quality, fast iteration

---

## When to Use (Decision Flow)

```
Have implementation plan?
    ↓ YES
Tasks mostly independent?
    ↓ YES
Stay in this session?
    ↓ YES
→ Use subagent-driven-development
    ↓ NO (want parallel session)
→ Use executing-plans
    ↓ NO (tightly coupled)
→ Manual execution or brainstorm first
```

**vs. Executing Plans (parallel session):**
- Same session (no context switch)
- Fresh subagent per task (no context pollution)
- Two-stage review after each task: spec compliance first, then code quality
- Faster iteration (no human-in-loop between tasks)

---

## The Process

### Per Task:

1. **Dispatch implementer subagent** with task text + context
2. **Implementer asks questions?** → Answer, provide context, re-dispatch
3. **Implementer implements, tests, commits, self-reviews** → Wait for completion
4. **Dispatch spec reviewer subagent** → Check code matches spec
5. **Spec reviewer approves?**
   - NO → Implementer fixes spec gaps → Re-review
   - YES → Continue
6. **Dispatch code quality reviewer subagent** → Check code quality
7. **Code quality reviewer approves?**
   - NO → Implementer fixes quality issues → Re-review
   - YES → Continue
8. **Mark task complete** → Move to next task

### After All Tasks:

1. **Dispatch final code reviewer** for entire implementation
2. **Use finishing-a-development-branch** skill to complete

---

## Model Selection Strategy

Use the least powerful model that can handle each role to conserve cost and increase speed.

### Mechanical Implementation Tasks

**Characteristics:**
- Isolated functions
- Clear specs
- 1-2 files to touch
- Straightforward implementation

**Use:** Fast, cheap model (Haiku)

**Most implementation tasks are mechanical when the plan is well-specified.**

### Integration and Judgment Tasks

**Characteristics:**
- Touches multiple files
- Integration concerns
- Pattern matching required
- Some debugging needed

**Use:** Standard model (Sonnet)

### Architecture, Design, and Review Tasks

**Characteristics:**
- Requires design judgment
- Broad codebase understanding
- Complex trade-offs
- Security or performance implications

**Use:** Most capable model (Opus)

### Task Complexity Signals

| Signal | Model |
|--------|-------|
| Touches 1-2 files with complete spec | Cheap (Haiku) |
| Touches multiple files with integration | Standard (Sonnet) |
| Requires design judgment or broad understanding | Capable (Opus) |

---

## Handling Implementer Status

Implementer subagents report one of four statuses. Handle each appropriately:

### DONE

**Meaning:** Task completed successfully

**Action:** Proceed to spec compliance review

### DONE_WITH_CONCERNS

**Meaning:** Implementer completed work but flagged doubts

**Action:**
1. Read the concerns before proceeding
2. If concerns about correctness or scope → Address before review
3. If observations (e.g., "this file is getting large") → Note and proceed to review

### NEEDS_CONTEXT

**Meaning:** Implementer needs information that wasn't provided

**Action:**
1. Provide the missing context
2. Re-dispatch with same model
3. Don't let implementer proceed without needed information

### BLOCKED

**Meaning:** Implementer cannot complete the task

**Action:**
1. Assess the blocker:
   - Context problem? → Provide more context, re-dispatch with same model
   - Requires more reasoning? → Re-dispatch with more capable model
   - Task too large? → Break into smaller pieces
   - Plan wrong? → Escalate to human

**Never:**
- Ignore an escalation
- Force same model to retry without changes
- Proceed without addressing the block

---

## Red Flags - STOP

**Never:**
- Start implementation on main/master branch without explicit user consent
- Skip reviews (spec compliance OR code quality)
- Proceed with unfixed issues
- Dispatch multiple implementation subagents in parallel (conflicts)
- Make subagent read plan file (provide full text instead)
- Skip scene-setting context (subagent needs to understand where task fits)
- Ignore subagent questions (answer before letting them proceed)
- Accept "close enough" on spec compliance (spec reviewer found issues = not done)
- Skip review loops (reviewer found issues = implementer fixes = review again)
- Let implementer self-review replace actual review (both are needed)
- **Start code quality review before spec compliance is ✅** (wrong order)
- Move to next task while either review has open issues

**If subagent asks questions:**
- Answer clearly and completely
- Provide additional context if needed
- Don't rush them into implementation

**If reviewer finds issues:**
- Implementer (same subagent) fixes them
- Reviewer reviews again
- Repeat until approved
- Don't skip the re-review

**If subagent fails task:**
- Dispatch fix subagent with specific instructions
- Don't try to fix manually (context pollution)

---

## Advantages

### vs. Manual Execution

- ✅ Subagents follow TDD naturally
- ✅ Fresh context per task (no confusion)
- ✅ Parallel-safe (subagents don't interfere)
- ✅ Subagent can ask questions (before AND during work)

### vs. Executing Plans

- ✅ Same session (no handoff)
- ✅ Continuous progress (no waiting)
- ✅ Review checkpoints automatic

### Efficiency Gains

- ✅ No file reading overhead (controller provides full text)
- ✅ Controller curates exactly what context is needed
- ✅ Subagent gets complete information upfront
- ✅ Questions surfaced before work begins (not after)

### Quality Gates

- ✅ Self-review catches issues before handoff
- ✅ Two-stage review: spec compliance, then code quality
- ✅ Review loops ensure fixes actually work
- ✅ Spec compliance prevents over/under-building
- ✅ Code quality ensures implementation is well-built

### Cost Considerations

- More subagent invocations (implementer + 2 reviewers per task)
- Controller does more prep work (extracting all tasks upfront)
- Review loops add iterations
- **But catches issues early** (cheaper than debugging later)

---

## Example Workflow

```
You: I'm using Subagent-Driven Development to execute this plan.

[Read plan file once: docs/superpowers/plans/feature-plan.md]
[Extract all 5 tasks with full text and context]
[Create TodoWrite with all tasks]

Task 1: Hook installation script

[Get Task 1 text and context (already extracted)]
[Dispatch implementation subagent with full task text + context]

Implementer: "Before I begin - should the hook be installed at user or system level?"

You: "User level (~/.config/superpowers/hooks/)"

Implementer: "Got it. Implementing now..."
[Later]
Implementer:
  - Implemented install-hook command
  - Added tests, 5/5 passing
  - Self-review: Found I missed --force flag, added it
  - Committed

[Dispatch spec compliance reviewer]
Spec reviewer: ✅ Spec compliant - all requirements met, nothing extra

[Get git SHAs, dispatch code quality reviewer]
Code reviewer: Strengths: Good test coverage, clean. Issues: None. Approved.

[Mark Task 1 complete]

Task 2: Recovery modes

[Get Task 2 text and context (already extracted)]
[Dispatch implementation subagent with full task text + context]

Implementer: [No questions, proceeds]
Implementer:
  - Added verify/repair modes
  - 8/8 tests passing
  - Self-review: All good
  - Committed

[Dispatch spec compliance reviewer]
Spec reviewer: ❌ Issues:
  - Missing: Progress reporting (spec says "report every 100 items")
  - Extra: Added --json flag (not requested)

[Implementer fixes issues]
Implementer: Removed --json flag, added progress reporting

[Spec reviewer reviews again]
Spec reviewer: ✅ Spec compliant now

[Dispatch code quality reviewer]
Code reviewer: Strengths: Solid. Issues (Important): Magic number (100)

[Implementer fixes]
Implementer: Extracted PROGRESS_INTERVAL constant

[Code reviewer reviews again]
Code reviewer: ✅ Approved

[Mark Task 2 complete]

...

[After all tasks]
[Dispatch final code-reviewer]
Final reviewer: All requirements met, ready to merge

Done!
```

---

## Integration with Other Skills

**Required previous step:**
- **writing-plans** - Creates the plan this skill executes

**Required sub-skills:**
- **test-driven-development** - Subagents follow TDD for each task
- **verification-before-completion** - Verify completion before claiming done

**Related skills:**
- **executing-plans** - Alternative: batch execution with checkpoints
- **finishing-a-development-branch** - Complete development after all tasks

**Agents to use:**
- Implementer subagent (dispatch per task)
- Spec reviewer subagent (dispatch per task)
- Code quality reviewer subagent (dispatch per task)
- Final code reviewer (dispatch after all tasks)

---

## Quick Reference

### Model Selection

| Task Type | Use Model |
|-----------|-----------|
| Mechanical (1-2 files, clear spec) | Haiku (fast, cheap) |
| Integration (multiple files) | Sonnet (standard) |
| Architecture/design/judgment | Opus (capable) |

### Status Handling

| Status | Action |
|--------|--------|
| DONE | Proceed to spec review |
| DONE_WITH_CONCERNS | Review concerns, proceed if minor |
| NEEDS_CONTEXT | Provide context, re-dispatch |
| BLOCKED | Assess blocker, fix or escalate |

### Review Order

1. ✅ Spec compliance review (MUST BE FIRST)
2. ✅ Code quality review (ONLY AFTER spec approved)

### Never Skip

- Reviews (both spec and quality)
- Re-review after fixes
- Scene-setting context
- Answering subagent questions

---

**Remember:** Fresh subagent per task + two-stage review = high quality, fast iteration. Don't skip reviews, don't skip re-reviews, and never start code quality review before spec compliance is approved.
