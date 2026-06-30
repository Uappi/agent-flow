---
shortDescription: LOC-based review tier selection with task-driven focus for the reviewer.
usedBy: [maestro]
version: 0.3.3
lastUpdated: 2026-06-25
---

## Purpose

Different scales of change need different review depth. This skill measures the scope of code changes, splits oversized scopes into reviewable blocks, selects the appropriate review tier, and dispatches the reviewer.

## Procedure

1. **Measure scope.** For code changes, count the lines changed, including untracked files:
   ```bash
   { git diff HEAD --numstat | awk '{s+=$1+$2}'; git ls-files --others --exclude-standard -z | xargs -0 -r cat | wc -l; } | awk '{s+=$1}END{print s}'
   ```
   This counts both staged and unstaged changes against the last commit, plus all lines in new untracked files. For plans and non-code work, skip to step 3 and use Unified tier.

2. **Split if needed.** If total LOC exceeds 1000, dispatch the Contextualizer in review scoping mode (step 6 of `personas/contextualizer.md`, dispatch via: `skills/dispatch.md`) to group changed files into blocks of 1000 or fewer LOC. Each block proceeds independently through step 3.

3. **Select tier and dispatch** (dispatch via: `skills/dispatch.md`). Each dispatch uses `personas/reviewer.md`.
   - **Unified** (< 300 LOC) — single dispatch. No focus in `<task>`; reviewer runs all three lenses.
   - **Standard** (300–600 LOC) — two dispatches with focused `<task>`:
     - First: coherence and quality focus.
     - Second: security focus.
   - **Full** (600–1000 LOC) — three dispatches with focused `<task>`. Suggest the user consider an external review tool (e.g., CodeRabbit, Greptile) for additional coverage.
     - First: coherence focus.
     - Second: quality focus.
     - Third: security focus.

4. **Merge findings.** When multiple dispatches run, merge findings: union all blockers, warnings, and notes; deduplicate identical entries. Conflicting verdicts resolve to the stricter one.

5. **Verify findings.** Spot-check each blocker and warning against the codebase before acting. Reviewers can hallucinate — discard false positives (invented violations, misread paths, fabricated rules). Only confirmed findings proceed.

6. **Act on verdict.**
   - `pass` — proceed to delivery.
   - `partial-pass` — no blockers but a review step was skipped. Surface the gap to the user.
   - `fail` — present the verified findings to the user, incorporate any additional input, re-dispatch the Coder with the findings, re-review. Repeat until the verdict is `pass` or `partial-pass`.

## Guardrails

- Never skip the verify step. Reviewers — especially when dispatched to cheaper models — can hallucinate findings. Every blocker and warning must be confirmed against the actual codebase before acting on it.
