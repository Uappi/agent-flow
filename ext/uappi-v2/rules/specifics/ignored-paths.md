---
shortDescription: Paths excluded from specifics comparison scans.
scope: specifics-sync
product: uappi-v2
version: 0.1.0
lastUpdated: 2026-05-27
---

## Statement

- MUST compare only under `especifico/` unless the task brief narrows scope further.
- MUST ignore during listing: `.context.md`, `.gitkeep`, VCS metadata.
- MUST NOT use `bin/` as comparison source — compiled artifact.
- MAY skip `lista-presente/` as legacy but MUST state when skipped.
- MUST NOT skip files solely because they lack ESPECÍFICO markers.

## Rationale

Scan scope must match maintainable overrides, not generated trees that duplicate core content.
