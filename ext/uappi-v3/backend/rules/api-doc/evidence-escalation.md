---
shortDescription: Priority order for evidence sources when validating endpoint behavior assertions.
scope: api-doc
product: uappi-v3/backend
version: 0.1.0
lastUpdated: 2026-06-02
---

## Statement

### Evidence escalation order

For every non-trivial statement (rules, defaults, branching, side effects), validate against source files in this priority order:

1. Route
2. Controller
3. Request
4. API service/process
5. Domain service/process
6. DMC/DTO

A lower-priority source may only be used when higher-priority sources have been inspected and do not resolve the question.

### Listing/search contract extraction

For docs that expose `condition[]`, `order[]`, `fields[]` (or aliases), derive the contract from the integration/service process class that builds search:
- `CONDITION_FIELDS`
- `ORDER_FIELDS`
- `SELECT_FIELDS`
- `TRANSFORM_FIELDS`

If aliases exist in `TRANSFORM_FIELDS` (for example `id -> payment_option.id`), document the public alias and optionally note the internal mapping. Do not infer searchable/selectable fields from sample responses alone.

### Gap policy

A `Gap` is allowed only when all relevant local layers were inspected and still do not define behavior. Do not use gaps to avoid exploration.

## Rationale

Evidence escalation prevents assertion drift. Without a canonical order, agents may cite lower-fidelity sources when higher-fidelity ones exist.
