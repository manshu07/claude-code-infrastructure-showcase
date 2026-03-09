# Claude Code Infrastructure Showcase

**A curated reference library of production-tested Claude Code infrastructure.**

Born from 6 months of real-world use managing a complex TypeScript microservices project, this showcase provides the patterns and systems that solved the "skills don't activate automatically" problem and scaled Claude Code for enterprise development.

> **This is NOT a working application** - it's a reference library. Copy what you need into your own projects.

---

## What's Inside

**Production-tested infrastructure for:**
- ✅ **Auto-activating skills** via hooks
- ✅ **Modular skill pattern** (500-line rule with progressive disclosure)
- ✅ **36 specialized skills** covering backend, frontend, DevOps, AI, and more
- ✅ **33 specialized agents** for complex tasks
- ✅ **50+ slash commands** for common workflows
- ✅ **Dev docs system** that survives context resets
- ✅ **Comprehensive examples** using generic blog domain
- ✅ **Non-technical guide** for users of all skill levels
- ✅ **Orchestration patterns** for agent-skill collaboration
- ✅ **MCP integration** for extended capabilities
- ✅ **YAML validation and troubleshooting guides**

**Time investment to build:** 6 months of iteration
**Time to integrate into your project:** 15-30 minutes
**Last updated:** March 2025

---

## Quick Start - Pick Your Path

### 🤖 Using Claude Code to Integrate?

**Claude:** Read [`CLAUDE_INTEGRATION_GUIDE.md`](CLAUDE_INTEGRATION_GUIDE.md) for step-by-step integration instructions tailored for AI-assisted setup.

### 🎯 I want skill auto-activation

**The breakthrough feature:** Skills that actually activate when you need them.

**What you need:**
1. The skill-activation hooks (2 files)
2. A skill or two relevant to your work
3. 15 minutes

**👉 [Setup Guide: .claude/hooks/README.md](.claude/hooks/README.md)**

### 📚 I want to add ONE skill

Browse the [skills catalog](.claude/skills/) and copy what you need.

**Available Skills (36 total):**

**Backend Development:**
- **backend-dev-guidelines** - Node.js/Express/TypeScript patterns
- **python-dev-guidelines** - Python development best practices
- **django-dev-guidelines** - Django web framework patterns
- **fastapi-dev-guidelines** - FastAPI high-performance APIs
- **api-design** - REST API design patterns

**Frontend Development:**
- **frontend-dev-guidelines** - React/TypeScript/MUI v7 patterns
- **shadcn-ui-guidelines** - shadcn-ui/Tailwind CSS components
- **frontend-slides** - Create HTML presentations from scratch

**DevOps & Infrastructure:**
- **devops-guidelines** - CI/CD, Docker, deployment strategies
- **browser-automation** - Playwright/Puppeteer automation

**Quality & Testing:**
- **testing-guidelines** - Unit, integration, E2E testing
- **tdd-workflow** - Test-driven development workflow
- **error-tracking** - Sentry integration patterns
- **coding-standards** - Project coding standards and best practices

**Security & Performance:**
- **security-guidelines** - OWASP Top 10, API security
- **performance-optimization** - Frontend/backend optimization

**AI & Agents:**
- **agentic-engineering** - Operate as an agentic engineer
- **ai-first-engineering** - AI-first engineering operating model
- **agent-harness-construction** - Design AI agent action spaces
- **continuous-agent-loop** - Continuous autonomous agent loops
- **cost-aware-llm-pipeline** - Cost optimization for LLM usage
- **continuous-learning** - Extract reusable patterns from sessions
- **continuous-learning-v2** - Instinct-based learning system

**Leadership & Process:**
- **cto-guidelines** - Technical leadership & architecture decisions
- **pm-guidelines** - Product management & planning

**Content & Marketing:**
- **article-writing** - Write articles, guides, blog posts
- **content-engine** - Multi-platform content systems
- **market-research** - Market research and competitive analysis
- **investor-materials** - Pitch decks, financial models
- **investor-outreach** - Investor communications and outreach

**Specialized Tools:**
- **pricing-master** - Pricing strategy and optimization
- **strategic-compact** - Context compaction strategies
- **verification-loop** - Comprehensive session verification

**Meta:**
- **skill-developer** - Create and manage skills
- **route-tester** - Test authenticated API routes
- **frontend-patterns** - React/Next.js patterns (NEW)

**👉 [Skills Guide: .claude/skills/README.md](.claude/skills/README.md)**

### 🤖 I want specialized agents

33 production-tested agents for complex tasks:

**Development Agents:**
- **architect** - System design and architecture decisions
- **planner** - Implementation planning for features
- **code-reviewer** - Code quality and security review
- **python-reviewer** - Python PEP 8 compliance
- **database-reviewer** - PostgreSQL optimization
- **security-reviewer** - Security vulnerability detection
- **tdd-guide** - Test-driven development enforcement
- **build-error-resolver** - Fix build and TypeScript errors
- Code architecture review
- Refactoring assistance
- Browser automation

**Documentation & Planning:**
- **doc-updater** - Documentation and codemap updates
- PRD writing
- UX writing
- Documentation generation
- Plan review

**Quality & Debugging:**
- **e2e-runner** - End-to-end testing with Playwright
- **refactor-cleaner** - Dead code cleanup
- Error debugging
- Tech debt analysis
- YOLO fixing (quick fixes)

**Specialized:**
- **chief-of-staff** - Communication triage
- **harness-optimizer** - Agent harness optimization
- **loop-operator** - Autonomous agent loops
- **go-build-resolver** - Go build error fixes
- **go-reviewer** - Go code review

**👉 [Agents Guide: .claude/agents/README.md](.claude/agents/README.md)**

### 💬 I want slash commands

50+ commands for common tasks:

**Planning & Development:**
- **/plan** - Create implementation plan
- **/tdd** - Test-driven development
- **/code-review** - Review code changes
- **/build-fix** - Fix build errors

**Quality & Testing:**
- **/quality-gate** - Quality checks
- **/test-coverage** - Check test coverage
- **/e2e** - Run end-to-end tests
- **/verify** - Comprehensive verification

**Learning & Patterns:**
- **/learn** - Extract reusable patterns
- **/skill-create** - Generate skills from git history
- **/evolve** - Evolve instincts

**Multi-Model:**
- **/multi-plan** - Multi-model planning
- **/multi-workflow** - Multi-model development
- **/orchestrate** - Orchestrate workflows

**And 40+ more commands**

### 👶 New to Claude Code?

**Start here:** Read [`NON-TECH-GUIDE.md`](NON-TECH-GUIDE.md) for a beginner-friendly introduction to using this repository.

---

## What Makes This Different?

### The Auto-Activation Breakthrough

**Problem:** Claude Code skills just sit there. You have to remember to use them.

**Solution:** UserPromptSubmit hook that:
- Analyzes your prompts
- Checks file context
- Automatically suggests relevant skills
- Works via `skill-rules.json` configuration

**Result:** Skills activate when you need them, not when you remember them.

### Production-Tested Patterns

These aren't theoretical examples - they're extracted from:
- ✅ 6 microservices in production
- ✅ 50,000+ lines of TypeScript
- ✅ React frontend with complex data grids
- ✅ Sophisticated workflow engine
- ✅ 6 months of daily Claude Code use

The patterns work because they solved real problems.

### Modular Skills (500-Line Rule)

Large skills hit context limits. The solution:

```
skill-name/
  SKILL.md                  # <500 lines, high-level guide
  resources/
    topic-1.md              # <500 lines each
    topic-2.md
    topic-3.md
```

**Progressive disclosure:** Claude loads main skill first, loads resources only when needed.

---

## Repository Structure

```
.claude/
├── skills/                 # 34 production skills
│   ├── backend-dev-guidelines/  (Node.js/Express/TypeScript)
│   ├── frontend-dev-guidelines/ (React/MUI v7/TypeScript)
│   ├── python-dev-guidelines/   (Python best practices)
│   ├── django-dev-guidelines/   (Django web framework)
│   ├── fastapi-dev-guidelines/  (FastAPI high-performance APIs)
│   ├── shadcn-ui-guidelines/    (shadcn-ui/Tailwind CSS)
│   ├── browser-automation/      (Playwright/Puppeteer)
│   ├── cto-guidelines/          (Technical leadership)
│   ├── pm-guidelines/           (Product management)
│   ├── skill-developer/         (Create your own skills)
│   ├── route-tester/            (API testing)
│   ├── error-tracking/          (Sentry integration)
│   └── skill-rules.json    # Skill activation configuration
├── hooks/                  # 10 hooks for automation
│   ├── skill-activation-prompt.*  (ESSENTIAL)
│   ├── post-tool-use-tracker.sh   (ESSENTIAL)
│   ├── auto-code-review.sh        (NEW - automated reviews)
│   ├── tsc-check.sh        (optional, needs customization)
│   └── trigger-build-resolver.sh  (optional)
├── agents/                 # 16 specialized agents
│   ├── code-architecture-reviewer.md
│   ├── python-code-reviewer.md     (NEW)
│   ├── browser-automation.md       (NEW)
│   ├── prd-writer.md               (NEW)
│   ├── ux-writer.md                (NEW)
│   ├── tech-debt-analyzer.md       (NEW)
│   ├── yolo-fixer.md               (NEW)
│   └── ... 9 more
└── commands/               # 5 slash commands
    ├── dev-docs.md
    ├── browser-test.md     (NEW)
    └── ...

dev/
└── active/                 # Dev docs pattern examples
    └── public-infrastructure-repo/
```

---

## Component Catalog

### 🎨 Skills (36)

**Backend Development:**

| Skill | Purpose | Best For |
|-------|---------|----------|
| [**backend-dev-guidelines**](.claude/skills/backend-dev-guidelines/) | Express/Prisma/Sentry patterns | Node.js APIs |
| [**python-dev-guidelines**](.claude/skills/python-dev-guidelines/) | Python best practices, async, testing | Python projects |
| [**django-dev-guidelines**](.claude/skills/django-dev-guidelines/) | Django models, views, DRF patterns | Django web apps |
| [**fastapi-dev-guidelines**](.claude/skills/fastapi-dev-guidelines/) | FastAPI routing, Pydantic, auth | High-performance APIs |
| [**api-design**](.claude/skills/api-design/) | REST API design patterns | API architecture |

**Frontend Development:**

| Skill | Purpose | Best For |
|-------|---------|----------|
| [**frontend-dev-guidelines**](.claude/skills/frontend-dev-guidelines/) | React/MUI v7/TypeScript patterns | React frontends |
| [**shadcn-ui-guidelines**](.claude/skills/shadcn-ui-guidelines/) | shadcn-ui components, Tailwind CSS | Modern UI development |
| [**frontend-slides**](.claude/skills/frontend-slides/) | Create HTML presentations | Presentations & pitches |

**DevOps & Infrastructure:**

| Skill | Purpose | Best For |
|-------|---------|----------|
| [**devops-guidelines**](.claude/skills/devops-guidelines/) | CI/CD, Docker, deployment | DevOps workflows |
| [**browser-automation**](.claude/skills/browser-automation/) | Playwright/Puppeteer patterns | Web scraping, testing |

**Quality & Testing:**

| Skill | Purpose | Best For |
|-------|---------|----------|
| [**testing-guidelines**](.claude/skills/testing-guidelines/) | Unit, integration, E2E testing | Testing strategy |
| [**tdd-workflow**](.claude/skills/tdd-workflow/) | Test-driven development workflow | TDD implementation |
| [**error-tracking**](.claude/skills/error-tracking/) | Sentry integration patterns | Error monitoring |
| [**coding-standards**](.claude/skills/coding-standards/) | Project coding standards | Code consistency |

**Security & Performance:**

| Skill | Purpose | Best For |
|-------|---------|----------|
| [**security-guidelines**](.claude/skills/security-guidelines/) | OWASP Top 10, API security | Security audits |
| [**performance-optimization**](.claude/skills/performance-optimization/) | Frontend/backend optimization | Performance tuning |

**AI & Agents:**

| Skill | Purpose | Best For |
|-------|---------|----------|
| [**agentic-engineering**](.claude/skills/agentic-engineering/) | Agentic engineering patterns | AI agent development |
| [**ai-first-engineering**](.claude/skills/ai-first-engineering/) | AI-first development model | AI-powered teams |
| [**agent-harness-construction**](.claude/skills/agent-harness-construction/) | Design AI agent action spaces | Agent architecture |
| [**continuous-agent-loop**](.claude/skills/continuous-agent-loop/) | Autonomous agent loops | Continuous automation |
| [**cost-aware-llm-pipeline**](.claude/skills/cost-aware-llm-pipeline/) | LLM cost optimization | Cost management |
| [**continuous-learning**](.claude/skills/continuous-learning/) | Extract reusable patterns | Knowledge management |
| [**continuous-learning-v2**](.claude/skills/continuous-learning-v2/) | Instinct-based learning | Advanced pattern extraction |

**Leadership & Process:**

| Skill | Purpose | Best For |
|-------|---------|----------|
| [**cto-guidelines**](.claude/skills/cto-guidelines/) | Architecture decisions, team scaling | Tech leaders |
| [**pm-guidelines**](.claude/skills/pm-guidelines/) | PRDs, roadmaps, stakeholder communication | Product managers |

**Content & Marketing:**

| Skill | Purpose | Best For |
|-------|---------|----------|
| [**article-writing**](.claude/skills/article-writing/) | Write articles, guides, blog posts | Content creation |
| [**content-engine**](.claude/skills/content-engine/) | Multi-platform content systems | Content operations |
| [**market-research**](.claude/skills/market-research/) | Market research and competitive analysis | Market insights |
| [**investor-materials**](.claude/skills/investor-materials/) | Pitch decks, financial models | Fundraising |
| [**investor-outreach**](.claude/skills/investor-outreach/) | Investor communications and outreach | Investor relations |

**Specialized Tools:**

| Skill | Purpose | Best For |
|-------|---------|----------|
| [**pricing-master**](.claude/skills/pricing-master/) | Pricing strategy and optimization | Pricing decisions |
| [**strategic-compact**](.claude/skills/strategic-compact/) | Context compaction strategies | Context management |
| [**verification-loop**](.claude/skills/verification-loop/) | Comprehensive session verification | Quality assurance |

**Meta & Utilities:**

| Skill | Purpose | Best For |
|-------|---------|----------|
| [**skill-developer**](.claude/skills/skill-developer/) | Create and manage Claude Code skills | Custom skills |
| [**route-tester**](.claude/skills/route-tester/) | Test authenticated API routes | API testing |
| [**frontend-patterns**](.claude/skills/frontend-patterns/) | React/Next.js patterns (NEW) | Modern frontend |

**All skills follow the modular pattern** - main file + resource files for progressive disclosure.

**👉 [How to integrate skills →](.claude/skills/README.md)**

### 🪝 Hooks (10)

| Hook | Type | Essential? | Customization |
|------|------|-----------|---------------|
| skill-activation-prompt | UserPromptSubmit | ✅ YES | ✅ None needed |
| post-tool-use-tracker | PostToolUse | ✅ YES | ✅ None needed |
| auto-code-review | PreToolUse | ⚠️ Optional | ✅ None needed |
| code-quality-reminder | PreToolUse | ⚠️ Optional | ✅ None needed |
| tsc-check | Stop | ⚠️ Optional | ⚠️ Heavy - monorepo only |
| trigger-build-resolver | Stop | ⚠️ Optional | ⚠️ Heavy - monorepo only |
| error-handling-reminder | Stop | ⚠️ Optional | ⚠️ Moderate |
| stop-build-check-enhanced | Stop | ⚠️ Optional | ⚠️ Moderate |

**Start with the two essential hooks** - they enable skill auto-activation and work out of the box.

**👉 [Hook setup guide →](.claude/hooks/README.md)**

### 🤖 Agents (33)

**Standalone - just copy and use!**

**Core Development (NEW):**

| Agent | Purpose |
|-------|---------|
| **architect** | System design and architecture decisions |
| **planner** | Implementation planning for features |
| **code-reviewer** | Code quality and security review |
| **tdd-guide** | Test-driven development enforcement |
| **security-reviewer** | Security vulnerability detection |

**Specialized Reviewers:**

| Agent | Purpose |
|-------|---------|
| **python-reviewer** | Python PEP 8 compliance |
| **database-reviewer** | PostgreSQL optimization |
| **go-reviewer** | Go code review |
| **go-build-resolver** | Go build error fixes |
| code-architecture-reviewer | Architectural consistency |
| python-code-reviewer | Python-specific review |
| tech-debt-analyzer | Technical debt analysis |

**Quality & Testing:**

| Agent | Purpose |
|-------|---------|
| **build-error-resolver** | Fix build/TypeScript errors |
| **e2e-runner** | End-to-end testing |
| **refactor-cleaner** | Dead code cleanup |
| frontend-error-fixer | Debug frontend errors |
| auto-error-resolver | Auto-fix TypeScript errors |

**Development & Refactoring:**

| Agent | Purpose |
|-------|---------|
| code-refactor-master | Plan and execute refactoring |
| refactor-planner | Create refactoring strategies |
| browser-automation | Browser automation tasks |
| yolo-fixer | Quick fixes without planning |

**Documentation & Planning:**

| Agent | Purpose |
|-------|---------|
| **doc-updater** | Documentation updates |
| documentation-architect | Generate documentation |
| prd-writer | Write Product Requirements Documents |
| ux-writer | UX copy and content |
| plan-reviewer | Review development plans |

**Specialized:**

| Agent | Purpose |
|-------|---------|
| **chief-of-staff** | Communication triage |
| **harness-optimizer** | Agent harness optimization |
| **loop-operator** | Autonomous agent loops |
| auth-route-tester | Test authenticated endpoints |
| auth-route-debugger | Debug auth issues |
| web-research-specialist | Research technical issues |

**👉 [How agents work →](.claude/agents/README.md)**

### 💬 Slash Commands (50+)

**Planning & Development:**

| Command | Purpose |
|---------|---------|
| **/plan** | Create implementation plan |
| **/tdd** | Test-driven development |
| **/code-review** | Review code changes |
| **/build-fix** | Fix build errors |

**Quality & Testing:**

| Command | Purpose |
|---------|---------|
| **/quality-gate** | Quality checks |
| **/test-coverage** | Check test coverage |
| **/e2e** | Run E2E tests |
| **/verify** | Comprehensive verification |

**Learning & Patterns:**

| Command | Purpose |
|---------|---------|
| **/learn** | Extract reusable patterns |
| **/learn-eval** | Extract with self-evaluation |
| **/skill-create** | Generate skills from git |
| **/evolve** | Evolve instincts |

**Multi-Model:**

| Command | Purpose |
|---------|---------|
| **/multi-plan** | Multi-model planning |
| **/multi-workflow** | Multi-model development |
| **/multi-execute** | Multi-model execution |
| **/multi-frontend** | Frontend-focused |
| **/multi-backend** | Backend-focused |
| **/orchestrate** | Orchestrate workflows |

**Go Specific:**

| Command | Purpose |
|---------|---------|
| **/go-test** | Go TDD workflow |
| **/go-review** | Go code review |
| **/go-build** | Fix Go build errors |

**And 30+ more commands**

---

## Key Concepts

### Hooks + skill-rules.json = Auto-Activation

**The system:**
1. **skill-activation-prompt hook** runs on every user prompt
2. Checks **skill-rules.json** for trigger patterns
3. Suggests relevant skills automatically
4. Skills load only when needed

**This solves the #1 problem** with Claude Code skills: they don't activate on their own.

### Progressive Disclosure (500-Line Rule)

**Problem:** Large skills hit context limits

**Solution:** Modular structure
- Main SKILL.md <500 lines (overview + navigation)
- Resource files <500 lines each (deep dives)
- Claude loads incrementally as needed

**Example:** backend-dev-guidelines has 12 resource files covering routing, controllers, services, repositories, testing, etc.

### Dev Docs Pattern

**Problem:** Context resets lose project context

**Solution:** Three-file structure
- `[task]-plan.md` - Strategic plan
- `[task]-context.md` - Key decisions and files
- `[task]-tasks.md` - Checklist format

**Works with:** `/dev-docs` slash command to generate these automatically

---

## ⚠️ Important: What Won't Work As-Is

### settings.json
The included `settings.json` is an **example only**:
- Stop hooks reference specific monorepo structure
- Service names (blog-api, etc.) are examples
- MCP servers may not exist in your setup

**To use it:**
1. Extract ONLY UserPromptSubmit and PostToolUse hooks
2. Customize or skip Stop hooks
3. Update MCP server list for your setup

### Blog Domain Examples
Skills use generic blog examples (Post/Comment/User):
- These are **teaching examples**, not requirements
- Patterns work for any domain (e-commerce, SaaS, etc.)
- Adapt the patterns to your business logic

### Hook Directory Structures
Some hooks expect specific structures:
- `tsc-check.sh` expects service directories
- Customize based on YOUR project layout

---

## Integration Workflow

**Recommended approach:**

### Phase 1: Skill Activation (15 min)
1. Copy skill-activation-prompt hook
2. Copy post-tool-use-tracker hook
3. Update settings.json
4. Install hook dependencies

### Phase 2: Add First Skill (10 min)
1. Pick ONE relevant skill
2. Copy skill directory
3. Create/update skill-rules.json
4. Customize path patterns

### Phase 3: Test & Iterate (5 min)
1. Edit a file - skill should activate
2. Ask a question - skill should be suggested
3. Add more skills as needed

### Phase 4: Optional Enhancements
- Add agents you find useful
- Add slash commands
- Customize Stop hooks (advanced)

---

## Getting Help

### For Users
**Issues with integration?**
1. Check [CLAUDE_INTEGRATION_GUIDE.md](CLAUDE_INTEGRATION_GUIDE.md)
2. Check [.claude/TROUBLESHOOTING.md](.claude/TROUBLESHOOTING.md) (NEW)
3. Ask Claude: "Why isn't [skill] activating?"
4. Run `.claude/scripts/validate-skill.sh` to check skill structure (NEW)
5. Open an issue with your project structure

### For Claude Code
When helping users integrate:
1. **Read CLAUDE_INTEGRATION_GUIDE.md FIRST**
2. Check [.claude/TROUBLESHOOTING.md](.claude/TROUBLESHOOTING.md) for common issues
3. Ask about their project structure
4. Customize, don't blindly copy
5. Verify after integration

---

## Recent Updates (March 2025)

### New Features
- ✅ **17 new specialized agents** for complex workflows
- ✅ **45+ new slash commands** for common tasks
- ✅ **Comprehensive troubleshooting guide** added
- ✅ **Skill validation script** for checking structure
- ✅ **TypeScript build guide** for hooks
- ✅ **Skill structure standards** documentation
- ✅ **frontend-patterns skill** added
- ✅ **All YAML parsing errors fixed**

### Infrastructure Improvements
- Fixed "mapping values are not allowed in this context" errors
- Standardized skill directory naming conventions
- Added automated validation tools
- Enhanced documentation coverage

### Documentation
- Added `.claude/TROUBLESHOOTING.md` - comprehensive troubleshooting
- Added `.claude/SKILL_STRUCTURE_STANDARDS.md` - directory conventions
- Added `.claude/hooks/TYPESCRIPT_BUILD_GUIDE.md` - TypeScript hooks
- Added `.claude/scripts/validate-skill.sh` - skill validation
- Updated NON-TECH-GUIDE.md with latest features

---

## What This Solves

### Before This Infrastructure

❌ Skills don't activate automatically
❌ Have to remember which skill to use
❌ Large skills hit context limits
❌ Context resets lose project knowledge
❌ No consistency across development
❌ Manual agent invocation every time

### After This Infrastructure

✅ Skills suggest themselves based on context
✅ Hooks trigger skills at the right time
✅ Modular skills stay under context limits
✅ Dev docs preserve knowledge across resets
✅ Consistent patterns via guardrails
✅ Agents streamline complex tasks

---

## Community

**Found this useful?**

- ⭐ Star this repo
- 🐛 Report issues or suggest improvements
- 💬 Share your own skills/hooks/agents
- 📝 Contribute examples from your domain

**Background:**
This infrastructure was detailed in a post I made to Reddit ["Claude Code is a Beast – Tips from 6 Months of Hardcore Use"](https://www.reddit.com/r/ClaudeAI/comments/1oivjvm/claude_code_is_a_beast_tips_from_6_months_of/). After hundreds of requests, this showcase was created to help the community implement these patterns.


---

## License

MIT License - Use freely in your projects, commercial or personal.

---

## Quick Links

- 📖 [Claude Integration Guide](CLAUDE_INTEGRATION_GUIDE.md) - For AI-assisted setup
- 👶 [Non-Technical Guide](NON-TECH-GUIDE.md) - Beginner-friendly introduction
- 🎨 [Skills Documentation](.claude/skills/README.md)
- 🪝 [Hooks Setup](.claude/hooks/README.md)
- 🤖 [Agents Guide](.claude/agents/README.md)
- 📝 [Dev Docs Pattern](dev/README.md)
- 🔄 [Agents vs Skills](.claude/AGENTS_VS_SKILLS.md) - When to use which
- 🔌 [MCP Integration](.claude/MCP_INTEGRATION.md) - MCP server patterns
- 🎯 [Orchestration Patterns](.claude/ORCHESTRATION_PATTERNS.md) - Agent-skill workflows
- 📚 [System README](.claude/README.md) - Complete system documentation
- 🔧 [Troubleshooting Guide](.claude/TROUBLESHOOTING.md) - Common issues and solutions (NEW)
- 📐 [Skill Structure Standards](.claude/SKILL_STRUCTURE_STANDARDS.md) - Directory conventions (NEW)

**Start here:** Copy the two essential hooks, add one skill, and see the auto-activation magic happen.
