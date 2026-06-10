---
shortDescription: Standard procedure for documenting backend/API features with verifiable implementation evidence.
usedBy: [api-documenter]
scope: api-doc
product: uappi-v3
version: 0.6.0
lastUpdated: 2026-06-02
---

## Purpose

This skill standardizes backend/API documentation so it stays traceable to implementation, explicit about scope boundaries, and honest about uncertainty.

## Output Language

- The produced Markdown pages MUST be written in Portuguese (`pt-BR`).
- The agent's process notes/handoff MAY remain in English.

## Procedure

1. **Define scope and evidence base.**
Record feature boundaries, included modules, excluded concerns, and endpoint inventory.

Build evidence from concrete files:
- Routes
- Controllers
- Requests/validators
- API services/processes
- Domain services/processes (mandatory when present)
- DMC/DTO contracts
- Migrations/settings/tests when relevant

Validate publication flow before writing — and MUST write/update the registry entry as a required output, not just read it for context:
- `apis/api.uappi.com.br/src/resources/documentation-repositories/menu-map.php`
- `apis/api.uappi.com.br/src/resources/documentation-repositories/files/public-api/public-api.php`
- `apis/api.uappi.com.br/src/resources/documentation-repositories/files/private-api/private-api.php`
- `apis/api.uappi.com.br/src/app/Console/Commands/IndexDocumentationCommand.php`
- `apis/api.uappi.com.br/src/app/Services/Documentation/GetDocumentationProcess.php`

2. **Use required templates by page type.**

- **`method: DOC` page (Portuguese headings):**
- `# <Título>`
- `## Visão Geral`
- `## Entidades Envolvidas`
- `## Regras Importantes` (when applicable and useful to readers)
- `## Endpoints Relacionados` (when applicable and useful to readers)
- `## Notas e Considerações` (optional)

- **HTTP endpoint page (Portuguese headings):**
- `# <Título>`
- ```endpoint``` block (`method`, `url`, `description`)
- `## Descrição`
- `## Parâmetros`
  - `### Headers Obrigatórios` — MANDATORY when the endpoint requires any header (auth, content-type, etc.). Omit ONLY after verifying the endpoint has no auth middleware and no header validation.
  - `### Parâmetros da URL` — MANDATORY when the route has path parameters. Omit ONLY when the route definition has none.
  - `### Parâmetros do Corpo` — MANDATORY for POST/PUT/PATCH. Omit ONLY when the endpoint has no request body.
  - `### Campos Disponíveis (fields)` — MANDATORY when the endpoint accepts `fields[]`. Omit ONLY after checking `SELECT_FIELDS`/`TRANSFORM_FIELDS` in the process class.
  - `### Exemplo de Requisição` — Always mandatory. Never omit.
- `## ✅ Resposta de Sucesso`
- `### ⚠️ Possíveis erros:`
- Do NOT include a `Reference Files` section in published markdown.

2.1 **Follow repository menu structure conventions (mandatory).**
- Read the target registry file in `documentation-repositories/files/...` before drafting page hierarchy.
- Mirror established naming patterns from sibling domains already in production.
- For private administrative families that follow the pattern `Gerenciamento de <Domínio>` (for example Brand/Category/Customer), create or maintain an umbrella DOC page for the domain.
- Keep subgroup pages (credentials/options/transactions/types etc.) as focused sections under the same family.
- Do not introduce fixed-path/auth noise in every DOC page when the side menu already scopes the family; mention permissions only when they add decision value.

2.2 **Menu granularity decision (mandatory).**
- Start from one umbrella item: `Gerenciamento de <Domínio>`.
- Split into additional menu items only when at least one condition is true:
  - The subdomain has distinct user intent and lifecycle (for example `Importação`, `Webhook`, `Histórico`, `Carteira`).
  - The subdomain has 3 or more HTTP endpoints and forms a coherent workflow on its own.
  - The subdomain has materially different permission profile from the base management flow.
  - The subdomain is already a stable pattern in sibling modules in production.
- Keep everything under the umbrella item when none of the split conditions apply.
- For each split item, include the shared DOC page only if it improves orientation; avoid excessive duplication.

2.3 **No-duplication rule for menu routing (mandatory).**
- Within the same `DocumentationDMC` family, each HTTP route doc key should belong to exactly one primary `DocumentationItemDMC`.
- Avoid duplicating endpoint pages across sibling menu items.
- Exception: high-level DOC intro pages may be repeated when they materially improve navigation context.
- Before finalizing, run a duplicate-key check over sibling menu items and resolve overlaps.

2.4 **`markdown-models` baseline (mandatory).**
- Before drafting, inspect:
  - `apis/api.uappi.com.br/src/resources/markdown-models/doc-model.md`
  - `apis/api.uappi.com.br/src/resources/markdown-models/get-model.md`
  - `apis/api.uappi.com.br/src/resources/markdown-models/listing-model.md`
  - `apis/api.uappi.com.br/src/resources/markdown-models/register-model.md`
- Choose the nearest model per page and preserve its structural intent (frontmatter style, section order, contract-centric examples).
- If the model conflicts with real behavior, keep behavior truth and document the conflict in process notes.

2.5 **Write registry entry (mandatory).**
After identifying the correct registry file, write or update the `DocumentationDMC` / `DocumentationItemDMC` entry:
- Each new doc page's path key (for example `'private-api/review/product/create-product-review'`) MUST appear in the item's array.
- The key pattern is: `'<api-type>/<domain>/<optional-subdomain>/<route-key>'` matching the folder path under `documentation-files/`.
- If the domain already has an existing `DocumentationDMC` family in the registry, add new keys to the appropriate `DocumentationItemDMC` — do not create a duplicate family.
- Cross-check each key against the actual folder path before saving — a mismatched key silently breaks frontend navigation.

3. **Attach evidence to assertions.**
For every non-trivial statement (rules, defaults, branching, side effects), validate against source files.

Evidence escalation order:
- Route
- Controller
- Request
- API service/process
- Domain service/process
- DMC/DTO

3.1 **Listing/search contract extraction (mandatory).**
- For docs that expose `condition[]`, `order[]`, `fields[]` (or aliases), derive the contract from the integration/service process class that builds search:
  - `CONDITION_FIELDS`
  - `ORDER_FIELDS`
  - `SELECT_FIELDS`
  - `TRANSFORM_FIELDS`
- If aliases exist in `TRANSFORM_FIELDS` (for example `id -> payment_option.id`), document the public alias and optionally note the internal mapping.
- Do not infer searchable/selectable fields from sample responses alone.

4. **Resolve unknowns before accepting gaps.**
A `Gap` is allowed only when all relevant local layers were inspected and still do not define behavior.

5. **Normalize terminology before final write.**
Build a short canonical glossary for feature-critical terms (field names, token names, policy names, flow names) and apply it across all related pages.
- Do not alternate ambiguous synonyms for the same contract concept.
- Keep wire-level field names exact (`mfaToken`, `secretKey`, etc.) while keeping prose terminology stable in pt-BR.

6. **Validate cross-consistency.**
If layers conflict, mark as `Conflict` and identify impacted assertion.

7. **Consumer-perspective filter (mandatory).**
For endpoint pages, keep focus on API consumption:
- What to send.
- When to send.
- What returns.
- Which errors to handle.
Remove non-contract internal implementation detail unless it changes integration behavior.

7.1 **Error table scope (mandatory).**
- Keep error tables focused on endpoint/domain-specific failures (business and integration errors tied to that route).
- Do not flood endpoint pages with repeated cross-cutting errors (`INVALID_AUTH_TOKEN`, `EXPIRED_AUTH_TOKEN`, `INVALID_AUTH_HOST`, auth user/scope, generic payload errors), except when:
  - the route contract is essentially limited to those errors, or
  - there is endpoint-specific behavior that changes how clients should react.
- When generic errors are intentionally omitted, this is considered compliant (not a documentation gap).

7.2 **Formatting conventions (all page types — mandatory).**
- **API field names**: always `camelCase` in examples, tables, and parameter descriptions.
- **Tables**: use simple dividers (`| --- |`) without alignment markers (`:`). Do not bold field names inside table cells.
- **Permissions**: do not use tables for permissions. Describe required scopes (READ/WRITE) directly in prose within the Description section.
- **Line length**: maximum 140–155 characters per line for readability in the doc renderer.
- **Line breaks**: never break a line mid-sentence without a closing period (`.`). Each line must end at a natural sentence boundary.
- **Paragraph spacing**: always use double line breaks (two blank lines) between paragraphs to ensure correct HTML rendering — single breaks are collapsed during conversion.

8. **Done criteria.**
Documentation is done only when:
- All mandatory sections exist.
- Every section from the selected `markdown-model` is present, or was explicitly verified as absent from the endpoint (verified, not assumed).
- HTTP pages include request example, success response, and possible errors.
- Non-trivial statements are evidence-backed.
- Publication flow is correctly wired.
- The selected `markdown-model` is respected for each page.
- Portuguese technical writing style is respected.
- Feature-family terminology is normalized.
- Error IDs and HTTP status codes are parity-checked against active error maps/throws.
- Error rows are curated for route-specific relevance; generic cross-cutting boilerplate is filtered out by default.
- No avoidable gaps remain.
- Registry entry written: new doc keys added to the correct `DocumentationItemDMC` in the target registry file.
- Key path verified: each doc key matches its actual folder path under `documentation-files/`.

9. **Writing style for `DOC` pages (mandatory quality bar).**
- Prefer explanatory, flowing text oriented to feature understanding (house style similar to `product/brand/brand-doc/pt-BR.md`).
- Use domain/business entity names first; avoid class-level inventory as primary content (for example listing only `*DMC`, controllers, and tables).
- Keep internal implementation terms only when they are necessary for API consumers.
- Avoid excessive jargon and English naming in headings/body when a clear Portuguese term exists.
- Include `Regras Importantes` and `Endpoints Relacionados` only if they improve comprehension; do not force these sections mechanically.
- Keep permission details concise. Prefer a dedicated `## Permissão` section only when access rules are central to understanding the module; otherwise avoid repeating middleware/scope boilerplate.
- Avoid scope-redundant labels in titles (for example `Privado`, `Private`, `Pública`) when the page is already nested under `API Privada` or `API Pública` in the menu.
- For very long error codes/tokens inside tables, insert soft break points (`<wbr>`) to avoid layout overflow in the rendered docs.
- In public endpoint pages, prefer behavior-oriented wording over middleware names (for example avoid explicit `PublicAuth` mention) unless the middleware behavior itself is part of the endpoint contract.

## Guardrails

- Never fill missing evidence with assumptions based on similar features.
- Never hide uncertainty to appear complete.
- Never skip domain/service inspection when that code exists in the workspace.
