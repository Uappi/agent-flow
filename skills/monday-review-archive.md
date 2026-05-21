---
shortDescription: Archives MR/PR code review files to the Monday task file column.
usedBy: [reviewer]
relatedTo: [monday]
version: 0.1.0
lastUpdated: 2026-05-21
---

## Purpose

MR/PR reviews must remain available in the task history, not only in local memory or transient chat output. This skill defines how to upload generated code review markdown files to the Monday task's `Revisões automáticas` file column only when the MR/PR review flow generates or regenerates the local review file, creating a timestamped file attachment for each archived review event.

## Procedure

1. **Confirm the Monday task destination.** Use the task/issue link supplied in the review brief to identify the Monday item and board. If the task/issue link is not a Monday task link, or the Monday item cannot be resolved from it, keep the local review saved and report the archive blocker in the handoff.

2. **Confirm the target column.** Read the board structure and locate the file column named `Revisões automáticas` on the Monday board that contains the task item. Do not guess another column. If the column does not exist, is not a file column, or cannot be accessed with write permissions, keep the local review saved and report the archive blocker in the handoff.

3. **Build the archive file name.** Generate a new markdown file name that includes the MR/PR identifier, short topic, and the review date/time. Use a stable, sortable timestamp format safe for file names, such as `YYYY-MM-DD_HH-mm`, in the account/user timezone when available, or UTC when timezone is unavailable. Example: `code-review-MR-123-checkout-fix-2026-05-21_14-30.md`.

4. **Prepare the timestamped upload file.** Immediately after the MR/PR review flow saves `.memory/docs/code-review/review-merge-<MR-OR-PR-ID>-<short-topic>.md`, upload that markdown content to the `Revisões automáticas` file column on the Monday item using the timestamped file name from step 3. If the upload mechanism requires a local file path with the final attachment name, create or copy a temporary `.md` file outside the review source path, upload it, and leave the canonical local review file unchanged.

5. **Archive review-flow regenerations only.** If the MR/PR review flow later regenerates or corrects the local review file as part of the same review delivery, upload another new timestamped `.md` file to `Revisões automáticas` with that latest generated content. Do not export arbitrary manual edits or local changes that happen outside the MR/PR review flow. The Monday archive is an append-only history of review-flow file versions, not a single synchronized file.

6. **Report archive status.** In the review handoff, state whether the review file was uploaded to Monday. Include the Monday item link and file/column reference when available. If upload failed, report the objective blocker and confirm that the local `.memory/docs/code-review/...md` file remains the source of record until the blocker is resolved.

## Guardrails

- Uploading to `Revisões automáticas` is part of the review history workflow and does not require per-run user authorization.
- Uploading to Monday does not authorize posting anything to the MR/PR. MR/PR comments and thread replies still require explicit user authorization after the review is delivered.
- Never create, rename, or repurpose Monday columns during this workflow. Use only the existing `Revisões automáticas` file column.
- Never overwrite, replace, or delete existing files in `Revisões automáticas`. The column is a file column and must keep historical review versions.
- Never upload a review file to Monday merely because a local file changed. Upload only when the MR/PR review flow generated or regenerated that local file.
- Never skip reporting a Monday upload failure. Silent archive failure breaks review traceability.
