---
shortDescription: Pre-dispatch requirements gate — verifies links and capabilities before any persona is dispatched.
usedBy: [maestro]
version: 0.2.0
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

Capabilities needed to read or write on external providers. Two severity levels:

- **Blocking** — the flow cannot proceed without this capability. Repositories are treated as private by default. Dispatch is not allowed until the user resolves it.

| Flow trigger | Required capability | Severity |
|---|---|---|
| `Revisar merge/MR` | Provider MCP — needed to read the MR/PR diff and post the review comment | **Blocking** |
| `Gerar checklist de testes` | Provider MCP — needed to read the MR/PR diff | **Blocking** |
| All other flows | — | — |

## Procedure

1. **Check required links.** For the matched flow, verify every required link is present in the user's message.
   - If any link is missing: tell the user exactly which link is needed. Do not proceed to step 2. Wait for the user to supply it, then re-run this check.

2. **Check required capabilities.** If the flow has a required capability:
   a. Identify the provider from the supplied URL — `github.com` → GitHub, `gitlab.com` → GitLab, `monday.com` → Monday, and so on.
   b. Check whether a matching MCP is available in the current session.
   c. If MCP is available: proceed to step 3.
   d. If MCP is unavailable — apply severity:
      - **Blocking:** inform the user — *"O MCP do [provider] não está configurado. Sem ele não é possível acessar o conteúdo do MR/PR. Configure o MCP e tente novamente."* Do not dispatch. Stop here.

3. **Proceed.** All requirements resolved — continue with dispatch.

## Guardrails

- Never dispatch while a required link is missing. Not even for tasks that seem straightforward.
- Never dispatch when a blocking capability is absent. There is no fallback — dispatch would produce an empty run.
- Never skip the capability check for flows listed in the table — only flows not listed are exempt.
