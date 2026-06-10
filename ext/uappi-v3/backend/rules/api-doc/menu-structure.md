---
shortDescription: Menu file paths, menu granularity rules, and no-duplication rule for menu keys.
scope: api-doc
product: uappi-v3
version: 0.1.0
lastUpdated: 2026-06-02
---

## Statement

### Menu file paths

Registry files are located at:
- `apis/api.uappi.com.br/src/resources/documentation-repositories/files/public-api/public-api.php`
- `apis/api.uappi.com.br/src/resources/documentation-repositories/files/private-api/private-api.php`

Read the target registry file before drafting page hierarchy. Mirror established naming patterns from sibling domains already in production.

For private administrative families that follow the pattern `Gerenciamento de <Domínio>` (for example Brand/Category/Customer), create or maintain an umbrella DOC page for the domain. Keep subgroup pages (credentials/options/transactions/types etc.) as focused sections under the same family. Do not introduce fixed-path/auth noise in every DOC page when the side menu already scopes the family; mention permissions only when they add decision value.

### Menu granularity decision

Start from one umbrella item: `Gerenciamento de <Domínio>`.

Split into additional menu items only when at least one condition is true:
- The subdomain has distinct user intent and lifecycle (for example `Importação`, `Webhook`, `Histórico`, `Carteira`).
- The subdomain has 3 or more HTTP endpoints and forms a coherent workflow on its own.
- The subdomain has materially different permission profile from the base management flow.
- The subdomain is already a stable pattern in sibling modules in production.

Keep everything under the umbrella item when none of the split conditions apply.

For each split item, include the shared DOC page only if it improves orientation; avoid excessive duplication.

### No-duplication rule for menu routing

Within the same `DocumentationDMC` family, each HTTP route doc key should belong to exactly one primary `DocumentationItemDMC`.

Avoid duplicating endpoint pages across sibling menu items.

Exception: high-level DOC intro pages may be repeated when they materially improve navigation context.

Before finalizing, run a duplicate-key check over sibling menu items and resolve overlaps.

## Rationale

Consistent menu structure prevents navigation fragmentation and key conflicts in the documentation renderer.
