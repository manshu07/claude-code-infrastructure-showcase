#!/bin/bash
# Update After Edit Script
# Automatically updates related files and commits after making edits

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Check if file provided
if [ -z "$1" ]; then
    echo -e "${RED}Error: Please provide the file you just edited${NC}"
    echo "Usage: $0 <file-edited> [commit-type] [commit-message]"
    echo ""
    echo "Example:"
    echo "  $0 .claude/skills/new-skill/SKILL.md feat \"Added new TDD skill\""
    exit 1
fi

EDITED_FILE="$1"
COMMIT_TYPE="${2:-update}"
COMMIT_MESSAGE="${3:-Updated $(basename "$EDITED_FILE")}"

echo -e "${BLUE}=======================================${NC}"
echo -e "${BLUE}Post-Edit Update Workflow${NC}"
echo -e "${BLUE}=======================================${NC}"
echo ""
echo -e "${GREEN}File edited:${NC} $EDITED_FILE"
echo -e "${GREEN}Commit type:${NC} $COMMIT_TYPE"
echo -e "${GREEN}Commit message:${NC} $COMMIT_MESSAGE"
echo ""

# Step 1: Find related files
echo -e "${BLUE}Step 1: Finding related files...${NC}"
RELATED_FILES=()

# If edited skill, update skill-rules.json
if [[ "$EDITED_FILE" == */skills/*/SKILL.md ]]; then
    SKILL_NAME=$(basename "$(dirname "$EDITED_FILE")")
    echo -e "  ${YELLOW}Skill file detected:${NC} $SKILL_NAME"

    # Check skill-rules.json
    if [ -f "$PROJECT_ROOT/.claude/skills/skill-rules.json" ]; then
        RELATED_FILES+=("$PROJECT_ROOT/.claude/skills/skill-rules.json")
        echo -e "  ${GREEN}→${NC} Will update: skill-rules.json"
    fi

    # Check README.md
    if [ -f "$PROJECT_ROOT/README.md" ]; then
        RELATED_FILES+=("$PROJECT_ROOT/README.md")
        echo -e "  ${GREEN}→${NC} Will update: README.md"
    fi
fi

# If edited agent, find skills that use it
if [[ "$EDITED_FILE" == */agents/*.md ]]; then
    AGENT_NAME=$(basename "$EDITED_FILE" .md)
    echo -e "  ${YELLOW}Agent file detected:${NC} $AGENT_NAME"

    # Search for skills that reference this agent
    REFERENCING_SKILLS=$(grep -r -l "$AGENT_NAME" "$PROJECT_ROOT/.claude/skills/"*/SKILL.md 2>/dev/null || true)
    if [ -n "$REFERENCING_SKILLS" ]; then
        echo "$REFERENCING_SKILLS" | while read skill; do
            RELATED_FILES+=("$skill")
            echo -e "  ${GREEN}→${NC} References in: $(basename $(dirname "$skill"))"
        done
    fi
fi

# If edited schema, find files that use it
if [[ "$EDITED_FILE" == */schemas/* ]]; then
    SCHEMA_NAME=$(basename "$EDITED_FILE")
    echo -e "  ${YELLOW}Schema file detected:${NC} $SCHEMA_NAME"

    # Search for files that reference this schema
    REFERENCING_FILES=$(grep -r -l "$SCHEMA_NAME" "$PROJECT_ROOT/.claude/" --include="*.md" 2>/dev/null || true)
    if [ -n "$REFERENCING_FILES" ]; then
        echo "$REFERENCING_FILES" | while read file; do
            RELATED_FILES+=("$file")
            echo -e "  ${GREEN}→${NC} References in: $file"
        done
    fi
fi

# If edited rule, update workflow-orchestration
if [[ "$EDITED_FILE" == */rules/workflow/*.md ]]; then
    RULE_NAME=$(basename "$EDITED_FILE")
    echo -e "  ${YELLOW}Workflow rule detected:${NC} $RULE_NAME"

    WORKFLOW_ORCH="$PROJECT_ROOT/.claude/rules/workflow/workflow-orchestration.md"
    if [ -f "$WORKFLOW_ORCH" ]; then
        RELATED_FILES+=("$WORKFLOW_ORCH")
        echo -e "  ${GREEN}→${NC} Will update: workflow-orchestration.md"
    fi
fi

echo ""

# Step 2: Check git status
echo -e "${BLUE}Step 2: Checking git status...${NC}"
cd "$PROJECT_ROOT"

if [ -d ".git" ]; then
    echo -e "  ${GREEN}Git repository detected${NC}"
    git status --short 2>&1 | head -10
else
    echo -e "  ${YELLOW}Not a git repository${NC}"
    NO_GIT=true
fi
echo ""

# Step 3: Summary of actions
echo -e "${BLUE}=======================================${NC}"
echo -e "${BLUE}Summary of Actions${NC}"
echo -e "${BLUE}=======================================${NC}"
echo ""
echo -e "${GREEN}1. ✅ File edited:${NC} $EDITED_FILE"
echo ""

if [ ${#RELATED_FILES[@]} -gt 0 ]; then
    echo -e "${YELLOW}2. ⏳ Related files to update:${NC}"
    for file in "${RELATED_FILES[@]}"; do
        echo -e "   - $file"
    done
    echo ""
    echo -e "${YELLOW}   ⚠ MANUAL UPDATE REQUIRED${NC}"
    echo -e "${YELLOW}   Please review and update these files manually.${NC}"
else
    echo -e "${GREEN}2. ✅ No related files found${NC}"
fi
echo ""

if [ "$NO_GIT" != true ]; then
    echo -e "${YELLOW}3. ⏳ Git commands to run:${NC}"
    echo -e "   ${BLUE}git add ${EDITED_FILE}${NC}"
    for file in "${RELATED_FILES[@]}"; do
        echo -e "   ${BLUE}git add ${file}${NC}"
    done
    echo -e "   ${BLUE}git commit -m \"${COMMIT_TYPE}: ${COMMIT_MESSAGE}\"${NC}"
    echo -e "   ${BLUE}git push${NC}"
    echo ""
fi

echo -e "${BLUE}=======================================${NC}"
echo ""
echo -e "${GREEN}Next Steps:${NC}"
echo "1. Review related files above"
echo "2. Update them if needed"
echo "3. Run the git commands shown above"
echo ""

if [ "$NO_GIT" != true ]; then
    echo -e "${YELLOW}Auto-commit?${NC} (not recommended - review first)"
    echo "To auto-commit (after reviewing):"
    echo "  git add .claude/ && git commit -m \"$COMMIT_TYPE: $COMMIT_MESSAGE\" && git push"
    echo ""
fi

# Optional: Create a checklist file
CHECKLIST_FILE="$PROJECT_ROOT/.claude/edit-checklist.txt"
cat > "$CHECKLIST_FILE" << EOF
Edit Checklist - $(date)
========================================

File Edited: $EDITED_FILE
Type: $COMMIT_TYPE
Message: $COMMIT_MESSAGE

Related Files to Update:
EOF

for file in "${RELATED_FILES[@]}"; do
    echo "- [ ] $file" >> "$CHECKLIST_FILE"
done

cat >> "$CHECKLIST_FILE" << EOF

Git Commands:
- [ ] git add $EDITED_FILE
EOF

for file in "${RELATED_FILES[@]}"; do
    echo "- [ ] git add $file" >> "$CHECKLIST_FILE"
done

cat >> "$CHECKLIST_FILE" << EOF
- [ ] git commit -m "$COMMIT_TYPE: $COMMIT_MESSAGE"
- [ ] git push

Verification:
- [ ] Related files updated
- [ ] Documentation updated
- [ ] Changes committed
- [ ] Pushed to repository
EOF

echo -e "${GREEN}✅ Checklist created:${NC} $CHECKLIST_FILE"
echo ""
