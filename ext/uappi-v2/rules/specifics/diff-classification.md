---
shortDescription: Classify core vs client differences before suggesting updates.
scope: specifics-sync
product: uappi-v2
version: 0.3.0
lastUpdated: 2026-05-28
---

## Statement

Every difference MUST be classified (per `customization-markers.md`) before suggesting a change.

### Difference categories

1. **Client-only customization** — exists only under client `especifico/`; not in core; preserve; MUST NOT overwrite; report when adjacent core rules changed.
2. **Core fix** — client patched core behavior; preserve unless incompatible; remove only if core now includes an equivalent fix.
3. **Custom implementation** — same path in core and client, divergent content; incremental merge only; MUST NOT full-file replace without analysis.
4. **Legacy code** — e.g. `lista-presente/`; MAY skip main analysis but MUST state when skipped.
5. **Generated artifact** — `bin/`; MUST NOT use as primary comparison source.

Priority on ambiguity: (1) → (2) → (3) → (4) → (5).

### Report classification (per file)

In `templates/specifics/compare-by-file.md`, use exactly one value under **Classificação** (Portuguese labels — report output):

| Situation | Report value |
|-----------|----------------|
| Same as core at tag | **Para remover** (unnecessary override) |
| Different; needs merge/update | **Para modificar** |
| Reviewed; no action now | **Sem alteração** |

Before suggesting a change: identify → classify (category + report value) → assess impact → explain effect on core flow → suggest safe update.

MUST NOT: blind overwrite; remove customization without analysis; assume every divergence is an error.

## Rationale

Mirrors the legacy comparador difference-classification reference. Report labels stay in Portuguese to match the output templates.
