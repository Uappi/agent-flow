---
shortDescription: Load project.config.yaml from the work repository root (support outputs and integrations).
usedBy: [support]
version: 0.3.0
lastUpdated: 2026-05-22
---

## Purpose

`project.config.yaml` at the work repo root is read **only by the Support persona** (triagem + RCA). Other personas ignore this file.

Each client repository may define the file for optional integration hints and triage/RCA save paths.

## Location

- Template: `project.config.yaml.example` (na raiz do submodule AgentFlow)
- Rule: `rules/support/project-config.md`
- Active config: `<work-repo-root>/project.config.yaml`

If missing, support saves to `.memory/docs/support/triage/` and `.memory/docs/support/rca/` with no fixed board, repository, or provider IDs.

## Procedure

1. Read `project.config.yaml` at the work repository root when present.
2. Apply:
   - `integrations.*` fields documented in `project.config.yaml.example` — hints only; URLs in the prompt take precedence.
   - `sources.architecture` — default `README.ai.md`.
   - `outputs.paths.support_triage` and `outputs.paths.support_rca` — replace `{id}` and `{topic}` at save time.
3. Resolved save path (always under `.memory/docs/`):
   - With config: `.memory/docs/<outputs.paths.support_triage|support_rca>`
   - Without config: `.memory/docs/support/triage/triage-<TASK-ID>-<short-topic>.md` or `.memory/docs/support/rca/rca-<TASK-ID>-<short-topic>.md`

## Guardrails

- Support artifacts MUST be saved only under `.memory/docs/`. Never save triage or RCA reports to `teste-docs/` or other project paths.
- Support workflows MUST work with explicit URLs even without `project.config.yaml`.
- Do not invent board, repository, or provider IDs when config is absent.
- Do not commit secrets in `project.config.yaml`.
