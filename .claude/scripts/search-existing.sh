#!/bin/bash
# Search Existing Components Script
# Quickly search for existing skills, agents, scripts, rules, schemas, and hooks

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Check if keyword provided
if [ -z "$1" ]; then
    echo -e "${RED}Error: Please provide a keyword to search${NC}"
    echo "Usage: $0 <keyword>"
    echo ""
    echo "Example:"
    echo "  $0 reviewer"
    echo "  $0 tdd"
    echo "  $0 test"
    exit 1
fi

KEYWORD="$1"
echo -e "${BLUE}=======================================${NC}"
echo -e "${BLUE}Searching for: ${GREEN}$KEYWORD${NC}"
echo -e "${BLUE}=======================================${NC}"
echo ""

# Count results
TOTAL=0

# Search Skills
echo -e "${BLUE}📁 Skills:${NC}"
SKILL_COUNT=$(find "$PROJECT_ROOT/.claude/skills/" -maxdepth 1 -type d -iname "*$KEYWORD*" 2>/dev/null | wc -l)
if [ $SKILL_COUNT -gt 0 ]; then
    find "$PROJECT_ROOT/.claude/skills/" -maxdepth 1 -type d -iname "*$KEYWORD*" 2>/dev/null | while read dir; do
        echo -e "  ${GREEN}✓${NC} $(basename "$dir")"
    done
    TOTAL=$((TOTAL+SKILL_COUNT))
else
    echo -e "  ${YELLOW}No matching skill directories${NC}"
fi

# Search skill content
SKILL_CONTENT=$(grep -r -l -i "$KEYWORD" "$PROJECT_ROOT/.claude/skills/"*/SKILL.md 2>/dev/null | wc -l)
if [ $SKILL_CONTENT -gt 0 ]; then
    echo -e "  ${YELLOW}Found in $(basename $(grep -r -l -i "$KEYWORD" "$PROJECT_ROOT/.claude/skills/"*/SKILL.md 2>/dev/null | head -1 | cut -d/ -f6)) SKILL.md${NC}"
fi
echo ""

# Search Agents
echo -e "${BLUE}🤖 Agents:${NC}"
AGENT_COUNT=$(find "$PROJECT_ROOT/.claude/agents/" -maxdepth 1 -type f -iname "*$KEYWORD*.md" 2>/dev/null | wc -l)
if [ $AGENT_COUNT -gt 0 ]; then
    find "$PROJECT_ROOT/.claude/agents/" -maxdepth 1 -type f -iname "*$KEYWORD*.md" 2>/dev/null | while read file; do
        echo -e "  ${GREEN}✓${NC} $(basename "$file")"
    done
    TOTAL=$((TOTAL+AGENT_COUNT))
else
    echo -e "  ${YELLOW}No matching agent files${NC}"
fi

# Search agent content
AGENT_CONTENT=$(grep -r -l -i "$KEYWORD" "$PROJECT_ROOT/.claude/agents/"*.md 2>/dev/null | wc -l)
if [ $AGENT_CONTENT -gt 0 ]; then
    echo -e "  ${YELLOW}Found in $(grep -r -l -i "$KEYWORD" "$PROJECT_ROOT/.claude/agents/"*.md 2>/dev/null | wc -l) agent files${NC}"
fi
echo ""

# Search Scripts
echo -e "${BLUE}📜 Scripts:${NC}"
SCRIPT_COUNT=$(find "$PROJECT_ROOT/.claude/scripts/" -maxdepth 1 -type f -iname "*$KEYWORD*.sh" 2>/dev/null | wc -l)
if [ $SCRIPT_COUNT -gt 0 ]; then
    find "$PROJECT_ROOT/.claude/scripts/" -maxdepth 1 -type f -iname "*$KEYWORD*.sh" 2>/dev/null | while read file; do
        echo -e "  ${GREEN}✓${NC} $(basename "$file")"
    done
    TOTAL=$((TOTAL+SCRIPT_COUNT))
else
    echo -e "  ${YELLOW}No matching script files${NC}"
fi
echo ""

# Search Rules
echo -e "${BLUE}📋 Rules:${NC}"
RULE_COUNT=$(find "$PROJECT_ROOT/.claude/rules/" -type f -iname "*$KEYWORD*.md" 2>/dev/null | wc -l)
if [ $RULE_COUNT -gt 0 ]; then
    find "$PROJECT_ROOT/.claude/rules/" -type f -iname "*$KEYWORD*.md" 2>/dev/null | while read file; do
        echo -e "  ${GREEN}✓${NC} $file"
    done
    TOTAL=$((TOTAL+RULE_COUNT))
else
    echo -e "  ${YELLOW}No matching rule files${NC}"
fi
echo ""

# Search Schemas
echo -e "${BLUE}📐 Schemas:${NC}"
SCHEMA_COUNT=$(find "$PROJECT_ROOT/.claude/schemas/" -maxdepth 1 -type f -iname "*$KEYWORD*" 2>/dev/null | wc -l)
if [ $SCHEMA_COUNT -gt 0 ]; then
    find "$PROJECT_ROOT/.claude/schemas/" -maxdepth 1 -type f -iname "*$KEYWORD*" 2>/dev/null | while read file; do
        echo -e "  ${GREEN}✓${NC} $(basename "$file")"
    done
    TOTAL=$((TOTAL+SCHEMA_COUNT))
else
    echo -e "  ${YELLOW}No matching schema files${NC}"
fi
echo ""

# Search Hooks
echo -e "${BLUE}🔗 Hooks:${NC}"
HOOK_COUNT=$(find "$PROJECT_ROOT/.claude/hooks/" -maxdepth 1 -type f -iname "*$KEYWORD*" 2>/dev/null | wc -l)
if [ $HOOK_COUNT -gt 0 ]; then
    find "$PROJECT_ROOT/.claude/hooks/" -maxdepth 1 -type f -iname "*$KEYWORD*" 2>/dev/null | while read file; do
        echo -e "  ${GREEN}✓${NC} $(basename "$file")"
    done
    TOTAL=$((TOTAL+HOOK_COUNT))
else
    echo -e "  ${YELLOW}No matching hook files${NC}"
fi
echo ""

# Search skill-rules.json
echo -e "${BLUE}📝 skill-rules.json:${NC}"
if [ -f "$PROJECT_ROOT/.claude/skills/skill-rules.json" ]; then
    SKILL_RULES_MATCH=$(grep -i "\"$KEYWORD\":" "$PROJECT_ROOT/.claude/skills/skill-rules.json" 2>/dev/null | wc -l)
    if [ $SKILL_RULES_MATCH -gt 0 ]; then
        echo -e "  ${GREEN}✓${NC} Found in skill-rules.json"
        TOTAL=$((TOTAL+SKILL_RULES_MATCH))
    else
        echo -e "  ${YELLOW}Not found in skill-rules.json${NC}"
    fi
fi
echo ""

# Summary
echo -e "${BLUE}=======================================${NC}"
if [ $TOTAL -gt 0 ]; then
    echo -e "${GREEN}Found $TOTAL matching component(s)${NC}"
    echo ""
    echo -e "${YELLOW}⚠ ACTION REQUIRED:${NC}"
    echo "1. Review existing components above"
    echo "2. Determine if they solve your need"
    echo "3. If yes: REUSE existing component"
    echo "4. If no: Create new component with clear differentiation"
else
    echo -e "${GREEN}No existing components found${NC}"
    echo ""
    echo -e "${GREEN}✓ SAFE to create new component${NC}"
fi
echo -e "${BLUE}=======================================${NC}"
