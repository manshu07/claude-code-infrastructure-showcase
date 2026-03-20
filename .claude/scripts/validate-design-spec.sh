#!/bin/bash
# Validate Design Spec Document
# Validates a design spec against the required schema

set -e

SPEC_FILE="$1"

if [ -z "$SPEC_FILE" ]; then
    echo "Usage: $0 <spec-file>"
    exit 1
fi

if [ ! -f "$SPEC_FILE" ]; then
    echo "Error: Spec file not found: $SPEC_FILE"
    exit 1
fi

echo "Validating design spec: $SPEC_FILE"
echo ""

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Validation checks
PASSED=0
FAILED=0

check_section() {
    if grep -q "^## $1" "$SPEC_FILE"; then
        echo -e "${GREEN}✓${NC} Section '$1' exists"
        ((PASSED++))
        return 0
    else
        echo -e "${RED}✗${NC} Section '$1' missing"
        ((FAILED++))
        return 1
    fi
}

# Required sections
echo "Checking required sections..."
check_section "Overview"
check_section "User Stories"
check_section "Requirements"
check_section "Architecture"
check_section "Technical Approach"
check_section "Testing Strategy"
check_section "Dependencies"

echo ""

# Check for key content
echo "Checking key content..."

# Problem statement
if grep -q "Problem Statement:" "$SPEC_FILE"; then
    echo -e "${GREEN}✓${NC} Problem statement present"
    ((PASSED++))
else
    echo -e "${RED}✗${NC} Problem statement missing"
    ((FAILED++))
fi

# Goals
if grep -q "Goals:" "$SPEC_FILE"; then
    echo -e "${GREEN}✓${NC} Goals present"
    ((PASSED++))
else
    echo -e "${RED}✗${NC} Goals missing"
    ((FAILED++))
fi

# Success criteria
if grep -q "Success Criteria:" "$SPEC_FILE"; then
    echo -e "${GREEN}✓${NC} Success criteria present"
    ((PASSED++))
else
    echo -e "${RED}✗${NC} Success criteria missing"
    ((FAILED++))
fi

# Technology stack
if grep -q "Technology Stack:" "$SPEC_FILE"; then
    echo -e "${GREEN}✓${NC} Technology stack specified"
    ((PASSED++))
else
    echo -e "${RED}✗${NC} Technology stack missing"
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
    echo -e "${GREEN}✓ Spec document is valid!${NC}"
    exit 0
else
    echo -e "${RED}✗ Spec document validation failed!${NC}"
    exit 1
fi
