# Non-Technical User Guide

## Overview

This repository contains tools that make Claude smarter and more helpful. Everything runs automatically - you do not need to configure anything special.

**What's New (March 2025):**
- ✅ Added 17 specialized agents for complex workflows
- ✅ Added 45+ slash commands for common tasks
- ✅ Fixed all YAML parsing errors
- ✅ Added comprehensive troubleshooting guide
- ✅ Added skill validation tools
- ✅ Total: 36 skills, 33 agents, 50+ commands

---

## Automatic Features

### 1. Skills Auto-Activate
When you ask Claude to do something, it automatically loads the right knowledge:

| You Say | What Activates |
|---------|---------------|
| "Create a Django model" | django-dev-guidelines |
| "Build a FastAPI endpoint" | fastapi-dev-guidelines |
| "Write a PRD" | pm-guidelines |
| "Review my code" | code-reviewer agent |
| "Fix Python code" | python-reviewer agent |
| "Plan a feature" | planner agent |
| "Test this route" | route-tester skill |

### 2. Hooks Run Automatically
When you edit files, hooks automatically:
- Check for issues
- Suggest improvements
- Track changes
- Remind about error handling

### 3. Agents Execute Tasks
When you want complex tasks done, agents do the work for you:

**Popular Agents:**
- **planner** - Plans features before coding
- **code-reviewer** - Reviews code for quality
- **tdd-guide** - Enforces test-driven development
- **architect** - Designs system architecture
- **security-reviewer** - Checks for security issues

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
"Review my code" - code-reviewer agent
"Fix all issues" - build-error-resolver agent
"Check for technical debt" - tech-debt-analyzer agent
"Write tests first" - tdd-guide agent
```

### For Architecture
```
"Review my architecture" - architect agent
"Design the system for [feature]" - architect agent
"Help me decide between X and Y" - architect agent
```

### For Planning
```
"Plan the implementation of [feature]" - planner agent
"Create a step-by-step plan" - plan command
"Review this plan" - plan-reviewer agent
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

### Skills (36 total) - Knowledge that auto-loads
- **Backend**: Node.js, Python, Django, FastAPI patterns
- **Frontend**: React, TypeScript, MUI, shadcn-ui
- **DevOps**: CI/CD, Docker, deployment
- **Quality**: Testing, TDD, code review, error tracking
- **Security**: OWASP Top 10, API security
- **AI/Agents**: Agentic engineering, cost optimization
- **Leadership**: CTO guidelines, PM guidelines
- **Content**: Article writing, investor materials
- **And 20+ more...**

### Agents (33 total) - Task executors
**New Key Agents:**
- **planner** - Creates implementation plans
- **code-reviewer** - Reviews code for quality/security
- **tdd-guide** - Enforces test-driven development
- **architect** - Designs system architecture
- **security-reviewer** - Checks for vulnerabilities
- **build-error-resolver** - Fixes build errors
- **python-reviewer** - Python-specific reviews
- **database-reviewer** - PostgreSQL optimization
- **chief-of-staff** - Communication triage

**Original Agents:**
- **prd-writer** - Creates PRDs
- **tech-debt-analyzer** - Finds technical debt
- **python-code-reviewer** - Reviews Python code
- **yolo-fixer** - Fixes everything automatically
- **code-architecture-reviewer** - Reviews architecture
- And 20+ more...

### Hooks (10 total) - Automatic checks
- Code review suggestions
- Skill auto-activation
- File tracking
- Error handling reminders
- Code quality reminders

### Commands (50+ total) - Quick shortcuts
**Popular Commands:**
- `/plan` - Create implementation plan
- `/tdd` - Enforce test-driven development
- `/code-review` - Review code changes
- `/build-fix` - Fix build errors
- `/quality-gate` - Quality checks
- `/learn` - Extract reusable patterns
- `/verify` - Comprehensive verification

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
| Fix issues | "Fix all issues" |
| Plan feature | "Plan the implementation of [feature]" |
| Check tech debt | "Analyze technical debt" |
| Build Django | "Create a Django model for..." |
| Build FastAPI | "Create a FastAPI endpoint for..." |
| Write tests | "Write tests for [feature]" |
| Design system | "Design the architecture for [feature]" |
| Security check | "Check for security issues" |

## New Features (March 2025)

### Slash Commands
Type these directly in Claude:
- `/plan` - Get implementation plan before coding
- `/tdd` - Write tests first, then code
- `/code-review` - Automatic code review
- `/learn` - Save patterns for reuse
- `/verify` - Full verification check

### Better Planning
- **planner agent** creates step-by-step plans
- Waits for YOUR approval before coding
- Breaks complex features into phases

### Improved Code Quality
- **code-reviewer** - Automatic reviews after changes
- **security-reviewer** - Security vulnerability checks
- **tdd-guide** - Ensures 80%+ test coverage
- **build-error-resolver** - Fixes build errors

### Specialized Help
- **architect** - System design decisions
- **database-reviewer** - SQL optimization
- **python-reviewer** - PEP 8 compliance
- **chief-of-staff** - Communication management

**Remember: Everything runs automatically. Just tell Claude what you want!**