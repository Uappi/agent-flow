# Comparar específicos (specifics sync)

Sincroniza overrides do cliente (`especifico/`) com o core Wapstore na **versão alvo** que você informar no prompt.

## Quando usar

- Repo **cliente** com `especifico/` e `.wapstore/build`
- Antes de atualizar o core no cliente ou após bump de release
- **Não** use no repo **core** (`wapstore/wapstore`) — não há `especifico/`; o Maestro bloqueia o dispatch

## Pré-requisitos

- AgentFlow em `.agents/`
- Acesso de leitura ao core no GitLab na tag (obrigatório): MCP [mcp/gitlab.md](mcp/gitlab.md), ou clone local do repositório `wapstore/wapstore` com a tag, ou `glab`/API com token. O Maestro verifica antes do dispatch (`skills/pre-dispatch-check.md`).
- Boot detecta `uappi-v2` com `repoKind: client`

## Prompt

Copie de `ext/uappi-v2/prompts/task/specifics-compare.md`:

```text
Comparar específicos:

Versão alvo do core: <tag>

Escopo: <opcional>
```

Sem **Versão alvo**, o Maestro não despacha.

Roteamento e gates: `ext/uappi-v2/ROUTING.md` (Maestro lê quando `uappi-v2` está ativo).

## Saída

`.memory/docs/specifics-sync/YYYY-MM-DD/01-analise-por-arquivo.md`

Classificações: ADDITION, IDENTICAL, MODIFIED (com sub-tipos e sugestão de merge).

## Aplicar alterações

1. Revise o relatório
2. Responda se deseja aplicar (sim / não / por arquivo)
3. O Maestro despacha o **Coder** com `ext/uappi-v2/skills/specifics-apply-patches.md`
4. Review loop padrão; commit só com autorização explícita

## Mapeamento

`especifico/wapstore/classes/Foo.class.php` → `core/wapstore/classes/Foo.class.php` no GitLab @ tag.

Não compara `bin/` como fonte primária.

## Referência

Regras em `ext/uappi-v2/rules/specifics/`. Extensão: `ext/uappi-v2/README.md`.
