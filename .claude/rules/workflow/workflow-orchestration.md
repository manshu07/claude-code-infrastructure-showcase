# Workflow Orchestration Rules

## Purpose

Define the complete workflow from idea to completion, ensuring all stages are followed in order with proper gates and verification.

## Pre-Workflow: Check Before Create

**MANDATORY STEP** before any component creation:

```bash
# Search for existing components first
./.claude/scripts/search-existing.sh "<keyword>"

# Review results:
# - If exists: REUSE or ENHANCE existing component
# - If not: Create new component with clear differentiation
```

See [check-before-create.md](./check-before-create.md) for complete details.

**Examples:**
- Creating agent? Search existing agents first
- Creating skill? Check skill-rules.json for conflicts
- Creating script? Check scripts directory first

## Complete Workflow

```
User Request
    ↓
[PRE-WORKFLOW] Check Before Create
    ├── Search existing components
    ├── Reuse if possible
    └── Create new only if needed
    ↓
[STAGE 1] brainstorming
    ├── Explore project context
    ├── Ask clarifying questions (one at a time)
    ├── Propose 2-3 approaches
    ├── Present design (section by section)
    ├── User approves design
    ├── Write design document
    ├── Spec review loop (subagent)
    ├── User reviews spec
    └── Transition to writing-plans
    ↓
[STAGE 2] writing-plans
    ├── Map file structure
    ├── Break into bite-sized tasks (2-5 min each)
    ├── Write complete plan with exact paths
    ├── Plan review loop (subagent)
    └── Execution handoff
    ↓
[STAGE 3] Domain Guidance (optional)
    ├── Load domain skill as needed
    ├── Apply domain-specific patterns
    └── Continue to execution
    ↓
[STAGE 4] subagent-driven-development
    ├── For each task:
    │   ├── Dispatch implementer subagent
    │   ├── Handle questions/context
    │   ├── Implementer completes + self-reviews
    │   ├── Dispatch spec reviewer
    │   ├── Fix spec gaps if needed
    │   ├── Dispatch code quality reviewer
    │   ├── Fix quality issues if needed
    │   └── Mark task complete
    ├── Dispatch final code reviewer
    └── All tasks complete
    ↓
[STAGE 5] verification-before-completion
    ├── Run verification commands
    ├── Check output
    ├── Confirm all requirements met
    └── Claim complete WITH evidence
    ↓
Complete ✅
```

## Post-Edit Workflow

**MANDATORY STEP** after editing any existing file:

```
Edited a file?
    ↓
[POST-EDIT] Edit With Permission
    ├── READ the file first (show existing content)
    ├── SHOW what will change
    ├── EXPLAIN the change
    ├── ASK for permission
    ├── Make edit (if user says yes)
    ├── Update related files
    │   ├── skill-rules.json (if skill edited)
    │   ├── README.md (if major change)
    │   └── Files that reference this file
    ├── Update documentation
    ├── Commit to git
    └── Push to repository
```

See [edit-with-permission.md](./edit-with-permission.md) for complete details.

**Quick Script:**
```bash
# After editing a file:
./.claude/scripts/update-after-edit.sh <file-edited> <commit-type> "<commit-message>"

# Example:
./.claude/scripts/update-after-edit.sh .claude/skills/new-skill/SKILL.md feat "Added new skill"
```

**Required Steps:**
1. ✅ Read file before editing
2. ✅ Show existing content to user
3. ✅ Ask permission before editing
4. ✅ Update related documentation
5. ✅ Update README if needed
6. ✅ Commit to git
7. ✅ Push to repository

## Stage Requirements

### Stage 1: brainstorming

**Hard Gate:** NO implementation before design approval

**Required Actions:**
- Explore project context (files, docs, commits)
- Ask clarifying questions ONE AT A TIME
- Offer visual companion if visual questions expected
- Propose 2-3 approaches with trade-offs
- Present design section by section
- Get user approval after each section
- Write design document to `docs/superpowers/specs/`
- Dispatch spec-document-reviewer subagent
- Fix issues until approved (max 3 iterations)
- Ask user to review written spec
- **ONLY THEN** transition to writing-plans

**Cannot skip to:** writing-plans, implementation, code writing

### Stage 2: writing-plans

**Hard Gate:** NO code before plan approval

**Required Actions:**
- Map file structure (all files to create/modify)
- Break into bite-sized tasks (2-5 minutes each)
- Write exact file paths
- Include complete code for each step
- Include exact commands with expected output
- Follow TDD cycle for each task
- Write plan to `docs/superpowers/plans/`
- Dispatch plan-document-reviewer subagent
- Fix issues until approved
- Offer execution choice (subagent vs inline)

**Cannot skip to:** implementation, code writing

### Stage 3: Domain Guidance

**Optional:** Load domain skills as needed

**When to use:**
- Backend work → backend-dev-guidelines
- Frontend work → frontend-dev-guidelines
- Python work → python-dev-guidelines
- Django work → django-dev-guidelines
- FastAPI work → fastapi-dev-guidelines
- DevOps work → devops-guidelines
- Security work → security-guidelines

**Purpose:** Apply domain-specific patterns and conventions

### Stage 4: subagent-driven-development

**Hard Gate:** Two-stage review after each task

**Required Actions:**
- Read plan once, extract all tasks
- Create TodoWrite with all tasks
- For EACH task:
  - Dispatch implementer subagent
  - Answer questions, provide context
  - Wait for completion
  - Check status (DONE/DONE_WITH_CONCERNS/NEEDS_CONTEXT/BLOCKED)
  - Handle appropriately
  - Dispatch spec reviewer subagent
  - Fix spec gaps if needed
  - Re-review until approved
  - Dispatch code quality reviewer subagent
  - Fix quality issues if needed
  - Re-review until approved
  - Mark task complete
- After all tasks: Dispatch final code reviewer
- Use finishing-a-development-branch skill

**Cannot skip:** Reviews (spec compliance FIRST, then code quality)

### Stage 5: verification-before-completion

**Hard Gate:** Evidence before claiming complete

**Required Actions:**
- IDENTIFY verification command
- RUN command (fresh, complete)
- READ full output
- CHECK exit code and results
- VERIFY output matches claim
- CLAIM complete WITH evidence

**Cannot skip:** Running verification, providing evidence

## Forbidden Transitions

### ❌ Cannot Skip Stages

- brainstorming → implementation (BLOCKED)
- Request → code writing (BLOCKED)
- Idea → implementation (BLOCKED)
- writing-plans → execution (BLOCKED if plan not approved)

### ❌ Cannot Skip Reviews

- Implementation without spec review (BLOCKED)
- Spec review without code quality review (BLOCKED)
- Completion without verification (BLOCKED)

### ❌ Cannot Skip Gates

- Design approval (BLOCKED)
- Plan approval (BLOCKED)
- Spec compliance (BLOCKED)
- Code quality review (BLOCKED)
- Verification (BLOCKED)

## Order Requirements

### Correct Order

1. ✅ Design → Plan → Execute → Verify
2. ✅ Spec review → Code quality review
3. ✅ RED → GREEN → REFACTOR → Commit

### Incorrect Order

1. ❌ Design → Execute (no plan)
2. ❌ Request → Code (no design)
3. ❌ Code quality → Spec review (wrong order)
4. ❌ GREEN → RED (no TDD)
5. ❌ Verify → Complete (wrong direction)

## Integration with Skills

### Required Skills (in order)

1. **brainstorming** - Design refinement
2. **writing-plans** - Implementation planning
3. **[domain skills]** - Domain guidance (optional)
4. **subagent-driven-development** - Execution
5. **test-driven-development** - TDD for each task
6. **verification-before-completion** - Evidence before claims

### Supporting Skills

- **spec-document-reviewer** agent - Review design specs
- **plan-document-reviewer** agent - Review implementation plans
- **implementer** agent - Execute tasks
- **spec-reviewer** agent - Check spec compliance
- **code-quality-reviewer** agent - Check code quality

## Workflow Automation

### Hooks

**workflow-stage-tracker** - Track current stage:
- Prevents skipping stages
- Ensures gates are respected
- Maintains stage state

**hard-gate-enforcer** - Enforce hard gates:
- Blocks implementation before design
- Blocks code before plan
- Blocks completion before verification

### Scripts

**verify-workflow-compliance.sh** - Check workflow:
- Verify all stages completed in order
- Check all gates passed
- Verify evidence provided
- Report compliance status

## Common Violations

### Violation 1: "I Already Know What to Build"

**Reality:** Unexamined assumptions cause wasted work.

**Action:** BLOCK - Require brainstorming stage

### Violation 2: "Planning Takes Too Long"

**Reality:** Planning saves time overall.

**Action:** BLOCK - Require writing-plans stage

### Violation 3: "I'll Review Later"

**Reality:** Reviews catch issues early.

**Action:** BLOCK - Require reviews before continuing

### Violation 4: "Just This Once"

**Reality:** "Just this once" = every time.

**Action:** BLOCK - No exceptions to workflow

## Verification Checklist

Before marking workflow complete:

- [ ] brainstorming stage completed
  - [ ] Design approved
  - [ ] Spec document written
  - [ ] Spec review passed
  - [ ] User reviewed spec
- [ ] writing-plans stage completed
  - [ ] File structure mapped
  - [ ] Tasks broken down (2-5 min each)
  - [ ] Plan review passed
- [ ] Domain guidance applied (if needed)
- [ ] subagent-driven-development stage completed
  - [ ] All tasks executed
  - [ ] Spec compliance verified
  - [ ] Code quality verified
  - [ ] Final review passed
- [ ] verification-before-completion stage completed
  - [ ] Verification commands run
  - [ ] Evidence collected
  - [ ] Output confirms completion

Can't check all boxes? Workflow not complete.

## Training Requirements

All developers MUST understand:

1. **Why workflow matters** - Prevents mistakes, saves time
2. **Stage purposes** - What each stage accomplishes
3. **Gate importance** - Why gates exist
4. **Review value** - How reviews improve quality
5. **Verification necessity** - Evidence before claims

---

**Remember:** The workflow exists for a reason. Skipping stages or gates doesn't save time — it creates rework. Follow the complete workflow every time.
