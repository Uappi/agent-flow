---
shortDescription: Paths excluded from specifics comparison scans.
scope: specifics-sync
product: uappi-v2
version: 0.2.0
lastUpdated: 2026-05-27
---

## Statement

**Diretórios**

- **`lista-presente/`** — legado; pode ignorar na comparação e na proposta de atualização; informar explicitamente quando ignorado.
- **`bin/`** — não usar como fonte primária.

**Arquivos**

- **`.gitkeep`** — placeholder; não analisar.
- **`.context.md`** — metadados AgentFlow; não analisar.

Comparar apenas `especifico/` (ou subpasta do escopo no brief). Não pular arquivos só por falta de marcador ESPECÍFICO.

## Rationale

Espelha `regras/diretorios-e-arquivos-ignoraveis.mdc`.
