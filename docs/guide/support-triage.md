# Guia: triagem de suporte N2

Triagem inicial de tickets de suporte com o AgentFlow. A persona **Support** classifica o comportamento, mapeia o fluxo crítico e produz o relatório em `.memory/docs/` — sem confirmar causa raiz definitiva.

- Próxima etapa (opcional): [RCA](support-rca.md)
- Índice dos fluxos de suporte: [support-analysis.md](support-analysis.md)
- Config por cliente: [project-config.md](../project-config.md)

## Quando usar

- Novo ticket N2 que precisa de direcionamento técnico.
- Falta contexto estruturado para desenvolvimento ou QA.
- Antes de uma RCA — a **seção 9** do relatório alimenta a etapa seguinte.

A triagem **não substitui** a RCA. Suspeita de regressão ou versão **não dispara** RCA automaticamente.

## Pré-requisitos

1. AgentFlow em `.agents/` e boot: `Por favor, siga as instruções de .agents/AGENTS.md`.
2. **`README.ai.md`** na raiz do cliente (recomendado) — ver [readme-ai.md](readme-ai.md).
3. **URL da tarefa** na primeira linha do prompt (obrigatória).
4. **Acesso autenticado ao tracker** (MCP ou equivalente) — o Maestro valida antes do dispatch.
5. **`project.config.yaml`** (opcional) — ver [project-config.md](../project-config.md).

## Primeira linha aceita

Use **uma** destas formas (dois pontos + URL):

- `Análise suporte:`
- `Triagem suporte:`
- `Diagnóstico suporte:`
- `Análise N2:`
- `Triagem N2:`
- `Diagnóstico N2:`
- `Documentação Analise inicial:`

## Prompt de exemplo

Copie `prompts/support/initial-analysis.md` e preencha:

```text
Análise suporte: https://<tracker>/boards/<board>/pulses/<item>

Contexto adicional:
- Cliente: Loja Exemplo
- Fluxo: Finalização de pedido
- Suspeita: Erro após deploy de ontem
- Observações: Só em produção
- Ambiente: Produção
- Já testado: Reproduzido em sandbox com mesmo carrinho
```

## O que o Maestro faz

1. Identifica triagem pela primeira linha.
2. **Pre-dispatch** — confirma URL da tarefa e acesso ao provider.
3. Despacha **Support** em modo triagem.
4. Support aplica `rules/support/support-initial-analysis.md` e salva o relatório.

## O que a triagem entrega

Template: `templates/support/initial-analysis.md`

- Comportamento observado vs esperado
- Classificação: Padrão | Configuração | Bug | Indeterminado
- Qualidade da triagem N1
- Direcionamento técnico (entrada → processamento → saída)
- **Seção 9 — Contexto estruturado para RCA** (obrigatória quando aplicável)

## Onde o arquivo é salvo

| Situação | Caminho |
| :--- | :--- |
| Sem `project.config.yaml` | `.memory/docs/support/triage/triage-<ID>-<topic>.md` |
| Com config | `.memory/docs/<outputs.paths.support_triage>` |

Substitua `<ID>` pelo ID da tarefa e `<topic>` por um resumo curto (slug).

## O que a triagem não faz

- Não confirma causa raiz definitiva.
- Não produz RCA (salvo pedido explícito no mesmo prompt).
- Não inventa comportamento de código sem evidência.

## Problemas comuns (triagem)

| Sintoma | Ação |
| :--- | :--- |
| Maestro pede link | Inclua URL na primeira linha |
| Bloqueio de acesso | Configure MCP em `docs/mcp/` |
| Seção 9 vazia | Complete manualmente antes da RCA |
| Arquivo fora do git | Esperado — `.memory/` é gitignored |

## Referência

| Recurso | Caminho |
| :--- | :--- |
| Prompt | `prompts/support/initial-analysis.md` |
| Template | `templates/support/initial-analysis.md` |
| Regra | `rules/support/support-initial-analysis.md` |
