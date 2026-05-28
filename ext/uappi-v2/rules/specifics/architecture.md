---
shortDescription: Uappi platform layout — backend, frontend, main directories.
scope: specifics-sync
product: uappi-v2
version: 0.2.0
lastUpdated: 2026-05-27
---

## Statement

Sistema multi-projeto com core compartilhado; customizações do cliente em `especifico/`.

**Stack**

- Backend: PHP 7.4, Apache, MariaDB
- Frontend: HTML/CSS, jQuery, Vue, Vue 3, Nuxt

**Diretórios relevantes (core / espelho em especifico)**

| Diretório | Papel |
|-----------|--------|
| checkout | Fluxo final de compra SaaS |
| classes | Regras de negócio compartilhadas |
| crons | Serviços periódicos (`crons.cron`) |
| dbm | Migrações SQL |
| estrutura | Rotas e redirecionamentos |
| lista-presente | Legado — ver `ignored-paths.md` |
| minha-conta | Área do cliente final |
| pagamento | Meios de pagamento |
| tema | Camada visual — fora do escopo v1 salvo brief |
| wapstore | Painel administrativo e classes compartilhadas |

Core no GitLab na tag de comparação é fonte de verdade funcional para o diff. `bin/` no cliente é artefato compilado — somente leitura neste fluxo.

O core não deve conter lógica específica de um cliente.

## Rationale

Espelha `arquitetura/arquitetura-geral.mdc`. Detalhes de projeto cliente: `architecture-projects.md`.
