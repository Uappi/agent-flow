---
shortDescription: Support RCA with technical root cause, code correlation, merge context, and confidence.
scope: support
version: 0.1.0
lastUpdated: 2026-04-28
---

# RCA de suporte

Use via `personas/support.md` when the main request is `RCA suporte`, `Análise profunda suporte`, or `Causa raiz suporte`.

## Context

- **Monday support board:** `8463166451`.
- **GitLab project:** `agenciawebart/wapstore/wapstore`.
- **Product source of truth:** `README.ai.md` in the work repository when present.

## Execution Rules

1. Prioritize the `Contexto estruturado para RCA` block from a triage output. Use additional prompt context next. Use the full triage only as support, not as text to copy.
2. Confirm or refute the main hypothesis, identify the technical root cause, the failure point, and whether the issue is a regression.
3. Build a timeline: when it started, current version, previous version, regression/new behavior/indeterminate.
4. When GitLab merge or release context is available, inspect relevant diffs and classify the relationship with the problem. Do not assert correlation without evidence.
5. Root cause must be technical, specific, and reproducible when possible.
6. Confidence must be high, medium, or low with justification.
7. Provide code evidence or state explicitly when code evidence could not be found.
8. Recommend at least one concrete mitigation or correction.

## Quality

- Do not hallucinate code.
- Do not ignore structured RCA context.
- Do not turn RCA into a copy of the triage report.
- If information is missing, write `Não identificado no contexto atual`.

## Output

Use `templates/support/rca.md` and save to `.memory/docs/support/rca/rca-<MONDAY-ID>-<short-topic>.md`.

