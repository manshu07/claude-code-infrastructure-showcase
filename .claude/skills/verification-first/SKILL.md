---
name: verification-before-completion
description: Use when about to claim work is complete, fixed, or passing, before committing or creating PRs. Requires running verification commands and confirming output before making any success claims. Evidence before assertions always. Prevents false completion claims, catches regressions, and maintains trust. Critical before: commits, PRs, task completion, moving to next task.
---

# Verification Before Completion

## Purpose

Ensure all completion claims are backed by fresh verification evidence, preventing false success claims and maintaining trust.

## When to Use This Skill

**ALWAYS use before:**
- ANY variation of success/completion claims
- ANY expression of satisfaction ("Great!", "Perfect!", "Done!")
- Committing code
- Creating PRs
- Marking tasks complete
- Moving to next task
- Delegating to agents

**CORE PRINCIPLE:** Evidence before claims, always.

**Violating the letter of this rule is violating the spirit of this rule.**

---

## The Iron Law

```
NO COMPLETION CLAIMS WITHOUT FRESH VERIFICATION EVIDENCE
```

If you haven't run the verification command in this message, you cannot claim it passes.

---

## The Gate Function

**BEFORE claiming any status or expressing satisfaction:**

1. **IDENTIFY:** What command proves this claim?
2. **RUN:** Execute the FULL command (fresh, complete)
3. **READ:** Full output, check exit code, count failures
4. **VERIFY:** Does output confirm the claim?
   - If NO: State actual status with evidence
   - If YES: State claim WITH evidence
5. **ONLY THEN:** Make the claim

**Skip any step = lying, not verifying**

---

## Common Failures

| Claim | Requires | Not Sufficient |
|-------|----------|----------------|
| Tests pass | Test command output: 0 failures | Previous run, "should pass" |
| Linter clean | Linter output: 0 errors | Partial check, extrapolation |
| Build succeeds | Build command: exit 0 | Linter passing, logs look good |
| Bug fixed | Test original symptom: passes | Code changed, assumed fixed |
| Regression test works | Red-green cycle verified | Test passes once |
| Agent completed | VCS diff shows changes | Agent reports "success" |
| Requirements met | Line-by-line checklist | Tests passing |

---

## Red Flags - STOP

- Using "should", "probably", "seems to"
- Expressing satisfaction before verification ("Great!", "Perfect!", "Done!")
- About to commit/push/PR without verification
- Trusting agent success reports
- Relying on partial verification
- Thinking "just this once"
- Tired and wanting work over
- **ANY wording implying success without having run verification**

---

## Rationalization Prevention

| Excuse | Reality |
|--------|---------|
| "Should work now" | RUN the verification |
| "I'm confident" | Confidence ≠ evidence |
| "Just this once" | No exceptions |
| "Linter passed" | Linter ≠ compiler |
| "Agent said success" | Verify independently |
| "I'm tired" | Exhaustion ≠ excuse |
| "Partial check is enough" | Partial proves nothing |
| "Different words so rule doesn't apply" | Spirit over letter |

---

## Key Patterns

### Tests

```
✅ GOOD: [Run test command] [See: 34/34 pass] "All tests pass"
❌ BAD: "Should pass now" / "Looks correct"
```

### Regression Tests (TDD Red-Green)

```
✅ GOOD: Write → Run (pass) → Revert fix → Run (MUST FAIL) → Restore → Run (pass)
❌ BAD: "I've written a regression test" (without red-green verification)
```

### Build

```
✅ GOOD: [Run build] [See: exit 0] "Build passes"
❌ BAD: "Linter passed" (linter doesn't check compilation)
```

### Requirements

```
✅ GOOD: Re-read plan → Create checklist → Verify each → Report gaps or completion
❌ BAD: "Tests pass, phase complete"
```

### Agent Delegation

```
✅ GOOD: Agent reports success → Check VCS diff → Verify changes → Report actual state
❌ BAD: Trust agent report
```

---

## Why This Matters

From 24 failure memories:
- Your human partner said "I don't believe you" - **trust broken**
- Undefined functions shipped - **would crash**
- Missing requirements shipped - **incomplete features**
- Time wasted on false completion → redirect → rework
- Violates: "Honesty is a core value. If you lie, you'll be replaced."

**False completion claims are catastrophic for:**
1. Trust (once broken, hard to rebuild)
2. Quality (bugs ship to production)
3. Efficiency (rework, context switching)
4. Reputation (reliability suffers)

---

## When To Apply

**Rule applies to:**
- Exact phrases ("done", "complete", "fixed", "passing")
- Paraphrases and synonyms
- Implications of success
- ANY communication suggesting completion/correctness
- ANY positive statement about work state
- ANY expression of satisfaction

**Always verify BEFORE:**
- Sending a message claiming completion
- Creating a commit
- Pushing to remote
- Creating a PR
- Marking a task as done
- Moving to the next task

---

## Verification Command Examples

### Tests

```bash
# Run all tests
npm test

# Run specific test file
npm test path/to/test.test.ts

# Run with coverage
npm test -- --coverage

# Expected output to claim "tests pass":
# Test Suites: 5 passed, 5 total
# Tests:       42 passed, 42 total
```

### Build

```bash
# Build project
npm run build

# Expected output to claim "build passes":
# Exit code: 0
# No errors in output
```

### Linting

```bash
# Run linter
npm run lint

# Expected output to claim "linting clean":
# No errors, no warnings
# Exit code: 0
```

### Type Checking

```bash
# TypeScript type check
npx tsc --noEmit

# Expected output to claim "types correct":
# No errors
# Exit code: 0
```

---

## Example Workflow

### BAD: No Verification

```
You: "I've fixed the authentication bug. The tests pass and everything is working great!"
```

**Problem:** No verification evidence. Claims are untrustworthy.

### GOOD: With Verification

```
You: "Running authentication tests..."

$ npm test tests/auth/login.test.ts

Test Suites: 1 passed, 1 total
Tests:       8 passed, 8 total
Snapshots:   0 total
Time:        2.3s

"All authentication tests pass. Login, logout, and token refresh all working."
```

**Good:** Fresh evidence backs the claim.

---

## Regression Testing Verification

When claiming a regression test prevents future bugs:

1. **Write test** that fails with current bug
2. **Run test** → confirm it fails (RED)
3. **Fix bug** → implement minimal fix
4. **Run test** → confirm it passes (GREEN)
5. **Revert fix** → temporarily undo fix
6. **Run test** → MUST FAIL (proves test catches bug)
7. **Restore fix** → bring back the fix
8. **Run test** → MUST PASS (back to GREEN)

**Only then can you claim:** "Regression test verified with red-green cycle."

---

## Common Anti-Patterns

### "Should Work Now"

```
❌ BAD: "I've updated the query. It should work now."

✅ GOOD: [Run query] [See: returns expected data] "Query working correctly."
```

### "Looks Good"

```
❌ BAD: "The code looks good, no issues."

✅ GOOD: [Run linter] [Run tests] [See: all pass] "Code verified, all checks pass."
```

### "Agent Said Success"

```
❌ BAD: "The refactoring agent completed successfully."

✅ GOOD: Agent reported success → [Check git diff] → [Run tests] → "Refactoring complete, verified with diff and tests."
```

### "From Earlier Run"

```
❌ BAD: "The tests passed when I ran them earlier."

✅ GOOD: [Run tests now] [See: all pass] "Tests pass as of right now."
```

---

## Integration with Other Skills

**Required workflows:**
- **test-driven-development** - Always run tests before claiming TDD complete
- **code-reviewer** - Use verification evidence in review reports
- **error-tracking** - Verify Sentry integration before claiming monitoring works

**Related skills:**
- **testing-guidelines** - Comprehensive verification strategies
- **backend-dev-guidelines** - Backend-specific verification
- **frontend-dev-guidelines** - Frontend verification (builds, linters)

---

## Verification Checklist

Before ANY completion claim:

- [ ] Identified verification command
- [ ] Ran command FRESH (not from earlier)
- [ ] Read FULL output
- [ ] Checked exit code
- [ ] Confirmed output matches claim
- [ ] Stated claim WITH evidence
- [ ] No "should", "probably", "seems"
- [ ] No premature satisfaction ("Great!", "Perfect!")

Can't check all boxes? You're not ready to claim completion.

---

## Final Rule

**No shortcuts for verification.**

Run the command. Read the output. THEN claim the result.

This is non-negotiable.

---

**Remember:** Claiming work is complete without verification is dishonesty, not efficiency. Evidence before claims, always.
