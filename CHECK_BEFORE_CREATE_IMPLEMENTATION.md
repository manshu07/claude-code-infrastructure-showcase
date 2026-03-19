# Check Before Create - Implementation Summary

**Date:** 2025-03-19
**Purpose:** Prevent duplicate component creation and enforce reuse

## Problem Identified

During the superpowers integration, I created **duplicate agents** without first checking what already existed:

- Created `spec-document-reviewer` when `spec-reviewer` already existed
- Created `plan-document-reviewer` when `plan-reviewer` already existed
- Created 5 new agents that partially overlapped with existing 33 agents

**Impact:**
- Wasted time creating duplicates
- Required conflict resolution after the fact
- Violated DRY (Don't Repeat Yourself) principle
- Created maintenance burden

## Solution Implemented

### 1. New Rule: `check-before-create.md`

**Location:** `.claude/rules/workflow/check-before-create.md`

**Iron Rule: ALWAYS Check Before Creating**

Mandatory pre-creation checklist for:
- Skills
- Agents
- Scripts
- Rules
- Schemas
- Hooks

**Key Requirements:**
1. Search for existing components first
2. Compare functionality
3. Reuse existing components when possible
4. Only create new when genuinely needed
5. Document search performed when creating new

### 2. New Tool: `search-existing.sh`

**Location:** `.claude/scripts/search-existing.sh`

**Usage:**
```bash
./.claude/scripts/search-existing.sh <keyword>
```

**Features:**
- Searches all component types (skills, agents, scripts, rules, schemas, hooks)
- Shows exact matches with file names
- Counts total matches
- Provides clear guidance:
  - If found: "ACTION REQUIRED - Review and reuse"
  - If not found: "SAFE to create new"

**Examples:**

```bash
# Check if "reviewer" agents exist
./.claude/scripts/search-existing.sh reviewer
# Output: Found 12 matching component(s)
# → Shows code-reviewer, security-reviewer, spec-reviewer, etc.
# → ACTION: Reuse existing, don't create new

# Check if "tdd-methodology" exists
./.claude/scripts/search-existing.sh tdd-methodology
# Output: No existing components found
# → SAFE to create new
```

### 3. Updated Workflow

Modified `.claude/rules/workflow/workflow-orchestration.md` to include **Pre-Workflow** stage:

```
User Request
    ↓
[PRE-WORKFLOW] Check Before Create
    ├── Search existing components
    ├── Reuse if possible
    └── Create new only if needed
    ↓
[STAGE 1] brainstorming
    ...
```

## How It Works

### Before Creating Any Component

1. **Search First:**
   ```bash
   ./.claude/scripts/search-existing.sh "<keyword>"
   ```

2. **Review Results:**
   - If matching components found → Read them to understand functionality
   - If similar but not exact match → Consider enhancing existing
   - If nothing found → Proceed with creation

3. **Document Decision:**
   When creating new, document:
   - What you searched for
   - What you found
   - Why new component was needed
   - How it differs from existing

### Example: Correct Workflow

**❌ WRONG (what I did):**
```
User: "Add agents for reviewing specs and plans"
Me: [Creates spec-document-reviewer.md]
    [Creates plan-document-reviewer.md]
    [Later discovers spec-reviewer and plan-reviewer already exist]
    [Wastes time resolving conflicts]
```

**✅ CORRECT (what I should have done):**
```
User: "Add agents for reviewing specs and plans"
Me: [Runs search]
    ./.claude/scripts/search-existing.sh spec-reviewer
    → Found: spec-reviewer.md

    [Reads spec-reviewer.md]
    "I found spec-reviewer.md already exists. It reviews spec compliance.
     Should I enhance it or do you need something different?"

User: "Enhance it to also check design document completeness"

Me: [Enhances existing spec-reviewer.md]
    [No conflicts, no duplication, efficient]
```

## Search Commands Reference

### Quick Search Commands
```bash
# Search by keyword across all components
./.claude/scripts/search-existing.sh <keyword>

# Search specific directories
ls -la .claude/agents/ | grep -i "<keyword>"
ls -la .claude/skills/ | grep -i "<keyword>"

# Search content
grep -r "<concept>" .claude/agents/*.md
grep -r "<concept>" .claude/skills/*/SKILL.md
```

### Decision Matrix

| Found | Action |
|-------|--------|
| **Exact match** | Use existing, DO NOT create new |
| **Similar** | Enhance existing if possible |
| **Partial overlap** | Reuse + extend for unique parts |
| **Nothing** | Create new with clear purpose |

## Files Added/Modified

### New Files Created
1. `.claude/rules/workflow/check-before-create.md` - Complete rule documentation
2. `.claude/scripts/search-existing.sh` - Search tool script
3. `CHECK_BEFORE_CREATE_IMPLEMENTATION.md` - This summary

### Modified Files
1. `.claude/rules/workflow/workflow-orchestration.md` - Added Pre-Workflow stage

## Testing

### Test Results

```bash
# Test 1: Search for existing component
$ ./.claude/scripts/search-existing.sh reviewer
Found 12 matching component(s)
✓ ACTION REQUIRED: Review and reuse

# Test 2: Search for non-existent component
$ ./.claude/scripts/search-existing.sh xyz-fake-component
No existing components found
✓ SAFE to create new component

# Test 3: Case insensitive search
$ ./.claude/scripts/search-existing.sh TDD
Found 2 matching component(s)
✓ tdd, tdd-methodology
```

## Benefits

✅ **Prevents Duplication** - Catch duplicates before creation
✅ **Saves Time** - Reuse battle-tested components
✅ **Reduces Complexity** - Fewer components to maintain
✅ **Improves Quality** - Built on proven foundations
✅ **Enforces DRY** - Don't Repeat Yourself principle

## Integration with Existing Workflow

This rule now integrates with all workflow stages:

1. **Brainstorming** - Check existing skills before suggesting new ones
2. **Implementation Planning** - Check existing agents/scripts before planning
3. **Subagent Development** - Check existing agents before creating
4. **Documentation** - Check existing docs before creating new

## Future Enhancements

### Potential Improvements
1. **Auto-check hook** - Automatically run search on Write/Edit tool calls
2. **Similarity detection** - Suggest similar components automatically
3. **Dependency mapping** - Show which components use which
4. **Conflict detection** - Warn about naming conflicts before creation

### Potential Hook Implementation
```typescript
// .claude/hooks/pre-write-check.ts
function preWriteCheck(filePath: string) {
  const componentName = path.basename(filePath, '.md');

  // Run search
  const results = searchExisting(componentName);

  // If duplicates found, warn user
  if (results.length > 0) {
    console.log(`⚠ Found ${results.length} similar components:`);
    results.forEach(r => console.log(`  - ${r}`));
    console.log(`Consider reusing existing instead of creating new.`);
  }
}
```

## Lesson Learned

**The Hard Way:**
- Created 5 duplicate agents
- Spent time resolving conflicts
- Had to rename skills to avoid command conflicts
- Created unnecessary work

**The Smart Way (now enforced):**
- Always search first
- Reuse when possible
- Create only when needed
- Document decisions

## Usage Instructions

### For Claude (Me)

**Before creating ANY new component:**

1. Run the search:
   ```bash
   ./.claude/scripts/search-existing.sh "<keyword>"
   ```

2. Review results carefully

3. If found:
   - Read existing component(s)
   - Determine if they solve the need
   - Enhance if possible
   - Only create new if truly different

4. If creating new:
   - Document what you searched
   - List what you found
   - Explain why new is needed
   - Describe differences

### For Users

**When asking me to create something:**

- If I create without checking, remind me:
  > "Did you check if this already exists?"

- If I find duplicates, I'll ask:
  > "Found X existing components. Should I reuse or create new?"

- This ensures:
  - No wasted time
  - No conflicts
  - Consistent system
  - Better quality

## Summary

✅ **Rule Created:** check-before-create.md
✅ **Tool Created:** search-existing.sh
✅ **Workflow Updated:** Pre-workflow stage added
✅ **Script Tested:** Working correctly
✅ **Documentation:** Complete

**Status:** Active and enforced
**Impact:** Prevents future duplication
**Next Step:** Use for all future component creation

---

**Created:** 2025-03-19
**Lesson Learned:** Always check before creating
**Rule:** CHECK BEFORE CREATE - MANDATORY
