# Guia: RCA de suporte N2

Análise de causa raiz (RCA) de tickets de suporte com o AgentFlow. A persona **Support** valida hipóteses com código, diff e timeline, e recomenda correção com nível de confiança.

- Etapa anterior (recomendada): [triagem](support-triage.md)
- Índice dos fluxos de suporte: [support-analysis.md](support-analysis.md)
- Config por cliente: [project-config.md](../project-config.md)

## Quando usar

- Após triagem, com a **seção 9** do relatório preenchida.
- Suspeita de regressão com MR/PR ou release para correlacionar.
- Necessidade de evidência em código e recomendação de correção.

Não rode RCA no lugar da triagem quando o ticket ainda não tiver direcionamento inicial.

## Pré-requisitos

1. AgentFlow em `.agents/` e boot: `Por favor, siga as instruções de .agents/AGENTS.md`.
2. **`README.ai.md`** na raiz do cliente (recomendado) — ver [readme-ai.md](readme-ai.md).
3. **URL da tarefa** na primeira linha (obrigatória).
4. **Seção 9** do relatório de triagem (fortemente recomendada).
5. **Acesso autenticado** ao tracker e, se informados, a MR/PR ou release.
6. **`project.config.yaml`** (opcional) — ver [project-config.md](../project-config.md).

## Primeira linha aceita

- `RCA suporte:`
- `RCA N2:`
- `Análise profunda suporte:`
- `Análise profunda N2:`
- `Causa raiz suporte:`
- `Causa raiz N2:`

## Prompt de exemplo

Copie `prompts/support/rca.md` e preencha:

```text
RCA suporte: https://<tracker>/boards/<board>/pulses/<item>
MR/PR ou release relacionado: https://gitlab.com/<grupo>/<projeto>/-/merge_requests/1234

Contexto estruturado (copie a seção 9 do relatório de triagem):
- Sintoma observado: ...
- Hipótese principal: ...
- Ponto crítico do fluxo: ...
(colar o restante do bloco)

Contexto adicional:
- Release atual: v2.4.1
- Release anterior: v2.4.0
- Merge/MR: !1234
- Fluxo: Pagamento com cartão salvo
- Sintoma observado: Timeout na confirmação
```

## Prioridade de contexto

1. **Seção 9** do relatório de triagem (maior prioridade)
2. Contexto adicional no prompt
3. Relatório de triagem completo (apoio — não copiar verbatim)

## O que o Maestro faz

1. Identifica RCA pela primeira linha.
2. **Pre-dispatch** — URL da tarefa + acesso a MR/PR/release **se você os informou**.
3. Despacha **Support** em modo RCA.
4. Support aplica `rules/support/support-root-cause-analysis.md` e salva o relatório.

## O que a RCA entrega

Template: `templates/support/rca.md`

- Timeline e tipo (regressão / novo comportamento / indeterminado)
- Correlação com merge/diff quando houver link
- Causa raiz técnica com confiança (Alta | Média | Baixa)
- Evidência no código e mitigação recomendada

## Onde o arquivo é salvo

| Situação | Caminho |
| :--- | :--- |
| Sem `project.config.yaml` | `.memory/docs/support/rca/rca-<ID>-<topic>.md` |
| Com config | `.memory/docs/<outputs.paths.support_rca>` |

## Links opcionais

| Link | Quando informar |
| :--- | :--- |
| MR/PR | Regressão suspeita em merge |
| Release | Correlação com mudança de versão |

Se informar MR/PR ou release, configure MCP do provider em `docs/mcp/` — o Maestro bloqueia dispatch sem acesso autenticado.

## Problemas comuns (RCA)

| Sintoma | Ação |
| :--- | :--- |
| RCA repete triagem | Cole a seção 9 estruturada |
| Sem evidência em código | Informe MR/PR; confira `README.ai.md` |
| Bloqueio no MR | Configure MCP GitLab/GitHub |
| Causa especulativa | Volte à triagem e refine a seção 9 |

## Referência

| Recurso | Caminho |
| :--- | :--- |
| Prompt | `prompts/support/rca.md` |
| Template | `templates/support/rca.md` |
| Regra | `rules/support/support-root-cause-analysis.md` |
