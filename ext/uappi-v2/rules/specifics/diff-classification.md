---
shortDescription: Classify core vs client differences before suggesting updates.
scope: specifics-sync
product: uappi-v2
version: 0.1.0
lastUpdated: 2026-05-27
---

## Statement

Every difference MUST be classified before suggesting a change:

1. **Customização própria** — exists only in client `especifico/`; preserve.
2. **Correção do core** — client patched core behavior; preserve unless core now includes equivalent fix.
3. **Implementação customizada** — same file as core, divergent behavior; incremental merge only.
4. **Código legado** — e.g. `lista-presente/`; may skip main analysis but MUST mention when ignored.
5. **Artefato gerado** — `bin/`; MUST NOT use as comparison source.

Priority on ambiguity: (1) → (2) → (3) → (4) → (5).

MODIFIED where core added structure the client override mirrors MUST suggest porting core structure while keeping marked client blocks.

## Rationale

Blind sync would destroy intentional client rules. Classification forces explicit decisions aligned with the legacy comparador workflow.
