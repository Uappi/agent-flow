---
shortDescription: Load project.config.yaml from the work repository root (support outputs and integrations).
usedBy: [support]
version: 0.2.0
lastUpdated: 2026-05-21
---

## Purpose

`project.config.yaml` at the work repo root is read **only by the Support persona** (triagem + RCA). Other personas ignore this file.

Each client repository may define the file for Monday/GitLab hints and triage/RCA save paths.

## Location

- Template: `project.config.yaml.example` (na raiz do submodule AgentFlow)
- Rule: `rules/support/project-config.md`
- Active config: `<work-repo-root>/project.config.yaml`

If missing, support saves to `.memory/docs/support/triage/` and `.memory/docs/support/rca/` with no fixed board or GitLab IDs.

## Procedure

1. Read `project.config.yaml` at the work repository root when present.
2. Apply:
   - `integrations.monday.boards.support` — hint only; URL in the prompt takes precedence.
   - `integrations.gitlab.project` — default for RCA when MR path has no project.
   - `sources.architecture` — default `README.ai.md`.
   - `outputs.mode` — `teste-docs` or `memory`.
   - `outputs.paths.support_triage` and `outputs.paths.support_rca` — replace `{id}` and `{topic}` at save time.
3. Resolved path:
   - `teste-docs` → `teste-docs/<path>`
   - `memory` → `.memory/docs/<path>`

## Monday MCP (support)

For `monday.com` URLs: use MCP only (`plugin-monday.com-monday` or `integrations.monday.mcp_server`). Never WebFetch/WebSearch on Monday cards.

## Guardrails

- Support workflows MUST work with explicit URLs even without `project.config.yaml`.
- Do not invent board or GitLab IDs when config is absent.
- Do not commit secrets in `project.config.yaml`.
