# Instalar RTK

O [RTK](https://github.com/rtk-ai/rtk) (Rust Token Killer) reduz tokens de **entrada**: comprime a saída de comandos (`git status`, `cargo test`, `grep`, `docker ps`, etc.) em 60–90% antes do resultado entrar no contexto do LLM.

**Escopo:** configuração na **máquina** + integração por agente (`rtk init`). Não altera o estilo de fala do modelo.

Documentação oficial: [github.com/rtk-ai/rtk](https://github.com/rtk-ai/rtk) · [INSTALL.md](https://github.com/rtk-ai/rtk/blob/develop/INSTALL.md)

Complemento de saída: [install-caveman.md](./install-caveman.md) · Índice: [README.md](./README.md)

---

## Pré-requisitos

- Linux, macOS, WSL ou Windows com terminal.
- Nenhuma dependência em runtime (binário Rust único).
- Agente de IA com suporte a hooks Bash ou regras (Cursor, Claude Code, OpenCode, etc.).

---

## 1. Instalar o binário na máquina

**Homebrew (macOS/Linux):**

```bash
brew install rtk
```

**Script rápido (Linux/macOS):**

```bash
curl -fsSL https://raw.githubusercontent.com/rtk-ai/rtk/refs/heads/master/install.sh | sh
```

Instala em `~/.local/bin`. Se `rtk` não for encontrado:

```bash
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

**Cargo:**

```bash
cargo install --git https://github.com/rtk-ai/rtk
```

> **Colisão de nome:** existe outro pacote `rtk` no crates.io. Se `rtk gain` falhar, reinstale com `cargo install --git` como acima.

**Verificar:**

```bash
rtk --version
rtk gain
```

---

## 2. Integrar com seu agente de IA

Sem `rtk init`, o binário existe mas os comandos **não** são reescritos automaticamente.

Após `rtk init`, **reinicie** o agente (Cursor, Claude Code, OpenCode, etc.).

| Agente | Comando |
|--------|---------|
| Claude Code / Copilot (padrão) | `rtk init -g` |
| Cursor | `rtk init -g --agent cursor` |
| Codex | `rtk init -g --codex` |
| Gemini CLI | `rtk init -g --gemini` |
| OpenCode | `rtk init -g --opencode` |
| Windsurf | `rtk init --agent windsurf` |
| Cline / Roo Code | `rtk init --agent cline` |

Conferir:

```bash
rtk init --show
```

No dia a dia, `git status` no Bash do agente tende a virar `rtk git status` de forma transparente.

**Limitação:** o hook cobre chamadas **Bash**. Ferramentas nativas (`Read`, `Grep`, `Glob` no Claude Code) não passam pelo hook — use shell ou `rtk read`, `rtk grep`, `rtk find`.

**Windows:** hook completo em WSL; no Windows nativo use `rtk` explicitamente (`rtk git status`). Ver [Windows no README do RTK](https://github.com/rtk-ai/rtk#windows).

---

## 3. Configuração opcional

Arquivo global: `~/.config/rtk/config.toml` (macOS: `~/Library/Application Support/rtk/config.toml`).

Exemplos: excluir comandos do rewrite, modo `tee` para salvar saída bruta em falhas. Referência: [rtk-ai.app/guide](https://rtk-ai.app/guide).

---

## 4. Validar

```bash
rtk --version
rtk init --show
rtk gain
```

No agente, execute `git status` via Bash e observe saída compacta.

---

## 5. Desinstalar

```bash
rtk init -g --uninstall
brew uninstall rtk   # se instalou via Homebrew
```

---

## Troubleshooting

### `rtk: command not found`

Adicione `~/.local/bin` ao `PATH` ou reinstale via Homebrew/Cargo.

### `rtk gain` falha

Pacote errado no crates.io — use `cargo install --git https://github.com/rtk-ai/rtk`.

### Comandos não mudam no agente

Rode `rtk init -g --agent cursor` (ou seu agente), **reinicie** o IDE/CLI, confira com `rtk init --show`.

---

## Referências

- [README](https://github.com/rtk-ai/rtk)
- [INSTALL.md](https://github.com/rtk-ai/rtk/blob/develop/INSTALL.md)
- [Agentes suportados](https://github.com/rtk-ai/rtk#supported-ai-tools)
