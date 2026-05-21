# Templates

Templates define the standard output format for each AgentFlow workflow. When a persona delivers a review, an implementation document, or a support analysis, the output fills one of these templates — no free-form substitutions, no omitted sections.

The filled template is the artifact. It is saved to `.memory/docs/`. Code review markdown files are also uploaded to the Monday task's `Revisões automáticas` file column when the task link points to Monday. The MR/PR review may be posted externally only after the user has reviewed it and clearly authorized publication, including whether to publish the full document or only specific sections/parts.

## Flow → Template → Destination

| Flow | Persona | Template | Destination |
|---|---|---|---|
| `Revisar merge/MR` | Reviewer | `task/code-review.md` | `.memory/docs/code-review/` + Monday `Revisões automáticas` file column; optional top-level MR/PR comment only after explicit user authorization and scope selection |
| `Gerar checklist de testes` | Reviewer | `task/test-checklist.md` | `.memory/docs/checklists/` |
| `Documentação Técnica` | Analyst | `task/tech-doc.md` | `.memory/docs/features/feat-<name>-tech.md` |
| `Documentação de Produto` | Analyst | `task/product-doc.md` | `.memory/docs/features/feat-<name>-prod.md` |
| `Documentação de Implementação` (correction) | Documenter | `task/implementation-correction.md` | `.memory/docs/implementations/` |
| `Documentação de Implementação` (development) | Documenter | `task/implementation-development.md` | `.memory/docs/implementations/` |
| `Análise suporte` | Support | `support/initial-analysis.md` | `.memory/docs/support/triage/` |
| `RCA suporte` | Support | `support/rca.md` | `.memory/docs/support/rca/` |

## Task Templates (`task/`)

- **`code-review.md`** — MR/PR review output. Saved locally, uploaded to the Monday task's `Revisões automáticas` file column when applicable, and posted as a top-level comment on GitLab/GitHub only after explicit user authorization and scope selection: full document or specific sections/parts. Sections: identification, context, scope (changed files), executive summary, risks by severity (high/medium/low), questions for the developer, thread reply (when applicable), improvement suggestions, team standard deviations, test checklist.

- **`test-checklist.md`** — Test checklist generated from the diff and task. Used by QA and developers before merge. Sections: identification, context, MR/PR scope, risk matrix by area (API, database, security, front, admin, checkout, legacy, integrations, crons), functional scenarios (happy path, negative, permission), regression, API tests, security, persistence, automated test suggestions, acceptance criteria.

- **`tech-doc.md`** — Technical documentation for a feature. Audience: developers and technical analysts. Content: overview, data flow, dependencies, behaviors, gaps identified in the code.

- **`product-doc.md`** — Product documentation for a feature. Audience: support, CS, and operations — no technical implementation details exposed. Content: what it is and what it does, configuration, business rules, restrictions, known caveats.

- **`implementation-correction.md`** — Delivery document for corrections, bugs, and hotfixes. Use when the task resolves wrong behavior. Sections: identified problem, implemented solution, current state, QA information, responsible parties, links, release.

- **`implementation-development.md`** — Delivery document for features, enhancements, and new developments. Use when the task delivers new value. Sections: motivation, objective, value proposition, how to configure, tests performed, technical notes, responsible parties, links, release.

## Support Templates (`support/`)

- **`initial-analysis.md`** — Support triage report produced from a Monday task link. Sections: initial analysis (what happens, expected vs actual, scope), possible causes by priority, next steps, behavior classification (standard/configuration/bug), triage quality, evidence checklist, escalation block, technical direction (files, hypothesis, action), structured context block for RCA input (section 9 — mandatory).

- **`rca.md`** — Root cause analysis report. Produced from the support task and correlated with an MR/PR or release when supplied. Sections: symptom, timeline (current vs previous version, regression type), merge/code correlation, technical flow (input/processing/persistence), root cause, evidence, impact, confidence level with justification, technical evidence in the code, mitigation and recommended fix.

## Rules

- Every section of the template must be filled — no section may be omitted or replaced with free-form text.
- The filled template is the final artifact. There is no internal draft separate from the delivered document.
- Use `implementation-correction.md` for wrong-behavior fixes; use `implementation-development.md` for new value delivery.
- Section 9 of `support/initial-analysis.md` (structured RCA context) is mandatory — it is the input for the subsequent RCA flow.
