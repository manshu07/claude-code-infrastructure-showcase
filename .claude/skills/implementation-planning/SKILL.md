---
name: writing-plans
description: Use when you have a spec or requirements for a multi-step task, before touching code. Creates comprehensive implementation plans with bite-sized tasks (2-5 minutes each). Critical for: feature implementation, system changes, refactoring, migrations. Prevents overwhelmed implementers, missing requirements, and architectural drift. Must complete after brainstorming, before any code.
---

# Writing Implementation Plans

## Purpose

Create comprehensive implementation plans that guide execution from spec to working software, assuming the implementer has zero context for the codebase.

## When to Use This Skill

**Use AFTER:**
- brainstorming skill has completed
- Spec document has been written and approved
- User has reviewed and approved the design

**Use BEFORE:**
- Touching any code
- Creating any files
- Running any implementation commands

**Announce at start:** "I'm using the writing-plans skill to create the implementation plan."

**Context:** This should be run in a dedicated worktree (created by brainstorming skill).

**Save plans to:** `docs/superpowers/plans/YYYY-MM-DD-<feature-name>.md`
(Override this path if user has different preferences)

---

## Core Principles

**Assume the implementer:**
- Is a skilled developer
- Knows almost nothing about your toolset or problem domain
- Doesn't know good test design very well
- Has zero context for the codebase
- Has questionable taste (no offense intended)
- Needs complete information to succeed

**Document everything they need:**
- Which files to touch for each task
- Complete code to write
- How to test it
- Docs they might need to check
- How to verify it works

**Key patterns:**
- DRY (Don't Repeat Yourself)
- YAGNI (You Aren't Gonna Need It)
- TDD (Test-Driven Development)
- Frequent commits

---

## Scope Check

**If the spec covers multiple independent subsystems**, it should have been broken into sub-project specs during brainstorming. If it wasn't:

- Suggest breaking this into separate plans — one per subsystem
- Each plan should produce working, testable software on its own
- Don't create a monolithic plan that tries to do everything at once

---

## File Structure Mapping

**Before defining tasks**, map out which files will be created or modified and what each one is responsible for.

### Design Units with Clear Boundaries

Each file should have:
- One clear responsibility
- Well-defined interfaces
- Can be understood independently

**Key questions for each file:**
- What does it do?
- How do you use it?
- What does it depend on?

**Preferred organization:**
- Files that change together should live together
- Split by responsibility, not by technical layer
- Smaller, focused files over large ones
- You reason best about code you can hold in context at once

### In Existing Codebases

- Follow established patterns
- If a file you're modifying has grown unwieldy, including a split in the plan is reasonable
- Don't unilaterally restructure the entire codebase
- Stay focused on what serves the current goal

**This structure informs the task decomposition.** Each task should produce self-contained changes that make sense independently.

---

## Bite-Sized Task Granularity

**Each step is one action (2-5 minutes):**

- ❌ BAD: "Implement user authentication" (too vague, hours of work)
- ✅ GOOD: "Write the failing test" (one action, 2-5 minutes)
- ✅ GOOD: "Run it to make sure it fails" (one action, 30 seconds)
- ✅ GOOD: "Write minimal code to make test pass" (one action, 2-5 minutes)
- ✅ GOOD: "Run test to verify it passes" (one action, 30 seconds)
- ✅ GOOD: "Commit" (one action, 30 seconds)

**If a step would take more than 5 minutes, break it down further.**

---

## Plan Document Header

**Every plan MUST start with this header:**

```markdown
# [Feature Name] Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** [One sentence describing what this builds]

**Architecture:** [2-3 sentences about approach]

**Tech Stack:** [Key technologies/libraries]

---
```

---

## Task Structure

````markdown
### Task N: [Component Name]

**Files:**
- Create: `exact/path/to/file.py`
- Modify: `exact/path/to/existing.py:123-145`
- Test: `tests/exact/path/to/test.py`

- [ ] **Step 1: Write the failing test**

```python
def test_specific_behavior():
    result = function(input)
    assert result == expected
```

- [ ] **Step 2: Run test to verify it fails**

Run: `pytest tests/path/test.py::test_name -v`
Expected: FAIL with "function not defined"

- [ ] **Step 3: Write minimal implementation**

```python
def function(input):
    return expected
```

- [ ] **Step 4: Run test to verify it passes**

Run: `pytest tests/path/test.py::test_name -v`
Expected: PASS

- [ ] **Step 5: Commit**

```bash
git add tests/path/test.py src/path/file.py
git commit -m "feat: add specific feature"
```
````

---

## Remember

- ✅ **Exact file paths always** - No "create a test file", use exact paths
- ✅ **Complete code in plan** - No "add validation", include the code
- ✅ **Exact commands with expected output** - Run command, show what to expect
- ✅ **Reference relevant skills** - Use @ syntax for skill references
- ✅ **DRY, YAGNI, TDD, frequent commits** - Core principles

---

## Plan Review Loop

**After writing the complete plan:**

### 1. Dispatch Plan Document Reviewer

Dispatch a **plan-document-reviewer** subagent with precisely crafted review context:

```markdown
Review the implementation plan at: docs/superpowers/plans/[plan-name].md

Spec document: docs/superpowers/specs/[spec-name].md

Focus on:
- Completeness - are all requirements addressed?
- Clarity - is each task unambiguous?
- Feasibility - can each task be completed in 2-5 minutes?
- Correctness - will executing this plan produce the intended result?
- Missing steps - what's been overlooked?
```

**IMPORTANT:** Never use your session history as review context. Keep the reviewer focused on the plan and spec documents.

### 2. Handle Review Feedback

**If ❌ Issues Found:**
- Fix the issues
- Re-dispatch the reviewer for the entire plan (not just fixes)
- Repeat until approved

**If ✅ Approved:**
- Proceed to execution handoff

**Review loop guidance:**
- Same agent that wrote the plan fixes it (preserves context)
- If loop exceeds 3 iterations, surface to human for guidance
- Reviewers are advisory — explain disagreements if you believe feedback is incorrect

---

## Execution Handoff

**After saving the plan**, offer execution choice:

```
"Plan complete and saved to `docs/superpowers/plans/<filename>.md`. Two execution options:

**1. Subagent-Driven (recommended)** - I dispatch a fresh subagent per task, review between tasks, fast iteration

**2. Inline Execution** - Execute tasks in this session using executing-plans, batch execution with checkpoints

Which approach?"
```

### If Subagent-Driven Chosen

- **REQUIRED SUB-SKILL:** Use superpowers:subagent-driven-development
- Fresh subagent per task
- Two-stage review after each task (spec compliance → code quality)
- Fast iteration without human-in-loop between tasks

### If Inline Execution Chosen

- **REQUIRED SUB-SKILL:** Use superpowers:executing-plans
- Batch execution with checkpoints for review
- Human reviews between batches of tasks

---

## Common Mistakes to Avoid

### ❌ Tasks Too Large

```
### Task 1: Implement user authentication
- Create user model
- Add password hashing
- Implement login endpoint
- Add JWT token generation
- Write tests
```

**Problem:** Too much for one task, will take hours.

**Fix:** Break into bite-sized steps:

```
### Task 1: User model and basic structure
- [ ] Write failing test for user model
- [ ] Run test to verify it fails
- [ ] Implement user model with email/password
- [ ] Run test to verify it passes
- [ ] Commit

### Task 2: Password hashing
- [ ] Write failing test for password hashing
- [ ] Run test to verify it fails
- [ ] Implement bcrypt password hashing
- [ ] Run test to verify it passes
- [ ] Commit
```

### ❌ Vague Instructions

```
- [ ] Add validation to the user form
```

**Problem:** What validation? How to implement?

**Fix:** Be explicit:

```
- [ ] **Step 1: Write failing test for email validation**

```python
def test_email_validation():
    with pytest.raises(ValueError):
        User(email="invalid").validate()
```

- [ ] **Step 2: Run test to verify it fails**

Run: `pytest tests/user_test.py::test_email_validation -v`
Expected: FAIL with "no validation"

- [ ] **Step 3: Implement email validation**

```python
import re

def validate_email(email):
    if not re.match(r'^[^@]+@[^@]+\.[^@]+$', email):
        raise ValueError("Invalid email")
```
```

### ❌ Missing File Paths

```
- [ ] Create a test file
- [ ] Create the implementation file
```

**Problem:** Where do these files go?

**Fix:** Always use exact paths:

```
**Files:**
- Create: `tests/backend/services/user_service_test.py`
- Create: `backend/services/user_service.py`
```

### ❌ No Expected Output

```
- [ ] Run the tests
```

**Problem:** What should happen?

**Fix:** Always specify expected output:

```
- [ ] **Step 2: Run test to verify it fails**

Run: `pytest tests/path/test.py::test_name -v`
Expected: FAIL with "function not defined"
```

---

## Integration with Other Skills

**Required previous step:**
- **brainstorming** - Must complete design and spec first

**Required next step:**
- **subagent-driven-development** - Execute plan with subagents
- **executing-plans** - Alternative: execute in batches with checkpoints

**Related skills:**
- **test-driven-development** - All tasks follow TDD cycle
- **verification-before-completion** - Verify completion before claiming done

---

## Example Plan Excerpt

````markdown
# User Authentication Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use subagent-driven-development to implement this plan task-by-task.

**Goal:** Build email/password authentication with JWT tokens

**Architecture:** User model with bcrypt password hashing, JWT token generation on login, protected routes requiring valid token

**Tech Stack:** FastAPI, bcrypt, PyJWT, Pydantic

---

### Task 1: User Model

**Files:**
- Create: `app/models/user.py`
- Create: `tests/models/user_test.py`

- [ ] **Step 1: Write failing test for user creation**

```python
def test_create_user():
    user = User(email="test@example.com", password="secret123")
    assert user.email == "test@example.com"
    assert user.check_password("secret123") == True
    assert user.check_password("wrong") == False
```

- [ ] **Step 2: Run test to verify it fails**

Run: `pytest tests/models/user_test.py::test_create_user -v`
Expected: FAIL with "User not defined"

- [ ] **Step 3: Implement user model**

```python
import bcrypt

class User:
    def __init__(self, email, password):
        self.email = email
        self.password_hash = bcrypt.hashpw(password.encode(), bcrypt.gensalt())

    def check_password(self, password):
        return bcrypt.checkpw(password.encode(), self.password_hash)
```

- [ ] **Step 4: Run test to verify it passes**

Run: `pytest tests/models/user_test.py::test_create_user -v`
Expected: PASS

- [ ] **Step 5: Commit**

```bash
git add app/models/user.py tests/models/user_test.py
git commit -m "feat: add user model with bcrypt password hashing"
```
````

---

## Verification Checklist

Before marking plan complete:

- [ ] Plan header with goal, architecture, tech stack
- [ ] All tasks are bite-sized (2-5 minutes each)
- [ ] Each task has exact file paths
- [ ] Each step has complete code
- [ ] Each test run has expected output
- [ ] TDD cycle in every task (test → fail → implement → pass → commit)
- [ ] References to relevant skills
- [ ] Plan reviewed by plan-document-reviewer
- [ ] All review issues addressed

**Can't check all boxes?** Plan isn't ready for execution.

---

**Remember:** The plan is the contract between design and implementation. Make it comprehensive, make it clear, make it unambiguous. A good plan means anyone can implement it successfully, even with zero context.
