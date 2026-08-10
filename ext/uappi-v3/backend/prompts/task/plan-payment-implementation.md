# Planejar implementação de gateway de pagamento
URL da documentação do pagamento: {documentationUrl}

## Objetivo
Implementar integração com novo gateway pagamento na plataforma obdecendo os padrões já registrados.

### Dados do gateway de pagamento
- Nome: {name};
- Código: {code};
- Descrição: {description};
- Link para imagem: {image};
- URL do pagamento: {url};
- Descrição curta: {description};
- Bandeiras de cartão suportadas: {flags};
- Códigos das credenciais públicas: {public_credentials};
- Status de ativação: true;
- OAuth: {oauth};
- Order: {order};

### Tipos de pagamento suportados

Utilize a tabela abaixo como guia para gerar o `insert` na tabela `payment_type_link`.

<!-- PREENCHA AS COLUNAS DA TABELA ABAIXO COM SIM OU NÃO. CASO UM TIPO DE PAGAMENTO NÃO SEJA NECESSÁRIO, REMOVA ELE DA TABELA. -->
<!-- AS COLUNAS DE DOCUMENTO E TELEFONE SE REFEREM A NECESSIDADE DE COBRAR O DOCUMENTO/TELEFONE NO FORMULÁRIO DE PAGAMENTO NO CHECKOUT  -->
<!-- PRESTE EXTREMA ATENÇÃO A ÚLTIMA COLUNA, POIS NEM TODO GATEWAY OU TIPO DE PAGAMENTO FUNCIONA COM O MIX (EXEMPLOS external e incorporated). -->

| ID do tipo | Código do tipo   | Requer número de telefone? | Requer documento? | Permitido no mix de pagamento? |
|------------|------------------|----------------------------|-------------------|--------------------------------|
| 1          | credit-card      |                            |                   |                                |
| 2          | pix              |                            |                   |                                |
| 3          | billet           |                            |                   |                                |
| 4          | external         |                            |                   | NÃO                            |
| 5          | external-deposit |                            |                   |                                |
| 6          | billet-pix       |                            |                   |                                |
| 8          | incorporated     |                            |                   | NÃO                            |
| 10         | debit-card       |                            |                   |                                |

### Lista de credenciais do pagamento
- Credencial1:
  - code: string
  - title: string
  - type: numeric|bool|map|object|array|string|enum
  - default: string
  - enum: string
  - mapKey: string
  - mapValue: string
- Credencial2:
  - code: string
  - title: string
  - type: numeric|bool|map|object|array|string|enum
  - default: string
  - enum: string
  - mapKey: string
  - mapValue: string

### Mapeamento de status do pagamento
<!-- DICA: VOCÊ PODE MAPEAR VÁRIOS STATUS DO PAGAMENTO PARA O MESMO STATUS PADRÃO -->
| Status do pagamento | Status padrão   |
|---------------------|-----------------|
|                     | WAITING_PAYMENT |
|                     | PAID            |
|                     | CANCELED        |
|                     | ERROR           |

## Escopo
Toda implementação do pagamento deve ser colocada no serviço `external.uappi` e deve ser registrado no serviço `integration.uappi`.

### Registrando o novo gateway de pagamento
Para registrar e disponibilizar o pagamento para uso na plataforma, adicione uma alteração de banco para a tabela `payment` usando as informações no tópico `### Dados do gateway de pagamento`.

### Modelo de autenticação
<!-- ESCOLHA UMA DAS OPÇÕES ABAIXO E REMOVA AS OUTRAS: Basic Auth, OAuth, Outro, link da documentação. Substitua as variáveis conforme necessário.  -->

Basic Auth
Utilize a credencial {nome da credencial 1} como username e a credencial {nome da credencial 2} para o password na montagem do header `authorization`.

OAuth
Usar a credencial `access-token` para montagem do header `authorization`.

Outro: Descrever outro modelo

Link da documentação: {link da documentação aqui de autenticação}.

<!-- PARA OS TÓPICOS ABAIXO, CASO NÃO TENHA LINK DA DOCUMENTAÇÃO APENAS REMOVA A LINHA DO LINK -->
<!-- ADICIONE OBSERVAÇÕES, EXPLICAÇÕES, MAPEAMENTOS CONFORME NECESSÁRIO -->
### Consulta de transação - Equivale ao método `consult`
Link da documentação: {link da documentação}

### Criação de transação - Equivale ao método `transact`
Link da documentação: {link da documentação}

1. Utilize o link da documentação acima, obtenha os campos disponíveis sempre se atentando a suas tipagens, formatações e se são obrigatórios;
2. Abaixo você vai encontrar uma tabela de mapeamento de campos. Utilize esse mapeamento para determinar se existe algum campo obrigatório que não foi específicado na tabela;
3. Caso existe algum campo obrigatório não mapeado, pause o planejamento e solicite ao usuário esclarecimento para esses campos (informe os nomes e descrições dos campos e se possível uma sugestão de mapeamento);
4. Após tudo estiver esclarecido, você pode seguir com o planejamento.

#### Mapeamento de campos CreateTransactionRequest x Campos do gateway de pagamento

<!-- PREENCHA APENAS OS CAMPOS NECESSÁRIOS, O RESTANTE PODE SER REMOVIDO ANTES DO PROMPT -->

| Campo na request no gateway de pagamento | Campo na Uappi                               | Observação |
|------------------------------------------|----------------------------------------------|------------|
|                                          | *.customer.id                                |            |
|                                          | *.customer.name                              |            |
|                                          | *.customer.isCorporate                       |            |
|                                          | *.customer.gender                            |            |
|                                          | *.customer.document1                         |            |
|                                          | *.customer.document2                         |            |
|                                          | *.customer.email                             |            |
|                                          | *.customer.phone                             |            |
|                                          | *.customer.birthDate                         |            |
|                                          | *.customer.homeAddress.zipCode               |            |
|                                          | *.customer.homeAddress.street                |            |
|                                          | *.customer.homeAddress.number                |            |
|                                          | *.customer.homeAddress.district              |            |
|                                          | *.customer.homeAddress.city                  |            |
|                                          | *.customer.homeAddress.stateCode             |            |
|                                          | *.customer.homeAddress.complement            |            |
|                                          | *.customer.billingAddress.zipCode            |            |
|                                          | *.customer.billingAddress.street             |            |
|                                          | *.customer.billingAddress.number             |            |
|                                          | *.customer.billingAddress.district           |            |
|                                          | *.customer.billingAddress.city               |            |
|                                          | *.customer.billingAddress.stateCode          |            |
|                                          | *.customer.billingAddress.complement         |            |
|                                          | *.order.id                                   |            |
|                                          | *.order.number                               |            |
|                                          | *.order.currency                             |            |
|                                          | *.order.date                                 |            |
|                                          | *.order.shippingValue                        |            |
|                                          | *.order.subtotalValue                        |            |
|                                          | *.order.totalValue                           |            |
|                                          | *.items.[]                                   |            |
|                                          | *.payments.[0].paymentOptionId               |            |
|                                          | *.payments.[0].paymentPositionKey            |            |
|                                          | *.payments.[0].code                          |            |
|                                          | *.payments.[0].method                        |            |
|                                          | *.payments.[0].installments                  |            |
|                                          | *.payments.[0].fee                           |            |
|                                          | *.payments.[0].total                         |            |
|                                          | *.payments.[0].capture                       |            |
|                                          | *.payments.[0].date                          |            |
|                                          | *.payments.[0].softDescription               |            |
|                                          | *.payments.[0].pix.dueDate                   |            |
|                                          | *.payments.[0].card.id                       |            |
|                                          | *.payments.[0].card.token                    |            |
|                                          | *.payments.[0].card.number                   |            |
|                                          | *.payments.[0].card.flag                     |            |
|                                          | *.payments.[0].card.name                     |            |
|                                          | *.payments.[0].card.expiration               |            |
|                                          | *.payments.[0].card.cvv                      |            |
|                                          | *.payments.[0].billet.dueDate                |            |
|                                          | *.payments.[0].billet.daysToExpiration       |            |
|                                          | *.payments.[0].billetPix.dueDate             |            |
|                                          | *.payments.[0].billetPix.ourNumber           |            |
|                                          | *.payments.[0].external.defaultRedirect      |            |
|                                          | *.payments.[0].external.confirmationRedirect |            |
|                                          | *.payments.[0].external.cancellationRedirect |            |
|                                          | *.payments.[0].externalDeposit.phoneNumber   |            |
|                                          | *.payments.[0].externalDeposit.dueDate       |            |
|                                          | *.payments.[0].callbackUrl                   |            |

#### Mapeamento de campos CreateTransactionResponse x Campos de resposta do gateway de pagamento

Utilize os campos da tabela abaixo para gerar o processo que vai mapear os dados de resposta do gateway de pagamento para a respota de criação de transação.

Os campos `paymentOptionId`, `paymentPositionKey`, `method` sempre devem ser obtidos do objeto de request (type `CreateTransactionRequest`).

O campo `date`, sempre deve ser preenchido com a data atual.

Os campos de forma de pagamento (`pix`, `billet`, `billetPix`, `card`, `external`, `externalDeposit`) são **nullable** e caso não sejam mapeados na tabela, devem receber o valor `null`.

Para os campos de `request` e `response` sempre utilize o objeto de request montado e o objeto resposta recebido.

O campo de referência para mapear o status da transação está em `{{caminho}}`.

| Campo na Uappi                   | Campo na response no gateway de pagamento | Observação |
|----------------------------------|-------------------------------------------|------------|
| *.success                        |                                           |            |
| *.value                          |                                           |            |
| *.data.id                        |                                           |            |
| *.data.reference                 |                                           |            |
| *.data.external                  |                                           |            |
| *.data.nsu                       |                                           |            |
| *.data.captured                  |                                           |            |
| *.data.captured                  |                                           |            |
| *.card.nsu                       |                                           |            |
| *.card.bin                       |                                           |            |
| *.card.last4                     |                                           |            |
| *.card.brand                     |                                           |            |
| *.card.expiration                |                                           |            |
| *.card.holder                    |                                           |            |
| *.pix.id                         |                                           |            |
| *.pix.dueDate                    |                                           |            |
| *.pix.emv                        |                                           |            |
| *.pix.qrCode                     |                                           |            |
| *.pix.link                       |                                           |            |
| *.billet.id                      |                                           |            |
| *.billet.ourNumber               |                                           |            |
| *.billet.base64                  |                                           |            |
| *.billet.barCode                 |                                           |            |
| *.billet.link                    |                                           |            |
| *.billet.digitableLine           |                                           |            |
| *.billet.dueDate                 |                                           |            |
| *.billetPix.billet               |                                           |            |
| *.billetPix.billet.id            |                                           |            |
| *.billetPix.billet.ourNumber     |                                           |            |
| *.billetPix.billet.base64        |                                           |            |
| *.billetPix.billet.barCode       |                                           |            |
| *.billetPix.billet.link          |                                           |            |
| *.billetPix.billet.digitableLine |                                           |            |
| *.billetPix.billet.dueDate       |                                           |            |
| *.billetPix.pix                  |                                           |            |
| *.billetPix.pix.id               |                                           |            |
| *.billetPix.pix.dueDate          |                                           |            |
| *.billetPix.pix.emv              |                                           |            |
| *.billetPix.pix.qrCode           |                                           |            |
| *.billetPix.pix.link             |                                           |            |
| *.external.paymentUrl            |                                           |            |
| *.external.paymentUrl            |                                           |            |
| *.captures.[].nsu                |                                           |            |
| *.captures.[].date               |                                           |            |
| *.captures.[].value              |                                           |            |
| *.refunds.[].id                  |                                           |            |
| *.refunds.[].date                |                                           |            |
| *.refunds.[].value               |                                           |            |

### Captura de transação - Equivale ao método `capture`
Link da documentação: {link da documentação}

### Cancelamento de transação - Equivale ao método `cancel`
Link da documentação: {link da documentação}

### Resposta de webhook - Equivale ao método `webhook`
Link da documentação: {link da documentação}

## Restrições
- Não é necessário desenvolver testes automatizados;