# Support Package

Triagem e RCA N2 com link da tarefa de suporte. O arquivo `project.config.yaml` na raiz do **repositório cliente** é exclusivo deste fluxo (não é lido por code-review, documentação nem MR).

## Arquivos deste pacote

| Tipo | Caminho |
| :--- | :--- |
| Persona | `personas/support.md` |
| Regras | `rules/support/support-initial-analysis.md`, `rules/support/support-root-cause-analysis.md`, `rules/support/project-config.md` |
| Skill | `skills/load-project-config.md` |
| Exemplo de config | `project.config.yaml.example` → copiar para a raiz do cliente como `project.config.yaml` |
| Templates | `templates/support/initial-analysis.md`, `templates/support/rca.md` |
| Prompts | `prompts/support/initial-analysis.md`, `prompts/support/rca.md` |
| Documentação | `docs/project-config.md` |

## Gatilhos

| Etapa | Primeira linha do prompt |
| :--- | :--- |
| Triagem | `Análise suporte`, `Análise N2`, `Triagem N2`, `Diagnóstico N2`, `Documentação Analise inicial` |
| RCA | `RCA suporte`, `RCA N2`, `Análise profunda suporte`, `Causa raiz suporte` |

## Setup em um cliente novo

```bash
# Na raiz do repositório de trabalho (ex.: wapstore), não dentro do submodule
cp .agentFlow/project.config.yaml.example project.config.yaml
# Editar integrations.* e outputs.* conforme o exemplo e a necessidade do cliente
```

No wapstore, ver também `AGENTS.md` na raiz do cliente.

## Saídas

Todos os relatórios são salvos em `.memory/docs/` (gitignored pelo boot).

| Etapa | Com `project.config.yaml` | Sem config |
| :--- | :--- | :--- |
| Triagem | `.memory/docs/<outputs.paths.support_triage>` | `.memory/docs/support/triage/triage-<ID>-<topic>.md` |
| RCA | `.memory/docs/<outputs.paths.support_rca>` | `.memory/docs/support/rca/rca-<ID>-<topic>.md` |

## Contexto externo

- Informe o link da tarefa de suporte no prompt.
- Para RCA, informe links de MR/PR ou release quando houver correlação com merge ou versão.
- Os links fornecidos são a fonte da verdade. Não assumir tracker, board, repositório ou provider fixos fora do que estiver em `project.config.yaml` e nos links do prompt.
- Tarefas e merges privados: acessar somente via MCP ou outro caminho autenticado configurado — nunca WebFetch/WebSearch. Ver `skills/pre-dispatch-check.md` e `docs/mcp/` para setup de MCP por provider.
