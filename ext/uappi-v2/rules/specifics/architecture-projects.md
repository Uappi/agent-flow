---
shortDescription: How client projects diverge from core — especifico, tema, bin.
scope: specifics-sync
product: uappi-v2
version: 0.2.0
lastUpdated: 2026-05-28
---

## Statement

Client projects derive from the core and MAY contain business, UI, or behavior customizations — treat them as intentional until analysis proves otherwise.

**Directories**

- **`especifico/`** — client customizations; client-specific changes SHOULD live here when possible.
- **`tema/`** — frontend (MVC or reactive); out of comparador v1 scope unless the brief explicitly includes it.
- **`bin/`** — consolidated core + specifics artifact; MUST NOT use as the primary comparison source.

**Customization types**

1. File override — client replaces a core file.
2. Extension — client adds behavior without changing the original core flow.
3. Partial modification — client changes part of existing behavior while keeping the rest.

**Updates**

- Analyze overrides carefully; classify before changing.
- Core MUST NOT replace client files without evaluation.
- Legitimate customizations MUST be preserved.

Every client customization is intentional until proven otherwise.

## Rationale

Mirrors the legacy comparador client-project architecture reference.
