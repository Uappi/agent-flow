# Uappi v2 product extension

Workflows for Wapstore/Uappi client clouds and the shared core repository.

## Detection (`skills/product-profile.md`)

| `repoKind` | Signals | Comparador (`specifics-sync`) | Requirements gathering |
|------------|---------|-------------------------------|------------------------|
| `client` | `especifico/` + `.wapstore/build` | Available | Available |
| `core` | Git remote `wapstore/wapstore` (not `/clientes/`) or `core/wapstore/` | **Not** available (no `especifico/`) | Available |

## Workflows

| Prompt template | Persona |
|-----------------|---------|
| `prompts/task/specifics-compare.md` | `personas/specifics-sync.md` |
| `prompts/general/requirements-gathering.md` | `personas/requirements-elicitor.md` (opens the requirements chain — see `ROUTING.md` § Requirements Chain) |

Intent, gates, and apply: `ROUTING.md`.

## Prerequisites

- Read access to core on GitLab at the tag (MCP, existing local checkout, `glab`, or API) — Maestro validates via `skills/pre-dispatch-check.md`; no `git clone` in the flow; optional MCP setup: `docs/guide/mcp/gitlab.md`
- Client compare: `especifico/` at work repo root; **Versão alvo** in the prompt (see `pre-dispatch-check`)
- Requirements gathering: no `especifico/` or `.wapstore/build` requirement — works in both `repoKind: client` and `repoKind: core`; only needs read access to `core/` (already local in this checkout) plus `README.ai.md`/`.context.md`.

## Output

`.memory/docs/specifics-sync/YYYY-MM-DD/`:

| Report mode | File | Template |
|-------------|------|----------|
| per file | `01-analise-por-arquivo.md` | `templates/specifics/compare-by-file.md` |
| per task | `02-analise-por-tarefa.md` | `templates/specifics/compare-by-task.md` |

Brief MUST include **Relatório:** `por arquivo`, `por tarefa`, or `ambos`. Report body uses Portuguese section labels (legacy comparador format).

`.memory/docs/requirements/<slug>/`:

| Document | File | Template |
|----------|------|----------|
| Formal requirements (drafted + validated in place) | `requisitos.md` | `templates/general/requirements.md` |

## User guide (Portuguese)

[docs/guide/extensions/uappi-v2-specifics-compare.md](../../docs/guide/extensions/uappi-v2-specifics-compare.md)
