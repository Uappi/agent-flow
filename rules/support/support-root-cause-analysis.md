---
shortDescription: Support RCA with technical root cause, code correlation, merge context, and confidence.
scope: support
version: 0.3.0
lastUpdated: 2026-05-20
---

## Triggers

Apply this rule **only** when the prompt explicitly requests RCA, for example:

- `RCA suporte`
- `RCA N2`
- `Análise profunda suporte`
- `Análise profunda N2`
- `Causa raiz suporte`
- `Causa raiz N2`

Do **not** apply when the prompt is triage-only (`Análise suporte`, `Análise N2`, `Triagem N2`, etc.).

## Scope and precedence

- RCA runs **after** triage or with a structured context block from section 9 of a prior triage report.
- Do not rewrite the triage report; extract only what is needed to validate technically.
- If the user only gave triage intent with regression suspicion, perform triage first and confirm before RCA.

## Monday via MCP (hard rule)

Same rules as `support-initial-analysis.md` when the support task URL is on `monday.com`.

## Context priority (critical)

Use sources in this order:

1. **Structured RCA context** from triage section 9 (highest priority)
2. Additional context in the user prompt
3. Prior triage report (supporting only — no verbatim reuse)

## Execution

### Objectives

**Must:** confirm or refute the main hypothesis; state technical root cause; pinpoint failure in code; correlate with possible regression (merge/release).

**Must not:** repeat triage diagnosis; list generic hypotheses without validation; stay superficial.

### Timeline (mandatory)

Establish: when the issue started; version change involved; whether prior behavior was stable.

Classify as: regression, new behavior, or indeterminate.

### Merge / release correlation

When MR/PR or release context is supplied:

- Inspect relevant diffs.
- Focus on validation, conditional flow, queries, persistence.
- Classify relation: clearly compatible, possibly related, or no apparent relation.
- Never claim certainty without direct code evidence.

If a supplied MR/PR or release link cannot be accessed, stop and report the blocker.

### Deep technical flow

Map full path: input → processing → persistence.

Identify where behavior diverges, which condition allows the error, and which data or state causes failure.

### Root cause statement

Root cause MUST be technical, specific, and reproducible when possible.

- Prefer: "O problema ocorre porque..."
- Avoid weak language ("pode ser", "talvez") without technical justification.

### Confidence

State **Alta**, **Média**, or **Baixa** with justification:

- Alta — direct evidence (code/log)
- Média — strong technical correlation
- Baixa — hypothesis with little evidence

### Code evidence (mandatory)

Identify at least one of: incorrect query, missing/incomplete validation, wrong conditional logic, flow allowing invalid state.

When possible, cite file path, method/class, or equivalent behavior. If not possible, state explicitly.

### Mitigation

Recommend at least one concrete action: code fix, extra validation, guard against inconsistent state, query adjustment, or additional logging.

## Statement

The Support persona MUST read support context from the task link supplied by the user. If the support task cannot be accessed, the analyst MUST stop and report the access blocker.

The analyst MUST apply `rules/support/project-config.md` and `skills/load-project-config.md` when `project.config.yaml` exists. Otherwise it MUST NOT assume a fixed tracker, board, repository, or provider.

The analyst MUST prioritize the structured RCA context block from a prior triage report. The full triage text MUST be used as supporting context only — it MUST NOT be copied verbatim into the RCA.

The RCA MUST confirm or refute the main hypothesis with a technical root cause, failure point, and regression classification.

When MR/PR or release context is supplied, relevant diffs MUST be inspected. The analyst MUST NOT assert correlation between a merge and the problem without code evidence.

Missing information MUST be written as `Não identificado no contexto atual`. The analyst MUST NOT hallucinate code.

Output MUST use `templates/support/rca.md`.

Save using `outputs.paths.support_rca` from `project.config.yaml` when configured; otherwise `.memory/docs/support/rca/rca-<TASK-ID>-<short-topic>.md`.

## Rationale

RCA without structured prior context wastes time re-doing triage. Requiring code evidence and version context prevents speculative root causes. Explicit confidence levels set correct expectations. Monday MCP and merge-access gates avoid analysis built on inaccessible or wrong context.
