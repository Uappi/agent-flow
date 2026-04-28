# Support Package

Support triage and root-cause-analysis flows for Uappi, using a dedicated Monday board and artifacts under `.memory/docs/support/`.

## Contents

- Persona: `personas/support.md`
- Rules: `rules/support/support-initial-analysis.md`, `rules/support/support-root-cause-analysis.md`
- Templates: `templates/support/initial-analysis.md`, `templates/support/rca.md`
- Prompts: `prompts/support/initial-analysis.md`, `prompts/support/rca.md`

## Monday

- **Support:** `board_id: 8463166451`.
- **Product and engineering:** `board_id: 18383662197`.

Do not mix these boards. The support persona uses only the support board unless it is correlating an RCA with GitLab or release context.

## Outputs

- Triage: `.memory/docs/support/triagem/triagem-<MONDAY-ID>-<topic>.md`
- RCA: `.memory/docs/support/rca/rca-<MONDAY-ID>-<topic>.md`

These files are under `.memory/`, which the boot sequence keeps out of git by default.
