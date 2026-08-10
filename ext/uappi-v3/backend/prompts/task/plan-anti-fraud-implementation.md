# Planejar implementação de Antifraude
URL da documentação do antifraude: {documentationUrl}

## Objetivo
Implementar novo antifraude na plataforma obdecendo os padrões já registrados.

### Dados do antifraude
- Nome: {name}
- Código: {code}
- Descrição: {description}
- Link para imagem: {image}
- URL do antifraude: {url}
- Descrição curta: {description}
- Momento da operação: {moment}
- Status de ativação: true;
- OAuth: false;

### Lista de credenciais do antifraude
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

### Mapeamento de status do antifraude
<!-- DICA: VOCÊ PODE MAPEAR VÁRIOS STATUS DO ANTIFRAUDE PARA O MESMO STATUS PADRÃO -->
| Status do antifraude | Status padrão |
|----------------------|---------------|
| data1                | PENDING       |
| data1                | APPROVED      |
| data1                | REPROVED      |
| data1                | ERROR         |

## Escopo
Toda implementação do antifraude deve ser colocada no serviço `external.uappi` e deve ser registrado no serviço `integration.uappi`.

### Registrando o novo antifraude
Para registrar e disponibilizar o antifraude para uso na plataforma, adicione uma alteração de banco para a tabela `payment_anti_fraud` usando as informações no tópico `### Dados do antifraude`.

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

### Criação de transação - Equivale ao método `create`
Link da documentação: {link da documentação}

1. Utilize o link da documentação acima, obtenha os campos disponíveis sempre se atentando a suas tipagens, formatações e se são obrigatórios;
2. Abaixo você vai encontrar uma tabela de mapeamento de campos. Utilize esse mapeamento para determinar se existe algum campo obrigatório que não foi específicado na tabela;
3. Caso existe algum campo obrigatório não mapeado, pause o planejamento e solicite ao usuário esclarecimento para esses campos (informe os nomes e descrições dos campos e se possível uma sugestão de mapeamento);
4. Após tudo estiver esclarecido, você pode seguir com o planejamento.

#### Mapeamento de campos CreateAntiFraudTransactionCustomerRequestType x Campos do antifraude

| Campo na request do antifraude | Campo na Uappi                 | Observação |
|--------------------------------|--------------------------------|------------|
|                                | *.orderPaymentId               |            |
|                                | *.paymentAntiFraudCredentialId |            |
|                                | *.antiFraudCode                |            |
|                                | *.credentials                  |            |
|                                | *.customer.id                  |            |
|                                | *.customer.nameCorporateName   |            |
|                                | *.customer.tradeName           |            |
|                                | *.customer.isCorporate         |            |
|                                | *.customer.gender              |            |
|                                | *.customer.email               |            |
|                                | *.customer.birthDate           |            |
|                                | *.customer.document            |            |
|                                | *.customer.phoneNumber         |            |
|                                | *.order.id                     |            |
|                                | *.order.totalValue             |            |
|                                | *.order.shippingValue          |            |
|                                | *.order.issuedAt               |            |
|                                | *.order.currency               |            |
|                                | *.order.businessModel          |            |
|                                | *.order.salesChannel           |            |
|                                | *.payment.cardMasked           |            |
|                                | *.payment.cardFlag             |            |
|                                | *.payment.value                |            |
|                                | *.payment.cardInstallments     |            |
|                                | *.payment.cardExpiration       |            |
|                                | *.delivery.street              |            |
|                                | *.delivery.number              |            |
|                                | *.delivery.city                |            |
|                                | *.delivery.district            |            |
|                                | *.delivery.stateCode           |            |
|                                | *.delivery.zipCode             |            |
|                                | *.delivery.countryCode         |            |
|                                | *.billing.street               |            |
|                                | *.billing.number               |            |
|                                | *.billing.city                 |            |
|                                | *.billing.district             |            |
|                                | *.billing.stateCode            |            |
|                                | *.billing.zipCode              |            |
|                                | *.billing.countryCode          |            |
|                                | *.items.[].id                  |            |
|                                | *.items.[].sku                 |            |
|                                | *.items.[].name                |            |
|                                | *.items.[].description         |            |
|                                | *.items.[].unitValue           |            |
|                                | *.items.[].quantity            |            |

### Resposta de webhook - Equivale ao método `getWebhookResponse`
Link da documentação: {link da documentação}

## Restrições
- Não é necessário desenvolver testes automatizados;