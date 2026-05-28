---
shortDescription: Paths excluded from specifics comparison scans.
scope: specifics-sync
product: uappi-v2
version: 0.3.0
lastUpdated: 2026-05-28
---

## Statement

**Directories**

- **`lista-presente/`** — legacy; MAY skip in comparison and update proposals; MUST state explicitly when skipped.
- **`bin/`** — MUST NOT use as the primary comparison source.

**Files**

- **`.gitkeep`** — placeholder only; MUST NOT analyze.
- **`.context.md`** — AgentFlow metadata; MUST NOT analyze.

Compare only under `especifico/` (or a scope subdirectory from the brief). MUST NOT skip files solely because they lack ESPECÍFICO markers.

## Rationale

Mirrors the legacy comparador ignorable paths reference.
