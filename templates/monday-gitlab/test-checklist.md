# Template — Checklist de Testes (QA / Dev)

> A checklist deve refletir o diff do MR e o contexto da tarefa (Monday + contexto adicional).

## Identificação

- **MR/Merge**: `<id ou link>`
- **Branch origem**: `<nome>`
- **Branch destino**: `<nome>`
- **Monday (link)**: `<link>`
- **Pessoas envolvidas**: `<nome>`
- **Data**: `<YYYY-MM-DD>`

## Contexto da tarefa

- **Problema / Motivação**: `<o que originou a tarefa>`
- **Objetivo**: `<o que deve mudar>`
- **Regra esperada**: `<comportamento correto>`
- **Escopo**: `<impacto / módulo / fluxo>`

## Escopo do MR

- `<arquivo 1>` — `<resumo da alteração>`
- `<arquivo 2>` — `<resumo da alteração>`

## Matriz de risco

| Área | Impactada? | Risco | Justificativa |
| --- | --- | --- | --- |
| API (rotas) | `sim/não` | `baixo/médio/alto` | `<motivo>` |
| Banco de dados | `sim/não` | `baixo/médio/alto` | `<motivo>` |
| Segurança | `sim/não` | `baixo/médio/alto` | `<motivo>` |
| Front (loja) | `sim/não` | `baixo/médio/alto` | `<motivo>` |
| Admin (painel) | `sim/não` | `baixo/médio/alto` | `<motivo>` |
| Checkout | `sim/não` | `baixo/médio/alto` | `<motivo>` |
| Legacy | `sim/não` | `baixo/médio/alto` | `<motivo>` |
| Integrações | `sim/não` | `baixo/médio/alto` | `<motivo>` |
| Crons/Jobs | `sim/não` | `baixo/médio/alto` | `<motivo>` |

## Cenários de teste funcional

### Happy path

- [ ] `<cenário 1>` — **pré-condição**: `<estado inicial>` — **esperado**: `<resultado>`
- [ ] `<cenário 2>` — **pré-condição**: `<estado inicial>` — **esperado**: `<resultado>`

### Negativos / edge cases

- [ ] `<cenário negativo 1>` — **esperado**: `<erro/validação>`
- [ ] `<cenário negativo 2>` — **esperado**: `<erro/validação>`

### Permissão / autenticação (se aplicável)

- [ ] `<sem autenticação>` — **esperado**: `<status>`
- [ ] `<sem permissão>` — **esperado**: `<status>`

## Cenários de regressão

- [ ] `<fluxo legado 1>` — **esperado**: `<continua funcionando>`
- [ ] `<fluxo legado 2>` — **esperado**: `<continua funcionando>`

## Testes de API (se aplicável)

| # | Endpoint | Cenário | Status esperado | Validação |
| --- | --- | --- | --- | --- |
| 1 | `<METHOD /rota>` | `<happy path>` | `<200/201/...>` | `<campos esperados>` |
| 2 | `<METHOD /rota>` | `<erro de validação>` | `<400/422/...>` | `<mensagem esperada>` |

## Testes de segurança (se aplicável)

- [ ] `<CSRF/XSS/SQLi/Auth/Rate limit>` — **esperado**: `<comportamento>`

## Testes de persistência / logs (se aplicável)

- [ ] `<tabela/registro/log>` — **esperado**: `<valor/comportamento>`

## Sugestões de testes automatizados

- [ ] `<teste integração 1>` — `<assert principal>`
- [ ] `<teste integração 2>` — `<assert principal>`
- [ ] `<teste unitário 1>` — `<método e regra>`

## Critérios de aceite

- [ ] Regras de negócio validadas
- [ ] Sem regressões nos fluxos impactados
- [ ] Evidências de teste registradas

## Observações finais

- `<pendências, dúvidas, follow-ups>`

