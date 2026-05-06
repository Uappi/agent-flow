# Support Package

Support triage and root-cause-analysis flows using supplied support task links and artifacts under `.memory/docs/support/`.

## Contents

- Persona: `personas/support.md`
- Rules: `rules/support/support-initial-analysis.md`, `rules/support/support-root-cause-analysis.md`
- Templates: `templates/support/initial-analysis.md`, `templates/support/rca.md`
- Prompts: `prompts/support/initial-analysis.md`, `prompts/support/rca.md`

## External Context

- Provide the support task link in the prompt.
- Provide MR/PR or release links when RCA needs merge or release correlation.

The supplied links are the source of truth. Do not assume a fixed tracker, board, repository, or provider.

## Outputs

- Triage: `.memory/docs/support/triagem/triagem-<TASK-ID>-<topic>.md`
- RCA: `.memory/docs/support/rca/rca-<TASK-ID>-<topic>.md`

These files are under `.memory/`, which the boot sequence keeps out of git by default.
