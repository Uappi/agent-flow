# Uappi V3 product extension

Workflows for the Uappi V3 distributed microservices platform — backend only.

## Detection (`skills/product-profile.md`)

All three signals below are **backend-specific**. A match activates this directory (`ext/uappi-v3/backend/`) exclusively. The sibling directory `ext/uappi-v3/frontend/` is the frontend extension — it has its own detection signals (not yet defined) and must NOT be loaded based on the signals below.

| `repoKind` | Signal | Condition |
|------------|--------|-----------|
| `core` | A — `grep -q "Uappi V3" README.ai.md` | README declares V3 |
| `core` | B — `find . -maxdepth 2 -type d -name "*.uappi"` | At least one microservice directory present |
| `core` | C — `test -d apis/api.uappi.com.br` | API gateway present (doc-only checkout) |

Any one signal is sufficient. All three resolve to `repoKind: core`.

## Workflows

| Prompt template | Persona |
|-----------------|---------|
| `prompts/task/api-doc.md` | `personas/api-documenter.md` |

Intent and dispatch: `ROUTING.md`.

## Usage

Copy the prompt template from `prompts/task/api-doc.md`, fill in the three fields (feature name, affected modules/endpoints, target audience), and send it to Maestro. Maestro will dispatch the `api-documenter` persona with skill `skills/api-doc.md`.

## Templates

- `templates/task/api-doc-endpoint-workflow.md` — checklist for documenting HTTP endpoints
- `templates/task/api-doc-module-workflow.md` — checklist for documenting module overview pages

## Prerequisites

- Repository detected as `uappi-v3` — at least one of the three signals in `skills/product-profile.md` must pass (Signal A: `README.ai.md` declares V3; Signal B: `*.uappi` directory present; Signal C: `apis/api.uappi.com.br` directory present).
- Source files for the targeted feature accessible in the work repository (routes, controllers, processes, DMCs).
- For publication flow validation: registry files under `apis/api.uappi.com.br/src/resources/documentation-repositories/` must be readable.

> **Note on `preferredModel: codex`:** The `api-documenter` persona sets `preferredModel: codex` to leverage Codex CLI's strength when reading large PHP codebases. The implementation dispatcher routes to Codex CLI when available and falls back to the native model otherwise. This is intentional — do NOT change it without explicit instruction.
