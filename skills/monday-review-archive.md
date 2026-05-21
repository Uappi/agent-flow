---
shortDescription: Archives MR/PR code review documents to the Monday task doc column.
usedBy: [reviewer]
relatedTo: [monday]
version: 0.1.0
lastUpdated: 2026-05-21
---

## Purpose

MR/PR reviews must remain available in the task history, not only in local memory or transient chat output. This skill defines how to export code review documents to the Monday task's multi-document `Revisões automáticas` doc column only when the MR/PR review flow generates or regenerates the local review document, creating a timestamped document for each archived review event.

## Procedure

1. **Confirm the Monday task destination.** Use the task/issue link supplied in the review brief to identify the Monday item and board. If the task/issue link is not a Monday task link, or the Monday item cannot be resolved from it, keep the local review saved and report the archive blocker in the handoff.

2. **Confirm the target column.** Read the board structure and locate the doc column named `Revisões automáticas` on the Monday board that contains the task item. Do not guess another column. If the column does not exist, is not a doc column, or cannot be accessed with write permissions, keep the local review saved and report the archive blocker in the handoff.

3. **Build the archive document name.** Generate a new document name that includes the MR/PR identifier, short topic, and the review date/time. Use a stable, sortable timestamp format such as `YYYY-MM-DD HH:mm` in the account/user timezone when available, or UTC when timezone is unavailable. Example: `Code Review - MR 123 - checkout-fix - 2026-05-21 14:30`.

4. **Export the saved review document.** Immediately after the MR/PR review flow saves `.memory/docs/code-review/review-merge-<MR-OR-PR-ID>-<short-topic>.md`, create a new doc attached to the `Revisões automáticas` column on the Monday item using the timestamped name from step 3. Export the full Markdown content into that new doc.

5. **Archive review-flow regenerations only.** If the MR/PR review flow later regenerates or corrects the local review document as part of the same review delivery, create another new timestamped doc in `Revisões automáticas` with that latest generated content. Do not export arbitrary manual edits or local changes that happen outside the MR/PR review flow. The Monday archive is an append-only history of review-flow document versions, not a single synchronized document.

6. **Report archive status.** In the review handoff, state whether the review was exported to Monday. Include the Monday item link and doc/column reference when available. If export failed, report the objective blocker and confirm that the local `.memory/docs/code-review/...md` file remains the source of record until the blocker is resolved.

## Guardrails

- Exporting to `Revisões automáticas` is part of the review history workflow and does not require per-run user authorization.
- Exporting to Monday does not authorize posting anything to the MR/PR. MR/PR comments and thread replies still require explicit user authorization after the review is delivered.
- Never create, rename, or repurpose Monday columns during this workflow. Use only the existing `Revisões automáticas` doc column.
- Never overwrite or replace existing docs in `Revisões automáticas`. The column is multi-document and must keep historical review versions.
- Never export a review document to Monday merely because a local file changed. Export only when the MR/PR review flow generated or regenerated that local document.
- Never skip reporting a Monday export failure. Silent archive failure breaks review traceability.
