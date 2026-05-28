---
shortDescription: Safe update rules when merging core into especifico/.
scope: specifics-sync
product: uappi-v2
version: 0.2.0
lastUpdated: 2026-05-27
---

## Statement

Atualizar o cliente preservando customizações legítimas e comportamento existente.

Antes de sugerir alteração, verificar: marcadores ESPECÍFICO; `especifico/`; `tema/` (se no escopo).

Durante atualização: ignorar `bin/` como fonte primária; tratar `lista-presente/` como legado e informar quando ignorado.

Estratégia: (1) identificar diferenças (2) classificar (3) avaliar impacto (4) sugerir merge incremental.

Nunca: sobrescrever direto; remover customização sem análise; alterar comportamento sem avaliação.

Compare mode é somente leitura — aplicar patches só após confirmação explícita (`specifics-apply-patches.md`).

## Rationale

Espelha `prompts/atualizar.mdc` do comparador legado.
