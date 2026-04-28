# Template — Code Review (Merge/MR)

> A revisão deve refletir apenas o diff do MR (merge-base), não o diff bruto entre branches.

## Identificação

- **MR/Merge**: `<id ou link>`
- **Branch origem**: `<nome>`
- **Branch destino**: `<nome>`
- **Monday (link)**: `<link>`
- **Pessoas envolvidas**: `<nome>`
- **Data**: `<YYYY-MM-DD>`

## Contexto (resumo de 1–5 linhas)

- **Problema**: `<o que estava errado>`
- **Objetivo**: `<o que deve mudar>`
- **Regra esperada**: `<o comportamento correto>`
- **Escopo**: `<impacto / módulo / fluxo>`

## Escopo do MR (arquivos alterados)

> Lista gerada a partir do diff do MR.

- `<arquivo 1>`
- `<arquivo 2>`

## Sumário executivo

- **O que mudou**: `<1–3 bullets>`
- **Risco geral**: `<baixo | médio | alto>` — `<por quê>`
- **Recomendação**: `<aprovar | aprovar com ajustes | solicitar mudanças>`

## Riscos e problemas encontrados

> Use severidade e impacto. Seja específico (arquivo/função/fluxo). Analise também o projeto como um todo para entender se as alterações do merge podem impactar outras áreas da aplicação de forma negativa.

### [ALTO] `<título curto>`

- **Impacto**: `<o que pode quebrar>`
- **Onde**: `<arquivo: função/trecho>`
- **Evidência**: `<ex.: cenário, exemplo numérico, regra quebrada, comportamento divergente>`
- **Sugestão**: `<correção ou alternativa>`

### [MÉDIO] `<título curto>`

- **Impacto**:
- **Onde**:
- **Evidência**:
- **Sugestão**:

### [BAIXO] `<título curto>`

- **Impacto**:
- **Onde**:
- **Sugestão**:

## Questionamentos para o dev

> Perguntas objetivas que o autor consegue responder com evidência.

- `<pergunta 1>`
- `<pergunta 2>`

## Sugestões de melhorias na implementação

> Melhorias incrementais de manutenibilidade, clareza, performance ou segurança.

- `<melhoria 1>`
- `<melhoria 2>`

## Desalinhamentos com padrão de desenvolvimento do time

> Baseie-se em `README.ai.md`, nas regras do framework e nos padrões locais do módulo.

- `<padrão 1: o que está fora e como corrigir>`
- `<padrão 2>`

## Checklist de testes (QA / Dev)

> Checklist executável e verificável. Inclua o que observar e onde confirmar.

### Cenários principais

- [ ] `<cenário 1>` — **esperado**: `<resultado>`
- [ ] `<cenário 2>` — **esperado**: `<resultado>`

### Regressão / efeitos colaterais

- [ ] `<cenário de regressão 1>` — **esperado**: `<resultado>`

### Persistência / logs (se aplicável)

- [ ] `<tabela/registro a conferir>` — **esperado**: `<valor>`

## Observações finais

- `<pendências, follow-ups, decisões>`

