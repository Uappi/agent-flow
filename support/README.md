# Support Package

Triagem e RCA N2 com link de tarefa Monday. O arquivo `project.config.yaml` na raiz do **repositório cliente** é exclusivo deste fluxo (não é lido por code-review, documentação nem MR).

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
# Editar: integrations.monday.boards.support, integrations.gitlab.project, outputs.paths.support_*
```

No wapstore, ver também `AGENTS.md` na raiz do cliente.

## Saídas

| `outputs.mode` | Triagem | RCA |
| :--- | :--- | :--- |
| `teste-docs` | `teste-docs/<support_triage>` | `teste-docs/<support_rca>` |
| `memory` | `.memory/docs/<support_triage>` | `.memory/docs/<support_rca>` |

## Monday MCP

URLs `monday.com` → somente MCP `plugin-monday.com-monday`. Ver `docs/mcp/monday.md`.

## Escopo do merge

Altera **somente** os arquivos listados acima (incl. `rules/support/project-config.md`, `skills/load-project-config.md`, `docs/project-config.md`, `project.config.yaml.example`) e aliases N2 em `skills/pre-dispatch-check.md`.

**Atenção no commit:** `project.config.yaml.example`, `rules/support/project-config.md`, `skills/load-project-config.md` e `docs/project-config.md` precisam de `git add` (estão novos, não só modificados).

**Não altera:** `README.md`, `rules/README.md`, `rules/global.mdc`, `skills/boot.md`, personas/prompts/templates de MR ou documentação.
