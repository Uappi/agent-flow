# Suporte N2 — índice de guias

Análises de suporte no AgentFlow em duas etapas. Relatórios ficam em `.memory/docs/` (gitignored).

## Guias

| Etapa | Guia | Objetivo |
| :--- | :--- | :--- |
| **Triagem** | [support-triage.md](support-triage.md) | Classificar, mapear fluxo, seção 9 para RCA |
| **RCA** | [support-rca.md](support-rca.md) | Causa raiz com código, diff e confiança |

```text
Ticket (URL)  →  Triagem  →  relatório + seção 9
                              ↓
                    RCA (opcional)  →  relatório com causa raiz
```

## Pré-requisitos comuns

1. AgentFlow clonado em `.agents/` no repositório de trabalho.
2. Boot: `Por favor, siga as instruções de .agents/AGENTS.md`.
3. `README.ai.md` na raiz do cliente — [readme-ai.md](readme-ai.md).
4. URL da tarefa no prompt; acesso autenticado ao tracker (MCP).
5. `project.config.yaml` opcional — [project-config.md](../project-config.md).

## Fluxo recomendado

1. [Triagem](support-triage.md) com URL + contexto adicional.
2. Revisar relatório; completar seção 9 se necessário.
3. [RCA](support-rca.md) com seção 9 + MR/release quando aplicável.
4. Usar o relatório de RCA para dev, hotfix ou comunicação interna.

## Referência do pacote

| Recurso | Caminho |
| :--- | :--- |
| Índice técnico | `support/README.md` |
| Setup MCP | `docs/mcp/` |
| Pre-dispatch | `skills/pre-dispatch-check.md` |
