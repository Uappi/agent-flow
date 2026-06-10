# Uappi V3 — Maestro routing

Read this file when `uappi-v3/backend` is in `activeProducts` (session `## Product Context`).

## Prompt → persona

| Trigger | Persona path | Mode |
|---------|--------------|------|
| First line of `prompts/task/api-doc.md` (`Documentação de API em lote (endpoints + opcional DOC)`) | `ext/uappi-v3/backend/personas/api-documenter.md` | document |
| Equivalent user intent (e.g. document a backend feature, write API docs for a feature) | same | document |

## Gates

Before dispatching `api-documenter`, apply the following checks in order:

1. **Missing page identifiers:** If the table of pages in the brief has no rows with an identifier (all cells are placeholders or the table is absent), do NOT dispatch. Respond asking the user to provide at least one page identifier (route key or file name) and its type (DOC, GET, POST, etc.).

2. **Missing ticket / objective:** If the `Ticket / objetivo` field is blank or still contains the placeholder text, do NOT dispatch. Respond asking the user to fill in the ticket reference or objective description before proceeding.

3. **`repoKind` behavior:** The `api-documenter` persona operates on source files in the work repository. It is available for `repoKind: core` (the only `repoKind` that passes product detection for `uappi-v3/backend`). There is no client-only restriction. If the repository does not detect as `uappi-v3/backend` (i.e. `uappi-v3/backend` is absent from `activeProducts`), do NOT dispatch; inform the user that this extension requires a repository identified as Uappi V3 backend.

> **Note on `preferredModel: codex`:** The `api-documenter` persona sets `preferredModel: codex` to leverage Codex CLI's strength in reading and cross-referencing large PHP codebases with minimal context overhead. This is a deliberate design decision. The implementation dispatcher routes to Codex CLI if available, otherwise falls back to the native model. Do NOT change this setting in the persona without explicit instruction.

## Dispatch paths

Use `ext/uappi-v3/backend/personas/api-documenter.md`.

Skill: `ext/uappi-v3/backend/skills/api-doc.md`.

Rules: all `ext/uappi-v3/backend/rules/api-doc/*.md` with `scope: api-doc`.
