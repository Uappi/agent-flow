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

Detalhes de intenção, gates e apply: `ROUTING.md`.

## Prerequisites

- Leitura do core no GitLab na tag (MCP, clone local do `wapstore/wapstore`, `glab`, ou API) — Maestro valida em `skills/pre-dispatch-check.md`; setup MCP opcional: `docs/guide/mcp/gitlab.md`
- Client compare: `especifico/` at work repo root; **Versão alvo** no prompt (ver `pre-dispatch-check`)

## Output

`.memory/docs/specifics-sync/YYYY-MM-DD/` (same layout as comparador legado `docs/`):

| Relatório | Arquivo | Template |
|-----------|---------|----------|
| por arquivo | `01-analise-por-arquivo.md` | `templates/specifics/compare-by-file.md` |
| por tarefa | `02-analise-por-tarefa.md` | `templates/specifics/compare-by-task.md` |

Brief must include **Relatório:** `por arquivo`, `por tarefa`, or `ambos`.

## Guia de uso

[docs/guide/extensions/uappi-v2-specifics-compare.md](../../docs/guide/extensions/uappi-v2-specifics-compare.md)
