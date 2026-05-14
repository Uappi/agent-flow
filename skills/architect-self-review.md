---
shortDescription: Deterministic self-evaluation rubric for Architect — scored every run using the DRAFT framework.
usedBy: [architect]
version: 0.1.1
lastUpdated: 2026-05-14
---

## Purpose

Before delivering a plan, the Architect evaluates its own output against the DRAFT rubric. Each letter is scored 0, 1, or 2. The total determines whether to deliver, rewrite, or abort. This replaces subjective self-assessment with a deterministic checklist aligned with the adversarial review skill's validation passes.

## Procedure

1. **Score each criterion.** After completing the plan, read the DRAFT rubric below and assign a score of 0, 1, or 2 to each letter. Show the scoring breakdown to yourself (internal reasoning, not to the user).

2. **Apply the hard-fail rule.** If any letter scores 0, do not deliver — go to step 3 immediately.

3. **Determine action by total score:**
    - **9 – 10** — **DELIVER** — Plan meets all criteria. Deliver to user.
    - **7 – 8** — **FIX the scored < 2 criteria.**
      a. Identify which letters scored below 2.
      b. Fix those gaps automatically (do NOT consult the user).
      c. Re-score, then deliver if 9-10.
      d. If still below 9-10, retry once more.
      e. After 2 failed fix attempts, yield with prefix `SELF-REVIEW YIELD:` followed by the current state, rubric scores, and blocking letters.
    - **0 – 6** — **RESTART** — The plan is fundamentally broken. Rewrite from scratch with corrected understanding, or yield with prefix `SELF-REVIEW YIELD:` followed by an explanation of what went wrong.

## DRAFT Rubric

### D — DELTA

_Did I correctly classify intent and extract all sub-requests?_

- **0** — Wrong task classification (plan revision treated as new, or vice versa). Dropped a sub-request.
- **1** — Right classification, but missed an implicit requirement or did not stress-test the user's proposed approach before proceeding.
- **2** — Correctly classified intent, extracted all key entities, and challenged assumptions before proceeding. Complex request persisted to disk.

### R — REALITY

_Are the current state and target state explicit, accurate, and grounded in the codebase?_

- **0** — Current state section is missing, vague, or contradicts the actual codebase. Target state is a restatement of the goal without actionable detail. Did not read context files or architecture skills before writing.
- **1** — Current and target states are present but one or more claims about the codebase were not verified. Target state is missing concrete "users/developers will be able to..." formulation.
- **2** — Current state verified against context files and architecture skills. Target state uses explicit "After completion, users/developers will be able to..." formulation. Inversion, subtraction, and weakest-link stress tests applied with results documented.

### A — ACCEPTANCE

_Are criteria defined, measurable, and mapped to phases?_

- **0** — No acceptance criteria defined. Criteria are present but unmeasurable ("works correctly", "improve performance").
- **1** — Criteria defined and measurable but not all are mapped to specific phases. One or more phases deliver no stated criterion.
- **2** — Every acceptance criterion is measurable, numbered, and mapped to one or more phases. Every phase serves at least one criterion. No criterion is left undelivered.

### F — FILES

_Do all referenced paths exist or have valid parents, are entities verified, and are phase dependencies acyclic?_

- **0** — Plan references files or entities that do not exist without verification. Phase dependency chain has a cycle or a missing link. Layer boundary violations present (inner layer depends on outer).
- **1** — All file references verified, but phase ordering is missing explicit dependency declarations. One or more entities mentioned but not confirmed in the codebase.
- **2** — Every existing file path confirmed with `test -f`. Every new file's parent directory confirmed. Every named entity (function, type, endpoint) searched in codebase and confirmed or marked "to create." Phase dependency chain is acyclic and every dependency is declared. Layer boundaries respected per architecture skills. No strikethroughs, "Revised:" annotations, "no longer" phrasing, or diff-style markers left in the plan.

### T — TESTS

_Are Good/Bad/Ugly specs per phase complete and mapped to criteria?_

- **0** — Missing test specifications for one or more phases. Test specs present but none map to acceptance criteria.
- **1** — Test specs present for all phases but one or more do not cover all three lenses (Good/Bad/Ugly). One or more specs are orphans — they verify no acceptance criterion.
- **2** — Every phase has complete Good/Bad/Ugly test specifications. Every spec maps to at least one acceptance criterion. No orphan tests. Test names, inputs, and expected outcomes are concrete — not abstract descriptions.

## Guardrails

- Never deliver if any letter scores 0 — regardless of total. A zero is a hard fail.
- Never skip scoring any letter — all 5 must be evaluated every run.
- The rubric is fixed — do not add or remove criteria. If a criterion proves inadequate, file a framework change request.
- When fixing gaps (score 7-8 range), only address the letters that scored below 2. Do not rework letters that already scored 2. Fix automatically — do NOT stop to consult the user.
- After 2 failed fix attempts, yield — do not keep looping. Present the current state, rubric scores, and blocking letters to the user.
- The "restart" action (score 0-6) means: do not deliver the current output. Rewrite the plan from scratch with corrected understanding, or yield to the user with a clear explanation of the failure mode.
