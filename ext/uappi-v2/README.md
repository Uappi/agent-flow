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
- Client compare: `especifico/` at work repo root, release in `.wapstore/build` or prompt

## Output

- `.memory/docs/specifics-sync/YYYY-MM-DD/01-analise-por-arquivo.md`
- Optional: `02-analise-por-tarefa.md` (phase 2)

## User guide

`docs/guide/specifics-sync.md`
