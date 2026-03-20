#!/bin/bash
# Validate Implementation Plan Document
# Validates an implementation plan against the required schema

set -e

PLAN_FILE="$1"

if [ -z "$PLAN_FILE" ]; then
    echo "Usage: $0 <plan-file>"
    exit 1
fi

if [ ! -f "$PLAN_FILE" ]; then
    echo "Error: Plan file not found: $PLAN_FILE"
    exit 1
fi

echo "Validating implementation plan: $PLAN_FILE"
echo ""

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Validation checks
PASSED=0
FAILED=0

# Check for required header sections
echo "Checking header sections..."

if grep -q "^#.*Implementation Plan$" "$PLAN_FILE"; then
    echo -e "${GREEN}✓${NC} Plan title present"
    ((PASSED++))
else
    echo -e "${RED}✗${NC} Plan title missing"
    ((FAILED++))
fi

if grep -q "\*\*Goal:\*\*" "$PLAN_FILE"; then
    echo -e "${GREEN}✓${NC} Goal specified"
    ((PASSED++))
else
    echo -e "${RED}✗${NC} Goal missing"
    ((FAILED++))
fi

if grep -q "\*\*Architecture:\*\*" "$PLAN_FILE"; then
    echo -e "${GREEN}✓${NC} Architecture specified"
    ((PASSED++))
else
    echo -e "${RED}✗${NC} Architecture missing"
    ((FAILED++))
fi

if grep -q "\*\*Tech Stack:\*\*" "$PLAN_FILE"; then
    echo -e "${GREEN}✓${NC} Tech stack specified"
    ((PASSED++))
else
    echo -e "${RED}✗${NC} Tech stack missing"
    ((FAILED++))
fi

echo ""

# Check for tasks
echo "Checking tasks..."

TASK_COUNT=$(grep -c "^### Task [0-9]" "$PLAN_FILE" || echo "0")

if [ "$TASK_COUNT" -gt 0 ]; then
    echo -e "${GREEN}✓${NC} Found $TASK_COUNT tasks"
    ((PASSED++))
else
    echo -e "${RED}✗${NC} No tasks found"
    ((FAILED++))
fi

# Check task structure
echo ""
echo "Checking task structure..."

# Each task should have specific sections
for i in $(seq 1 $TASK_COUNT); do
    TASK_HEADER=$(grep -n "^### Task $i:" "$PLAN_FILE" | cut -d: -f1)

    if [ -n "$TASK_HEADER" ]; then
        # Extract task content (next 50 lines)
        TASK_CONTENT=$(sed -n "$((TASK_HEADER + 1)),$((TASK_HEADER + 50))p" "$PLAN_FILE")

        # Check for Files section
        if echo "$TASK_CONTENT" | grep -q "\*\*Files:\*\*"; then
            : # File section present
        else
            echo -e "${YELLOW}⚠${NC} Task $i: Files section missing"
        fi

        # Check for TDD steps
        if echo "$TASK_CONTENT" | grep -q "Write the failing test"; then
            : # TDD cycle present
        else
            echo -e "${YELLOW}⚠${NC} Task $i: TDD cycle missing"
        fi

        # Check for commit step
        if echo "$TASK_CONTENT" | grep -q "Commit"; then
            : # Commit step present
        else
            echo -e "${YELLOW}⚠${NC} Task $i: Commit step missing"
        fi
    fi
done

echo ""

# Check for file paths
echo "Checking file paths..."

FILE_PATH_COUNT=$(grep -c "Create:\|Modify:" "$PLAN_FILE" || echo "0")

if [ "$FILE_PATH_COUNT" -gt 0 ]; then
    echo -e "${GREEN}✓${NC} Found $FILE_PATH_COUNT file path specifications"
    ((PASSED++))
else
    echo -e "${RED}✗${NC} No file paths specified"
    ((FAILED++))
fi

# Check for code blocks
echo ""
echo "Checking code blocks..."

CODE_BLOCK_COUNT=$(grep -c '^\`\`\`' "$PLAN_FILE" || echo "0")

if [ "$CODE_BLOCK_COUNT" -ge 2 ]; then
    echo -e "${GREEN}✓${NC} Found code blocks ($CODE_BLOCK_COUNT code fences)"
    ((PASSED++))
else
    echo -e "${RED}✗${NC} No code blocks found"
    ((FAILED++))
fi

# Check for commands
echo ""
echo "Checking commands..."

COMMAND_COUNT=$(grep -c "^Run:" "$PLAN_FILE" || echo "0")

if [ "$COMMAND_COUNT" -gt 0 ]; then
    echo -e "${GREEN}✓${NC} Found $COMMAND_COUNT command specifications"
    ((PASSED++))
else
    echo -e "${RED}✗${NC} No commands specified"
    ((FAILED++))
fi

# Check for expected output
echo ""
echo "Checking expected output..."

EXPECTED_COUNT=$(grep -c "Expected:" "$PLAN_FILE" || echo "0")

if [ "$EXPECTED_COUNT" -gt 0 ]; then
    echo -e "${GREEN}✓${NC} Found $EXPECTED_COUNT expected output specifications"
    ((PASSED++))
else
    echo -e "${RED}✗${NC} No expected output specified"
    ((FAILED++))
fi

echo ""

# Summary
echo "======================================"
echo "Validation Summary"
echo "======================================"
echo -e "${GREEN}Passed: $PASSED${NC}"
echo -e "${RED}Failed: $FAILED${NC}"
echo ""

if [ $FAILED -eq 0 ]; then
    echo -e "${GREEN}✓ Implementation plan is valid!${NC}"
    exit 0
else
    echo -e "${RED}✗ Implementation plan validation failed!${NC}"
    exit 1
fi
