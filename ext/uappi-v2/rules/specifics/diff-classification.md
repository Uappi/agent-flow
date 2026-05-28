---
shortDescription: Classify core vs client differences before suggesting updates.
scope: specifics-sync
product: uappi-v2
version: 0.2.0
lastUpdated: 2026-05-27
---

## Statement

Toda diferença deve ser classificada (seguir `customization-markers.md`) antes de sugerir alteração.

### Categorias de diferença

1. **Customização própria** — só no cliente (`especifico/`); não existe no core; preservar; não sobrescrever; reportar se regra do core mudou na área adjacente.
2. **Correção do core** — cliente corrigiu fluxo do core; preservar salvo incompatibilidade; remover só se o core já corrigiu o mesmo cenário.
3. **Implementação customizada** — mesmo arquivo no core e cliente, conteúdo divergente; merge incremental; nunca substituição direta sem análise.
4. **Código legado** — ex.: `lista-presente/`; pode ignorar na análise principal mas informar explicitamente.
5. **Artefato gerado** — `bin/`; não é fonte primária de comparação.

Prioridade em ambiguidade: (1) → (2) → (3) → (4) → (5).

### Classificação no relatório (por arquivo)

No template `compare-by-file.md`, usar **uma** opção em **Classificação**:

| Situação | Classificação no relatório |
|----------|---------------------------|
| Igual ao core na tag | **Para remover** (override desnecessário) |
| Diferente; precisa merge/atualização | **Para modificar** |
| Analisado; nenhuma ação agora | **Sem alteração** |

Antes de sugerir alteração: identificar → classificar (categoria + ação) → avaliar impacto → explicar efeito no fluxo do core → sugerir atualização segura.

Nunca: sobrescrever diretamente; remover customização sem análise; assumir que divergência é erro.

## Rationale

Espelha `regras/classificacao-de-diferencas.mdc` e `prompts/comparar.mdc` do comparador legado.
