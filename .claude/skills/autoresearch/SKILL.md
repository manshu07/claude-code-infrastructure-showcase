---
name: autoresearch
description: "Autonomously optimize any Claude Code skill by running it repeatedly, scoring outputs against binary evals, mutating the prompt, and keeping improvements. Based on Karpathy's autoresearch methodology. Use when: optimize this skill, improve this skill, run autoresearch on, make this skill better, self-improve skill, benchmark skill, eval my skill, run evals on. Outputs: an improved SKILL.md, a results log, and a changelog of every mutation tried."
---

# Autoresearch for Skills

Most skills work about 70% of the time. The other 30% you get garbage. The fix isn't to rewrite the skill from scratch. It's to let an agent run it dozens of times, score every output, and tighten the prompt until that 30% disappears.

This skill adapts Andrej Karpathy's autoresearch methodology (autonomous experimentation loops) to Claude Code skills. Instead of optimizing ML training code, we optimize skill prompts.

---

## the core job

Take any existing skill, define what "good output" looks like as binary yes/no checks, then run an autonomous loop that:

1. Generates outputs from the skill using test inputs
2. Scores every output against the eval criteria
3. Mutates the skill prompt to fix failures
4. Keeps mutations that improve the score, discards the rest
5. Repeats until the score ceiling is hit or the user stops it

---

## before starting: gather context

**STOP. Do not run any experiments until all fields below are confirmed with the user. Ask for any missing fields before proceeding.**

1. **Target skill** — Which skill do you want to optimize? (need the exact path to SKILL.md)
2. **Test inputs** — What 3-5 different prompts/scenarios should we test the skill with? (variety matters — pick inputs that cover different use cases so we don't overfit to one scenario)
3. **Eval criteria** — What 3-6 binary yes/no checks define a good output? (these are your "test questions" — see [references/eval-guide.md](references/eval-guide.md) for how to write good evals)
4. **Runs per experiment** — How many times should we run the skill per mutation? Default: 5. (more runs = more reliable scores, but slower and more expensive. 5 is the sweet spot for most skills.)
5. **Run interval** — How often should experiments cycle? Default: every 2 minutes. (shorter = faster iteration, but costs more)
6. **Budget cap** — Optional. Max number of experiment cycles before stopping. Default: no cap (runs until you stop it).

---

## step 1: read the skill

Before changing anything, read and understand the target skill completely.

1. Read the full SKILL.md file
2. Read any files in `references/` that the skill links to
3. Identify the skill's core job, process steps, and output format
4. Note any existing quality checks or anti-patterns already in the skill

Do NOT skip this. You need to understand what the skill does before you can improve it.

---

## step 2: build the eval suite

Convert the user's eval criteria into a structured test. Every check must be binary — pass or fail, no scales.

**Format each eval:**

```
EVAL [number]: [Short name]
Question: [Yes/no question about the output]
Pass: [What "yes" looks like — be specific]
Fail: [What triggers a "no"]
```

**Requirements:** Binary only (yes/no). 3-6 evals is optimal. See [references/eval-guide.md](references/eval-guide.md) for detailed examples.

**Max score:** `[number of evals] × [runs per experiment]` (e.g., 4 evals × 5 runs = max score of 20).

---

## anti-patterns for mutations

**NEVER do these:**
- Rewrite entire skill from scratch
- Add multiple rules at once
- Add vague instructions like "make it better"
- Lengthen skill without specific reason

**ALWAYS do these:**
- Change ONE thing per experiment
- Test specific, targeted changes
- Remove complexity that doesn't add value

---

## step 3: generate the live dashboard

Create `autoresearch-[skill-name]/dashboard.html` with:
- Auto-refresh every 10 seconds (reads `results.json`)
- Line chart: experiment # vs pass rate %
- Color-coded experiments: green (keep), red (discard), blue (baseline)
- Experiment table with: #, score, pass rate, status, description
- Per-eval breakdown showing pass/fail rates
- Current status: "Running experiment [N]..." or "Idle"

Use single HTML file with inline CSS/JS, Chart.js from CDN. Open immediately after creation: `open dashboard.html`.

**Update `results.json`** after each experiment:

```json
{
  "skill_name": "[name]",
  "status": "running",
  "current_experiment": 3,
  "baseline_score": 70.0,
  "best_score": 90.0,
  "experiments": [
    {"id": 0, "score": 14, "max_score": 20, "pass_rate": 70.0, "status": "baseline", "description": "original"}
  ],
  "eval_breakdown": [
    {"name": "Text legibility", "pass_count": 8, "total": 10}
  ]
}
```

When finished, set `status` to `"complete"`.

---

## step 4: establish baseline

Run the skill AS-IS before changing anything. This is experiment #0.

1. **Ask the user what to name the new version.** Example: "What should I call the optimized version? (e.g., anti-slop-v2, anti-slop-optimized)" The user picks the name.
2. Create a working directory: `autoresearch-[skill-name]/` inside the skill's folder
3. **Copy the original SKILL.md into the working directory as `[user-chosen-name].md`** — this is the copy you will mutate. NEVER edit the original SKILL.md. All mutations happen on this copy only.
4. Also save `SKILL.md.baseline` in the working directory (identical to the original — this is your revert target)
4. Create `results.tsv` with the header row
5. Create `results.json` and `dashboard.html`, then open the dashboard in the browser
6. Run the skill [N] times using the test inputs (use [user-chosen-name].md for all runs)
7. Score every output against every eval
8. Record the baseline score and update both results.tsv and results.json

**results.tsv format (tab-separated):**

```
experiment	score	max_score	pass_rate	status	description
0	14	20	70.0%	baseline	original skill — no changes
```

**IMPORTANT:** After establishing baseline, confirm the score with the user before proceeding. If baseline is already 90%+, the skill may not need optimization — ask the user if they want to continue.

---

## step 5: run the experiment loop

This is the core autoresearch loop. Once started, run autonomously until stopped.

**LOOP:**

1. **Analyze failures.** Look at which evals are failing most. Read the actual outputs that failed. Identify the pattern — is it a formatting issue? A missing instruction? An ambiguous directive?

2. **Form a hypothesis.** Pick ONE thing to change. Don't change 5 things at once — you won't know what helped.

   Good mutations:
   - Add a specific instruction that addresses the most common failure
   - Reword an ambiguous instruction to be more explicit
   - Add an anti-pattern ("Do NOT do X") for a recurring mistake
   - Move a buried instruction higher in the skill (priority = position)
   - Add or improve an example that shows the correct behavior
   - Remove an instruction that's causing the skill to over-optimize for one thing at the expense of others

   Bad mutations:
   - Rewriting the entire skill from scratch
   - Adding 10 new rules at once
   - Making the skill longer without a specific reason
   - Adding vague instructions like "make it better" or "be more creative"

3. **Make the change.** Edit `[user-chosen-name].md` (in the working directory) with ONE targeted mutation. NEVER touch the original SKILL.md.

4. **Run the experiment.** Execute the skill [N] times with the same test inputs.

5. **Score it.** Run every output through every eval. Calculate total score.

6. **Decide: keep or discard.**
   - Score improved → **KEEP.** Log it. This is the new baseline for `[user-chosen-name].md`.
   - Score stayed the same → **DISCARD.** Revert `[user-chosen-name].md` to previous version. The change added complexity without improvement.
   - Score got worse → **DISCARD.** Revert `[user-chosen-name].md` to previous version.

7. **Log the result** in results.tsv.

8. **Repeat.** Go back to step 1 of the loop.

**NEVER STOP.** Once the loop starts, do not pause to ask the user if you should continue. They may be away from the computer. Run autonomously until:
- The user manually stops you
- You hit the budget cap (if one was set)
- You hit 95%+ pass rate for 3 consecutive experiments (diminishing returns)

**If you run out of ideas:** Re-read the failing outputs. Try combining two previous near-miss mutations. Try a completely different approach to the same problem. Try removing things instead of adding them. Simplification that maintains the score is a win.

---

## step 6: write the changelog

After each experiment (whether kept or discarded), append to `changelog.md`:

```markdown
## Experiment [N] — [keep/discard]

**Score:** [X]/[max] ([percent]%)
**Change:** [One sentence describing what was changed]
**Reasoning:** [Why this change was expected to help]
**Result:** [What actually happened — which evals improved/declined]
**Failing outputs:** [Brief description of what still fails, if anything]
```

This changelog is the most valuable artifact. It's a research log that any future agent (or smarter future model) can pick up and continue from.

---

## step 7: deliver results

When the user returns or the loop stops, present:

1. **Score summary:** Baseline score → Final score (percent improvement)
2. **Total experiments run:** How many mutations were tried
3. **Keep rate:** How many mutations were kept vs discarded
4. **Top 3 changes that helped most** (from the changelog)
5. **Remaining failure patterns** (what the skill still gets wrong, if anything)
6. **The improved [user-chosen-name].md** (in the working directory — the original SKILL.md is untouched)
7. **Location of results.tsv and changelog.md** for reference

---

## output format

Produces in `autoresearch-[skill-name]/`:

```
dashboard.html       # live dashboard (auto-refreshes)
results.json         # dashboard data
results.tsv          # experiment log
changelog.md         # mutation details
SKILL.md.baseline    # original skill (unchanged)
[user-chosen-name].md  # improved skill copy
```

**Original SKILL.md is NEVER modified.** User reviews and applies changes manually.

**results.tsv format:**

```
experiment	score	max_score	pass_rate	status	description
0	14	20	70.0%	baseline	original
1	16	20	80.0%	keep	added explicit instruction
2	16	20	80.0%	discard	removed ambiguity
```

---

## example: optimizing a diagram-generator skill

**Setup:**
- Skill: `~/.claude/skills/diagram-generator/SKILL.md`
- Test inputs: 5 varied scenarios
- Evals: text legibility, pastel colors, linear layout, no numbering
- Runs per experiment: 10, Max score: 40

**Baseline (32/40, 80%):** Failures: numbering, bright colors, small text.

**Exp 1 — KEEP (35/40, 87.5%):** Added anti-numbering rule. Numbering dropped from 3 to 1.

**Exp 2 — DISCARD (34/40, 85%):** Enforced 14px font. Legibility +1, color -2.

**Exp 3 — KEEP (37/40, 92.5%):** Replaced "pastel" with hex codes (#A8D8EA, #AA96DA, #FCBAD3, #FFFFD2, #B5EAD7). Color eval 8/10 → 10/10.

**Exp 4 — DISCARD (37/40, 92.5%):** Anti-pattern for red/orange/neon. No improvement — hex codes already solved it.

**Exp 5 — KEEP (39/40, 97.5%):** Added worked example. Hit 39/40. Remaining issue: complex diagrams with overlapping labels.

**Result:** 80% → 97.5% (5 experiments, 3 kept). Top changes: hex codes, anti-numbering, worked example.

---

## how this connects to other skills

**What feeds into autoresearch:**
- Any existing skill that needs optimization
- User-defined eval criteria (or help them define evals using the eval guide)

**What autoresearch feeds into:**
- The improved skill replaces the original
- The changelog can be passed to future models for continued optimization
- The eval suite can be reused whenever the skill is updated

---

## the test

A good autoresearch run:

1. **Started with a baseline** — never changed anything before measuring the starting point
2. **Used binary evals only** — no scales, no vibes, no "rate this 1-10"
3. **Changed one thing at a time** — so you know exactly what helped
4. **Kept a complete log** — every experiment recorded, kept or discarded
5. **Improved the score** — measurable improvement from baseline to final
6. **Didn't overfit** — the skill got better at the actual job, not just at passing the specific test inputs
7. **Ran autonomously** — didn't stop to ask permission between experiments

If the skill "passes" all evals but the actual output quality hasn't improved — the evals are bad, not the skill. Go back to step 2 and write better evals.
