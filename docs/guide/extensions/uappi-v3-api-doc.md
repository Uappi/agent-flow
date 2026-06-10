# Guia: documentar API (Uappi v3)

Documenta endpoints e páginas de módulo para a plataforma distribuída Uappi V3 (backend). Gera arquivos Markdown publicáveis e atualiza registros de menu/navegação.

- Índice: [README.md](README.md)
- Extensão: `ext/uappi-v3/backend/README.md` · Roteamento: `ext/uappi-v3/backend/ROUTING.md`
- Criar outra extensão: [create-extension.md](create-extension.md)

## Quando usar

- Repositório detectado como `uappi-v3/backend` (`repoKind: core`) — qualquer um dos três sinais (todos backend): README.ai.md declara `Uappi V3 Backend` (Signal A), diretório `*.uappi` presente (Signal B), ou diretório `apis/api.uappi.com.br` presente (Signal C). Esses sinais ativam exclusivamente `ext/uappi-v3/backend/` — o diretório `ext/uappi-v3/frontend/` não é ativado por eles.
- Ao documentar novos endpoints ou revisar páginas de API já existentes.
- Ao criar páginas de visão geral de módulo (`method: DOC`) para famílias de domínio.

**Não use** quando o repositório não contiver as rotas do produto (o Maestro não terá evidência para validar afirmações).

## Pré-requisitos

1. AgentFlow em `.agents/` no projeto (ou workspace apontando para o repo Uappi V3).
2. Boot: `Por favor, siga as instruções de .agents/AGENTS.md` — o perfil deve detectar `uappi-v3/backend` com `repoKind: core`.
3. **Identificadores de página** (route key ou nome de arquivo, um por linha na tabela) e **Ticket / objetivo** são obrigatórios no prompt.

## Primeira linha aceita

```text
Documentação de API em lote (endpoints + opcional DOC)
```

## Prompt de exemplo

Copie `ext/uappi-v3/backend/prompts/task/api-doc.md` e preencha:

```text
Documentação de API em lote (endpoints + opcional DOC)

Ticket / objetivo: US-1234 — Documentar módulo de Pagamento
Família de referência de estilo (opcional): brand

Todas as páginas deste pedido (uma linha por arquivo a produzir ou revisar):

| Identificador (ex. route_key) | Tipo | Notas |
|-------------------------------|------|-------|
| payment-doc                   | DOC  | Visão geral do módulo |
| payment-list                  | GET  | Listagem de pagamentos |
| payment-create                | POST | Criar pagamento |
```

### Campos obrigatórios

| Campo | Valores |
| :--- | :--- |
| **Ticket / objetivo** | Descrição ou referência do ticket (livre) |
| **Tabela de páginas** | Ao menos uma linha com Identificador + Tipo |

### Contexto opcional

- **Família de referência de estilo** — módulo ou entidade existente usada como espelho de estilo.

## O que acontece no fluxo

1. Maestro verifica que a tabela de páginas contém ao menos um identificador e que o campo Ticket / objetivo está preenchido; em caso contrário, solicita complemento antes de despachar.
2. Dispatch da persona `ext/uappi-v3/backend/personas/api-documenter.md` (modelo Codex, tier-2).
3. Leitura do `README.ai.md` do workspace para entender arquitetura e convenções.
4. Validação do fluxo de publicação (menu-map.php, arquivos de registro de API).
5. Mapeamento de evidências por página (rota → controller → request → processo → DMC).
6. Escolha do modelo Markdown por tipo de página; verificação de modelos canônicos em `markdown-models/`.
7. Redação em português (pt-BR); exemplos, tabelas e nomes de campo em camelCase.
8. Atualização de registros de menu/navegação.
9. Handoff com lista de arquivos criados ou alterados + sumário de status por identificador.

Os arquivos completos são salvos no disco — não são colados no chat; apenas o sumário é exibido.

## Saída

Arquivos Markdown nas pastas de documentação do projeto + registros de menu atualizados.

| Item | Descrição |
| :--- | :--- |
| Página DOC | Visão geral do módulo em pt-BR |
| Página de endpoint | Descrição, parâmetros, exemplo, resposta, erros |
| Sumário final | Status por identificador (`Pronto` ou `Lacunas: …`) |

## Referência técnica

| Recurso | Caminho |
| :--- | :--- |
| Regras de menu | `ext/uappi-v3/backend/rules/api-doc/menu-structure.md` |
| Regras de publicação | `ext/uappi-v3/backend/rules/api-doc/publication-flow.md` |
| Regras de formatação | `ext/uappi-v3/backend/rules/api-doc/formatting.md` |
| Regras de evidência | `ext/uappi-v3/backend/rules/api-doc/evidence-escalation.md` |
| Regras de escaneabilidade | `ext/uappi-v3/backend/rules/api-doc/scannability.md` |
| Regras de conformidade de template | `ext/uappi-v3/backend/rules/api-doc/template-compliance.md` |
| Skill principal | `ext/uappi-v3/backend/skills/api-doc.md` |
| Workflow de endpoint | `ext/uappi-v3/backend/templates/task/api-doc-endpoint-workflow.md` |
| Workflow de módulo | `ext/uappi-v3/backend/templates/task/api-doc-module-workflow.md` |
