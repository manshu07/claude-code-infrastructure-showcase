# Check Before Create Rule

## Iron Rule: ALWAYS Check Before Creating

**CRITICAL:** Before creating ANY new skill, agent, script, rule, schema, or hook, you MUST:

1. **Search for existing components** that solve the same problem
2. **Compare functionality** to avoid duplication
3. **Reuse existing components** when possible
4. **Only create new** when genuinely needed

## Mandatory Pre-Creation Checklist

### For Skills
```bash
# Check if skill exists
ls -la .claude/skills/ | grep -i "<keyword>"

# Check skill-rules.json for similar triggers
grep -i "<keyword>" .claude/skills/skill-rules.json

# Search skill descriptions
grep -r "<concept>" .claude/skills/*/SKILL.md
```

### For Agents
```bash
# Check if agent exists
ls -la .claude/agents/ | grep -i "<keyword>"

# Search agent descriptions
grep -r "<concept>" .claude/agents/*.md
```

### For Scripts
```bash
# Check if script exists
ls -la .claude/scripts/ | grep -i "<keyword>"

# Search script functionality
grep -r "<concept>" .claude/scripts/*.sh
```

### For Rules
```bash
# Check if rule exists
ls -la .claude/rules/ | grep -i "<keyword>"

# Search rule content
grep -r "<concept>" .claude/rules/**/*.md
```

### For Schemas
```bash
# Check if schema exists
ls -la .claude/schemas/ | grep -i "<keyword>"

# Search schema content
grep -r "<concept>" .claude/schemas/*
```

### For Hooks
```bash
# Check if hook exists
ls -la .claude/hooks/ | grep -i "<keyword>"

# Search hook functionality
grep -r "<concept>" .claude/hooks/*
```

## Search Strategy

### 1. Broad Search First
```bash
# Search across all relevant directories
grep -r "<keyword>" .claude/skills/ .claude/agents/ .claude/scripts/ .claude/rules/ .claude/schemas/ .claude/hooks/
```

### 2. Check Similar Names
```bash
# Find similar names (fuzzy match)
find .claude/skills/ -type d -iname "*<partial-name>*"
find .claude/agents/ -type f -iname "*<partial-name>*"
```

### 3. Check Descriptions
```bash
# Search descriptions for similar purpose
grep -r "description.*<purpose>" .claude/skills/skill-rules.json
grep -r "^description:" .claude/agents/*.md | grep -i "<concept>"
```

## Decision Matrix

| Scenario | Action |
|----------|--------|
| **Exact match exists** | Use existing component, DO NOT create new |
| **Similar component exists** | Enhance existing if possible, else create new with clear differentiation |
| **Partial overlap** | Reuse what exists, extend only for unique functionality |
| **Nothing similar exists** | Create new component with clear purpose |

## Anti-Patterns to Avoid

❌ **WRONG:**
```bash
# Creating without checking
echo "Creating new agent..."
write .claude/agents/my-agent.md
```

✅ **RIGHT:**
```bash
# First check what exists
echo "Checking for existing agents..."
ls -la .claude/agents/ | grep -i "my-agent"
grep -r "my concept" .claude/agents/*.md

# Then decide
if [ existing ]; then
  echo "Reusing existing agent..."
else
  echo "Creating new agent..."
  write .claude/agents/my-agent.md
fi
```

## Documentation Requirements

When you DO create a new component (after checking):

1. **Document the search** you performed
2. **List similar components** you found
3. **Explain why** a new component was needed
4. **Describe differences** from existing components

Example:
```markdown
## Search Performed
- Checked .claude/agents/ for "reviewer" agents
- Found: code-reviewer, security-reviewer
- Missing: spec-document-reviewer

## Why New Component Needed
Existing code-reviewer focuses on code quality after implementation.
New spec-document-reviewer focuses on design spec completeness before implementation.
Different stage of workflow, different purpose.
```

## Integration with Workflow

This rule MUST be followed at these workflow stages:

1. **Brainstorming**: Check existing skills before suggesting new skills
2. **Implementation Planning**: Check existing agents/scripts before planning new ones
3. **Subagent Development**: Check existing agents before creating new subagents
4. **Documentation**: Check existing docs before creating new docs

## Verification

Before marking ANY task complete that involved creating new components:

```bash
# Run verification
./.claude/scripts/verify-no-duplicates.sh "<component-type>" "<component-name>"
```

## Consequences

**If you skip this step:**
- Waste time creating duplicates
- Create maintenance burden
- Confuse users with similar components
- Violate DRY principle

**If you follow this step:**
- Reuse battle-tested components
- Faster development
- Consistent system
- Easier maintenance

## Examples

### Example 1: Agent Creation
❌ **Wrong:**
```
User: "I need an agent to review specs"
Assistant: [Creates spec-document-reviewer without checking]
Result: Duplicate! spec-reviewer already existed
```

✅ **Right:**
```
User: "I need an agent to review specs"
Assistant: [Checks .claude/agents/]
         Found: spec-reviewer.md
         [Reads spec-reviewer.md]
         "spec-reviewer already does spec compliance review. Should I enhance it or do you need something different?"
```

### Example 2: Skill Creation
❌ **Wrong:**
```
User: "Add TDD workflow"
Assistant: [Creates test-driven-development skill]
Result: Conflict with /tdd command!
```

✅ **Right:**
```
User: "Add TDD workflow"
Assistant: [Checks skill-rules.json for "tdd"]
         Found: /tdd command exists
         [Checks skills/ directory]
         No tdd-methodology skill
         "I'll create tdd-methodology skill (not test-driven-development) to avoid conflict with /tdd command"
```

## Tools to Help

### Search Helper Script
```bash
# search-existing.sh - Search all Claude Code components
search-existing() {
    local keyword="$1"
    echo "Searching for: $keyword"
    echo "================================"

    echo -e "\n📁 Skills:"
    find .claude/skills/ -type d -iname "*$keyword*" 2>/dev/null

    echo -e "\n🤖 Agents:"
    find .claude/agents/ -type f -iname "*$keyword*" 2>/dev/null

    echo -e "\n📜 Scripts:"
    find .claude/scripts/ -type f -iname "*$keyword*" 2>/dev/null

    echo -e "\n📋 Rules:"
    find .claude/rules/ -type f -iname "*$keyword*" 2>/dev/null

    echo -e "\n📐 Schemas:"
    find .claude/schemas/ -type f -iname "*$keyword*" 2>/dev/null

    echo -e "\n🔗 Hooks:"
    find .claude/hooks/ -type f -iname "*$keyword*" 2>/dev/null

    echo -e "\n🔍 Content search:"
    grep -r "$keyword" .claude/skills/ .claude/agents/ .claude/scripts/ .claude/rules/ .claude/schemas/ .claude/hooks/ 2>/dev/null | head -20
}
```

## Remember

**Check First → Reuse When Possible → Create Only When Needed**

This saves time, reduces complexity, and keeps the system maintainable.

---

**Created:** 2025-03-19
**Purpose:** Prevent duplicate component creation
**Status:** MANDATORY for all development work
