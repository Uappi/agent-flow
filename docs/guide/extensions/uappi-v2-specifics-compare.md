# Guia: comparar específicos (Uappi v2)

Compara os overrides do cliente em `especifico/` com o core Wapstore no GitLab na tag informada no prompt. Gera relatórios em disco (por arquivo e/ou por tarefa) sem colar o conteúdo completo no chat.

- Índice: [README.md](README.md)
- Extensão: `ext/uappi-v2/README.md` · Roteamento: `ext/uappi-v2/ROUTING.md`
- Criar outra extensão: [create-extension.md](create-extension.md)

## Quando usar

- Repositório **cliente** com `especifico/` e `.wapstore/build`.
- Antes de subir a versão do core no cliente ou depois de definir a tag alvo.
- Revisão de customizações vs core compartilhado (`agenciawebart/wapstore/wapstore`).

**Não use** no repositório **core** (`wapstore/wapstore` sem pasta de cliente) — o Maestro bloqueia: não há `especifico/` para comparar.

## Pré-requisitos

1. AgentFlow em `.agents/` no projeto (ou workspace apontando para o repo cliente).
2. Boot: `Por favor, siga as instruções de .agents/AGENTS.md` — o perfil deve listar `uappi-v2` com `repoKind: client`.
3. **Versão alvo do core (tag)** e **Relatório** no prompt (obrigatórios).
4. Leitura do core na tag: MCP GitLab ([gitlab.md](../mcp/gitlab.md)), checkout local **já existente** do `wapstore/wapstore`, `glab` ou API — acesso e **existência da tag** validados em `skills/pre-dispatch-check.md` (passos 3–4) antes do dispatch.

## Primeira linha aceita

```text
Comparar específicos:
```

## Prompt de exemplo

Copie `ext/uappi-v2/prompts/task/specifics-compare.md` e preencha:

```text
Comparar específicos:

Versão alvo do core (tag): v2.8.13.0
Relatório: ambos

Contexto opcional:
- Branch do cliente: master
- Escopo (subpasta de especifico/):
- Caminho do repo cliente (se o cwd não for o cliente):
```

### Campos obrigatórios

| Campo | Valores |
| :--- | :--- |
| **Versão alvo do core (tag)** | Tag Git do core (ex.: `v2.8.13.0`) — não use só `.wapstore/build` como tag de comparação |
| **Relatório** | `por arquivo` · `por tarefa` · `ambos` |

### Contexto opcional

- **Branch do cliente** — registrada no cabeçalho do relatório; checkout se o cwd for o repo cliente.
- **Repo core GitLab** — padrão `agenciawebart/wapstore/wapstore`.
- **Escopo** — subpasta dentro de `especifico/`.
- **Caminho do repo cliente** — quando o agente não estiver na raiz do cliente.

## O que acontece no fluxo

1. Maestro valida links/campos (`pre-dispatch-check`), acesso ao GitLab e existência da tag alvo (sem `git clone`).
2. Dispatch da persona `ext/uappi-v2/personas/specifics-sync.md`.
3. Comparação arquivo a arquivo; classificação (customização própria, correção do core, etc.).
4. Relatório(s) gravados em `.memory/docs/specifics-sync/YYYY-MM-DD/`.
5. Handoff com caminhos dos arquivos e pergunta se deseja **aplicar** alterações.

O relatório completo **não** é colado no chat — apenas resumo e paths.

## Saída

Pasta: `.memory/docs/specifics-sync/<YYYY-MM-DD>/`

| Arquivo | Quando gerar |
| :--- | :--- |
| `01-analise-por-arquivo.md` | `Relatório: por arquivo` ou `ambos` |
| `02-analise-por-tarefa.md` | `Relatório: por tarefa` ou `ambos` |

Templates: `ext/uappi-v2/templates/specifics/compare-by-file.md` e `compare-by-task.md`.

Classificações no relatório por arquivo:

- **Sem alteração** · **Para modificar** · **Para remover**

Marcadores preservados: comentários `ESPECÍFICO`, `ESPECÍFICO TEMPORÁRIO`, blocos permanentes/temporários.

## Aplicar alterações (fase opcional)

1. Abra o relatório no disco e revise as sugestões.
2. Responda no chat: aplicar **sim**, **não** ou **arquivo por arquivo**.
3. O Maestro despacha o **Coder** com `ext/uappi-v2/skills/specifics-apply-patches.md`.
4. Review loop padrão; **commit** só com sua autorização explícita.

## Limitações

- Não compara `bin/` como fonte primária (artefato compilado).
- `lista-presente/` pode ser tratado como legado (informado no relatório se ignorado).
- `tema/` fora do escopo salvo inclusão explícita no brief.

## Referência técnica

| Recurso | Caminho |
| :--- | :--- |
| Regras | `ext/uappi-v2/rules/specifics/` |
| Skill de comparação | `ext/uappi-v2/skills/specifics-compare-core.md` |
| Skill de apply | `ext/uappi-v2/skills/specifics-apply-patches.md` |
