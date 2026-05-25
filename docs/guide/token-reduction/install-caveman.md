# Instalar Caveman

O [Caveman](https://github.com/JuliusBrussee/caveman) reduz tokens de **saída**: faz o agente responder de forma ultra-compacta, mantendo precisão técnica (~65–75% menos tokens na resposta).

**No AgentFlow:** após instalar o skill, o **boot da sessão** (passo 7 em `.agents/skills/boot.md`) ativa automaticamente **`/caveman ultra`**. Não é preciso digitar `/caveman` a cada sessão — só garantir que o skill esteja instalado e detectável.

A saudação do Maestro (passo 8 do boot) continua em português normal; o caveman vale para as respostas seguintes.

Documentação oficial: [github.com/JuliusBrussee/caveman](https://github.com/JuliusBrussee/caveman) · [INSTALL.md](https://github.com/JuliusBrussee/caveman/blob/main/INSTALL.md)

Complemento de entrada: [install-rtk.md](./install-rtk.md) · Índice: [README.md](./README.md) · AgentFlow: [install-start.md](../install-start.md)

---

## Pré-requisitos

- **Node.js ≥ 18** (instalador usa `npx`).
- Linux, macOS, WSL ou Windows com terminal.
- AgentFlow em `.agents/` no projeto (para ativação automática no boot).

---

## 1. Instalar o skill na máquina

**macOS / Linux / WSL / Git Bash:**

```bash
curl -fsSL https://raw.githubusercontent.com/JuliusBrussee/caveman/main/install.sh | bash
```

**Windows (PowerShell 5.1+):**

```powershell
irm https://raw.githubusercontent.com/JuliusBrussee/caveman/main/install.ps1 | iex
```

O instalador detecta agentes presentes e copia o skill. Pode reexecutar com segurança.

Matriz completa de agentes: [INSTALL.md do caveman](https://github.com/JuliusBrussee/caveman/blob/main/INSTALL.md).

---

## 2. Onde o AgentFlow procura o skill

O boot usa o **runtime atual**, não “qualquer caveman na máquina”. Exemplo: caveman em `~/.cursor/skills/` **não** ativa no OpenCode se lá não estiver instalado — a saudação **não** deve anunciar modo caveman.

Ordem no boot (`skills/boot.md`, passo 7):

1. Identificar o host (`opencode`, `cursor`, `claude`, `codex`, …) — mesmo critério de `skills/dispatch.md`.
2. Lista de skills do **host atual** — `caveman` precisa aparecer na lista exposta pelo runtime.
3. Script `maestro-boot-caveman-resolve.sh` — só caminhos do host atual:
   - Projeto (qualquer host): `.agents/skills/caveman/SKILL.md`
   - Cursor: `~/.cursor/skills/caveman/SKILL.md`
   - Claude: `~/.claude/skills/caveman/SKILL.md`
   - Codex: `~/.codex/skills/caveman/SKILL.md`
   - OpenCode: `~/.config/opencode/skills/caveman/SKILL.md`, `.opencode/skills/caveman/SKILL.md`

Ativa se (2) **ou** (3) confirmar. Caso contrário: boot ignora caveman e **não** inclui a linha “Modo caveman ativo” na saudação.

**Vendorizar no projeto** (recomendado para times com vários IDEs):

```bash
mkdir -p .agents/skills/caveman
curl -fsSL https://raw.githubusercontent.com/JuliusBrussee/caveman/main/SKILL.md \
  -o .agents/skills/caveman/SKILL.md
```

Confira a URL no repositório oficial se o upstream mover o arquivo.

---

## 3. Ativação no boot do AgentFlow

1. Instale o caveman (seção 1) **ou** vendorize em `.agents/skills/caveman/`.
2. Inicie o Maestro:

   ```text
   Por favor, siga as instruções de .agents/AGENTS.md
   ```

3. Boot passo 7: aplica **`/caveman ultra`**.
4. A saudação pode incluir:

   > Modo **caveman** (`ultra`) ativo nas próximas respostas. Diga **normal mode** ou **stop caveman** para desligar.

Código, commits, PRs e prompts para sub-agentes **não** usam caveman.

**Desligar na sessão:** `normal mode` ou `stop caveman`.

---

## 4. Uso manual (fora do AgentFlow)

```text
/caveman
/caveman lite
/caveman ultra
```

Outros comandos: `/caveman-commit`, `/caveman-review`, `/caveman-compress`.

---

## 5. Validar

- Skill em um dos caminhos da seção 2.
- Boot mostra `Modo caveman (ultra) ativo...` quando encontrado.
- Respostas do Maestro após a saudação: curtas e diretas.
- Saudação ainda começa com `Olá! Sou o **Maestro** do AgentFlow.`

---

## Troubleshooting

### Caveman não ativa no boot

1. Confirme instalação **no host que você está usando** (OpenCode ≠ Cursor).
2. Rode `bash .agents/skills/assets/maestro-boot-caveman-resolve.sh` — deve imprimir `caveman: active`, não `skip`.
3. Vendorize em `.agents/skills/caveman/SKILL.md` para funcionar em qualquer host.
4. Reenvie `Por favor, siga as instruções de .agents/AGENTS.md`.

### Saudação anuncia caveman mas respostas não estão compactas

Caveman estava só em outro IDE (ex.: Cursor) e o boot antigo lia o path errado. Atualize `.agents/` e confira `caveman: skip` no host atual.

### Muito seco

Diga `normal mode`. Para outro nível na sessão: `/caveman full`, `/caveman lite`, etc.

### Instalador pede Node

Instale Node 18+: [nodejs.org](https://nodejs.org).

---

## Referências

- [README](https://github.com/JuliusBrussee/caveman)
- [INSTALL.md](https://github.com/JuliusBrussee/caveman/blob/main/INSTALL.md)
- Boot AgentFlow: `skills/boot.md` (repo `agent-flow`) · `.agents/skills/boot.md` (projeto consumidor)
