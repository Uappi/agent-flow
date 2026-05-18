---
shortDescription: Pre-dispatch requirements gate — verifies links and capabilities before any persona is dispatched.
usedBy: [maestro]
version: 0.3.0
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

All external resources are treated as private by default. Authenticated access must be available for every external URL the flow will access — via MCP, API token, or any other configured access path. If access to any provider cannot be confirmed, dispatch is **blocked**.

| Flow trigger | External URLs accessed |
|---|---|
| `Revisar merge/MR` | task/issue URL, MR/PR URL |
| `Gerar checklist de testes` | task/issue URL, MR/PR URL |
| `Documentação de Implementação` | task/issue URL, MR/PR URL (if supplied) |
| `Análise suporte` | support task URL |
| `RCA suporte` | support task URL, MR/PR URL (if supplied), release URL (if supplied) |
| All other flows | — |

## Procedure

1. **Check required links.** For the matched flow, verify every required link is present in the user's message.
   - If any link is missing: tell the user exactly which link is needed. Do not proceed to step 2. Wait for the user to supply it, then re-run this check.

2. **Check required access.** For the matched flow, collect every external URL that will be accessed (required and optionally supplied). For each URL:
   a. Identify the provider from the URL — `github.com` → GitHub, `gitlab.com` → GitLab, `monday.com` → Monday, and so on.
   b. Check whether authenticated access to that provider is available in the current session — MCP configured, API token set, or any other active access path.
   c. If access is confirmed for all providers: proceed to step 3.
   d. If access to any provider cannot be confirmed: inform the user — *"Não há acesso autenticado configurado para [provider]. Sem ele não é possível acessar [URL]. Configure um meio de acesso (MCP, token, ou equivalente) e tente novamente."* Do not dispatch. Stop here.

3. **Proceed.** All requirements resolved — continue with dispatch.

## Guardrails

- Never dispatch while a required link is missing. Not even for tasks that seem straightforward.
- Never dispatch when access to any required provider cannot be confirmed. There is no fallback — dispatch would produce an empty run.
- Check each supplied URL independently — a flow may involve multiple providers (e.g. Monday task + GitLab MR), each requiring its own access path.
- Never skip the access check for flows listed in the table — only flows not listed are exempt.
- `All other flows` in the Required Links table means no link is required as a pre-condition for that flow. It does not exempt those flows from dispatch, the review loop, or any other playbook step. The full Playbook remains mandatory.
