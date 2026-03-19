# Verification Requirements Rules

## Purpose

Ensure all completion claims are backed by fresh verification evidence to maintain trust and quality.

## Iron Law

```
NO COMPLETION CLAIMS WITHOUT FRESH VERIFICATION EVIDENCE
```

If you haven't run the verification command in this message, you cannot claim it passes.

## The Gate Function

Before ANY completion claim:

1. **IDENTIFY** - What command proves this claim?
2. **RUN** - Execute the FULL command (fresh, complete)
3. **READ** - Full output, check exit code, count failures
4. **VERIFY** - Does output confirm the claim?
5. **ONLY THEN** - Make the claim

Skip any step = lying, not verifying

## Enforcement Levels

### Critical (BLOCK)

Claims that MUST be blocked without evidence:
- "Tests pass" (without test output)
- "Build succeeds" (without build output)
- "Fixed the bug" (without verification)
- "Done" or "Complete" (without verification)
- "Should work now" (without running)

### High (SUGGEST)

Behaviors that should be corrected:
- Using "should", "probably", "seems to"
- Expressing satisfaction before verification
- Relying on previous runs
- Trusting agent reports without verification

## Required Evidence by Claim Type

### "Tests Pass"

**REQUIRED:**
- Test command output showing execution
- Pass/fail counts (e.g., "42 passed, 42 total")
- Exit code 0
- No errors or warnings

**NOT SUFFICIENT:**
- "Tests passed when I ran them earlier"
- "Should be passing now"
- "I saw them pass before"

### "Build Succeeds"

**REQUIRED:**
- Build command output showing compilation
- Exit code 0
- No compilation errors
- No critical warnings

**NOT SUFFICIENT:**
- "Linter passed" (linter ≠ compiler)
- "No errors showed up"
- "Builds on my machine"

### "Bug Fixed"

**REQUIRED:**
- Test reproducing original bug passes
- Steps to reproduce bug fail
- Before/after comparison
- Regression test (if applicable)

**NOT SUFFICIENT:**
- "I changed the code"
- "Should be fixed now"
- "Code looks correct"

### "Feature Complete"

**REQUIRED:**
- All acceptance criteria verified
- Requirements checklist complete
- Integration tests pass
- E2E tests pass (if applicable)
- Documentation updated

**NOT SUFFICIENT:**
- "Main functionality works"
- "Tests pass"
- "Ready enough"

## Verification Commands

### Testing

```bash
# Run all tests
npm test

# Run with coverage
npm test -- --coverage

# Expected output format:
# Test Suites: 5 passed, 5 total
# Tests:       42 passed, 42 total
# Coverage:    85.3%
```

### Building

```bash
# Build project
npm run build

# TypeScript type check
npx tsc --noEmit

# Expected: Exit code 0, no errors
```

### Linting

```bash
# Run linter
npm run lint

# Expected: 0 errors, 0 warnings
```

### Regression Testing

```bash
# 1. Write test that reproduces bug
# 2. Run test → should FAIL (bug present)
# 3. Fix bug
# 4. Run test → should PASS (bug fixed)
# 5. Revert fix → test should FAIL (proves test catches bug)
# 6. Restore fix → test should PASS (back to working)
```

## Red Flags

**BLOCK these behaviors:**

- Using "should", "probably", "seems to", "likely"
- Expressing satisfaction before running verification
- About to commit/PR without verification
- Trusting agent success reports
- Relying on partial verification
- "Just this once" rationalizations
- "I'm tired" or "it's late" excuses
- Any wording implying success without evidence

## Integration with Skills

### Required Skills

- **verification-before-completion** - Must be active before any completion claim
- **test-driven-development** - TDD includes verification phases

### Related Skills

- **testing-guidelines** - Verification strategies
- **code-reviewer** - Review includes verification checks
- **quality-gate command** - Comprehensive verification

## Verification Checklist

Before ANY completion claim:

- [ ] Identified verification command
- [ ] Ran command FRESH (not from earlier)
- [ ] Read FULL output
- [ ] Checked exit code
- [ ] Confirmed output matches claim
- [ ] Stated claim WITH evidence
- [ ] No "should", "probably", "seems"
- [ ] No premature satisfaction

Can't check all boxes? You're not ready to claim completion.

## Code Review Requirements

Reviewers MUST reject if:

1. **No verification evidence provided**
2. **Evidence is from earlier run** (not fresh)
3. **Evidence doesn't support claim** (output shows failures)
4. **Evidence is partial** (only ran linter, not tests)
5. **Claim uses "should" or "probably"**

**Required evidence in PR descriptions:**
```markdown
## Verification

- [x] Tests: `npm test` → 42/42 pass
- [x] Build: `npm run build` → exit 0
- [x] Type check: `npx tsc --noEmit` → no errors
- [x] Lint: `npm run lint` → 0 errors, 0 warnings
```

## Examples

### ❌ BAD: No Verification

```
I've fixed the authentication bug. The tests pass and everything is working great!
```

### ✅ GOOD: With Verification

```
Running authentication tests...

$ npm test tests/auth/login.test.ts

Test Suites: 1 passed, 1 total
Tests:       8 passed, 8 total
Snapshots:   0 total
Time:        2.3s

All authentication tests pass. Login, logout, and token refresh all working.
```

### ❌ BAD: "Should" Language

```
The build should work now and tests should pass.
```

### ✅ GOOD: Evidence-Based

```
$ npm run build
Build completed successfully. Exit code: 0.

$ npm test
Test Suites: 5 passed, 5 total
Tests:       42 passed, 42 total

Build passes and all tests pass.
```

## Common Rationalizations

| Excuse | Reality |
|--------|---------|
| "Should work now" | RUN the verification |
| "I'm confident" | Confidence ≠ evidence |
| "Just this once" | No exceptions |
| "Linter passed" | Linter ≠ compiler |
| "Agent said success" | Verify independently |
| "I'm tired" | Exhaustion ≠ excuse |
| "Partial check is enough" | Partial proves nothing |

---

**Remember:** Claiming work is complete without verification is dishonesty, not efficiency. Evidence before claims, always.
