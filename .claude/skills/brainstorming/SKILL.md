---
name: brainstorming
description: Use when starting any creative work - creating features, building components, adding functionality, or modifying behavior. Explores user intent, requirements, and design before implementation. Prevents unexamined assumptions, wasted work, and misalignment. Critical for: new features, UI components, API endpoints, system changes, refactoring. Must complete before ANY code is written.
---

# Brainstorming Ideas Into Designs

## Purpose

Turn rough ideas into fully formed designs and specs through natural collaborative dialogue, preventing unexamined assumptions and wasted work.

## When to Use This Skill

**ALWAYS use before:**
- Creating new features
- Building components
- Adding functionality
- Modifying behavior
- System changes
- Refactoring efforts
- **ANY implementation work**

**HARD GATE:** Do NOT invoke any implementation skill, write any code, scaffold any project, or take any implementation action until you have presented a design and the user has approved it.

**Anti-Pattern:** "This Is Too Simple To Need A Design"

Every project goes through this process. A todo list, a single-function utility, a config change — all of them. "Simple" projects are where unexamined assumptions cause the most wasted work. The design can be short (a few sentences for truly simple projects), but you MUST present it and get approval.

---

## Core Principles

- **One question at a time** - Don't overwhelm with multiple questions
- **Multiple choice preferred** - Easier to answer than open-ended when possible
- **YAGNI ruthlessly** - Remove unnecessary features from all designs
- **Explore alternatives** - Always propose 2-3 approaches before settling
- **Incremental validation** - Present design, get approval before moving on
- **Be flexible** - Go back and clarify when something doesn't make sense

---

## The Process

### 1. Explore Project Context

Check the current project state first:
- Read relevant files (README, package.json, recent commits)
- Understand existing patterns and conventions
- Identify constraints and requirements
- Note the project's technology stack

### 2. Offer Visual Companion (If Applicable)

**ONLY if** the topic will involve visual questions (mockups, layouts, diagrams):

```
"Some of what we're working on might be easier to explain if I can show it to you in a web browser. I can put together mockups, diagrams, comparisons, and other visuals as we go. This feature is still new and can be token-intensive. Want to try it? (Requires opening a local URL)"
```

**This offer MUST be its own message.** Do not combine it with clarifying questions or context summaries.

If they decline, proceed with text-only brainstorming.

### 3. Ask Clarifying Questions

Ask questions **one at a time** to refine the idea. Focus on understanding:
- Purpose - What problem does this solve?
- Constraints - What are the limitations?
- Success criteria - How do we know it works?
- Context - How does this fit with existing systems?

**Prefer multiple choice questions when possible**, but open-ended is fine too.

### 4. Explore Approaches

Propose **2-3 different approaches** with trade-offs:
- Present options conversationally
- Lead with your recommended option
- Explain your reasoning
- Be ready to adjust based on feedback

### 5. Present Design

Once you understand what you're building, present the design:
- Scale each section to its complexity (few sentences if straightforward, up to 200-300 words if nuanced)
- Ask after each section whether it looks right so far
- Cover: architecture, components, data flow, error handling, testing
- Be ready to go back and clarify if something doesn't make sense

### 6. Write Design Document

After user approval, save the design to:
```
docs/superpowers/specs/YYYY-MM-DD-<topic>-design.md
```

(Override this path if user has different preferences)

Use clear, concise writing. Commit to git.

### 7. Spec Review Loop

Dispatch a **spec-document-reviewer** subagent with precisely crafted review context (never your session history):

1. Dispatch reviewer with spec path
2. If issues found: fix, re-dispatch, repeat until approved
3. If loop exceeds 3 iterations, surface to human for guidance

### 8. User Review Gate

After the spec review loop passes, ask the user to review the written spec:

> "Spec written and committed to `<path>`. Please review it and let me know if you want to make any changes before we start writing out the implementation plan."

Wait for the user's response. Only proceed once they approve.

### 9. Transition to Implementation

Invoke the **writing-plans** skill to create a detailed implementation plan.

**Do NOT** invoke frontend-design, mcp-builder, or any other implementation skill. The ONLY skill you invoke after brainstorming is writing-plans.

---

## Design for Isolation and Clarity

Break the system into smaller units that each have:
- One clear purpose
- Well-defined interfaces
- Can be understood and tested independently

For each unit, you should be able to answer:
- What does it do?
- How do you use it?
- What does it depend on?

**Can someone understand what a unit does without reading its internals?** If not, the boundaries need work.

**Can you change the internals without breaking consumers?** If not, the interface needs work.

Smaller, well-bounded units are easier to work with:
- You reason better about code you can hold in context at once
- Your edits are more reliable when files are focused
- When a file grows large, that's often a signal it's doing too much

---

## Working in Existing Codebases

- Explore the current structure before proposing changes
- Follow existing patterns
- Where existing code has problems that affect the work, include targeted improvements as part of the design
- Don't propose unrelated refactoring — stay focused on what serves the current goal

---

## Scope Check

**If the request describes multiple independent subsystems** (e.g., "build a platform with chat, file storage, billing, and analytics"):

- Flag this immediately
- Don't spend questions refining details of a project that needs to be decomposed first
- Help the user decompose into sub-projects:
  - What are the independent pieces?
  - How do they relate?
  - What order should they be built?
- Brainstorm the first sub-project through the normal design flow
- Each sub-project gets its own spec → plan → implementation cycle

---

## Key Principles Summary

| Principle | Application |
|-----------|-------------|
| **One question at a time** | Don't overwhelm with multiple questions |
| **Multiple choice preferred** | Easier to answer when possible |
| **YAGNI ruthlessly** | Remove unnecessary features |
| **Explore alternatives** | Always propose 2-3 approaches |
| **Incremental validation** | Present design, get approval, move on |
| **Be flexible** | Go back and clarify when needed |

---

## Integration with Other Skills

**Required next step:**
- **writing-plans** - Create detailed implementation plan from approved design

**Related skills:**
- **architect** agent - For complex system design decisions
- **frontend-dev-guidelines** - For UI/UX component design
- **backend-dev-guidelines** - For API and service design
- **pm-guidelines** - For product requirements and stakeholder communication

---

## Example Workflow

**User:** "I want to add user authentication"

**You:** "Let me first explore the project context to understand the current setup..."

[Reads files, checks existing patterns]

**You:** "A few questions to understand what you need:

1. **What type of authentication?**
   - Email/password with JWT tokens
   - OAuth (Google, GitHub, etc.)
   - Magic link authentication
   - Something else

I'd recommend email/password with JWT for most use cases — it's straightforward, well-understood, and gives you full control over the user experience. OAuth is great if you want users to sign in with existing accounts, but adds complexity. Magic links are excellent for UX but require careful implementation.

What feels right for your use case?"

**User:** "Email/password with JWT sounds good"

**You:** "Great. Next question:

2. **What do users need to be able to do?**
   - Just log in and log out
   - Also reset their password
   - Manage their profile (email, name, etc.)
   - Delete their account

For a minimum viable authentication system, I'd start with just login/logout and password reset — you can always add profile management later."

[Continue with more questions, then present design for approval]

---

## After Design Approval

1. **Write spec document** to `docs/superpowers/specs/YYYY-MM-DD-<topic>-design.md`
2. **Dispatch spec-document-reviewer** subagent
3. **Fix issues** and re-dispatch until approved (max 3 iterations)
4. **Ask user to review** the written spec
5. **Invoke writing-plans** skill to create implementation plan

**ONLY writing-plans skill.** No other implementation skills.

---

**Remember:** Hard gate — no implementation actions until design is approved and documented. This applies to EVERY project regardless of perceived simplicity.
