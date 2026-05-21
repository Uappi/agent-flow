# Guia: implementação simples com o AgentFlow

Este guia mostra como pedir uma implementação direta ao AgentFlow, sem passar antes por um plano formal.

Use este fluxo quando a mudança é pequena, isolada e bem descrita.

## Quando usar

Use implementação simples quando:

- A mudança deve tocar até 5 arquivos.
- A mudança deve alterar até 300 linhas aproximadamente.
- O comportamento esperado é claro.
- O escopo está bem delimitado.
- Não há decisão arquitetural pendente.
- Não há mudança relevante de contrato entre módulos.
- Não há necessidade de dividir em fases.

Exemplos:

- Corrigir uma validação simples.
- Ajustar uma regra localizada.
- Corrigir texto, formatação ou retorno de erro.
- Adicionar um campo simples em resposta já existente.
- Corrigir um bug com causa provável bem delimitada.

## Quando não usar

Não use implementação simples quando:

- A mudança envolve múltiplos módulos ou camadas.
- O bug pode ter causa em várias partes do sistema.
- A alteração muda contrato de API, evento, fila ou integração.
- A mudança exige refactor estrutural.
- A tarefa tem risco alto de regressão.
- O objetivo ainda está ambíguo.

Nesses casos, use o guia de implementação com plano.

## Prompt

Use o template:

```text
.agents/prompts/general/implementation.md
```

Conteúdo do prompt:

```text
Implementar
Escopo: <ex.: apenas camada de frete / seguir plano em .memory/plan/...>
Objetivo: <resultado esperado>
Restricoes: <opcional>
Observacoes: <opcional>
```

## Como preencher

### `Escopo`

Defina exatamente onde a mudança deve acontecer e o que fica fora.

Bom exemplo:

```text
Escopo: Corrigir validação de cupom no checkout. Alterar apenas camada de checkout e testes relacionados.
```

Evite:

```text
Escopo: Corrigir checkout.
```

### `Objetivo`

Descreva o resultado verificável da implementação.

Bom exemplo:

```text
Objetivo: Cupons expirados devem retornar erro claro e não podem aplicar desconto no pedido.
```

Evite:

```text
Objetivo: Melhorar cupom.
```

### `Restricoes`

Liste limites que o Coder deve respeitar.

Exemplo:

```text
Restricoes: Não alterar o contrato da API. Não mexer em regras de frete.
```

### `Observacoes`

Inclua evidências, links, logs, comportamento atual, comportamento esperado ou casos de reprodução.

Exemplo:

```text
Observacoes: A tarefa do Monday informa que o problema ocorre quando o cupom expirou no dia anterior.
```

## Exemplo completo

```text
Implementar
Escopo: Corrigir validação de cupom no checkout. Alterar apenas camada de checkout e testes relacionados.
Objetivo: Cupons expirados devem retornar erro claro e não podem aplicar desconto no pedido.
Restricoes: Não alterar o contrato da API. Não mexer em regras de frete.
Observacoes: A tarefa do Monday informa que o problema ocorre quando o cupom expirou no dia anterior.
```

## O que o AgentFlow faz

Ao receber uma implementação simples, o Maestro despacha o Coder quando o escopo parece pequeno o suficiente.

O Coder deve:

- Ler arquivos próximos para absorver o estilo local.
- Definir um breve plano de ação.
- Criar to-do da tarefa.
- Implementar a mudança.
- Escrever ou ajustar testes quando aplicável.
- Rodar testes da área afetada.
- Fazer self-review antes de entregar.

Depois disso, o resultado passa pelo review loop do AgentFlow antes da entrega final.

## Atualização de contexto

Durante uma implementação simples, atualize artefatos de contexto apenas se a mudança justificar.

Atualize `.context.md` se a mudança altera responsabilidade, estrutura ou arquivos relevantes de um diretório.

Atualize `docs/FEATURE-MAP.md` se a mudança adiciona, remove ou altera o fluxo de uma funcionalidade visível ao usuário.

Não atualize contexto apenas por bugfix interno, formatação ou refactor que preserva fluxo e responsabilidades.

## Critérios de aceite

Inclua critérios de aceite verificáveis sempre que possível.

Bons exemplos:

- Cupom expirado retorna erro `coupon_expired` e não altera o total do pedido.
- Usuário sem permissão recebe 403 ao tentar cancelar pedido de outra loja.
- Pedido com retirada em loja não cria cotação de frete.
- Job de sincronização registra falha quando a API externa retorna timeout.

Evite critérios vagos como:

- Melhorar checkout.
- Ajustar frete.
- Deixar mais seguro.
- Corrigir problema do cliente.

## Problemas comuns

### O Coder pediu um plano

Isso significa que a tarefa foi classificada como complexa demais para implementação direta. Use o fluxo de implementação com plano.

### A implementação expandiu o escopo

Reforce as restrições. O Coder não deve implementar melhorias não solicitadas.

### Os testes não existem

Peça que o Coder valide a área afetada com o melhor comando disponível e reporte quando não houver suíte automatizada aplicável.

### A mudança exige decisão de produto

Não force implementação. Resolva a decisão com produto, suporte ou responsável pela regra antes de continuar.
