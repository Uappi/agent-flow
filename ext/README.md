# Extensões de produto (`ext/`)

Camadas opcionais para fluxos específicos de produto. O **núcleo** do AgentFlow (`personas/`, `skills/`, `rules/` na raiz de `.agents/`) permanece genérico.

## Estrutura

```text
ext/<product-id>/
├── README.md
├── ROUTING.md          # Maestro lê quando o produto está ativo
├── personas/
├── skills/
├── rules/
├── prompts/
└── templates/
```

## Ativação

No boot, `skills/product-profile.md` detecta sinais no **repositório de trabalho** (não em `.agents/`) e grava `activeProducts` na sessão.

No greeting do boot (`skills/boot.md`), cada id em `activeProducts` ganha uma categoria na saudação: título do `README.md` da extensão e um bullet por arquivo em `prompts/` (rótulo = primeira linha do prompt).

Maestro e `skills/dispatch.md` carregam assets de `ext/<product-id>/` **somente** quando esse id está em `activeProducts` ou no brief da tarefa.

## Frontmatter nos arquivos da extensão

```yaml
product: uappi-v2
scope: specifics-sync   # filtro de regras/skills no dispatch
```

## Extensões disponíveis

| Produto | Pasta | Sinais (resumo) |
|---------|-------|-----------------|
| Uappi v2 | `ext/uappi-v2/` | Cliente: `especifico/` + `.wapstore/build` — Core: remote `wapstore/wapstore` ou `core/wapstore/` |
| Uappi v3 — backend | `ext/uappi-v3/backend/` | Core (qualquer sinal, todos backend): A — `grep -q "Uappi V3 Backend" README.ai.md` · B — dir `*.uappi` presente · C — dir `apis/api.uappi.com.br` presente. |
| Uappi v3 — frontend | `ext/uappi-v3/frontend/` | Core: `grep -q "uappi3/frontend" README.ai.md` (título `README.ai.md — uappi3/frontend`). |

## Guias

- Índice: [docs/guide/extensions/README.md](../docs/guide/extensions/README.md)
- Criar extensão: [create-extension.md](../docs/guide/extensions/create-extension.md)
- Comparar específicos (Uappi v2): [uappi-v2-specifics-compare.md](../docs/guide/extensions/uappi-v2-specifics-compare.md)
- Documentar API (Uappi v3): [uappi-v3-api-doc.md](../docs/guide/extensions/uappi-v3-api-doc.md)
