# Uappi V3 product extension — frontend

Workflows and templates specific to the Uappi V3 admin frontend (this repository) — distinct from the sibling `ext/uappi-v3/backend/` extension.

## Detection (`skills/product-profile.md`)

| `repoKind` | Signal | Condition |
|------------|--------|-----------|
| `core` | A — `grep -q "uappi3/frontend" README.ai.md` | README title declares `README.ai.md — uappi3/frontend` |

A match activates this directory (`ext/uappi-v3/frontend/`) exclusively. The sibling directory `ext/uappi-v3/backend/` has its own signals (see its `README.md`) and must NOT be loaded based on the signal above.

## Templates

- `templates/task/monday-task.md` — personal/team format for logging already-completed work (hotfix, bugfix, or feature) as a Monday task description, pasted directly into the task item. Sections: Contexto/Objetivo (problem/opportunity, references/OKRs, Quinteto de Valor, expected impact), Escopo (what was done, dependencies), Decisões Técnicas (root cause per defect, rationale), Implementação (approach, package/module, commit/branch/MR status, suggested commit message — suggestion only, committing still requires explicit user authorization per `rules/git.md`), Critérios de Sucesso (validation performed and pending).

## Guides

- `docs/guide/quinteto-de-valor.md` — definitions of the five business-value metrics (Ticket médio, ICP, EBITDA, LTV, ACV) referenced by the `Quinteto de Valor` field in `templates/task/monday-task.md`.

## Usage

No dedicated persona/workflow yet — these are standalone templates read directly when preparing a Monday task description or filling in the value-impact section of one. Use `templates/task/monday-task.md` as the structure and `docs/guide/quinteto-de-valor.md` as the reference for the Quinteto de Valor field.

## Prerequisites

- Repository detected as `uappi-v3/frontend` — the signal in `skills/product-profile.md` above must pass.
