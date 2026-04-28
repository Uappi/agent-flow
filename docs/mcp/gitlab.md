# Configuração do MCP do GitLab no Cursor

Este guia mostra como configurar o MCP do GitLab no Cursor para que cada dev copie o JSON base e substitua apenas o token pessoal.

## Pré-requisitos

- Ter conta no GitLab com acesso aos projetos do time.
- Ter o Cursor instalado e funcionando.
- Ter Node.js/NPM instalado, porque o MCP usa `npx`.

## 1. Criar o token no GitLab

1. Acesse o GitLab com seu usuário.
2. Vá em **User Settings** > **Personal access tokens**: `https://gitlab.com/-/user_settings/personal_access_tokens`.
3. Crie um novo token com:
   - **Nome**: `cursor-mcp-gitlab` (sugestão).
   - **Expiração**: conforme política do time.
   - **Escopos mínimos sugeridos**: `read_api`.
4. Clique em **Create personal access token**.
5. Copie o token gerado imediatamente. Ele não será mostrado novamente.

Segurança: nunca commite token em repositório, print, documentação versionada ou chat público.

## 2. Escolher forma de configuração no Cursor

Você pode configurar o MCP do GitLab de três formas:

- **Opção A, recomendada para padronização do time**: arquivo `~/.cursor/mcp.json`.
- **Opção B, interface gráfica**: `Settings` > `Tools & MCP`.
- **Opção C, não testada pelo time até o momento**: instalação do plugin pela aba `Marketplace` do Cursor.

## 3. Opção A: configurar via `mcp.json`

No Cursor, abra:

```text
~/.cursor/mcp.json
```

Se o arquivo não existir, crie-o.

Use este modelo como base e troque apenas `SEU_TOKEN_AQUI`:

```json
{
  "mcpServers": {
    "GitLab": {
      "command": "npx",
      "args": ["-y", "@zereight/mcp-gitlab"],
      "env": {
        "GITLAB_PERSONAL_ACCESS_TOKEN": "SEU_TOKEN_AQUI",
        "GITLAB_API_URL": "https://gitlab.com",
        "GITLAB_READ_ONLY_MODE": "true",
        "USE_GITLAB_WIKI": "false",
        "USE_MILESTONE": "false",
        "USE_PIPELINE": "false"
      }
    }
  }
}
```

### Variáveis

- `GITLAB_PERSONAL_ACCESS_TOKEN`: token pessoal criado no GitLab.
- `GITLAB_API_URL`: URL da API do GitLab. Para GitLab cloud, use `https://gitlab.com`; para self-hosted, use a URL da instância.
- `GITLAB_READ_ONLY_MODE`: em `true`, restringe o MCP para leitura. Recomendado por segurança.
- `USE_GITLAB_WIKI`, `USE_MILESTONE`, `USE_PIPELINE`: habilitam ou desabilitam esses recursos no MCP.

## 4. Opção B: configurar pela interface

Se o servidor GitLab já estiver instalado no Cursor:

1. Abra `Settings`.
2. Acesse `Tools & MCP`.
3. Em **Installed MCP Servers**, localize **GitLab**.
4. Abra as configurações do servidor GitLab.
5. Preencha o token com seu `GITLAB_PERSONAL_ACCESS_TOKEN`.
6. Salve as alterações.

Se o servidor ainda não existir, clique em **New MCP Server** e cole o JSON da seção anterior.

## 5. Opção C: instalar via Marketplace do Cursor

Atenção: esta opção ainda não foi testada pelo time. Use preferencialmente as opções A ou B.

1. Abra `Settings` no Cursor.
2. Acesse `Marketplace`.
3. Pesquise por `gitlab`.
4. Instale o plugin relacionado ao GitLab.
5. Vá para `Tools & MCP` e confirme se o servidor GitLab foi adicionado e ativado.
6. Inicie a autenticação pela interface do plugin/servidor.
7. Faça login na sua conta GitLab e conceda as permissões solicitadas.

Nessa opção, o fluxo esperado é autenticação pela interface, sem necessidade de criar token manual.

## 6. Reiniciar o Cursor

Após salvar o `mcp.json`, reinicie o Cursor para carregar o servidor MCP com a nova configuração.

Mesmo configurando pela interface, reiniciar o Cursor evita falhas de carregamento de credenciais.

## 7. Validar se o MCP subiu

- Abra o painel de MCPs no Cursor.
- Verifique se o servidor **GitLab** aparece como ativo.
- Se houver erro, revise token inválido ou expirado, escopo insuficiente ou erro de digitação no JSON.

## Troubleshooting

- **401/Unauthorized**: token inválido, expirado ou sem `read_api`.
- **Servidor não inicia**: Node/NPM ausente ou JSON inválido.
- **Projeto não encontrado**: usuário sem permissão no projeto GitLab.
- **Não funcionou na primeira tentativa**: em `Settings` > `Tools & MCP`, desative o toggle do **GitLab**, aguarde alguns segundos e ative novamente.

