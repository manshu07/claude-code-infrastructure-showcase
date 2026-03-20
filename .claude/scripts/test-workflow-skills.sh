#!/bin/bash
# Test Superpowers Workflow Skills
# Validates that all workflow skills are properly configured and functional

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
SKILLS_DIR="$PROJECT_ROOT/.claude/skills"
AGENTS_DIR="$PROJECT_ROOT/.claude/agents"

echo "======================================"
echo "Superpowers Workflow Skills Test Suite"
echo "======================================"
echo ""

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Test counter
TESTS_PASSED=0
TESTS_FAILED=0

# Function to print test result
print_result() {
    if [ $1 -eq 0 ]; then
        echo -e "${GREEN}✓ PASS${NC}: $2"
        ((TESTS_PASSED++))
    else
        echo -e "${RED}✗ FAIL${NC}: $2"
        ((TESTS_FAILED++))
    fi
}

# Test 1: Check skill files exist
echo "Testing skill files..."
test -f "$SKILLS_DIR/tdd-methodology/SKILL.md"
print_result $? "tdd-methodology skill exists"

test -f "$SKILLS_DIR/verification-first/SKILL.md"
print_result $? "verification-first skill exists"

test -f "$SKILLS_DIR/brainstorming/SKILL.md"
print_result $? "brainstorming skill exists"

test -f "$SKILLS_DIR/implementation-planning/SKILL.md"
print_result $? "implementation-planning skill exists"

test -f "$SKILLS_DIR/subagent-driven-development/SKILL.md"
print_result $? "subagent-driven-development skill exists"

echo ""

# Test 2: Check agent files exist
echo "Testing agent files..."
test -f "$AGENTS_DIR/spec-document-reviewer.md"
print_result $? "spec-document-reviewer agent exists"

test -f "$AGENTS_DIR/plan-document-reviewer.md"
print_result $? "plan-document-reviewer agent exists"

test -f "$AGENTS_DIR/implementer.md"
print_result $? "implementer agent exists"

test -f "$AGENTS_DIR/spec-reviewer.md"
print_result $? "spec-reviewer agent exists"

test -f "$AGENTS_DIR/code-quality-reviewer.md"
print_result $? "code-quality-reviewer agent exists"

echo ""

# Test 3: Check schema files exist
echo "Testing schema files..."
test -f "$PROJECT_ROOT/.claude/schemas/design-spec-template.md"
print_result $? "design spec template exists"

test -f "$PROJECT_ROOT/.claude/schemas/implementation-plan-template.md"
print_result $? "implementation plan template exists"

test -f "$PROJECT_ROOT/.claude/schemas/validation-schema.yaml"
print_result $? "validation schema exists"

echo ""

# Test 4: Check workflow rules exist
echo "Testing workflow rules..."
test -f "$PROJECT_ROOT/.claude/rules/workflow/tdd-enforcement.md"
print_result $? "TDD enforcement rules exist"

test -f "$PROJECT_ROOT/.claude/rules/workflow/verification-requirements.md"
print_result $? "verification requirements rules exist"

test -f "$PROJECT_ROOT/.claude/rules/workflow/workflow-orchestration.md"
print_result $? "workflow orchestration rules exist"

echo ""

# Test 5: Validate skill frontmatter
echo "Testing skill frontmatter..."
for skill in tdd-methodology verification-first brainstorming implementation-planning subagent-driven-development; do
    skill_file="$SKILLS_DIR/$skill/SKILL.md"

    # Check if file starts with frontmatter delimiter
    if head -n 1 "$skill_file" | grep -q "^---$"; then
        print_result 0 "$skill has valid frontmatter start"
    else
        print_result 1 "$skill missing frontmatter start"
    fi

    # Check if frontmatter contains 'name' field
    if grep -q "^name:" "$skill_file"; then
        print_result 0 "$skill has 'name' field"
    else
        print_result 1 "$skill missing 'name' field"
    fi

    # Check if frontmatter contains 'description' field
    if grep -q "^description:" "$skill_file"; then
        print_result 0 "$skill has 'description' field"
    else
        print_result 1 "$skill missing 'description' field"
    fi
done

echo ""

# Test 6: Validate agent frontmatter
echo "Testing agent frontmatter..."
for agent in spec-document-reviewer plan-document-reviewer implementer spec-reviewer code-quality-reviewer; do
    agent_file="$AGENTS_DIR/$agent.md"

    # Check if file starts with frontmatter delimiter
    if head -n 1 "$agent_file" | grep -q "^---$"; then
        print_result 0 "$agent has valid frontmatter start"
    else
        print_result 1 "$agent missing frontmatter start"
    fi

    # Check if frontmatter contains 'name' field
    if grep -q "^name:" "$agent_file"; then
        print_result 0 "$agent has 'name' field"
    else
        print_result 1 "$agent missing 'name' field"
    fi

    # Check if frontmatter contains 'description' field
    if grep -q "^description:" "$agent_file"; then
        print_result 0 "$agent has 'description' field"
    else
        print_result 1 "$agent missing 'description' field"
    fi
done

echo ""

# Test 7: Check skill-rules.json includes new skills
echo "Testing skill-rules.json integration..."
if [ -f "$SKILLS_DIR/skill-rules.json" ]; then
    # Check if each skill is in skill-rules.json
    for skill in tdd-methodology verification-first brainstorming implementation-planning subagent-driven-development; do
        if grep -q "\"$skill\":" "$SKILLS_DIR/skill-rules.json"; then
            print_result 0 "$skill is in skill-rules.json"
        else
            print_result 1 "$skill is NOT in skill-rules.json"
        fi
    done
else
    echo -e "${YELLOW}⚠ SKIP${NC}: skill-rules.json not found"
fi

echo ""

# Test 8: Validate YAML syntax
echo "Testing YAML syntax..."
if command -v yamllint &> /dev/null; then
    yamllint "$PROJECT_ROOT/.claude/schemas/validation-schema.yaml" > /dev/null 2>&1
    print_result $? "validation-schema.yaml has valid YAML"
else
    echo -e "${YELLOW}⚠ SKIP${NC}: yamllint not installed"
fi

echo ""

# Test 9: Check skill sizes (500-line rule)
echo "Testing skill sizes (500-line rule)..."
for skill in tdd-methodology verification-first brainstorming implementation-planning subagent-driven-development; do
    skill_file="$SKILLS_DIR/$skill/SKILL.md"
    lines=$(wc -l < "$skill_file")

    if [ $lines -le 500 ]; then
        print_result 0 "$skill is under 500 lines ($lines lines)"
    else
        print_result 1 "$skill exceeds 500 lines ($lines lines)"
    fi
done

echo ""

# Test 10: Check for required sections in skills
echo "Testing skill sections..."

# Check tdd-methodology for Iron Law
if grep -q "Iron Law" "$SKILLS_DIR/tdd-methodology/SKILL.md"; then
    print_result 0 "tdd-methodology has Iron Law section"
else
    print_result 1 "tdd-methodology missing Iron Law section"
fi

# Check verification-first for Gate Function
if grep -q "Gate Function" "$SKILLS_DIR/verification-first/SKILL.md"; then
    print_result 0 "verification-first has Gate Function section"
else
    print_result 1 "verification-first missing Gate Function section"
fi

# Check brainstorming for Hard Gate
if grep -q "HARD GATE" "$SKILLS_DIR/brainstorming/SKILL.md"; then
    print_result 0 "brainstorming has Hard Gate section"
else
    print_result 1 "brainstorming missing Hard Gate section"
fi

echo ""

# Summary
echo "======================================"
echo "Test Summary"
echo "======================================"
echo -e "${GREEN}Passed: $TESTS_PASSED${NC}"
echo -e "${RED}Failed: $TESTS_FAILED${NC}"
echo ""

if [ $TESTS_FAILED -eq 0 ]; then
    echo -e "${GREEN}All tests passed!${NC}"
    exit 0
else
    echo -e "${RED}Some tests failed!${NC}"
    exit 1
fi
