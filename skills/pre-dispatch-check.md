---
shortDescription: Pre-dispatch requirements gate — verifies links and capabilities before any persona is dispatched.
usedBy: [maestro]
version: 0.3.3
lastUpdated: 2026-05-27
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
| `Análise suporte`, `Triagem suporte`, `Diagnóstico suporte`, `Análise N2`, `Triagem N2`, `Diagnóstico N2`, `Documentação Analise inicial` | support task URL |
| `RCA suporte`, `RCA N2`, `Análise profunda suporte`, `Análise profunda N2`, `Causa raiz suporte`, `Causa raiz N2` | support task URL |
| `Comparar específicos` (Uappi v2; see `ext/uappi-v2/ROUTING.md`) | — |
| All other flows | — |

### Required inputs (non-URL)

Fields the user must supply in the message before dispatch. If any is missing or empty, ask for it — do not dispatch.

| Flow trigger | Required inputs |
|---|---|
| `Comparar específicos` | **Versão alvo do core (tag)** — the core release to compare/update toward. MUST NOT be inferred from `.wapstore/build` (that file is the client's **installed** version only). |
| All other flows | — |

### Required capabilities

All external resources are treated as private by default. Authenticated access must be available for every external URL the flow will access — via MCP, API token, or any other configured access path. If the flow writes to an external system, authenticated write access must also be available. If access to any provider cannot be confirmed, dispatch is **blocked**.

| Flow trigger | External URLs accessed |
|---|---|
| `Revisar merge/MR` | task/issue URL, MR/PR URL; Monday task file upload access for `Revisões automáticas` when task/issue is Monday |
| `Gerar checklist de testes` | task/issue URL, MR/PR URL |
| `Documentação de Implementação` | task/issue URL, MR/PR URL (if supplied) |
| `Análise suporte`, `Triagem suporte`, `Diagnóstico suporte`, `Análise N2`, `Triagem N2`, `Diagnóstico N2`, `Documentação Analise inicial` | support task URL |
| `RCA suporte`, `RCA N2`, `Análise profunda suporte`, `Análise profunda N2`, `Causa raiz suporte`, `Causa raiz N2` | support task URL, MR/PR URL (if supplied), release URL (if supplied) |
| `Comparar específicos` | GitLab read access to core project `agenciawebart/wapstore/wapstore` (or brief override) at **target** release tag from required inputs — verify provider access per step 2 |
| All other flows | — |

## Procedure

1. **Check required links.** For the matched flow, verify every required link is present in the user's message.
   - If any link is missing: tell the user exactly which link is needed. Do not proceed to step 2. Wait for the user to supply it, then re-run this check.

2. **Check required inputs.** For the matched flow, verify every required input from the table above is present and non-empty in the user's message (e.g. `Versão alvo do core (tag): v2.8.13.0`).
   - For `Comparar específicos`, reject dispatch if only `.wapstore/build` exists on disk but the user did not state the target tag in the prompt.
   - If any input is missing: tell the user exactly which field is needed. Do not proceed to step 3.

3. **Check required access.** For the matched flow, collect every external URL that will be accessed (required and optionally supplied). For flows that need a provider without a user URL (e.g. `Comparar específicos` → GitLab core at tag), treat the provider as **GitLab** and run the same access check.

   For each URL or required provider:
   a. Identify the provider — `github.com` → GitHub, `gitlab.com` → GitLab, `monday.com` → Monday, and so on.
   b. Confirm **any** authenticated read path works — not only MCP. Valid examples: GitLab MCP, `glab` CLI with token, local clone of the core repo with `git fetch` / checkout tag, `GITLAB_TOKEN` + API, or host tooling that can read `gitlab.com` private content.
   c. If access is confirmed for all providers: proceed to step 4.
   d. If access to any provider cannot be confirmed: inform the user — *"Não há acesso autenticado configurado para [provider]. Configure MCP, token, clone local, ou equivalente e tente novamente."* Do not dispatch. Stop here.

4. **Proceed.** All requirements resolved — continue with dispatch.

## Guardrails

- Never dispatch while a required link is missing. Not even for tasks that seem straightforward.
- Never dispatch when access to any required provider cannot be confirmed. There is no fallback — dispatch would produce an empty run.
- Check each supplied URL independently — a flow may involve multiple providers (e.g. Monday task + GitLab MR), each requiring its own access path.
- Never skip the access check for flows listed in the table — only flows not listed are exempt.
- `All other flows` in the Required Links table means no link is required as a pre-condition for that flow. It does not exempt those flows from dispatch, the review loop, or any other playbook step. The full Playbook remains mandatory.
