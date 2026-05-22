# `project.config.yaml` — somente suporte N2

Arquivo na **raiz do repositório cliente** (ex.: wapstore). Não fica dentro de `.agents/`.

**Não** é usado por code-review, checklist, documentação técnica/produto nem implementação.

## Setup

```bash
cd /path/to/repositorio-cliente
cp .agents/project.config.yaml.example project.config.yaml
```

## Campos (somente suporte)

| Campo | Uso |
| :--- | :--- |
| `integrations.monday.boards.support` | Board N2 de suporte |
| `integrations.gitlab.project` | Projeto GitLab na RCA com MR |
| `sources.architecture` | Ex.: `README.ai.md` |
| `outputs.paths.support_triage` | Relatório de triagem (relativo a `.memory/docs/`) |
| `outputs.paths.support_rca` | Relatório de RCA (relativo a `.memory/docs/`) |

Sem o arquivo: salvar em `.memory/docs/support/triage/` e `.memory/docs/support/rca/`.

Todos os relatórios de suporte MUST ser salvos sob `.memory/docs/` (gitignored pelo boot).

## Regras e skill no AgentFlow

- `rules/support/project-config.md`
- `skills/load-project-config.md`

Documentação do pacote: `support/README.md`. Guias: `docs/guide/support-triage.md`, `docs/guide/support-rca.md`.
