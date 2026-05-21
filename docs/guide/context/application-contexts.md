# Guia: contextos da aplicação para o AgentFlow

O AgentFlow usa três artefatos principais para entender um repositório de trabalho antes de implementar, revisar, documentar ou analisar:

- `README.ai.md` - contexto geral do sistema.
- `.context.md` - contexto local de cada diretório relevante.
- `docs/FEATURE-MAP.md` - mapa das funcionalidades visíveis ao usuário e seus caminhos de código.

Esses arquivos ficam no projeto consumidor, não dentro de `.agents/`.

## Visão geral

| Arquivo | Pergunta que responde | Escopo | Guia |
| --- | --- | --- | --- |
| `README.ai.md` | O que é este sistema e quais regras gerais a IA deve respeitar? | Projeto inteiro | `docs/guide/context/readme-ai.md` |
| `.context.md` | O que existe neste diretório e quais cuidados locais importam? | Diretório específico | `docs/guide/context/context-md.md` |
| `docs/FEATURE-MAP.md` | Onde está o fluxo de cada funcionalidade visível ao usuário? | Funcionalidades ponta a ponta | `docs/guide/context/feature-map.md` |

## Como eles trabalham juntos

O `README.ai.md` dá o contexto macro: produto, arquitetura, convenções, regras de negócio e glossário.

O `.context.md` dá o contexto micro: propósito de diretórios, arquivos importantes, restrições e recomendações locais.

O `FEATURE-MAP.md` conecta o produto ao código: mostra quais arquivos implementam cada fluxo funcional.

Quando os três existem, a IA consegue:

- Entender o domínio antes de tocar no código.
- Localizar rapidamente áreas relevantes.
- Reduzir suposições sobre arquitetura e regras de negócio.
- Planejar alterações com menos varredura repetida.
- Revisar impacto funcional com mais precisão.
- Gerar documentação técnica e de produto com melhor contexto.

## Quando usar cada um

Use `README.ai.md` para informações estáveis do projeto:

- Propósito do sistema.
- Arquitetura geral.
- Convenções de código.
- Regras de negócio transversais.
- Glossário do domínio.

Use `.context.md` para orientação local:

- Propósito de um diretório.
- Responsabilidade dos arquivos daquele diretório.
- Restrições específicas da área.
- Recomendações práticas para manutenção local.

Use `docs/FEATURE-MAP.md` para fluxo funcional:

- Funcionalidades percebidas pelo usuário.
- Caminho de entrada, processamento e saída.
- Relação entre controllers, services, jobs, repositories, views, APIs e integrações.
- Impacto funcional de mudanças em arquivos.

## Ordem recomendada em um projeto novo

1. Criar `README.ai.md` manualmente com visão de produto, arquitetura e regras gerais.
2. Rodar o fluxo `Mapear contexto` do AgentFlow para gerar `.context.md` e `docs/FEATURE-MAP.md`.
3. Revisar os arquivos gerados para remover suposições, corrigir termos e ajustar escopo.
4. Usar esses artefatos como base para implementação, review, documentação e suporte.

Prompt para mapear contexto:

```text
Mapear contexto
Escopo: <raiz, ex.: . ou core/wapstore>
Objetivo do mapeamento: <o que voce quer enxergar melhor>
Observacoes: <opcional>
```

O arquivo do prompt fica em:

```text
.agents/prompts/general/context-mapping.md
```

## Quem mantém cada arquivo

O `README.ai.md` é mantido manualmente pelo time. Ele muda quando há mudança relevante de arquitetura, regra de negócio, convenção ou glossário.

Os `.context.md` são criados ou atualizados pelo Contextualizer durante o mapeamento de contexto. O Coder também deve atualizá-los quando uma implementação muda estrutura ou responsabilidade de diretórios.

O `docs/FEATURE-MAP.md` é criado ou atualizado pelo Contextualizer durante o mapeamento de contexto. O Coder também deve atualizá-lo quando uma implementação adiciona, remove ou altera uma funcionalidade visível ao usuário.

## Critério de atualização

Atualize `README.ai.md` quando mudar algo global:

- Nova regra de negócio transversal.
- Nova convenção técnica.
- Mudança arquitetural relevante.
- Novo termo importante no glossário.

Atualize `.context.md` quando mudar algo local:

- Novo arquivo relevante no diretório.
- Responsabilidade do diretório alterada.
- Arquivo citado foi removido ou renomeado.
- Restrição local mudou.

Atualize `docs/FEATURE-MAP.md` quando mudar o fluxo funcional:

- Nova funcionalidade visível ao usuário.
- Funcionalidade removida ou renomeada.
- Novo ponto de entrada ou saída.
- Nova etapa relevante no caminho do fluxo.
- Arquivo citado em um fluxo foi movido ou renomeado.

## O que evitar

- Não transformar `README.ai.md` em documentação de setup ou deploy.
- Não transformar `.context.md` em documentação longa de módulo.
- Não adicionar ao `FEATURE-MAP.md` funcionalidades que não foram rastreadas no código.
- Não duplicar a mesma informação nos três arquivos.
- Não atualizar datas de `.context.md` sem mudança real de conteúdo.
- Não registrar suposições como fatos.

## Exemplo de uso em uma tarefa

Ao pedir uma implementação no AgentFlow, o fluxo ideal é:

1. O Maestro usa `README.ai.md` para entender produto, vocabulário e regras gerais.
2. O agente responsável lê `.context.md` nos diretórios afetados para entender responsabilidades locais.
3. Se a tarefa altera uma funcionalidade existente, o agente consulta `docs/FEATURE-MAP.md` para entender o fluxo atual.
4. Após a mudança, o agente atualiza `.context.md` ou `FEATURE-MAP.md` apenas se a estrutura ou o fluxo funcional mudou.

## Guias relacionados

- `docs/guide/context/readme-ai.md` - como criar e manter o `README.ai.md`.
- `docs/guide/context/context-md.md` - como criar e manter `.context.md` por diretório.
- `docs/guide/context/feature-map.md` - como criar e manter `docs/FEATURE-MAP.md`.
