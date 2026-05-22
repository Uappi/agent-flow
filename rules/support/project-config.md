---
shortDescription: project.config.yaml at work repo root — support N2 only (Monday, GitLab, triage/RCA paths).
scope: support
version: 0.3.0
lastUpdated: 2026-05-21
---

## Statement

Only the **Support** persona reads `project.config.yaml`. MR review, documentation, implementation, and other personas MUST NOT use this file unless the user explicitly asks otherwise.

When executing support triage or RCA, the Support persona MUST follow `skills/load-project-config.md` and read `<work-repo-root>/project.config.yaml` when it exists.

When config is present, use `integrations.monday.boards.support`, `integrations.gitlab.project` (RCA with MR), `sources.architecture`, and `outputs.paths.support_triage` / `support_rca` only. Resolved paths MUST be under `.memory/docs/`.

When absent, use `.memory/docs/support/triage/` and `.memory/docs/support/rca/` defaults and only URLs from the prompt.

## Rationale

N2 needs per-client integration defaults and optional subpaths under `.memory/docs/` without changing the shared AgentFlow package. Scoping config to support avoids implying code-review or doc flows must adopt the same file.
