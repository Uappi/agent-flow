---
shortDescription: All sections present in the selected markdown-model are mandatory unless the endpoint is verified to lack that element.
scope: api-doc
product: uappi-v3
version: 0.1.0
lastUpdated: 2026-06-02
---

## Statement

### Section obligation

Every section and subsection present in the selected `markdown-model` MUST appear in the produced page, UNLESS the endpoint is verified to lack that element.

"Verified absent" means: after reading the route, controller, request class, and middleware stack, no evidence of that element exists. Assumption, doubt, or inference from similar endpoints is NOT sufficient — inspect first.

### Omission protocol

Before omitting any section from the model template, the documenter MUST:

1. Read the route definition, controller, request class, and middleware for the specific endpoint.
2. Confirm the element is absent (not undocumented or assumed absent).
3. Only then remove the section.

Omitting a section without verification is a documentation defect — not an acceptable simplification.

### Sections most commonly omitted incorrectly

**`### Headers Obrigatórios`** — present in all endpoint models.
MUST be documented when any of the following are true:
- The endpoint's middleware stack includes any auth guard (`PrivateAuth`, `PublicAuth`, `CustomerAuth`, or equivalent).
- The controller, route, or request validates any header.
Do NOT skip because the header seems "obvious" or "standard". If the endpoint requires `Authorization`, document it.

**`### Parâmetros da URL`** — present in endpoint models.
MUST be documented when the route definition contains path parameters (`{id}`, `{hash}`, `{slug}`, etc.).
Check: read the route definition directly.

**`### Parâmetros do Corpo`** — present in register models (POST/PUT/PATCH).
MUST be documented for every endpoint that accepts a request body.
Check: read the Request class for all validated fields.

**`### Campos Disponíveis (fields)`** — present in GET/listing models.
MUST be documented when the endpoint accepts a `fields[]` parameter.
Check: look for `SELECT_FIELDS` or `TRANSFORM_FIELDS` in the service/process class.

**`### Exemplo de Requisição`** — present in all endpoint models.
Always mandatory. Every endpoint page MUST contain a `curl` example, regardless of endpoint type.

### Extra sections are allowed

The model is a floor, not a ceiling. Additional sections (e.g. `### Parâmetros de Query`, `### Parâmetros de Corpo Opcionais`) MAY be added when the endpoint warrants them. The obligation is to include everything in the model — adding more is always acceptable.

## Rationale

Skipping template sections produces incomplete documentation that misleads API consumers. The markdown models were designed with all common endpoint elements; their presence in the template is an implicit assertion that the section is relevant. Verification before omission prevents silent gaps.
