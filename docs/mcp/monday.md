# Configuração do MCP do Monday no Cursor

Este guia mostra como instalar e autenticar o MCP do Monday no Cursor usando o plugin oficial e OAuth, sem editar JSON.

## Pré-requisitos

- Ter conta ativa no Monday.
- Ter o Cursor instalado e funcionando.
- Estar logado no Cursor.

## 1. Instalar o plugin do Monday no Cursor

1. Abra `Settings` no Cursor.
2. Acesse `Marketplace`.
3. Pesquise por `monday`.
4. Selecione o plugin **Monday.com**.
5. Clique em **Install** ou valide se já está como **Installed**.

## 2. Definir visibilidade do plugin

Na tela do plugin, confirme a visibilidade:

- `Private`, recomendado para uso individual no ambiente de cada dev.

## 3. Habilitar o MCP no Cursor

1. Volte para `Settings`.
2. Acesse `Tools & MCP`.
3. Em **Plugin MCP Servers**, localize `monday`.
4. Ative o toggle do servidor MCP.

## 4. Autenticar no Monday via OAuth

1. Com o MCP `monday` ativo, inicie uma ação que use o servidor, como **Try in Chat** no plugin ou a primeira chamada de ferramenta do Monday.
2. O Cursor abrirá o fluxo de autenticação OAuth do Monday.
3. Faça login na sua conta Monday.
4. Autorize o acesso solicitado pelo plugin.

Não é necessário gerar token manual nem editar `mcp.json` para esse fluxo.

## 5. Validar se está funcionando

- Em `Settings` > `Tools & MCP`, confirme que `monday` está ativado.
- No chat do Cursor, execute uma ação simples do Monday para validar acesso.
- Se a autenticação expirar, refaça o fluxo OAuth.

## Troubleshooting

- **Plugin não aparece no Marketplace**: confira conexão e versão do Cursor.
- **MCP monday não aparece em Tools & MCP**: verifique se o plugin **Monday.com** foi instalado.
- **Falha de autenticação**: saia e entre novamente na conta Monday durante o OAuth.
- **Permissão negada**: confirme se o usuário possui acesso ao workspace e aos boards necessários no Monday.

