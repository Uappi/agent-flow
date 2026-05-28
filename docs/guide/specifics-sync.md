# Comparar específicos (specifics sync)

Sincroniza overrides do cliente (`especifico/`) com o core Wapstore na tag informada no prompt.

## Quando usar

- Repo **cliente** com `especifico/` e `.wapstore/build`
- Antes de atualizar o core no cliente ou após bump de release
- **Não** use no repo **core** — o Maestro bloqueia

## Pré-requisitos

- AgentFlow em `.agents/`
- Leitura do core no GitLab na tag (`pre-dispatch-check`)
- Boot com `uappi-v2` / `repoKind: client`

## Prompt

`ext/uappi-v2/prompts/task/specifics-compare.md`

Obrigatório: **Versão alvo do core (tag)** e **Relatório** (`por arquivo` | `por tarefa` | `ambos`).

## Saída

| Arquivo | Quando |
|---------|--------|
| `01-analise-por-arquivo.md` | `por arquivo` ou `ambos` |
| `02-analise-por-tarefa.md` | `por tarefa` ou `ambos` |

Pasta: `.memory/docs/specifics-sync/YYYY-MM-DD/`

Templates e regras alinhados ao comparador em `DesenvolvimentoIA/` (classificação, marcadores ESPECÍFICO, agrupamento por tarefa).

## Aplicar alterações

1. Revise o relatório no disco
2. Confirme aplicar (sim / não / por arquivo)
3. Maestro → Coder + `specifics-apply-patches.md` + review loop

## Referência

`ext/uappi-v2/rules/specifics/` · `ext/uappi-v2/README.md`
