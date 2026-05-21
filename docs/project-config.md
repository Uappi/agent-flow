# `project.config.yaml` — somente suporte N2

Arquivo na **raiz do repositório cliente** (ex.: wapstore). Não fica dentro do submodule AgentFlow.

**Não** é usado por code-review, checklist, documentação técnica/produto nem implementação.

## Setup

```bash
cd /path/to/repositorio-cliente
cp .agentFlow/project.config.yaml.example project.config.yaml
```

Ajuste o caminho `.agentFlow/` conforme o nome da pasta do framework no projeto (`.agents/`, `agent-flow/`, etc.).

## Campos (somente suporte)

| Campo | Uso |
| :--- | :--- |
| `integrations.monday.boards.support` | Board N2 de suporte |
| `integrations.gitlab.project` | Projeto GitLab na RCA com MR |
| `sources.architecture` | Ex.: `README.ai.md` |
| `outputs.mode` | `teste-docs` ou `memory` |
| `outputs.paths.support_triage` | Relatório de triagem |
| `outputs.paths.support_rca` | Relatório de RCA |

Sem o arquivo: salvar em `.memory/docs/support/triage/` e `rca/`.

## Regras e skill no AgentFlow

- `rules/support/project-config.md`
- `skills/load-project-config.md`

Documentação do pacote: `support/README.md`.
