---
shortDescription: Eight-step workflow for comparing client especifico/ with core.
scope: specifics-sync
product: uappi-v2
version: 0.1.0
lastUpdated: 2026-05-27
---

## Statement

1. **Escopo** — Identificar repo cliente (`especifico/`), tag do core (`target_release`), modo de relatório e branch do cliente quando informada.
2. **Varredura** — Mapear arquivos em `especifico/` (ignorar `bin/`, legado conforme `ignored-paths.md`).
3. **Comparação estrutural** — Arquivos só no cliente vs. com equivalente no core (`core/` + path relativo).
4. **Comparação de conteúdo** — Diff por arquivo na tag do core.
5. **Customizações** — Aplicar `customization-markers.md` (comentários ESPECÍFICO).
6. **Classificação** — Aplicar `diff-classification.md` (cinco categorias + classificação de ação no relatório).
7. **Impacto** — Avaliar impacto funcional, dependências e risco.
8. **Proposta** — Sugerir atualização incremental; preservar customizações; não sobrescrever sem análise.

Nunca: sobrescrever customizações diretamente; remover código sem análise; assumir que divergência é erro.

Sempre: classificar; avaliar impacto; sugerir atualização segura.

## Rationale

Espelha o fluxo do comparador legado (`workflow.mdc`) para análises repetíveis entre clientes.
