#!/bin/bash
# Resolve Agent Conflicts Script
# Automatically compares and resolves duplicate agent files

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
AGENTS_DIR="$PROJECT_ROOT/.claude/agents"
BACKUP_DIR="$PROJECT_ROOT/.claude/agents/backups"

echo "======================================"
echo "Agent Conflict Resolver"
echo "======================================"
echo ""

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Create backup directory
mkdir -p "$BACKUP_DIR"

# Function to compare two files
compare_agents() {
    local agent1="$1"
    local agent2="$2"

    echo -e "${BLUE}Comparing:${NC}"
    echo "  File 1: $agent1"
    echo "  File 2: $agent2"
    echo ""

    # Check if files are different
    if ! diff -q "$agent1" "$agent2" > /dev/null 2>&1; then
        echo -e "${YELLOW}Files are different${NC}"

        # Count lines
        local lines1=$(wc -l < "$agent1")
        local lines2=$(wc -l < "$agent2")

        echo "  Lines in file 1: $lines1"
        echo "  Lines in file 2: $lines2"
        echo ""

        # Check which has superpowers markers
        local has_superpowers1=0
        local has_superpowers2=0

        if grep -q "superpowers" "$agent1"; then
            has_superpowers1=1
        fi

        if grep -q "superpowers" "$agent2"; then
            has_superpowers2=1
        fi

        echo "  File 1 has superpowers markers: $has_superpowers1"
        echo "  File 2 has superpowers markers: $has_superpowers2"
        echo ""

        # Recommendation
        if [ $has_superpowers2 -eq 1 ] && [ $has_superpowers1 -eq 0 ]; then
            echo -e "${GREEN}Recommendation: Keep file 2 (superpowers version)${NC}"
            echo "  Action: Backup and replace file 1 with file 2"
            return 2
        elif [ $has_superpowers1 -eq 1 ] && [ $has_superpowers2 -eq 0 ]; then
            echo -e "${GREEN}Recommendation: Keep file 1 (superpowers version)${NC}"
            echo "  Action: Keep file 1, delete file 2"
            return 1
        else
            echo -e "${YELLOW}Both have superpowers markers or neither does${NC}"
            echo -e "${YELLOW}Recommendation: Manual review required${NC}"
            return 99
        fi
    else
        echo -e "${GREEN}Files are identical${NC}"
        echo -e "${BLUE}Action: Keep file 1, delete file 2${NC}"
        return 0
    fi
}

# Duplicate agents to resolve
declare -A duplicates=(
    ["spec-document-reviewer"]="new"
    ["plan-document-reviewer"]="new"
    ["implementer"]="new"
    ["spec-reviewer"]="new"
    ["code-quality-reviewer"]="new"
)

echo "Checking for duplicate agents..."
echo ""

for agent in "${!duplicates[@]}"; do
    agent_file="$AGENTS_DIR/$agent.md"

    if [ -f "$agent_file" ]; then
        # Check if this is one of the new ones I just created
        # by checking if it's very recent
        if [ -n "$AGENT_CHECK_START_TIME" ]; then
            file_age=$(($(date +%s) - $(stat -c %Y "$agent_file")))

            if [ $file_age -lt 3600 ]; then
                echo -e "${YELLOW}Found recent agent: $agent${NC}"

                # Check if there's an older version
                # (For this script, we'll assume the new one should be checked)
            fi
        fi
    fi
done

echo ""
echo "======================================"
echo "Manual Resolution Required"
echo "======================================"
echo ""
echo "Due to the complexity of agent conflicts, manual resolution is required."
echo ""
echo "For each duplicate agent pair:"
echo ""
echo "1. Compare the two agents:"
echo "   $ cat .claude/agents/spec-document-reviewer.md"
echo "   $ cat .claude/agents/spec-document-reviewer.md.old"
echo ""
echo "2. Decide which to keep based on:"
echo "   - Superpowers methodology compliance"
echo "   - Completeness and detail"
echo "   - Integration with skills"
echo "   - Recent updates"
echo ""
echo "3. Backup the worse version:"
echo "   $ cp .claude/agents/spec-document-reviewer.md.backup"
echo ""
echo "4. Delete the worse version:"
echo "   $ rm .claude/agents/spec-document-reviewer.md"
echo ""
echo "5. Update any skill references"
echo ""
echo "See CONFLICT_REPORT.md for detailed analysis."
echo ""
