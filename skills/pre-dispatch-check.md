---
shortDescription: Pre-dispatch requirements gate — verifies links and capabilities before any persona is dispatched.
usedBy: [maestro]
version: 0.1.0
lastUpdated: 2026-05-14
---

## Purpose

Dispatching a persona without its required inputs wastes a full agent run — the persona reaches a blocker mid-execution and returns empty-handed. This skill defines a requirements gate the Maestro runs before every dispatch, so blockers are surfaced to the user before work begins, not after.

## Requirements by Flow

### Required links

Links the user must supply before dispatch. If any is missing, ask for it — do not dispatch until provided.

| Flow trigger | Required links |
|---|---|
| `Revisar merge/MR` | MR/PR URL and task/issue URL |
| `Gerar checklist de testes` | MR/PR URL and task/issue URL |
| `Documentação de Implementação` | task/issue URL |
| `Análise suporte` | support task URL |
| `RCA suporte` | support task URL |
| All other flows | — |

### Required capabilities

Capabilities needed for write operations on external providers. Absent capability does not block the flow — but the user must choose how to proceed before dispatch.

| Flow trigger | Required capability |
|---|---|
| `Revisar merge/MR` | Provider MCP — needed to post the review as a comment on the MR/PR |
| All other flows | — |

## Procedure

1. **Check required links.** For the matched flow, verify every required link is present in the user's message.
   - If any link is missing: tell the user exactly which link is needed. Do not proceed to step 2. Wait for the user to supply it, then re-run this check.

2. **Check required capabilities.** If the flow has a required capability:
   a. Identify the provider from the supplied URL — `github.com` → GitHub, `gitlab.com` → GitLab, `monday.com` → Monday, and so on.
   b. Check whether a matching MCP is available in the current session.
   c. If MCP is available: proceed to step 3.
   d. If MCP is unavailable: inform the user — *"O MCP do [provider] não está configurado. O review será gerado, mas não poderá ser postado automaticamente. Deseja continuar assim ou prefere configurar o MCP primeiro?"*
      - **Continue without posting:** include `capability-unavailable: [provider]` in the task brief. The persona will generate the output and report the saved file path, skipping the posting attempt.
      - **Abort:** stop here and guide the user to configure the MCP before retrying.

3. **Proceed.** All requirements resolved — continue with dispatch.

## Guardrails

- Never dispatch while a required link is missing. Not even for tasks that seem straightforward.
- Never skip the capability check for write flows. The user must make an explicit choice when the capability is absent — silent degradation is not acceptable.
- Never block on capabilities not listed in the Requirements table — only check what is declared here.
