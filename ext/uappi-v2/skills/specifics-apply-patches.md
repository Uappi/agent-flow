---
shortDescription: Apply approved specifics-sync patches to especifico/ preserving client markers.
usedBy: [specifics-sync, coder]
product: uappi-v2
version: 0.1.0
lastUpdated: 2026-05-27
---

## Purpose

After compare mode and explicit user approval, this skill applies only the approved patches to files under `especifico/`, preserving `[ESPECÍFICO PERMANENTE]` and `[ESPECÍFICO TEMPORÁRIO]` blocks unless the user explicitly approved removal.

## Procedure

1. **Confirm authorization** — user said `sim`, listed files, or equivalent in the current turn. "Looks good" on the report alone is not enough.

2. **Load scope** from compare report or brief:
   - All MODIFIED with approved suggestion, or
   - Per-file list from "arquivo por arquivo" confirmation

3. **For each approved file:**
   - Re-read local `especifico/<path>`
   - Apply merge/patch from the report — not a full overwrite from core
   - Re-scan markers after edit; restore any accidental deletion of permanent blocks

4. **Skip** with reason:
   - IDENTICAL (unless user asked to delete override)
   - ADDITION without approved change
   - MODIFIED marked "preservar sem alteração"

5. **Handoff:** files touched, files skipped, residual risks. Maestro runs review loop on code changes.

## Guardrails

- Never apply without compare report or explicit patch list in brief.
- Never delete `especifico/` files unless user approved removal for that path.
- Never commit — Maestro handles git only on explicit commit request.
