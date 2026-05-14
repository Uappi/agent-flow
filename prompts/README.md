# Prompts

Prompts are user-facing input templates. Copy the relevant prompt, fill in the fields, and send it to the Maestro. The first line identifies the workflow and routes to the correct persona.

## Task Prompts (`task/`)

- **`code-review.md`** — MR/PR review. Routes to `reviewer` in MR/PR review mode. Requires: MR/PR URL and task/issue URL.

- **`test-checklist.md`** — Test checklist generation. Routes to `reviewer` in test-checklist mode. Requires: MR/PR URL and task/issue URL.

- **`tech-doc.md`** — Technical feature documentation. Routes to `analyst` (lens: technical).

- **`product-doc.md`** — Product feature documentation. Routes to `analyst` (lens: business).

- **`implementation.md`** — Implementation delivery document. Routes to `documenter`. Requires: task/issue URL. MR/PR URL optional but recommended.

## General Prompts (`general/`)

- **`context-mapping.md`** — Codebase context scan. Routes to `contextualizer` in context-scan mode.

- **`implementation-plan.md`** — Implementation planning. Routes to `architect`.

- **`implementation.md`** — Code implementation. Routes to `coder`.

## Support Prompts (`support/`)

- **`initial-analysis.md`** — Support triage. Routes to `support` in triage mode. Requires: support task URL.

- **`rca.md`** — Root cause analysis. Routes to `support` in RCA mode. Requires: support task URL. Preferably include the structured context block from section 9 of the triage report.

## Usage

1. Copy the prompt file that matches your workflow.
2. Fill in every field. Fields marked `<opcional>` may be left blank.
3. Send the filled prompt to the Maestro.

The Maestro identifies the workflow from the first line and runs the pre-dispatch requirements check (`skills/pre-dispatch-check.md`) before dispatching any persona. Missing required links or inaccessible providers block dispatch until resolved.
