---
shortDescription: Hierarchy and conventions for core vs client specifics sync.
scope: specifics-sync
product: uappi-v2
version: 0.2.0
lastUpdated: 2026-05-28
---

## Statement

**Conventions**

- `especifico/` — client customization (on-disk folder name is Portuguese).
- `bin/` — compiled core + specifics on the client; MUST NOT use as the primary comparison source.
- `painel` / `Uappi` — administrative area.
- `plataforma` — the project as a whole.

**Decision hierarchy**

1. Core on GitLab at `target_release`
2. Rules under `ext/uappi-v2/rules/specifics/*`
3. Documented architecture (`architecture.md`, `architecture-projects.md`)
4. Client project (`especifico/`)
5. Local comments or ad hoc implementations

**Core vs. client conflicts**

- Core is the primary reference.
- Client MUST be analyzed for legitimate customization.
- No difference MAY be overwritten without prior classification.
- When in doubt: incremental update, not full replacement.

MUST NOT assume: every client difference is an error; every divergence must be removed; every extra client file is obsolete.

## Rationale

Mirrors the legacy comparador source-of-truth reference, adapted for GitLab core instead of a local `CORE/` directory.
