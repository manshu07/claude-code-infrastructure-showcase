# [Feature Name] Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** [One sentence describing what this builds]

**Architecture:** [2-3 sentences about approach]

**Tech Stack:** [Key technologies/libraries]

---

## Task Breakdown

### Task 1: [Component/Feature Name]

**Files:**
- Create: `exact/path/to/file.ext`
- Modify: `exact/path/to/existing.ext:123-145` (line numbers if applicable)
- Test: `exact/path/to/test.ext`

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

---

### Task 2: [Component/Feature Name]

**Files:**
- Create: `exact/path/to/file.ext`
- Modify: `exact/path/to/existing.ext`
- Test: `exact/path/to/test.ext`

- [ ] **Step 1: Write the failing test**

[Code for test]

- [ ] **Step 2: Run test to verify it fails**

Run: `[command]`
Expected: [expected failure message]

- [ ] **Step 3: Write minimal implementation**

[Code for implementation]

- [ ] **Step 4: Run test to verify it passes**

Run: `[command]`
Expected: PASS

- [ ] **Step 5: Commit**

```bash
git add [files]
git commit -m "[commit message]"
```

---

[Continue for all tasks...]

---

## Verification Checklist

Before marking implementation complete:

- [ ] All tasks completed
- [ ] All tests pass
- [ ] No errors or warnings
- [ ] Code follows project conventions
- [ ] No debug code or console.logs
- [ ] All requirements from spec are implemented
- [ ] Edge cases are handled
- [ ] Documentation is updated if needed

---

## Notes

[Any additional notes, assumptions, or context for implementers]
