# Guia: `.context.md`

O `.context.md` é um arquivo de orientação local criado dentro de diretórios relevantes do repositório de trabalho. Ele responde rapidamente: "o que existe aqui, por que existe e quais cuidados a IA precisa respeitar neste ponto do código".

Ele não fica dentro de `.agents/`. Ele fica no próprio projeto consumidor, ao lado dos arquivos que descreve.

## Para que serve

O `.context.md` reduz exploração repetida. Antes de implementar, revisar ou documentar uma área, a IA pode ler o contexto daquele diretório e entender seu papel sem varrer todos os arquivos de novo.

Use `.context.md` para registrar:

- Propósito do diretório.
- Arquivos e subdiretórios importantes.
- Restrições locais que não são óbvias pelo nome dos arquivos.
- Recomendações práticas para mexer naquela área.

## Onde fica

Cada `.context.md` fica dentro do diretório que descreve.

Exemplo:

```text
app/
├── Services/
│   ├── .context.md
│   ├── OrderService.php
│   └── PaymentService.php
└── Http/
    └── Controllers/
        ├── .context.md
        └── OrderController.php
```

## Estrutura recomendada

```markdown
<context path="relative/path" updated="YYYY-MM-DD">

Uma ou duas frases descrevendo o que este diretório contém e por que ele existe.

## Summary

- arquivo.ext - descrição curta do papel deste arquivo
- subdiretorio/ - descrição curta do que este subdiretório contém

## Constraints

- MUST / MUST NOT - restrições obrigatórias específicas deste diretório.

## Guidance

- SHOULD / SHOULD NOT - recomendações que podem ser desviadas com justificativa.

</context>
```

## Como preencher cada seção

### Tag `<context>`

Use `path` com o caminho relativo a partir da raiz do projeto consumidor.

Use `updated` somente quando o conteúdo do `.context.md` mudar de fato.

Exemplo:

```markdown
<context path="app/Services" updated="2026-05-21">
```

### Descrição inicial

Explique em prosa curta o propósito do diretório.

Bom exemplo:

```markdown
Este diretório concentra serviços de aplicação que orquestram regras de negócio entre controllers, repositories e integrações externas.
```

Evite descrições genéricas como:

```markdown
Este diretório contém arquivos do sistema.
```

### Summary

Liste cada arquivo e subdiretório relevante com uma linha objetiva.

Exemplo:

```markdown
## Summary

- OrderService.php - orquestra criação, pagamento e cancelamento de pedidos.
- PaymentService.php - encapsula comunicação com o provedor de pagamento.
- Contracts/ - define interfaces consumidas pelos serviços deste módulo.
```

### Constraints

Use apenas para regras locais obrigatórias e verificáveis.

Exemplo:

```markdown
## Constraints

- MUST NOT chamar gateways externos diretamente a partir de controllers.
- MUST preservar idempotência nas rotinas de criação de pedido.
```

Se não houver restrições específicas, omita a seção.

### Guidance

Use para recomendações úteis, mas não absolutas.

Exemplo:

```markdown
## Guidance

- SHOULD adicionar novos fluxos de pedido neste diretório antes de criar novos módulos.
- SHOULD manter validações de entrada nos requests ou controllers, não nos services.
```

Se não houver orientação útil, omita a seção.

## Quando criar

Crie `.context.md` quando:

- O diretório contém código relevante para regras de negócio ou arquitetura.
- A área será usada com frequência por agentes de IA.
- O propósito do diretório não é óbvio apenas pelos nomes dos arquivos.
- Um mapeamento de contexto foi solicitado pelo prompt `.agents/prompts/general/context-mapping.md`.

Não é necessário criar para:

- Diretórios gerados automaticamente.
- Dependências vendorizadas.
- Cache, build, distribuição ou arquivos temporários.
- Diretórios triviais cujo conteúdo é autoexplicativo.

## Quando atualizar

Atualize o `.context.md` quando uma mudança:

- Altera o propósito do diretório.
- Adiciona ou remove arquivos importantes.
- Move responsabilidades entre diretórios.
- Muda uma restrição ou orientação local.
- Renomeia arquivos citados no `Summary`.

Não atualize só por:

- Bugfix que não muda estrutura ou responsabilidade.
- Formatação.
- Refactor interno que preserva os mesmos papéis.
- Alteração de testes sem impacto no propósito do diretório.

## Relação com o AgentFlow

O Contextualizer gera e atualiza `.context.md` durante o fluxo `Mapear contexto`.

O Coder deve atualizar `.context.md` quando uma implementação altera a estrutura ou responsabilidade de diretórios afetados.

Outras personas usam esses arquivos como orientação antes de planejar, revisar, implementar ou documentar.

## Boas práticas

- Escreva para leitura rápida, não para documentação completa.
- Use fatos observáveis no código.
- Prefira frases curtas.
- Mantenha uma linha por arquivo no `Summary`.
- Não copie README, comentários de código ou documentação de API.
- Não registre regra global em `.context.md`; este arquivo deve descrever apenas o diretório onde está.

## Exemplo completo

```markdown
<context path="app/Services/Orders" updated="2026-05-21">

Este diretório concentra os serviços responsáveis por criar, cancelar e consultar pedidos. Ele coordena regras de negócio com persistência, pagamento e notificações.

## Summary

- CreateOrderService.php - cria pedidos e inicia o fluxo de pagamento.
- CancelOrderService.php - aplica regras de cancelamento e registra o motivo.
- OrderStatusService.php - centraliza transições de status do pedido.
- Contracts/ - interfaces usadas pelos serviços de pedido.

## Constraints

- MUST preservar idempotência na criação de pedidos.
- MUST NOT enviar notificações antes da persistência do status final.

## Guidance

- SHOULD adicionar novas transições de status em OrderStatusService.php.
- SHOULD manter integrações externas atrás de contratos.

</context>
```
