# Non-Technical User Guide

## Overview

This repository contains tools that make Claude smarter and more helpful. Everything runs automatically - you do not need to configure anything special.

---

## Automatic Features

### 1. Skills Auto-Activate
When you ask Claude to do something, it automatically loads the right knowledge:

| You Say | What Activates |
|---------|---------------|
| "Create a Django model" | django-dev-guidelines |
| "Build a FastAPI endpoint" | fastapi-dev-guidelines |
| "Write a PRD" | pm-guidelines |
| "Review my code" | cto-guidelines |
| "Fix Python code" | python-dev-guidelines |

### 2. Hooks Run Automatically
When you edit files, hooks automatically:
- Check for issues
- Suggest improvements
- Track changes

### 3. Agents Execute Tasks
When you want complex tasks done, agents do the work for you.

---

## Simple Commands

### For Product Management
```
"Create a PRD for [feature name]"
"Write user stories for [feature]"
"Plan a sprint for [team]"
```

### For Code
```
"Review my code" - Gets a full code review
"Fix all issues automatically" - Auto-fix mode
"Check for technical debt" - Analyzes codebase
```

### For Architecture
```
"Review my architecture"
"Help me decide between X and Y"
"Create an architecture decision record"
```

---

## Auto-Fix Mode

When you want Claude to fix things automatically without asking for confirmation:

```
"Fix all the issues in my code"
"Clean up my codebase"
"Make everything work"
```

The **auto-fixer** agent will:
1. Scan for all issues
2. Fix them automatically
3. Report what was fixed
4. Not ask permission - just do it

---

## What You Get (Summary)

### Skills (10 total) - Knowledge that auto-loads
- Python development patterns
- Django web development
- FastAPI API development
- Product management
- Technical leadership
- Backend/frontend development
- And more...

### Agents (15 total) - Task executors
- **prd-writer** - Creates PRDs
- **tech-debt-analyzer** - Finds and prioritizes debt
- **python-code-reviewer** - Reviews Python code
- **yolo-fixer** - Fixes everything automatically
- **code-architecture-reviewer** - Reviews architecture
- And 10 more...

### Hooks (9 total) - Automatic checks
- Code review on save
- Skill suggestions
- File tracking
- Error detection

---

## How to Use in Your Project

### Option 1: Copy Everything
Copy the `.claude` folder to your project:
```
your-project/
└── .claude/
    ├── agents/
    ├── hooks/
    ├── skills/
    └── settings.json
```

### Option 2: Copy What You Need
Only copy the skills/agents relevant to your work:
- Python project? Copy `python-dev-guidelines` skill
- Django project? Copy `django-dev-guidelines` skill
- Need PRDs? Copy `prd-writer` agent

---

## Tips for Non-Technical Users

1. **Just describe what you want** - Claude will figure out which skill/agent to use
2. **Use simple language** - "Create a PRD for login" works great
3. **Trust the automation** - Skills activate without you doing anything
4. **Use YOLO mode** - When you want things just fixed, say "fix everything"

---

## Getting Help

If something isn't working:
1. Check the README files in each folder
2. Ask Claude: "What skills are available?"
3. Ask Claude: "What agents can help me?"

---

## Quick Reference Card

| I Want To... | I Say... |
|--------------|----------|
| Create a PRD | "Create a PRD for [feature]" |
| Review code | "Review my code" |
| Fix issues | "Fix all issues" (YOLO) |
| Plan a sprint | "Plan a sprint" |
| Check tech debt | "Analyze technical debt" |
| Build Django | "Create a Django model for..." |
| Build FastAPI | "Create a FastAPI endpoint for..." |

**Remember: Everything runs automatically. Just tell Claude what you want!**