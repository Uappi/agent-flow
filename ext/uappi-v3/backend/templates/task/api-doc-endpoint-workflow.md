---
product: uappi-v3/backend
scope: api-doc
version: 0.2.0
lastUpdated: 2026-06-02
---

# Workflow: Documentar Endpoint HTTP

Use este checklist junto aos modelos de documentação do projeto. Eles são a fonte de verdade para a estrutura da página (frontmatter, seções, blocos).

## 0. Modo lote (várias páginas no mesmo pedido)

Use esta seção quando o pedido trouxer duas ou mais páginas para documentar.

### 0.1 Inventário antes de escrever

Monte uma tabela de trabalho com uma linha por página para organizar o escopo:

| Identificador (ex. route_key) | Método HTTP / Papel | Modelo Sugerido | Já existe arquivo? | Registro de Menu/Navegação |
|--------------------------------|----------------------|-----------------|---------------------|----------------------------|
| …                              | …                    | …               | …                   | …                          |

- **Inferir o modelo** pelo verbo da rota e pelo padrão da família de referência; em dúvida, abrir a rota no código antes de redigir.
- Marcar itens **bloqueados** (falta rota, conflito de escopo) para não segurar o lote inteiro: documente o que for possível e liste lacunas.

### 0.2 Uma vez por lote (consistência)

- Escolher uma **família de referência** no projeto e comparar títulos, densidade da descrição, tabelas de erro e estilo de exemplos de requisição.
- Alinhar variáveis globais (URLs base, tokens padrão, headers) entre todas as páginas do mesmo lote.

### 0.3 Ordem de execução sugerida

1. Páginas de **visão geral/módulo** (`method: DOC` ou similar) para fixar a linguagem de domínio.
2. Endpoints na **ordem lógica de exibição** (geralmente a ordem em que aparecem no código ou menu).

### 0.4 Registro e Menu (consolidar)

- Identificar todos os arquivos de configuração de menu/navegação que precisam de novas chaves ou reordenação.
- Editar cada arquivo de configuração **uma vez**: insira todos os identificadores novos na ordem final.
- Evitar múltiplas passadas no mesmo arquivo que gerem conflitos.

### 0.5 Entrega do lote

- Listar todos os arquivos criados ou alterados + arquivos de configuração tocados.
- **Sumário por item:** Relate o status (`Pronto` ou `Lacunas: …`).
- Execute comandos de indexação ou limpeza de cache de documentação se o projeto exigir.

---

## 1. Escolher o modelo Markdown

Consulte a pasta de modelos de documentação do projeto para selecionar o correto:

| Cenário | Descrição do Modelo |
|---------|----------------------|
| GET / Busca | Recuperação de dados ou detalhes por ID. |
| Listagem | Filtros, ordenação e listas paginadas. |
| Mutação | POST/PUT/PATCH/DELETE (Cadastro, atualização, remoção). |
| Visão Geral | Contexto do módulo ou grupo de rotas. |

## 2. Onde gravar o conteúdo

Consulte o `README.ai.md` ou guia de documentação do projeto para saber o caminho exato onde os arquivos devem ser salvos.

## 3. Registrar na navegação

Siga as regras de registro do projeto para garantir que as novas páginas apareçam nos menus ou índices de documentação.

## 4. Evidência (ordem sugerida)

1. Definições de rota (define o contrato HTTP).
2. Controladores e classes de validação (FormRequests, etc.).
3. Delegação para serviços ou processos de domínio.
4. Contratos de resposta (DMCs, DTOs, parsers).
5. Erros explícitos (mapas de erro, exceções de domínio).

Não descrever comportamento como certeza sem evidência no repositório.

## 5. Conteúdo mínimo por página de endpoint

- **Descrição:** operacional, escaneável; evitar redundância com tabelas de parâmetros.
- **Parâmetros:** apenas o que a rota usa; remover seções não aplicáveis.
- **Exemplo de requisição:** fiel ao contrato real (headers, corpo, URL).
- **Resposta de sucesso:** JSON ou formato fiel ao retorno real.
- **Erros:** tabela ou lista com códigos e mensagens relevantes baseados no código.

## 6. Antes de considerar pronto

- [ ] Frontmatter e blocos de código coerentes com a implementação real.
- [ ] Nenhuma afirmação factual sem evidência no repositório.
- [ ] Registro em menus/navegação atualizado.
- [ ] Todos os tópicos do modelo utilizado presentes conforme a necessidade.
- [ ] Comentários de instrução dos modelos removidos do arquivo final.
- [ ] Lacunas listadas explicitamente (não omitir com texto vago).
- [ ] Indexação/Cache de documentação atualizado se necessário.
- [ ] Todas as novas docs mapeadas no menu-map.