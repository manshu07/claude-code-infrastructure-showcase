# Edit With Permission Rule

## Iron Rule: ALWAYS Ask Permission Before Editing Existing Files

**CRITICAL:** Before editing/updating ANY existing file, you MUST:

1. **Show the existing content**
2. **Explain what you're changing**
3. **Ask for explicit permission**
4. **Get user confirmation**
5. **Then make the edit**

## Mandatory Pre-Edit Checklist

### Before ANY Edit/Write Operation

#### 1. Read the File First
```bash
# ALWAYS read existing files before editing
read <file-path>
```

#### 2. Show What Exists
Display the relevant section to the user:
```
Existing content:
---
<show the actual content that will be changed>
---
```

#### 3. Explain Your Change
```
I want to change:
- From: <what it currently says>
- To: <what you want to change it to>
- Reason: <why this change is needed>
```

#### 4. Ask Permission
```
Do you want me to make this change? (yes/no)
```

#### 5. Wait for Confirmation
- **User says "yes"** → Make the edit
- **User says "no"** → Do NOT edit, ask for clarification
- **User modifies** → Apply their suggestions and ask again

## When This Rule Applies

### Always Ask For:

✅ **Files that already exist:**
- Any file that `read` can access
- Configuration files (JSON, YAML, TOML)
- Documentation files (README.md, docs)
- Source code files (.ts, .js, .py, etc.)
- Skill files (SKILL.md)
- Agent files (.md)
- Rules, schemas, scripts

✅ **Especially critical files:**
- `.claude/settings.json`
- `.claude/skills/skill-rules.json`
- `.gitignore`
- `README.md`
- `package.json`
- Any config file

### Exceptions (Auto-Approved):

❌ **You DON'T need to ask for:**
- Files that don't exist yet (Write tool on non-existent files)
- Files you just created in the same task
- Temporary/cache files
- Files user explicitly told you to edit

## Examples

### Example 1: Editing Configuration

❌ **WRONG:**
```
User: "Update the timeout setting in config.json"
Assistant: [Edits config.json immediately]
```

✅ **RIGHT:**
```
User: "Update the timeout setting in config.json"
Assistant: [Reads config.json]

         Current config.json:
         {
           "timeout": 5000,
           "retries": 3
         }

         I want to change:
         - From: timeout: 5000
         - To: timeout: 10000
         - Reason: You requested to update the timeout

         Do you want me to make this change? (yes/no)

User: "yes"
Assistant: [Makes the edit]
```

### Example 2: Editing Skill File

❌ **WRONG:**
```
User: "Add a new section to the brainstorming skill"
Assistant: [Edits .claude/skills/brainstorming/SKILL.md immediately]
```

✅ **RIGHT:**
```
User: "Add a new section to the brainstorming skill"
Assistant: [Reads .claude/skills/brainstorming/SKILL.md]

         Current brainstorming skill has:
         - Section 1: Purpose
         - Section 2: When to Use
         - Section 3: How It Works

         I want to add:
         - Section 4: Common Pitfalls
         - Content: <shows what will be added>
         - Location: After "How It Works"

         Do you want me to make this change? (yes/no)

User: "yes, but add it before the examples section"
Assistant: [Updates plan and asks again]
         "Updated plan: Add before examples section. Confirm? (yes/no)"
```

### Example 3: Updating README

❌ **WRONG:**
```
User: "Update README with the new skills"
Assistant: [Edits README.md immediately]
```

✅ **RIGHT:**
```
User: "Update README with the new skills"
Assistant: [Reads README.md]

         Current README structure:
         # Skills
         - skill1
         - skill2

         I want to add:
         - New skills section with:
           - tdd-methodology
           - verification-first
           - implementation-planning

         Do you want me to make this change? (yes/no)

User: "yes"
Assistant: [Makes the edit]
```

## Post-Edit Required Actions

After getting permission and making an edit, you MUST:

### 1. Update Related Documentation

If you edited a file that other files reference:

```bash
# Find files that reference this file
grep -r "<file-name>" .claude/ --include="*.md" --include="*.json"

# Update those files too
```

**Examples:**

| If You Edited | Also Update |
|---------------|-------------|
| Skill directory | skill-rules.json, README.md |
| Agent file | Skills that use that agent |
| Script | Documentation that mentions it |
| Schema | Skills/agents that use it |
| Rule file | workflow-orchestration.md |

### 2. Update README Files

If you created/modified skills, agents, or major components:

```bash
# Update main README
update-readme

# Or manually update README.md
```

**What to include in README:**
- New skills added
- New agents added
- New scripts/tools added
- New rules added
- Any breaking changes

### 3. Commit and Push

After completing edits and documentation updates:

```bash
# Stage changes
git add <files-you-changed>

# Commit with descriptive message
git commit -m "feat: <descriptive commit message>

- Added/Updated <what>
- Updated <related-files>
- Updated README"

# Push to remote
git push
```

## Complete Edit Workflow

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

## Special Cases

### Case 1: Multiple Edits

If editing multiple files:

```
I want to edit 3 files:
1. config.json - Update timeout
2. README.md - Add new section
3. skill-rules.json - Add new skill

Should I proceed with all 3 edits? (yes/no/edit specific)
```

### Case 2: Dangerous Edits

For risky changes (config, credentials, critical files):

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

For edits changing many lines:

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

## Integration with Git Workflow

### Before Edit
```bash
# Check git status
git status

# See if file is already modified
git diff <filename>
```

### After Edit
```bash
# See what you changed
git diff

# Stage the changes
git add <filename>

# Commit with proper message
git commit -m "<type>: <description>

<optional body with details>

Co-Authored-By: Claude Sonnet 4.6 <noreply@anthropic.com>"

# Push to remote
git push
```

### Commit Message Types

| Type | When to Use |
|------|-------------|
| `feat` | New feature or skill |
| `fix` | Bug fix |
| `refactor` | Code refactoring |
| `docs` | Documentation only |
| `update` | Update existing content |
| `config` | Configuration changes |

## Anti-Patterns to Avoid

❌ **WRONG:**
```bash
# Editing without reading
edit file.txt "new content"

# Editing without asking
edit file.txt "new content"
[User didn't approve]

# Editing without updating docs
edit skill.md "new content"
[Don't update README or skill-rules.json]

# Editing without committing
edit file.txt "new content"
[Don't git commit/push]
```

✅ **RIGHT:**
```bash
# Read first
read file.txt

# Show what exists
"Current content: ..."

# Ask permission
"Do you want me to change it to: ...? (yes/no)"

# Make edit after approval
[User says "yes"]
edit file.txt "new content"

# Update related files
update-related-files

# Update README
update-readme

# Commit and push
git add .
git commit -m "..."
git push
```

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

## Templates

### Template 1: Simple Edit
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

### Template 2: Complex Edit
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

## Remember

**Read → Show → Ask → Edit → Document → Commit → Push**

This prevents:
- Unintended changes
- Breaking existing functionality
- Outdated documentation
- Lost work (not committed)
- Confusion (no history)

---

**Created:** 2025-03-19
**Purpose:** Ensure safe, documented, and version-controlled edits
**Status:** MANDATORY for all file edits
