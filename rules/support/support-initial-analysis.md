---
shortDescription: Initial backend support triage based on tasks from the dedicated support Monday board.
scope: support
version: 0.1.0
lastUpdated: 2026-04-28
---

# Triagem inicial de suporte

Use via `personas/support.md` when the main request is `Análise suporte`, `Triagem suporte`, `Diagnóstico suporte`, or `Documentação análise inicial`.

## Context

- **Monday support board:** `8463166451`.
- **Product source of truth:** `README.ai.md` in the work repository when present.

## Execution Rules

1. Triage quality is a signal, not a blocker. Evaluate visual evidence, sandbox, comparison between clients, steps to reproduce, logs, and requests; record missing evidence as a triage improvement.
2. With little evidence, assume the most likely flow, reduce the investigation to the critical path, define testable hypotheses, and avoid definitive conclusions.
3. Use the mandatory flow: Input -> Processing -> Output. Identify the first likely breaking point.
4. Classify the behavior as platform standard behavior, configuration, bug, or indeterminate.
5. Keep depth appropriate for triage. Do not replace RCA; avoid deep debugging and definitive root cause claims.

## Quality

- Do not invent code or behavior without evidence.
- If information is missing, write `Informação não encontrada no contexto atual`.

## Output

Use `templates/support/initial-analysis.md` and save to `.memory/docs/support/triagem/triagem-<MONDAY-ID>-<short-topic>.md`.

