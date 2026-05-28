---
shortDescription: How client projects diverge from core — especifico, tema, bin.
scope: specifics-sync
product: uappi-v2
version: 0.1.0
lastUpdated: 2026-05-27
---

## Statement

Projetos cliente derivam do core e podem conter customizações de negócio, interface ou comportamento — tratadas como intencionais até análise em contrário.

**Diretórios**

- **`especifico/`** — customizações do cliente; alterações específicas devem ficar aqui quando possível.
- **`tema/`** — frontend (MVC ou reativo); fora do escopo v1 do comparador salvo inclusão explícita no brief.
- **`bin/`** — artefato consolidado core + específicos; não usar como fonte primária de comparação.

**Tipos de customização**

1. Sobrescrita de arquivos do core.
2. Extensão sem alterar o fluxo original.
3. Modificação parcial preservando parte da estrutura.

**Atualização**

- Analisar sobrescritas com cautela; classificar antes de alterar.
- Core não substitui cliente sem avaliação.
- Customização legítima deve ser preservada.

Toda customização no cliente é intencional até prova em contrário.

## Rationale

Espelha `arquitetura/arquitetura-projetos.mdc`.
