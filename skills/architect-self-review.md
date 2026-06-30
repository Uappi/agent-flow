---
shortDescription: Deterministic self-evaluation rubric for Architect — scored every run using the DRAFT framework.
usedBy: [architect]
version: 0.2.2
lastUpdated: 2026-06-26
---

## Purpose

Before delivering a plan, the Architect evaluates its own output against the DRAFT rubric. Each letter is scored 0, 1, or 2. The total determines whether to deliver, rewrite, or abort.

## Procedure

1. **Gather evidence.** Before scoring, run verification commands to collect proof — `test -f` for file paths, `rg` for entities, `wc -l` for LOC estimates. Choose commands that fit your plan.

2. **Score.** Read the DRAFT rubric below. For each letter, assign 0, 1, or 2. Quote the matching level and cite specific evidence from your work.

3. **Determine action.** If any letter scores 0, RESTART immediately. Otherwise, use the total score:
    - **9 – 10** — **DELIVER**
    - **7 – 8** — **FIX** the letters that scored below 2. Fix automatically (do NOT consult the user). Re-score, then deliver if 9-10. After 2 failed fix attempts, yield with current state and blocking letters.
    - **0 – 6** — **RESTART** — Rewrite from scratch, or yield to the user with an explanation.

## DRAFT Rubric

**Exception:** If the architect yielded blocking questions instead of a plan (playbook step 12), skip scoring — the yield is the correct action.

### D — DELTA

_Did I correctly classify intent, choose scope mode, extract sub-requests, and name methods explicitly?_

- **0** — Wrong task classification (plan revision treated as new, or vice versa). Dropped a sub-request. Scope mode not stated or chosen with no rationale. Method names missing or vague.
- **1** — Right classification, but scope mode stated without rationale, or method names are vague.
- **2** — Correctly classified intent, extracted all key entities, chose the right scope mode with stated rationale. Method signatures are explicit. Complex request persisted to disk.

### R — REALITY

_Is the goal grounded, each phase's before/after explicit, the information flow traced, assumptions verified, rules respected, and the plan grounded in the codebase?_

- **0** — Goal section missing or vacuous. Per-phase before/after missing. Information flow section missing or not traced. Did not read context files or architecture skills before writing.
- **1** — Goal present but vague. Before/after present per phase but not verified against the codebase. Information flow traced but missing layers or handoffs. Key assumptions left unverified. Implementation approach may contradict loaded rules but not verified.
- **2** — Goal clearly states the problem, why it matters, and concrete verifiable outcomes. Every phase has explicit before/after verified against the codebase. Information flow traces user entry → layers → infra and back. Key assumptions verified. Implementation approach verified against loaded rules — no contradictions. Stress tests applied with results documented.

### A — ACCEPTANCE

_Are criteria defined, measurable, and mapped to phases?_

- **0** — No acceptance criteria defined. Criteria are present but unmeasurable ("works correctly", "improve performance").
- **1** — Criteria defined and measurable but not all are mapped to specific phases. One or more phases deliver no stated criterion.
- **2** — Every acceptance criterion is measurable, numbered, and mapped to one or more phases. Every phase serves at least one criterion. No criterion is left undelivered.

### F — FILES

_Do all referenced paths exist, reference files listed per phase, entities verified, phase dependencies acyclic, finalize sections present, planned commits present, and phases within LOC limits?_

- **0** — Plan references files or entities that do not exist without verification. Reference files not listed per phase. Phase dependency chain has a cycle or missing link. Layer boundary violations. Any phase exceeds 800 LOC.
- **1** — All file references verified, but one or more phases missing reference file suggestions. Phase ordering missing explicit dependency declarations. One or more entities not confirmed. One or more phases exceed 600 LOC but none exceed 800. Finalize sections partially present. One or more phases missing planned commits.
- **2** — Every existing file path confirmed with `test -f`. Every new file's parent directory confirmed. Reference files listed per phase (selected from `ls` output). Every entity confirmed or marked "to create." Phase dependencies acyclic and declared. Layer boundaries respected. No strikethroughs, "Revised:" annotations, or diff-style markers. Finalize sections complete (Feature Map, Changelog, Estimated Total LOC). Every phase has planned commits. All phases ≤600 LOC.

### T — TESTS

_Are test specs per method with max 1 per lens, mapped to criteria?_

- **0** — Missing test specifications for one or more methods. Test specs present but none map to acceptance criteria.
- **1** — Tests present for all methods but one or more methods lack a lens (Good/Bad/Ugly). One or more specs are orphans. One or more methods have more than 1 test per lens (over-specification).
- **2** — Every method has exactly 1 Good, 1 Bad, 1 Ugly test. Every test maps to at least one acceptance criterion. Every acceptance criterion has at least one test verifying it. No orphan tests. Test names, inputs, and outcomes are concrete. No method exceeds the 1-per-lens cap.

## Guardrails

- A letter without a specific evidence citation scores 0.
- Never skip scoring any letter — all 5 must be evaluated every run.
- The rubric is fixed — do not add or remove criteria. If a criterion proves inadequate, file a framework change request.
- When fixing gaps (7-8 range), only fix letters that scored below 2. Do not rework letters that already scored 2.
- After 2 failed fix attempts, yield — do not keep looping.
