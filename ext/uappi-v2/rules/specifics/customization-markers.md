---
shortDescription: Identify and preserve ESPECÍFICO comment markers in client overrides.
scope: specifics-sync
product: uappi-v2
version: 0.3.0
lastUpdated: 2026-05-28
---

## Statement

Customizations are identified by code comments:

- `ESPECÍFICO`
- `ESPECÍFICO TEMPORÁRIO`
- `[ESPECÍFICO PERMANENTE]` / `ESPECÍFICO PERMANENTE`
- `[ESPECÍFICO TEMPORÁRIO]` / `ESPECÍFICO TEMPORÁRIO`

Marked blocks are legitimate customization — highest priority for preservation.

MUST NOT overwrite or remove without analysis.

Missing a marker does NOT prove the diff is safe to overwrite — also consider:

- files under `especifico/`;
- client-only files;
- significant changes vs. core.

When in doubt: treat as possible customization; flag for review; avoid automatic overwrite.

## Rationale

Mirrors the legacy comparador customization identification reference.
