# Uappi v2 product extension

Workflows for Wapstore/Uappi client clouds and the shared core repository.

## Detection (`skills/product-profile.md`)

| `repoKind` | Signals | Comparador (`specifics-sync`) |
|------------|---------|-------------------------------|
| `client` | `especifico/` + `.wapstore/build` | Available |
| `core` | Git remote `wapstore/wapstore` (not `/clientes/`) or `core/wapstore/` | **Not** available (no `especifico/`) |

## Workflows

| Prompt template | Persona |
|-----------------|---------|
| `prompts/task/specifics-compare.md` | `personas/specifics-sync.md` |

Intent, gates, and apply: `ROUTING.md`.

## Prerequisites

- Read access to core on GitLab at the tag (MCP, local `wapstore/wapstore` clone, `glab`, or API) — Maestro validates via `skills/pre-dispatch-check.md`; optional MCP setup: `docs/guide/mcp/gitlab.md`
- Client compare: `especifico/` at work repo root; **Versão alvo** in the prompt (see `pre-dispatch-check`)

## Output

`.memory/docs/specifics-sync/YYYY-MM-DD/`:

| Report mode | File | Template |
|-------------|------|----------|
| per file | `01-analise-por-arquivo.md` | `templates/specifics/compare-by-file.md` |
| per task | `02-analise-por-tarefa.md` | `templates/specifics/compare-by-task.md` |

Brief MUST include **Relatório:** `por arquivo`, `por tarefa`, or `ambos`. Report body uses Portuguese section labels (legacy comparador format).

## User guide (Portuguese)

[docs/guide/extensions/uappi-v2-specifics-compare.md](../../docs/guide/extensions/uappi-v2-specifics-compare.md)
