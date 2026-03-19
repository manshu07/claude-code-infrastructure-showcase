# TDD Enforcement Rules

## Purpose

Enforce Test-Driven Development across all implementation work to ensure code quality, prevent bugs, and enable safe refactoring.

## Iron Law

```
NO PRODUCTION CODE WITHOUT A FAILING TEST FIRST
```

This is non-negotiable. Write code before the test? Delete it. Start over.

## Enforcement Levels

### Critical (BLOCK)

Violations that MUST be blocked:
- Writing implementation code before tests
- Skipping RED phase (watching test fail)
- Writing tests after implementation
- Accepting tests that pass immediately

### High (SUGGEST)

Behaviors that should be corrected:
- Not watching tests fail before implementation
- Writing incomplete tests
- Skipping verification phases
- Not committing after GREEN phase

## Required Workflow

Every implementation MUST follow:

1. **RED** - Write failing test
2. **Verify RED** - Run test, confirm it fails correctly
3. **GREEN** - Write minimal code to pass
4. **Verify GREEN** - Run test, confirm it passes
5. **REFACTOR** - Clean up (keep tests green)
6. **Commit** - Small, logical commit

## Common Violations

### Violation 1: "Too Simple to Test"

**Reality:** Simple code breaks. Test takes 30 seconds.

**Action:** BLOCK - Require test first

### Violation 2: "I'll Test After"

**Reality:** Tests passing immediately prove nothing.

**Action:** BLOCK - Delete code, start over

### Violation 3: "Tests After Achieve Same Goals"

**Reality:** Tests-after answer "What does this do?" Tests-first answer "What should this do?"

**Action:** BLOCK - Not equivalent. Start over.

### Violation 4: "Already Manually Tested"

**Reality:** Ad-hoc ≠ systematic. No record, can't re-run.

**Action:** SUGGEST - Explain why automated tests are necessary

### Violation 5: "Keep as Reference, Write Tests First"

**Reality:** You'll adapt it. That's testing after.

**Action:** BLOCK - Delete means delete. No exceptions.

## Integration with Skills

### Required Skills

- **test-driven-development** - Must be active for all implementation
- **verification-before-completion** - Verify TDD cycle complete

### Related Skills

- **testing-guidelines** - Comprehensive testing strategies
- **backend-dev-guidelines** - Backend TDD patterns
- **frontend-dev-guidelines** - Frontend TDD patterns
- **python-dev-guidelines** - Python TDD (pytest)
- **django-dev-guidelines** - Django TDD patterns
- **fastapi-dev-guidelines** - FastAPI TDD (TestClient)

## Verification Checklist

Before marking any implementation complete:

- [ ] Test written first
- [ ] Test watched failing (RED phase verified)
- [ ] Minimal implementation written (GREEN phase)
- [ ] Test watched passing (GREEN phase verified)
- [ ] Refactored if needed (kept tests green)
- [ ] Committed with logical message
- [ ] No debug code left
- [ ] All tests pass (not just new one)

Can't check all boxes? TDD was violated. Start over.

## Enforcement in Code Review

Code reviewers MUST check:

1. **Test exists** - Is there a test for this code?
2. **Test came first** - Does git history show test written before code?
3. **TDD cycle followed** - RED → GREEN → REFACTOR → commit
4. **No rationalization** - No excuses for skipping TDD

**If any check fails:** Reject the review. TDD is required.

## Red Flags

Immediate rejection if you see:

- Code before test in git history
- Test passes immediately (no RED phase)
- "I tested it manually"
- "Tests are coming"
- "I'll add tests later"
- "Too simple to test"
- Any variation of "just this once"

## Training Requirements

All developers MUST:

1. Understand TDD principles
2. Practice RED-GREEN-REFACTOR cycle
3. Learn to write testable code
4. Recognize rationalization patterns
5. Know how to refactor with confidence

## Resources

- **test-driven-development skill** - Complete TDD guide
- **testing-guidelines skill** - Testing strategies
- **tdd-workflow command** - Interactive TDD enforcement
- Domain-specific skills for language patterns

---

**Remember:** NO PRODUCTION CODE WITHOUT A FAILING TEST FIRST. This is non-negotiable.
