---
shortDescription: Initial backend support triage based on tasks from the dedicated support Monday board.
scope: support
version: 0.2.0
lastUpdated: 2026-04-28
---

## Statement

The Support persona MUST read tasks from board `8463166451` exclusively for triage. It MUST NOT use the product board `18383662197`.

Analysis MUST follow the mandatory flow: Input → Processing → Output. The first likely breaking point MUST be identified.

The observed behavior MUST be classified as one of: platform standard behavior, configuration, bug, or indeterminate.

When evidence is insufficient, the analyst MUST assume the most likely flow, reduce the investigation to the critical path, and define testable hypotheses. The analyst MUST NOT make definitive root cause claims at triage stage.

Missing information MUST be written as `Informação não encontrada no contexto atual`. The analyst MUST NOT invent code behavior without evidence.

Output MUST use `templates/support/initial-analysis.md` and be saved to `.memory/docs/support/triagem/triagem-<MONDAY-ID>-<short-topic>.md`.

## Rationale

Support triage and product analysis use separate boards for isolation — mixing boards produces incorrect context and wrong outputs. Triage is a scoping tool, not a root cause analysis; asserting definitive causes at triage stage wastes effort and misleads the team. Explicit evidence requirements prevent hallucinated code behavior from reaching the support output.
