# Guia: implementação com plano no AgentFlow

Este guia mostra como usar o AgentFlow para planejar uma mudança antes de implementar.

Use este fluxo quando a mudança é grande, ambígua, estrutural ou arriscada demais para implementação direta.

## Quando usar

Use implementação com plano quando:

- A mudança pode tocar mais de 5 arquivos.
- A mudança pode alterar mais de 300 linhas.
- Envolve múltiplos módulos ou camadas.
- Exige refactor.
- Muda fluxo funcional importante.
- Muda contrato de API, evento, fila ou integração.
- Tem risco alto de regressão.
- Precisa ser dividida em fases.
- Você ainda não sabe exatamente onde mexer.

Exemplos:

- Reestruturar cálculo de frete.
- Trocar provedor de pagamento.
- Adicionar uma nova etapa no checkout.
- Mudar fluxo de cancelamento de pedido.
- Corrigir um bug cuja causa pode estar em múltiplas camadas.
- Implementar uma feature que afeta API, banco, frontend e jobs.

## Passo 1: pedir o plano

Use o template:

```text
.agents/prompts/general/implementation-plan.md
```

Conteúdo do prompt:

```text
Planejar implementação
Objetivo: <o que deve existir ao final>
Escopo: <partes do sistema que entram e que ficam fora>
Restricoes: <opcional>
Criterios de aceite: <opcional>
```

## Como preencher o plano

### `Objetivo`

Descreva o estado final esperado.

Exemplo:

```text
Objetivo: Permitir que pedidos com retirada em loja tenham fluxo próprio de disponibilidade, sem cálculo de frete.
```

### `Escopo`

Liste o que entra e o que fica fora.

Exemplo:

```text
Escopo: Checkout, criação de pedido, cálculo de entrega e testes relacionados. Não alterar painel administrativo nesta etapa.
```

### `Restricoes`

Registre limites técnicos ou de produto.

Exemplo:

```text
Restricoes: Manter compatibilidade com pedidos de entrega normal. Não alterar contrato público da API sem indicar impacto.
```

### `Criterios de aceite`

Liste condições verificáveis para considerar o plano implementado.

Exemplo:

```text
Criterios de aceite: Pedido com retirada em loja não chama cálculo de frete; pedido com entrega normal mantém comportamento atual; indisponibilidade da loja bloqueia finalização.
```

## Exemplo completo de plano

```text
Planejar implementação
Objetivo: Permitir que pedidos com retirada em loja tenham fluxo próprio de disponibilidade, sem cálculo de frete.
Escopo: Checkout, criação de pedido, cálculo de entrega e testes relacionados. Não alterar painel administrativo nesta etapa.
Restricoes: Manter compatibilidade com pedidos de entrega normal. Não alterar contrato público da API sem indicar impacto.
Criterios de aceite: Pedido com retirada em loja não chama cálculo de frete; pedido com entrega normal mantém comportamento atual; indisponibilidade da loja bloqueia finalização.
```

## O que o Architect entrega

O Architect deve produzir um plano em `.memory/plan/` com:

- Objetivo.
- Estado atual.
- Estado desejado.
- Áreas afetadas.
- Fases de implementação, se necessário.
- Critérios de aceite.
- Especificação de testes quando aplicável.

O plano deve ter um caminho parecido com:

```text
.memory/plan/2026-05-21-feat-store-pickup.md
```

## Passo 2: implementar seguindo o plano

Depois que o plano for aceito, peça a implementação informando o caminho do plano.

Use o template:

```text
.agents/prompts/general/implementation.md
```

Exemplo:

```text
Implementar
Escopo: Seguir o plano em .memory/plan/2026-05-21-feat-store-pickup.md. Implementar apenas a Fase 1.
Objetivo: Entregar a primeira fase conforme critérios de aceite do plano.
Restricoes: Não avançar para a Fase 2. Não ampliar escopo além do plano.
Observacoes: Se encontrar divergência entre plano e código atual, parar e reportar antes de seguir.
```

Quando o plano possui múltiplas fases, o Coder deve implementar apenas a fase solicitada e parar. A próxima fase deve ser uma nova solicitação.

## O que o AgentFlow faz

No planejamento, o Maestro despacha o Architect.

O Architect deve:

- Entender o estado atual.
- Definir o estado desejado.
- Mapear áreas afetadas.
- Dividir em fases quando necessário.
- Definir critérios de aceite e testes.
- Salvar o plano em `.memory/plan/`.

Depois, na implementação, o Maestro despacha o Coder com o plano como referência.

O Coder deve:

- Seguir o plano aprovado.
- Implementar apenas a fase solicitada.
- Escrever ou ajustar testes quando aplicável.
- Rodar testes da área afetada.
- Fazer self-review antes de entregar.

Depois disso, o resultado passa pelo review loop do AgentFlow antes da entrega final.

## Atualização de contexto

Durante uma implementação com plano, atualize artefatos de contexto apenas quando necessário.

Atualize `.context.md` se a mudança altera responsabilidade, estrutura ou arquivos relevantes de um diretório.

Atualize `docs/FEATURE-MAP.md` se a mudança adiciona, remove ou altera o fluxo de uma funcionalidade visível ao usuário.

Não atualize contexto apenas por bugfix interno, formatação ou refactor que preserva fluxo e responsabilidades.

## Problemas comuns

### O plano ficou ambíguo

Responda às perguntas do Architect ou refine objetivo, escopo e critérios de aceite.

### O plano ficou grande demais

Peça para dividir em fases menores. Cada fase deve ser implementável separadamente.

### O Coder encontrou divergência entre plano e código

Pare a implementação e revise o plano. Não force o Coder a improvisar uma mudança estrutural sem atualizar o plano.

### A implementação avançou para outra fase

Reforce que cada fase é uma solicitação separada. O Coder deve parar após concluir a fase pedida.

### A mudança exige decisão de produto

Resolva a decisão antes de aprovar o plano ou iniciar a implementação.
