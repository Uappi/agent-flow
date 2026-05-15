# Guia: README.ai.md

O `README.ai.md` é o ponto de entrada que a IA lê antes de qualquer tarefa no repositório de trabalho — revisão de código, planejamento, documentação, análise de suporte. Sem ele, a IA trabalha sem contexto de produto e pode gerar saídas genéricas ou inconsistentes com as convenções do projeto.

Este arquivo fica na raiz do repositório de trabalho (não dentro de `.agents/`).

## O que pertence aqui

O `README.ai.md` responde três perguntas fundamentais que a IA não consegue inferir apenas lendo o código:

1. **O que este sistema faz** — propósito do produto, fluxos principais, o que existe para o usuário final.
2. **Como o sistema está organizado** — camadas, módulos, padrões arquiteturais, convenções de nomenclatura.
3. **O que a IA deve respeitar** — regras de negócio, restrições técnicas, termos do domínio.

## Estrutura recomendada

Não há frontmatter. É um Markdown livre, mas com seções previsíveis para que a IA encontre o que precisa sem varredura desnecessária.

```markdown
# README.ai.md — <Nome do Projeto>

## O que é este sistema

Uma ou duas frases descrevendo o produto e seu propósito principal.
Inclua aqui: quem usa, o que entrega, qual problema resolve.

## Arquitetura e organização

Descreva as camadas, módulos ou serviços principais.
Liste os diretórios mais relevantes com uma linha de propósito cada.

Exemplo:
- `app/Http/Controllers/` — entrada HTTP, validação de request
- `app/Services/` — lógica de negócio e orquestração
- `app/Repositories/` — acesso a dados, queries
- `app/Jobs/` — processamento assíncrono

## Convenções do projeto

Liste as convenções que a IA deve seguir ao gerar ou revisar código:
- Padrão de nomenclatura (snake_case, camelCase, etc.)
- Como nomear arquivos, classes, variáveis
- Padrões de retorno de API (formato, chaves, erros)
- Regras de validação ou tratamento de erro específicas do projeto

## Regras de negócio

Liste as regras que afetam decisões técnicas e que a IA pode não inferir pelo código:
- Restrições de fluxo (ex.: pedido só pode ser cancelado antes do status X)
- Comportamentos esperados que parecem estranhos mas são intencionais
- Integrações externas e como elas se comportam
- Limites e cotas do sistema

## Glossário

Termos do domínio que a IA deve reconhecer e usar consistentemente:
- `lojista` — usuário que gerencia uma loja na plataforma
- `vitrine` — página pública de produtos de uma loja
- (adicione os termos do seu domínio)
```

## O que a IA cria automaticamente

Quando o Contextualizer é despachado (manualmente ou pelo Maestro antes de uma tarefa complexa), ele percorre o repositório e gera dois artefatos que ficam versionados junto ao código:

### `.context.md` por diretório

Um arquivo dentro de cada diretório relevante do projeto. Responde: "o que existe aqui e por quê."

Formato gerado:

```markdown
<context path="app/Services" updated="YYYY-MM-DD">

Descrição em prosa do propósito do diretório.

## Summary

- NomeDoServico.php — o que este arquivo faz
- OutroServico.php — o que este arquivo faz

## Constraints

- MUST / MUST NOT — restrições não negociáveis deste diretório

## Guidance

- SHOULD / SHOULD NOT — recomendações com justificativa

</context>
```

Esses arquivos são lidos por todas as personas antes de qualquer tarefa nas proximidades daquele diretório. São atualizados automaticamente pelo Coder sempre que uma mudança estrutural altera o propósito do diretório.

### `docs/FEATURE-MAP.md`

Um único arquivo na raiz do projeto que mapeia cada funcionalidade visível ao usuário para o caminho de código que a implementa.

Formato gerado:

```markdown
# Feature Map

## [Nome da Funcionalidade]

Descrição do que a funcionalidade faz do ponto de vista do usuário.

**Flow:**

1. `app/Http/Controllers/PedidoController.php` — recebe a requisição, valida o input
2. `app/Services/PedidoService.php` — orquestra a lógica de criação
3. `app/Repositories/PedidoRepository.php` — persiste no banco
4. `app/Jobs/NotificarLojista.php` — dispara notificação assíncrona

---
```

O Feature Map é atualizado pelo Coder sempre que uma feature é adicionada, removida ou tem seu fluxo alterado. Nunca é atualizado só por refactoring ou bugfix que não muda o fluxo.

## Quando atualizar o README.ai.md

Atualize manualmente quando:

- O produto ganha um fluxo ou módulo novo relevante para a IA
- Uma convenção do projeto muda (nomenclatura, padrão de resposta, estrutura de diretórios)
- Uma regra de negócio importante é adicionada ou alterada
- O glossário precisa de novos termos

Não é necessário sincronizar com cada PR. O `README.ai.md` é uma referência estável — muda quando a arquitetura ou as regras mudam, não quando o código evolui.

## O que não colocar aqui

- Instruções de setup e deploy → pertencem ao `README.md` normal
- Detalhes de implementação que já estão no código → a IA lê o código
- Histórico de decisões técnicas → use ADRs ou commits
- Documentação de API pública → use Swagger/OpenAPI ou docs dedicados
