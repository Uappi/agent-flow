---
shortDescription: Preserve ESPECÍFICO comment markers in client overrides.
scope: specifics-sync
product: uappi-v2
version: 0.1.0
lastUpdated: 2026-05-27
---

## Statement

- Blocks with `[ESPECÍFICO PERMANENTE]` or `ESPECÍFICO PERMANENTE` MUST be preserved unless the user explicitly approves removal after compare.
- Blocks with `[ESPECÍFICO TEMPORÁRIO]` or `ESPECÍFICO TEMPORÁRIO` SHOULD be flagged for review when core changes overlap; removal only if core absorbed the fix.
- Generic `ESPECÍFICO` comments indicate legitimate customization — default to preserve.
- Absence of markers does NOT prove the diff is safe to overwrite — use structural analysis.

## Rationale

Markers are the team's contract for intentional overrides. The comparador exists to sync structure, not erase business rules.
