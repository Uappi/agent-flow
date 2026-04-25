---
shortDescription: Deterministic self-evaluation rubric for Contextualizer — scored every run using the TRACE framework.
usedBy: [contextualizer]
version: 0.1.0
lastUpdated: 2026-04-24
---

## Purpose

Before delivering context files or briefs, the Contextualizer evaluates its own output against the TRACE rubric. Each letter is scored 0, 1, or 2. The total determines whether to deliver, rewrite, or abort. This replaces subjective self-assessment with a deterministic checklist aligned with the persona's execution pipeline — classify, execute, ground, scope, and deliver.

## Procedure

1. **Score each criterion.** After completing the task, read the TRACE rubric below and assign a score of 0, 1, or 2 to each letter. Show the scoring breakdown to yourself (internal reasoning, not to the user).

2. **Apply the hard-fail rule.** If any letter scores 0, do not deliver — go to step 3 immediately.

3. **Determine action by total score:**
   - **9 – 10** — **DELIVER** — Output meets all criteria. Deliver to user.
   - **7 – 8** — **FIX the scored < 2 criteria.**
     a. Identify which letters scored below 2.
     b. Fix those gaps automatically (do NOT consult the user).
     c. Re-score, then deliver if 9-10.
     d. If still below 9-10, retry once more.
     e. After 2 failed fix attempts, yield with the current state, rubric scores, and blocking letters.
   - **0 – 6** — **RESTART** — The output is fundamentally broken. Rewrite from scratch with corrected understanding, or yield to the user with an explanation of what went wrong.

## TRACE Rubric

### T — TASK

_Did I classify the task correctly and produce the right deliverable?_

- **0** — Wrong mode chosen (full scan when structural brief was needed, or vice versa). Produced the wrong deliverable type entirely.
- **1** — Right mode chosen but one deliverable element is missing or wrong format (e.g., review blocks without LOC counts, structural brief missing Information Flow section).
- **2** — Correct mode, correct deliverable, correct format. Full scan produced `.context.md` files AND `FEATURE-MAP.md`. Structural brief has all three sections (Modules, Boundaries, Information Flow). Review blocks respect 1500 LOC limit, module co-location, and boundary rules.

### R — RUN

_Did I follow the mandated skill and produce output in the correct schema?_

- **0** — Did not follow `skills/context-maintenance.md` for full scan. Used ad-hoc format instead of the prescribed `.context.md` or `FEATURE-MAP.md` schema. Did not run the directory scan script when producing context files. Structural brief does not use the required three-section format.
- **1** — Followed the skill but one schema detail is off: `<context>` tag missing path or date, feature flow step lacks "what happens here" description, or `updated` date touched without content change.
- **2** — Followed `context-maintenance.md` end-to-end. `.context.md` files use exact schema: opening `<context>` tag with path and date, description, Summary, Constraints, Guidance sections. `FEATURE-MAP.md` uses exact schema: feature name (user-visible), flow steps in information order with file paths and role descriptions. Structural brief uses exact three-section format. Only drifted features updated in existing map — not a full rewrite.

### A — ANCHORED

_Is every claim grounded in actual code? Nothing invented, nothing assumed._

- **0** — Invented purpose for a directory without reading its contents. Added constraints or guidance to `.context.md` that cannot be verified from the code itself. Added a feature to the map without tracing its full path through the codebase.
- **1** — Mostly grounded but one or more claims are uncertain: a directory's purpose is described vaguely rather than marked "unclear," or one feature flow step is inferred rather than confirmed by reading the actual code.
- **2** — Every claim traceable to code. Directories with unclear purpose are labeled as such rather than guessed. All `.context.md` constraints verified from code itself. Every `FEATURE-MAP.md` entry traced end-to-end from entry point to output. No assumptions, no inference without evidence.

### C — COVERAGE

_Did I scope correctly — incremental update, yield when too big, respect boundaries?_

- **0** — Project exceeds 200 files / 50 directories and no yield or coverage report was produced. Review blocks cross major architectural boundaries without tight coupling. Rewrote `FEATURE-MAP.md` from scratch when it already existed.
- **1** — Mostly scoped correctly but did not report what was covered vs. what remains after a partial scan. One review block slightly exceeds 1500 LOC. Missed a drifted feature in the existing map.
- **2** — Incremental update only — changed entries in existing `.context.md` and `FEATURE-MAP.md`, untouched stable ones. Yield condition evaluated: project size checked, coverage gap reported if exceeded. Review blocks each under 1500 LOC, module files co-located, boundaries respected. Nothing left silently unprocessed.

### E — EVIDENT

_Can someone arriving cold orient from this output alone? Is it brief enough?_

- **0** — Output is bloated — `.context.md` takes longer to read than the directory itself. Feature map cannot be followed from entry point to output. Newcomer cannot determine what a directory does without reading the code.
- **1** — Output is mostly navigable but one `.context.md` summary is too detailed or one feature flow step is unclear without inspecting the code. Structure present but one section reads like prose instead of a quick-reference list.
- **2** — Every `.context.md` is brief: one-to-two sentence description, one-line-per-file summary, constraints and guidance only when truly needed. Feature map follows a straight path from entry to output — a newcomer can trace the flow without opening any code file. Structure over prose everywhere. Brevity check passes: output is shorter than the directory contents it describes.

## Guardrails

- Never deliver if any letter scores 0 — regardless of total. A zero is a hard fail.
- Never skip scoring any letter — all 5 must be evaluated every run.
- The rubric is fixed — do not add or remove criteria. If a criterion proves inadequate, file a framework change request.
- When fixing gaps (score 7-8 range), only address the letters that scored below 2. Do not rework letters that already scored 2. Fix automatically — do NOT stop to consult the user.
- After 2 failed fix attempts, yield — do not keep looping. Present the current state, rubric scores, and blocking letters to the user.
- The "restart" action (score 0-6) means: do not deliver the current output. Rewrite from scratch with corrected understanding, or yield to the user with a clear explanation of the failure mode.
