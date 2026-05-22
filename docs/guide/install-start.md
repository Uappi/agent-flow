# Guia: instalar e iniciar o AgentFlow

Este guia mostra como instalar o AgentFlow dentro de um repositório de trabalho e iniciar o Maestro pela primeira vez.

O AgentFlow não é instalado como dependência da aplicação. Ele é clonado dentro do projeto consumidor na pasta `.agents/`, onde ficam as personas, skills, regras, prompts, templates e guias usados pela IA.

## Pré-requisitos

- Ter acesso ao repositório `agent-flow`.
- Ter `git` instalado.
- Ter um agente de IA em modo CLI ou editor com chat, como OpenCode, Claude Code, Cursor, Codex ou equivalente.
- Estar na raiz do repositório onde o AgentFlow será usado.

Opcional para OpenCode:

- `jq` e `yq`, caso queira que o boot gere ou atualize automaticamente o `opencode.json` com os agentes das personas.

Opcional para economia de tokens (recomendado):

- **RTK** — reduz tokens de **entrada** (saída de comandos no terminal); configurar na máquina. Ver [token-reduction/install-rtk.md](./token-reduction/install-rtk.md).
- **Caveman** — reduz tokens de **saída** (respostas do agente); ativado no boot do AgentFlow com `/caveman full`. Ver [token-reduction/install-caveman.md](./token-reduction/install-caveman.md).

## 1. Clonar o AgentFlow no projeto

Na raiz do repositório de trabalho, execute:

```bash
git clone https://github.com/Uappi/agent-flow.git .agents
```

Depois disso, a estrutura esperada é:

```text
seu-projeto/
├── .agents/
│   ├── AGENTS.md
│   ├── personas/
│   ├── skills/
│   ├── rules/
│   ├── prompts/
│   ├── templates/
│   └── docs/
└── ...arquivos do projeto
```

A pasta `.agents/` pertence ao ambiente local de orquestração. Ela não deve ser versionada junto com o projeto consumidor.

## 2. Iniciar o agente de IA

Abra o projeto no seu agente de IA preferido.

Exemplos:

```bash
opencode
```

```bash
claude
```

Ou abra o repositório no Cursor e use o chat do editor.

## 3. Pedir para seguir o AgentFlow

No chat do agente, envie exatamente:

```text
Por favor, siga as instruções de .agents/AGENTS.md
```

Esse comando faz o agente ler o ponto de entrada do AgentFlow e iniciar o Maestro.

## 4. O que acontece no primeiro boot

Durante o boot, o Maestro executa a sequência inicial definida em `.agents/skills/boot.md`.

Ele deve:

- Garantir que `.agents/`, `.memory/`, `opencode.json` e `.ignore` estejam no `.gitignore` do projeto consumidor.
- Atualizar o AgentFlow com `git -C .agents pull`.
- Carregar memória de sessões anteriores quando existir.
- Tentar configurar o CLI quando o ambiente suportar, especialmente OpenCode.
- Carregar o índice de regras.
- Verificar se já existem arquivos `.context.md` no projeto.
- Ativar caveman no boot com `/caveman full` quando o skill estiver disponível (ver [token-reduction/install-caveman.md](./token-reduction/install-caveman.md)).
- Exibir a saudação do Maestro com os fluxos disponíveis.

O boot foi concluído quando a resposta começa com:

```text
Olá! Sou o **Maestro** do AgentFlow.
```

## 5. Reiniciar quando o OpenCode criar configuração

Se o boot informar que `opencode.json` foi criado, reinicie a sessão do OpenCode.

Isso é necessário porque o OpenCode precisa recarregar a configuração para reconhecer os agentes vinculados às personas.

Depois de reiniciar, envie novamente:

```text
Por favor, siga as instruções de .agents/AGENTS.md
```

Se o boot apenas atualizar um `opencode.json` existente, normalmente não é necessário reiniciar.

## 6. Validar a instalação

A instalação está funcional quando:

- A pasta `.agents/` existe na raiz do projeto consumidor.
- O agente consegue ler `.agents/AGENTS.md`.
- O Maestro responde com a saudação inicial.
- A saudação lista fluxos como `Mapear contexto`, `Planejar implementação`, `Implementar`, `Revisar merge/MR`, `Documentação Técnica`, `Documentação de Produto` e `RCA`.
- `.agents/`, `.memory/`, `opencode.json` e `.ignore` aparecem no `.gitignore` do projeto consumidor.

## 7. Próximo passo recomendado

Em um projeto novo para o AgentFlow, gere o mapa de contexto antes de pedir implementação, revisão ou documentação.

Use o prompt:

```text
.agents/prompts/general/context-mapping.md
```

O mapeamento cria arquivos `.context.md` e pode gerar `docs/FEATURE-MAP.md`, dando ao AgentFlow contexto estável sobre arquitetura, módulos e fluxos do projeto.

## Troubleshooting

### O agente não encontra `.agents/AGENTS.md`

Confirme se você iniciou o chat na raiz do projeto consumidor e se a pasta `.agents/` existe nesse diretório.

### O clone falhou

Verifique acesso ao GitHub, credenciais e permissão para ler o repositório `Uappi/agent-flow`.

### O Maestro não respondeu com a saudação

Peça novamente para seguir `.agents/AGENTS.md`. Se ainda falhar, verifique se o agente tem permissão para ler arquivos do workspace.

### O boot avisou que não há mapa de contexto

Isso é esperado em projetos que ainda não foram mapeados. Execute o fluxo de mapeamento de contexto antes de tarefas complexas.

### `jq` ou `yq` não estão instalados

O AgentFlow continua funcionando. Apenas a configuração automática do OpenCode pode ser ignorada.

### `git -C .agents pull` falhou

Verifique conexão, branch local, alterações não commitadas dentro de `.agents/` ou permissões do repositório remoto.
