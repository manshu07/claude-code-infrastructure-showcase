#!/bin/bash
# Verify Workflow Compliance Script
# Checks that all stages of the superpowers workflow were completed in order

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
STATE_FILE="$PROJECT_ROOT/.claude/hooks/state/workflow-state.json"

echo "======================================"
echo "Workflow Compliance Checker"
echo "======================================"
echo ""

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Check if state file exists
if [ ! -f "$STATE_FILE" ]; then
    echo -e "${YELLOW}⚠ WARNING:${NC} No workflow state found."
    echo "This may mean the workflow hasn't started or the state file is missing."
    exit 0
fi

# Load state
CURRENT_STAGE=$(jq -r '.currentStage' "$STATE_FILE")
LAST_STAGE=$(jq -r '.lastStage' "$STATE_FILE")
DESIGN_APPROVED=$(jq -r '.designApproved' "$STATE_FILE")
PLAN_APPROVED=$(jq -r '.planApproved' "$STATE_FILE")
GATES_PASSED=$(jq -r '.gatesPassed[]' "$STATE_FILE" 2>/dev/null || echo "")

echo "Current Stage: $CURRENT_STAGE"
echo "Last Stage: $LAST_STAGE"
echo "Design Approved: $DESIGN_APPROVED"
echo "Plan Approved: $PLAN_APPROVED"
echo "Gates Passed: ${GATES_PASSED:-none}"
echo ""

# Validation checks
COMPLIANT=true
WARNINGS=0
ERRORS=0

# Check 1: Design approval
if [ "$DESIGN_APPROVED" = "true" ]; then
    echo -e "${GREEN}✓${NC} Design has been approved"
else
    echo -e "${RED}✗${NC} Design has NOT been approved"
    ((ERRORS++))
    COMPLIANT=false
fi

# Check 2: Plan approval
if [ "$PLAN_APPROVED" = "true" ]; then
    echo -e "${GREEN}✓${NC} Plan has been approved"
else
    echo -e "${RED}✗${NC} Plan has NOT been approved"
    ((ERRORS++))
    COMPLIANT=false
fi

# Check 3: Stage order
echo ""
echo "Checking stage order..."

EXPECTED_ORDER=("brainstorming" "writing-plans" "executing" "verification")
ACTUAL_ORDER=()

# Check gates passed
if [ -n "$GATES_PASSED" ]; then
    while IFS= read -r gate; do
        ACTUAL_ORDER+=("$gate")
    done <<< "$GATES_PASSED"
fi

# Check if stages were followed in order
for i in "${!EXPECTED_ORDER[@]}"; do
    expected="${EXPECTED_ORDER[$i]}"
    actual="${ACTUAL_ORDER[$i]:-none}"

    if [ "$actual" = "$expected" ]; then
        echo -e "${GREEN}✓${NC} Stage $i ($expected) completed in order"
    else
        echo -e "${RED}✗${NC} Stage $i should be $expected, but got $actual"
        ((ERRORS++))
        COMPLIANT=false
    fi
done

# Check 4: Required documentation
echo ""
echo "Checking required documentation..."

SPEC_DOC=$(jq -r '.specDocumentPath // empty' "$STATE_FILE")
PLAN_DOC=$(jq -r '.planDocumentPath // empty' "$STATE_FILE")

if [ "$SPEC_DOC" != "empty" ] && [ -f "$PROJECT_ROOT/$SPEC_DOC" ]; then
    echo -e "${GREEN}✓${NC} Spec document exists: $SPEC_DOC"
else
    echo -e "${YELLOW}⚠${NC} Spec document not found"
    ((WARNINGS++))
fi

if [ "$PLAN_DOC" != "empty" ] && [ -f "$PROJECT_ROOT/$PLAN_DOC" ]; then
    echo -e "${GREEN}✓${NC} Plan document exists: $PLAN_DOC"
else
    echo -e "${YELLOW}⚠${NC} Plan document not found"
    ((WARNINGS++))
fi

# Summary
echo ""
echo "======================================"
echo "Compliance Summary"
echo "======================================"
echo -e "${GREEN}Errors:${NC} $ERRORS"
echo -e "${YELLOW}Warnings:${NC} $WARNINGS"
echo ""

if [ "$COMPLIANT" = true ] && [ $ERRORS -eq 0 ]; then
    echo -e "${GREEN}✓ Workflow is compliant!${NC}"
    exit 0
else
    echo -e "${RED}✗ Workflow compliance check failed!${NC}"
    exit 1
fi
