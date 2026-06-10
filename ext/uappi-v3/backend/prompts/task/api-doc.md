Documentação de API em lote (endpoints + opcional DOC)

Ticket / objetivo: <DESCREVA O OBJETIVO OU TICKET>
Família de referência de estilo (opcional): <ex.: módulo/entidade — usa exemplos existentes como espelho>

Todas as páginas deste pedido (uma linha por arquivo a produzir ou revisar):

| Identificador (ex. route_key) | Tipo | Notas |
|--------------------------------|------|-------|
| <identificador-1>              | DOC  | Contexto geral do módulo |
| <identificador-2>              | GET  | Listagem ou Detalhes |
| <identificador-3>              | POST | Cadastro ou Ação |
|                                |      |       |

Instruções: Aplicar o workflow de documentação de endpoint (`.agents/ext/uappi-v3/templates/task/api-doc-endpoint-workflow.md`, modo Lote) e, para páginas de visão geral, também o workflow de módulo (`.agents/ext/uappi-v3/templates/task/api-doc-module-workflow.md`). Consulte o Playbook da persona `api-documenter` e as diretrizes centrais no `README.ai.md`. 

Saída: Arquivos salvos nos diretórios padrão do projeto + registros atualizados em menus/navegação; sumário final com status por identificador.
