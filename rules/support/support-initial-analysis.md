---
shortDescription: Initial backend support triage based on a supplied support task link.
scope: support
version: 0.3.0
lastUpdated: 2026-05-20
---

## Triggers

Apply this rule when the prompt starts with any of:

- `Análise suporte`
- `Triagem suporte`
- `Diagnóstico suporte`
- `Análise N2`
- `Triagem N2`
- `Diagnóstico N2`
- `Documentação Analise inicial`

## Scope and precedence

- Use **only** triage depth in this mode. Do not produce RCA content unless the user explicitly requests RCA (`RCA suporte`, `RCA N2`, `Análise profunda suporte`, `Causa raiz suporte`, or equivalent).
- Suspected regression or versioning alone does **not** trigger RCA automatically.
- When in doubt, finish triage and ask whether to proceed to RCA.

## Monday via MCP (hard rule)

When the support task URL is on `monday.com`:

- Access the task **only** via MCP `plugin-monday.com-monday`.
- Do **not** use `WebFetch` or `WebSearch` to read Monday cards.
- Minimum sequence:
  1. Extract `boardId` and `itemId` from the URL.
  2. Read the item with `get_board_items_page` (`itemIds`).
  3. Read description and comments with `get_updates` (`objectType: Item`).
- On auth or permission failure: stop, ask the user to reconnect Monday MCP, and do not continue from HTML placeholders such as "Loading...".

## Execution

### Triage quality signal (non-blocking)

Evaluate presence of: step-by-step, visual evidence, sandbox test, cross-client comparison, logs/requests.

- Never block triage for missing evidence.
- Record gaps as triage-quality improvements.
- State how missing evidence affects confidence.

### Low-evidence strategy

When information is scarce:

- Assume the most likely functional flow.
- Reduce investigation to the critical path.
- Avoid definitive conclusions.
- Prioritize testable hypotheses.

### Flow-oriented analysis (mandatory)

Map:

- **Input:** request / event / trigger
- **Processing:** service / rule / condition
- **Output:** database / integration / response

Goal: identify the **first likely breaking point**.

### Classification

| Label | When to use |
| :--- | :--- |
| Padrão | Configuration dependency, explicit code condition, inconsistent data, specific scenario |
| Configuração | Wrong parameter, disabled flag, incomplete data |
| Bug | Exception, interrupted flow, regression, inconsistent logic |
| Indeterminado | Insufficient technical evidence |

### Depth limits

**Must:** identify probable failure point and suggest next technical investigation.

**Must not:** deep debug, full stack-trace analysis, or definitive root-cause confirmation (that belongs to RCA).

## Statement

The Support persona MUST read the support task from the link supplied by the user. If the support task cannot be accessed, the analyst MUST stop and report the access blocker.

The analyst MUST apply `rules/support/project-config.md` and `skills/load-project-config.md` when `project.config.yaml` exists at the work repo root (board hints, GitLab project, output paths). Without config, it MUST NOT assume a fixed tracker, board, repository, or provider.

Analysis MUST follow the mandatory flow: Input → Processing → Output. The first likely breaking point MUST be identified.

The observed behavior MUST be classified as one of: platform standard behavior, configuration, bug, or indeterminate.

When evidence is insufficient, the analyst MUST assume the most likely flow, reduce the investigation to the critical path, and define testable hypotheses. The analyst MUST NOT make definitive root cause claims at triage stage.

Missing information MUST be written as `Informação não encontrada no contexto atual`. The analyst MUST NOT invent code behavior without evidence.

Output MUST use `templates/support/initial-analysis.md`. Section 9 (structured RCA context) MUST be filled whenever applicable.

Save using `outputs.paths.support_triage` from `project.config.yaml` when configured; otherwise `.memory/docs/support/triage/triage-<TASK-ID>-<short-topic>.md`.

## Rationale

Support triage uses the supplied task link as the source of truth. Separating triage from RCA avoids wasted effort and misleading definitive causes. Monday MCP enforcement prevents false context from scraped pages. Explicit evidence requirements prevent hallucinated code behavior from reaching the support output.
