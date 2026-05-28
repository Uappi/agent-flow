---
shortDescription: Hierarchy and conventions for core vs client specifics sync.
scope: specifics-sync
product: uappi-v2
version: 0.1.0
lastUpdated: 2026-05-27
---

## Statement

**Convenções**

- `específico` / `especifico/` — customização do cliente.
- `bin/` — compilação core + específicos no cliente; não é fonte primária de comparação.
- `painel` / `Uappi` — área administrativa.
- `plataforma` — projeto como um todo.

**Hierarquia de decisão**

1. Core no GitLab na tag `target_release`
2. Regras `ext/uappi-v2/rules/specifics/*`
3. Arquitetura documentada (`architecture.md`, `architecture-projects.md`)
4. Projeto cliente (`especifico/`)
5. Comentários locais ou implementações ad hoc

**Conflitos core vs cliente**

- Core é referência principal.
- Cliente deve ser analisado para customização legítima.
- Nenhuma diferença sobrescrita sem classificação prévia.
- Em dúvida: atualização incremental, não substituição total.

Não assumir: toda diferença no cliente é erro; toda divergência deve ser removida; arquivo extra no cliente é obsoleto.

## Rationale

Espelha `contexto/fontes-de-verdade.mdc`, adaptado para core no GitLab em vez de diretório `CORE/` local.
