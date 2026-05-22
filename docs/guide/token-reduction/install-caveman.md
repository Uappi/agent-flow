# Instalar Caveman

O [Caveman](https://github.com/JuliusBrussee/caveman) reduz tokens de **saída**: faz o agente responder de forma ultra-compacta, mantendo precisão técnica (~65–75% menos tokens na resposta).

**No AgentFlow:** após instalar o skill, o **boot da sessão** (passo 7 em `.agents/skills/boot.md`) ativa automaticamente **`/caveman full`**. Não é preciso digitar `/caveman` a cada sessão — só garantir que o skill esteja instalado e detectável.

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

Ordem de detecção no boot (host-agnóstico):

1. Lista de skills do runtime (`caveman` disponível).
2. Cópia no projeto: `.agents/skills/caveman/SKILL.md` ou `.agents/skills/caveman.md`.
3. Instalação do usuário — primeiro arquivo existente:

   ```bash
   for f in \
     "${HOME}/.cursor/skills/caveman/SKILL.md" \
     "${HOME}/.claude/skills/caveman/SKILL.md" \
     "${HOME}/.codex/skills/caveman/SKILL.md" \
     "${HOME}/.config/caveman/SKILL.md"; do
     [ -f "$f" ] && echo "$f" && break
   done
   ```

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

3. Boot passo 7: aplica **`/caveman full`** (sempre `full`, não `ultra`).
4. A saudação pode incluir:

   > Modo **caveman** (`full`) ativo nas próximas respostas. Diga **normal mode** ou **stop caveman** para desligar.

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
- Boot mostra `Modo caveman (full) ativo...` quando encontrado.
- Respostas do Maestro após a saudação: curtas e diretas.
- Saudação ainda começa com `Olá! Sou o **Maestro** do AgentFlow.`

---

## Troubleshooting

### Caveman não ativa no boot

1. Confirme o skill (probe da seção 2).
2. Reenvie `Por favor, siga as instruções de .agents/AGENTS.md`.
3. Vendorize em `.agents/skills/caveman/SKILL.md`.

### Muito seco

Diga `normal mode`. Boot usa só `full`; `ultra` é manual com `/caveman ultra`.

### Instalador pede Node

Instale Node 18+: [nodejs.org](https://nodejs.org).

---

## Referências

- [README](https://github.com/JuliusBrussee/caveman)
- [INSTALL.md](https://github.com/JuliusBrussee/caveman/blob/main/INSTALL.md)
- Boot AgentFlow: `skills/boot.md` (repo `agent-flow`) · `.agents/skills/boot.md` (projeto consumidor)
