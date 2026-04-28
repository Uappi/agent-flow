---
shortDescription: Support RCA with technical root cause, code correlation, merge context, and confidence.
scope: support
version: 0.2.0
lastUpdated: 2026-04-28
---

## Statement

The Support persona MUST read Monday context from board `8463166451`. The GitLab project is `agenciawebart/wapstore/wapstore`.

The analyst MUST prioritize the `Contexto estruturado para RCA` block from a prior triage report. The full triage text MUST be used as supporting context only — it MUST NOT be copied verbatim into the RCA.

The RCA MUST confirm or refute the main hypothesis with a technical root cause, failure point, and regression classification.

The analyst MUST build a timeline: when the issue started, current version, previous version, and whether it is a regression, new behavior, or indeterminate.

When GitLab merge or release context is available, relevant diffs MUST be inspected. The analyst MUST NOT assert correlation between a merge and the problem without code evidence.

Root cause MUST be technical, specific, and reproducible when possible. Confidence MUST be stated as high, medium, or low with justification.

The analyst MUST provide code evidence or explicitly state when code evidence could not be found. At least one concrete mitigation or correction MUST be recommended.

Missing information MUST be written as `Não identificado no contexto atual`. The analyst MUST NOT hallucinate code.

Output MUST use `templates/support/rca.md` and be saved to `.memory/docs/support/rca/rca-<MONDAY-ID>-<short-topic>.md`.

## Rationale

RCA without structured prior context wastes time re-doing triage work. Requiring code evidence and version context prevents speculative root causes that mislead developers. Explicit confidence levels set correct expectations about certainty of findings. Separating triage from RCA ensures each mode produces proportionate depth without overlap.
