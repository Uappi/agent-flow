---
shortDescription: Safe update rules when merging core into especifico/.
scope: specifics-sync
product: uappi-v2
version: 0.3.0
lastUpdated: 2026-05-28
---

## Statement

Update the client while preserving legitimate customizations and existing behavior.

Before suggesting a change, check: ESPECÍFICO markers; `especifico/`; `tema/` (when in scope).

During update: MUST NOT use `bin/` as the primary source; treat `lista-presente/` as legacy and state when ignored.

Strategy: (1) identify differences (2) classify (3) assess impact (4) suggest incremental merge.

MUST NOT: blind overwrite; remove customization without analysis; change behavior without assessment.

Compare mode is read-only — apply patches only after explicit confirmation (`specifics-apply-patches.md`).

## Rationale

Mirrors the legacy comparador safe-update prompt rules.
