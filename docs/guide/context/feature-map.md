# Guia: `docs/FEATURE-MAP.md`

O `docs/FEATURE-MAP.md` é o mapa das funcionalidades visíveis ao usuário e dos caminhos de código que implementam cada uma delas.

Ele fica no repositório de trabalho, em `docs/FEATURE-MAP.md`, não dentro de `.agents/`.

## Para que serve

O Feature Map ajuda a IA e o time a responder rapidamente: "onde esta funcionalidade começa, por onde passa e onde termina?".

Ele é útil para:

- Planejar mudanças em fluxos existentes.
- Revisar MRs com impacto funcional.
- Gerar documentação técnica ou de produto.
- Fazer triagem de bug em áreas conhecidas.
- Evitar exploração repetida do mesmo fluxo.

## Estrutura recomendada

```markdown
# Feature Map

> Auto-maintained index of every user-facing feature and the code path that implements it. Updated alongside the code - not after the fact.

## [Nome da Funcionalidade]

Descrição breve do que a funcionalidade faz do ponto de vista do usuário.

**Flow:**

1. `path/to/entry-point.ext` - o que acontece aqui
2. `path/to/service.ext` - o que acontece aqui
3. `path/to/repository.ext` - o que acontece aqui
4. `path/to/output.ext` - o que acontece aqui

---
```

## Como escolher o nome da funcionalidade

Use o nome que o usuário, suporte, produto ou operação reconheceria.

Bons exemplos:

- `Criar pedido`
- `Cancelar assinatura`
- `Exportar relatório financeiro`
- `Sincronizar estoque com ERP`

Evite nomes internos como:

- `OrderService flow`
- `Module checkout_v2`
- `Job SyncStockCommand`

## Como montar o fluxo

Liste os arquivos na ordem em que a informação percorre o sistema.

Normalmente o fluxo começa em um ponto de entrada:

- Rota HTTP.
- Controller.
- Command.
- Job.
- Consumer de fila.
- Cron.
- Componente de UI.

Depois siga pelas camadas principais:

- Validação.
- Orquestração.
- Regra de negócio.
- Persistência.
- Integração externa.
- Evento, fila ou notificação.
- Resposta ao usuário.

## Quando criar ou atualizar

Atualize `docs/FEATURE-MAP.md` quando uma mudança:

- Adiciona funcionalidade visível ao usuário.
- Remove funcionalidade visível ao usuário.
- Renomeia uma funcionalidade.
- Altera o fluxo de informação de uma funcionalidade existente.
- Move ou renomeia arquivos citados em um fluxo.
- Adiciona uma nova camada relevante ao caminho da funcionalidade.

Não é necessário atualizar quando a mudança é apenas:

- Bugfix sem mudança de fluxo.
- Refactor que preserva os mesmos pontos de entrada e saída.
- Ajuste de estilo ou formatação.
- Alteração isolada em testes.
- Otimização interna que não muda o caminho principal.

## Como lidar com variações de fluxo

Se a funcionalidade tem ramificações, registre o caminho principal e cite a variação em uma linha curta.

Exemplo:

```markdown
## Criar pedido

Cria um pedido a partir do checkout e inicia o processamento de pagamento.

**Flow:**

1. `app/Http/Controllers/CheckoutController.php` - recebe os dados do checkout.
2. `app/Services/Orders/CreateOrderService.php` - valida regras comerciais e cria o pedido.
3. `app/Repositories/OrderRepository.php` - persiste pedido e itens.
4. `app/Jobs/ProcessPaymentJob.php` - processa pagamento de forma assíncrona quando o método exige captura posterior.
5. `app/Http/Resources/OrderResource.php` - formata a resposta exibida ao comprador.

Fluxo alternativo: pedidos gratuitos pulam `ProcessPaymentJob.php` e são confirmados diretamente pelo service.

---
```

## Relação com o AgentFlow

O Contextualizer cria ou atualiza o Feature Map durante o fluxo `Mapear contexto`.

O Coder deve atualizar o Feature Map quando uma implementação altera uma funcionalidade visível ao usuário.

O Analyst usa o Feature Map para gerar documentação técnica ou de produto com menos exploração inicial.

O Reviewer pode usar o Feature Map para identificar impacto funcional e risco de regressão em MRs.

## Boas práticas

- Só registre funcionalidades rastreáveis no código.
- Não invente fluxo para preencher lacunas.
- Use caminhos reais de arquivos.
- Mantenha cada passo em uma linha.
- Descreva o papel do arquivo no fluxo, não todos os detalhes internos.
- Prefira o fluxo principal; cite ramificações só quando mudam comportamento relevante.
- Atualize junto com a mudança de código, não depois.

## Exemplo completo

```markdown
# Feature Map

> Auto-maintained index of every user-facing feature and the code path that implements it. Updated alongside the code - not after the fact.

## Cancelar pedido

Permite cancelar um pedido elegível e registrar o motivo do cancelamento para auditoria e atendimento.

**Flow:**

1. `app/Http/Controllers/OrderCancelController.php` - recebe a solicitação de cancelamento.
2. `app/Http/Requests/CancelOrderRequest.php` - valida motivo e permissão do usuário.
3. `app/Services/Orders/CancelOrderService.php` - verifica regras de cancelamento e altera o status.
4. `app/Repositories/OrderRepository.php` - persiste o novo status e o motivo.
5. `app/Jobs/NotifyOrderCanceledJob.php` - notifica comprador e operação.
6. `app/Http/Resources/OrderResource.php` - retorna o pedido atualizado.

---
```
