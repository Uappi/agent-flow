# Guia: gerar checklist de testes com o AgentFlow

Este guia mostra como gerar um checklist de testes a partir de uma tarefa e de um MR/PR.

O fluxo é acionado pelo prompt `Gerar checklist de testes` e executado pela persona Reviewer em modo checklist. O objetivo é produzir um roteiro verificável para QA ou dev validar a mudança antes do merge.

## Quando usar

Use este fluxo quando:

- Um MR/PR precisa ser validado por QA.
- Um dev quer um roteiro de testes antes de pedir aprovação.
- A mudança tem risco de regressão funcional.
- A tarefa tem regras de negócio que precisam virar cenários de teste.
- Você quer separar checklist de testes do documento completo de code review.

## Quando não usar

Não use este fluxo para:

- Aprovar ou reprovar tecnicamente um MR/PR. Use `Revisar merge/MR`.
- Documentar uma entrega. Use `Documentação de Implementação`.
- Planejar implementação. Use `Planejar implementação`.
- Fazer RCA ou triagem de suporte.

## Pré-requisitos

- AgentFlow instalado e iniciado no projeto consumidor.
- Maestro já carregado a partir de `.agents/AGENTS.md`.
- Link do MR ou PR.
- Link da tarefa ou issue.
- Acesso autenticado ao provedor do MR/PR, como GitLab ou GitHub.
- Acesso autenticado ao provedor da tarefa, como Monday, GitLab, GitHub ou outro tracker usado pelo time.

O link da tarefa é obrigatório porque contém objetivo, regra esperada e contexto de negócio.

O link do MR/PR é obrigatório porque contém o diff real que define o que precisa ser testado.

## Prompt

Use o template em:

```text
.agents/prompts/task/test-checklist.md
```

Conteúdo do prompt:

```text
Gerar checklist de testes
Merge/Pull Request: <URL do MR ou PR>
Tarefa/issue: <URL da tarefa ou issue>
Contexto adicional: <opcional>
```

## Como preencher

### `Merge/Pull Request`

Informe o link direto do MR ou PR.

Exemplos:

```text
Merge/Pull Request: https://gitlab.com/grupo/projeto/-/merge_requests/123
```

```text
Merge/Pull Request: https://github.com/org/projeto/pull/456
```

### `Tarefa/issue`

Informe o link da tarefa, issue ou card que explica o motivo da alteração.

Exemplo:

```text
Tarefa/issue: https://uappi.monday.com/boards/123/pulses/456
```

### `Contexto adicional`

Use para indicar foco de teste, ambiente, dados conhecidos ou preocupação específica.

Exemplos:

```text
Contexto adicional: Priorizar checkout, cupom e regressão de cálculo de frete.
```

```text
Contexto adicional: QA deve validar em loja com multi-CD habilitado.
```

Se não houver contexto extra, deixe como `<opcional>` ou em branco.

## Exemplo completo

```text
Gerar checklist de testes
Merge/Pull Request: https://gitlab.com/uappi/plataforma/-/merge_requests/123
Tarefa/issue: https://uappi.monday.com/boards/111/pulses/222
Contexto adicional: Priorizar checkout, cupons expirados e regressão de pedidos sem desconto.
```

## O que o AgentFlow faz

Ao receber o prompt, o Maestro executa a checagem de pré-dispatch.

Ele valida:

- Se o link do MR/PR foi informado.
- Se o link da tarefa ou issue foi informado.
- Se existe acesso autenticado para ler cada link.

Depois disso, o Reviewer:

- Lê a tarefa ou issue.
- Lê o diff real do MR/PR.
- Mapeia áreas impactadas.
- Considera riscos funcionais e de segurança.
- Preenche o template `templates/task/test-checklist.md`.
- Salva o resultado em `.memory/docs/checklists/`.

## Saída esperada

O checklist é salvo em:

```text
.memory/docs/checklists/checklist-merge-<MR-OR-PR-ID>-<short-topic>.md
```

O documento inclui:

- Identificação do MR/PR e da tarefa.
- Contexto da tarefa.
- Escopo do MR/PR.
- Matriz de risco por área.
- Cenários de teste funcional.
- Casos negativos e edge cases.
- Cenários de permissão e autenticação, quando aplicável.
- Cenários de regressão.
- Testes de API, quando aplicável.
- Testes de segurança, quando aplicável.
- Testes de persistência e logs, quando aplicável.
- Sugestões de testes automatizados.
- Critérios de aceite.
- Observações finais.

## Diferença para code review

O checklist de testes não substitui o code review.

Use checklist quando você precisa de um roteiro de validação.

Use code review quando você precisa avaliar qualidade, lógica, segurança, risco técnico e recomendação de aprovação ou mudança.

Os dois fluxos podem ser usados no mesmo MR/PR quando necessário.

## Como usar o checklist gerado

Depois que o arquivo for gerado:

- QA pode executar os cenários marcando cada item.
- Dev pode usar como validação antes de pedir aprovação.
- O time pode anexar evidências nos itens relevantes.
- Itens não aplicáveis devem ser marcados com justificativa.
- Falhas encontradas devem virar comentário no MR/PR ou retorno na tarefa.

## Boas práticas

- Inclua sempre a tarefa e o MR/PR.
- Use contexto adicional para direcionar risco conhecido.
- Peça checklist novamente se o MR/PR mudar muito depois da primeira geração.
- Não trate checklist como garantia de ausência de bug.
- Execute regressões próximas, não apenas o happy path.

## Problemas comuns

### Falta link da tarefa

O Maestro deve bloquear o fluxo e pedir o link da tarefa ou issue.

### Falta acesso ao MR/PR

Configure o MCP, token ou acesso autenticado do provedor correspondente e tente novamente.

### O checklist ficou genérico

Inclua contexto adicional mais específico, como módulo, ambiente, regra de negócio ou área de risco.

### O MR/PR mudou depois do checklist

Gere um novo checklist se o diff mudou de forma relevante.

### Preciso publicar no MR/PR

Este fluxo gera arquivo local em `.memory/docs/checklists/`. Se quiser publicar partes no MR/PR, peça explicitamente depois de revisar o conteúdo.
