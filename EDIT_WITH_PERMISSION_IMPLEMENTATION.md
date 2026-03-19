# Edit With Permission - Implementation Summary

**Date:** 2025-03-19
**Purpose:** Ensure safe, documented, and version-controlled edits

## Problem Identified

User pointed out a critical gap in the workflow:

> "also add rules for edit/update anything on existing to ask permission that this what its look exiting are you sure want to update/edit it? after this update readme and all relatable files who use this folder. then commit and push to the repo"

**Missing Workflow Steps:**
1. No permission asking before editing existing files
2. No showing of existing content before changes
3. No updating of related files after edits
4. No README updates after changes
5. No git commit/push workflow

**Impact:**
- Risk of unintended changes
- Breaking existing functionality
- Outdated documentation
- Lost work (not committed)
- No version history

## Solution Implemented

### 1. New Rule: `edit-with-permission.md`

**Location:** `.claude/rules/workflow/edit-with-permission.md`

**Iron Rule: ALWAYS Ask Permission Before Editing Existing Files**

**Mandatory Pre-Edit Checklist:**
1. **Read the file first**
2. **Show existing content**
3. **Explain your change**
4. **Ask for explicit permission**
5. **Wait for confirmation**
6. **Then make the edit**

**Required Actions After Edit:**
1. Update related documentation
2. Update README files
3. Commit changes to git
4. Push to repository

### 2. New Tool: `update-after-edit.sh`

**Location:** `.claude/scripts/update-after-edit.sh`

**Usage:**
```bash
./.claude/scripts/update-after-edit.sh <file-edited> <commit-type> "<commit-message>"
```

**Example:**
```bash
./.claude/scripts/update-after-edit.sh \
  .claude/skills/new-skill/SKILL.md \
  feat \
  "Added new TDD methodology skill"
```

**Features:**
- Automatically finds related files
- Checks git status
- Generates git commands
- Creates checklist file
- Shows what needs to be updated

**Example Output:**
```
Post-Edit Update Workflow
========================================
File edited: .claude/skills/tdd-methodology/SKILL.md
Commit type: feat
Commit message: Added TDD methodology skill

Step 1: Finding related files...
  Skill file detected: tdd-methodology
  → Will update: skill-rules.json
  → Will update: README.md

Step 2: Checking git status...
  Git repository detected

Summary of Actions
========================================
1. ✅ File edited: .claude/skills/tdd-methodology/SKILL.md

2. ⏳ Related files to update:
   - skill-rules.json
   - README.md

   ⚠ MANUAL UPDATE REQUIRED
   Please review and update these files manually.

3. ⏳ Git commands to run:
   git add .claude/skills/tdd-methodology/SKILL.md
   git add skill-rules.json
   git add README.md
   git commit -m "feat: Added TDD methodology skill"
   git push
```

### 3. Updated Workflow

Modified `.claude/rules/workflow/workflow-orchestration.md` to include **Post-Edit Workflow**:

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

### 4. Updated README

Added to `README.md`:

**New Section: Workflow Rules & Governance**
- Check Before Create
- Edit With Permission
- TDD Enforcement
- Verification First
- Workflow Orchestration

**Updated Counts:**
- Skills: 36 → 41 (added 5 workflow skills)
- Agents: 33 → 38 (added 5 workflow agents)

**New Skills Listed:**
- brainstorming
- implementation-planning
- subagent-driven-development
- tdd-methodology
- verification-first

**New Agents Listed:**
- spec-document-reviewer
- plan-document-reviewer
- implementer
- spec-reviewer
- code-quality-reviewer

## How It Works

### Complete Edit Workflow

```
User asks to edit something
    ↓
1. READ the file first
    ↓
2. SHOW existing content
    ↓
3. EXPLAIN your change
    ↓
4. ASK permission
    ↓
5. WAIT for confirmation
    ↓
6. If user says YES:
    a. Make the edit
    b. Update related documentation
    c. Update README
    d. Commit changes
    e. Push to repo
    ↓
7. If user says NO:
    a. Ask for clarification
    b. Modify your plan
    c. Go back to step 2
```

### Example: Correct Edit Workflow

**❌ WRONG (what I used to do):**
```
User: "Update the brainstorming skill"
Me: [Edits .claude/skills/brainstorming/SKILL.md immediately]
    [No permission asked]
    [No related files updated]
    [No git commit]
    [Changes potentially lost]
```

**✅ CORRECT (what I must do now):**
```
User: "Update the brainstorming skill"
Me: [Reads .claude/skills/brainstorming/SKILL.md]

     Current content has:
     - Section 1: Purpose
     - Section 2: When to Use
     - Section 3: How It Works

     I want to change:
     - Section 2: Add new trigger patterns
     - Reason: You requested to update triggers

     Do you want me to make this change? (yes/no)

User: "yes"
Me: [Makes the edit]
    [Runs update-after-edit.sh]
    [Updates skill-rules.json]
    [Updates README.md]
    [Commits to git]
    [Pushes to repository]
```

## Templates

### Template 1: Simple Edit Permission
```
I want to edit <file-name>

Current content:
---
<show existing>
---

Proposed change:
---
<show what will change>
---

Reason: <why>

Do you want me to make this change? (yes/no)
```

### Template 2: Complex Edit Permission
```
I want to edit <file-name>

This will affect:
- <X> lines
- <Y> sections
- <Z> references

Summary:
<changes summary>

Show full diff? (yes/no)

[If user says yes, show diff]

Confirm edit? (yes/no)
```

### Template 3: Post-Edit Actions
```
Edit complete! Now I will:

1. ✅ Made edit to <file>
2. ⏳ Update related files:
   - <related-file-1>
   - <related-file-2>
3. ⏳ Update README.md
4. ⏳ Commit changes
5. ⏳ Push to repository

Proceeding with step 2...
```

## Special Cases

### Case 1: Multiple Edits
```
I want to edit 3 files:
1. config.json - Update timeout
2. README.md - Add new section
3. skill-rules.json - Add new skill

Should I proceed with all 3 edits? (yes/no/edit specific)
```

### Case 2: Dangerous Edits
```
⚠ WARNING: This edit affects <critical-file>

Current content:
---
<shows current content>
---

Proposed change:
---
<shows what will change>
---

Risk: <explains potential impact>

Are you SURE you want to make this change? (yes/no)
```

### Case 3: Large Edits
```
This edit will change <X> lines in <filename>

Summary of changes:
- <brief summary>
- <another change>

Show full diff? (yes/no)

If yes:
<shows the complete diff>

Confirm edit? (yes/no)
```

## Files Added/Modified

### New Files Created
1. `.claude/rules/workflow/edit-with-permission.md` - Complete rule
2. `.claude/scripts/update-after-edit.sh` - Update tool ✅ Tested
3. `EDIT_WITH_PERMISSION_IMPLEMENTATION.md` - This summary

### Modified Files
1. `.claude/rules/workflow/workflow-orchestration.md` - Added Post-Edit stage
2. `README.md` - Added Workflow Rules section, updated counts

## Integration with Existing Workflow

This rule integrates with all workflow stages:

**Before Creating:**
- Use `check-before-create.md` rule
- Search for existing components

**Before Editing:**
- Use `edit-with-permission.md` rule
- Read file, show content, ask permission

**After Editing:**
- Use `update-after-edit.sh` script
- Update related files
- Commit and push

## Testing

### Test Results

```bash
# Test 1: Edit skill file
$ ./.claude/scripts/update-after-edit.sh \
    .claude/skills/tdd-methodology/SKILL.md \
    feat \
    "Added TDD methodology skill"

✅ Found related files: skill-rules.json, README.md
✅ Generated git commands
✅ Created checklist file

# Test 2: Workflow integration
✅ Rule added to workflow-orchestration.md
✅ README updated with new section
✅ All counts updated (36→41 skills, 33→38 agents)
```

## Benefits

✅ **Prevents Unintended Changes** - User reviews before edit
✅ **Transparency** - Shows what will change
✅ **Documentation Stays Current** - Related files updated
✅ **Version Control** - All changes committed
✅ **Recovery** - Git history for rollbacks
✅ **Accountability** - Clear audit trail

## Verification Checklist

Before marking any edit task complete:

- [ ] Read the existing file first
- [ ] Show user what exists
- [ ] Explained the change clearly
- [ ] Got explicit permission (yes/no)
- [ ] Made the edit
- [ ] Updated related documentation
- [ ] Updated README files
- [ ] Committed changes to git
- [ ] Pushed to remote repository

## Commit Message Guidelines

### Commit Types

| Type | When to Use | Example |
|------|-------------|---------|
| `feat` | New feature or skill | `feat: Added TDD methodology skill` |
| `fix` | Bug fix | `fix: Corrected skill activation trigger` |
| `refactor` | Code refactoring | `refactor: Simplified skill structure` |
| `docs` | Documentation only | `docs: Updated README with new skills` |
| `update` | Update existing content | `update: Enhanced brainstorming skill` |
| `config` | Configuration changes | `config: Updated skill-rules.json` |

### Commit Message Format
```bash
git commit -m "<type>: <description>

<optional body with details>

- Added/Updated <what>
- Updated <related-files>
- Updated README

Co-Authored-By: Claude Sonnet 4.6 <noreply@anthropic.com>"
```

## Summary

✅ **Rule Created:** edit-with-permission.md
✅ **Tool Created:** update-after-edit.sh
✅ **Workflow Updated:** Post-edit stage added
✅ **README Updated:** New section, updated counts
✅ **Script Tested:** Working correctly
✅ **Documentation:** Complete

**Status:** Active and enforced
**Impact:** Ensures safe, documented, and version-controlled edits
**Next Step:** Use for all file edits going forward

## Quick Reference

### Before ANY Edit:
```bash
# 1. Read file
read <file-path>

# 2. Show content and ask permission
"Current content: ... Proposed change: ... Confirm? (yes/no)"

# 3. After edit, run
./.claude/scripts/update-after-edit.sh <file> <type> "<message>"

# 4. Commit and push
git add <files>
git commit -m "<type>: <message>"
git push
```

---

**Created:** 2025-03-19
**Lesson Learned:** Always ask permission before editing
**Rule:** EDIT WITH PERMISSION - MANDATORY
**Integration:** Complete with workflow, tools, and documentation
