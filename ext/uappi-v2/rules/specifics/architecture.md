---
shortDescription: Uappi platform layout — backend, frontend, main directories.
scope: specifics-sync
product: uappi-v2
version: 0.3.0
lastUpdated: 2026-05-28
---

## Statement

Multi-project system with a shared core; client customizations live under `especifico/`.

**Stack**

- Backend: PHP 7.4, Apache, MariaDB
- Frontend: HTML/CSS, jQuery, Vue, Vue 3, Nuxt

**Relevant directories (core / mirrored under `especifico/`)**

| Directory | Role |
|-----------|------|
| checkout | SaaS checkout flow |
| classes | Shared business rules |
| crons | Periodic services (`crons.cron`) |
| dbm | SQL migrations |
| estrutura | Routes and redirects |
| lista-presente | Legacy — see `ignored-paths.md` |
| minha-conta | End-customer account area |
| pagamento | Payment methods |
| tema | Visual layer — out of v1 scope unless the brief includes it |
| wapstore | Admin panel and shared classes |

Core on GitLab at the comparison tag is the functional source of truth for the diff. Client `bin/` is a compiled artifact — read-only in this workflow.

The core MUST NOT contain client-specific logic.

## Rationale

Mirrors the legacy comparador general architecture reference. Client project layout: `architecture-projects.md`.
