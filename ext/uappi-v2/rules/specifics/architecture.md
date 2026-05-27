---
shortDescription: Uappi client vs core layout for specifics sync.
scope: specifics-sync
product: uappi-v2
version: 0.1.0
lastUpdated: 2026-05-27
---

## Statement

- **Core** (GitLab `wapstore/wapstore` at tag) is the functional source of truth for shared behavior.
- **Client `especifico/`** holds overrides that mirror `bin/` layout but are maintained separately before compile.
- **`bin/`** is the compiled merge of core + especifico — read-only for this workflow.
- **`tema/`** is out of scope for v1 compare unless the task brief explicitly includes it.
- Hierarchy for conflicts: core tag content → extension rules → client `especifico/` → ad hoc comments.

## Rationale

Agents must understand why comparison targets GitLab core, not the local `bin/` tree, to avoid false positives from generated code.
