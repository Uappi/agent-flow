# Guia: usar o code review do AgentFlow

Este guia mostra como solicitar uma revisão de MR/PR usando o AgentFlow.

O fluxo é acionado pelo prompt `Revisar merge/MR` e executado pela persona Reviewer. Ele analisa a tarefa, o diff do MR/PR, riscos de regressão, aderência ao padrão do projeto e segurança.

## Pré-requisitos

- AgentFlow instalado e iniciado no projeto consumidor.
- Maestro já carregado a partir de `.agents/AGENTS.md`.
- Link do MR ou PR que será revisado.
- Link da tarefa ou issue que explica o contexto de negócio.
- Acesso autenticado ao provedor do MR/PR, como GitLab ou GitHub.
- Acesso autenticado ao provedor da tarefa, como Monday, GitLab, GitHub ou outro tracker usado pelo time.

Se a tarefa estiver no Monday, o fluxo também tenta arquivar o resultado no campo de arquivos `Revisões automáticas` da tarefa.

## Prompt de revisão

Use o prompt em:

```text
.agents/prompts/task/code-review.md
```

## Como preencher

### `Revisar merge/MR`

Informe o link direto do MR ou PR.

Exemplos:

```text
Revisar merge/MR: https://gitlab.com/grupo/projeto/-/merge_requests/123
```

```text
Revisar merge/MR: https://github.com/org/projeto/pull/456
```

### `Tarefa/issue`

Informe o link da tarefa, issue ou card que explica o motivo da alteração.

Esse link é obrigatório porque o Reviewer usa a tarefa como fonte de regra de negócio, objetivo e critério esperado.

Exemplo:

```text
Tarefa/issue: https://uappi.monday.com/boards/123/pulses/456
```

### Thread ou comentário específico

Use `sim` quando existe uma discussão específica que deve ser considerada na revisão.

Exemplo:

```text
Há thread/comentário específico para considerar na revisão? sim
Thread/comentário para considerar: https://gitlab.com/grupo/projeto/-/merge_requests/123#note_999
```

Use `não` quando a revisão deve considerar apenas a tarefa e o MR/PR.

Exemplo:

```text
Há thread/comentário específico para considerar na revisão? não
Thread/comentário para considerar: 
```

Uma thread informada é apenas contexto. O AgentFlow pode sugerir uma resposta, mas não publica nada automaticamente.

## Exemplo completo

```text
Revisar merge/MR: https://gitlab.com/uappi/plataforma/-/merge_requests/123
Tarefa/issue: https://uappi.monday.com/boards/111/pulses/222

Há thread/comentário específico para considerar na revisão? não
Thread/comentário para considerar:
```

## O que o AgentFlow faz

Ao receber o prompt, o Maestro executa uma checagem antes de despachar o Reviewer.

Ele valida:

- Se o link do MR/PR foi informado.
- Se o link da tarefa ou issue foi informado.
- Se existe acesso autenticado para ler cada link.
- Se há acesso ao Monday para arquivar o review quando a tarefa está no Monday.

Depois disso, o Reviewer:

- Lê a tarefa ou issue.
- Lê o diff real do MR/PR.
- Lê `README.ai.md` quando existir no projeto consumidor.
- Analisa impacto funcional, regressão, performance, rastreabilidade, requisitos não atendidos e segurança.
- Considera a thread informada, quando houver.
- Preenche o template `templates/task/code-review.md`.
- Salva o resultado em `.memory/docs/code-review/`.
- Arquiva o markdown no Monday quando a tarefa permite isso.

## Saída esperada

O review é salvo em:

```text
.memory/docs/code-review/review-merge-<MR-OR-PR-ID>-<short-topic>.md
```

O documento segue o template de code review e inclui:

- Identificação do MR/PR e da tarefa.
- Contexto do problema e objetivo.
- Arquivos alterados.
- Sumário executivo.
- Riscos por severidade.
- Perguntas para o dev.
- Thread considerada, quando aplicável.
- Sugestões de melhoria.
- Desalinhamentos com padrões do time.
- Checklist de testes para QA ou dev.
- Observações finais.

## Arquivamento no Monday

Quando a tarefa informada é do Monday, o Reviewer tenta enviar o arquivo `.md` gerado para a coluna de arquivos chamada:

```text
Revisões automáticas
```

O upload cria um arquivo timestampado para preservar histórico.

Esse arquivamento faz parte do fluxo de rastreabilidade e não significa publicar comentário no MR/PR.

Se a coluna não existir, não for acessível ou o MCP/API do Monday não permitir escrita, o AgentFlow mantém o arquivo local em `.memory/docs/code-review/` e reporta o bloqueio no handoff.

## Publicação no MR/PR

O AgentFlow não publica o review automaticamente no MR/PR.

Depois de entregar o documento para você, ele deve perguntar se você quer publicar algo e qual escopo deve ser publicado.

Opções comuns:

- Publicar o review completo como comentário no MR/PR.
- Publicar apenas seções específicas.
- Publicar apenas um resumo executivo.
- Responder a uma thread específica com o rascunho sugerido.
- Não publicar nada.

A publicação exige autorização explícita depois que você viu o conteúdo do review.

## Quando usar

Use este fluxo quando:

- Um MR/PR precisa de revisão técnica antes do merge.
- A mudança tem impacto funcional ou risco de regressão.
- Você quer checklist de pontos de atenção antes de aprovar.
- Existe uma thread específica que precisa ser avaliada com base no código.
- O time precisa arquivar a revisão junto à tarefa.

## Quando não usar

Não use este fluxo para:

- Gerar checklist de QA sem análise completa de review. Use `prompts/task/test-checklist.md`.
- Documentar entrega de implementação. Use `prompts/task/implementation.md`.
- Fazer RCA de suporte. Use `prompts/support/rca.md`.
- Revisar código local sem MR/PR, a menos que você explique o escopo manualmente ao Maestro.

## Problemas comuns

### Falta link da tarefa

O Maestro deve bloquear o fluxo e pedir o link da tarefa ou issue.

### Falta acesso ao MR/PR

Configure o MCP, token ou acesso autenticado do provedor correspondente e tente novamente.

### O Monday não recebeu o arquivo

Verifique se a tarefa é do Monday, se o item pode ser acessado e se existe uma coluna de arquivo chamada `Revisões automáticas`.

### O review não deve ser publicado inteiro

Diga exatamente o que publicar, por exemplo: "publique apenas o sumário executivo e os riscos altos".

### A thread era só contexto

Isso é o comportamento esperado. O AgentFlow só responde à thread se você autorizar explicitamente depois de revisar o rascunho.
