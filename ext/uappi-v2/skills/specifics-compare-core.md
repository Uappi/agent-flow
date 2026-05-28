---
shortDescription: Compare especifico/ files against Wapstore core at release tag via GitLab.
usedBy: [specifics-sync]
product: uappi-v2
relatedTo: [gitlab-mcp, gitlab-api, glab]
version: 0.2.1
lastUpdated: 2026-05-28
---

## Purpose

Compare `especifico/` to core on GitLab at `target_release`, classify per `rules/specifics/*`, write reports from templates. Do not apply changes. Do not paste full reports in chat — only paths and summary counts in handoff.

## Procedure

Follow `ext/uappi-v2/rules/specifics/workflow.md`.

1. **Resolve inputs**
   - **`target_release`** — task brief; if missing, stop.
   - **`report_mode`** — `por arquivo` | `por tarefa` | `ambos` (brief field **Relatório**); if missing, stop.
   - **`client_branch`** — optional; record in report header when supplied (checkout if cwd is client repo and branch exists).
   - **`installed_release`** — from `.wapstore/build` when present; header only (`path-mapping.md`).

2. **Resolve paths** (`path-mapping.md`)
   - Overrides: `especifico/`
   - Core: `agenciawebart/wapstore/wapstore` @ `target_release`, prefix `core/`

3. **Core access** at `target_release` (Maestro validated via `pre-dispatch-check.md`):

   | Priority | Path |
   |----------|------|
   | A | GitLab MCP |
   | B | Local core clone with tag |
   | C | `glab` / API |
   | D | Ephemeral clone |

   Validate tag with one anchor file under `core/`. On failure, stop.
   - If the team uses `branch-{tag}` on core, verify it exists (create only when the brief explicitly requests it).
   - If `client_branch` is set and the work tree is the client repo, checkout when possible; otherwise record the branch in the report header only.

4. **List files**

   ```bash
   find especifico/ -type f ! -name '.gitkeep' ! -name '.context.md' | sort
   ```

   Apply `ignored-paths.md`; honor scope from brief.

5. **Per file** — `RELATIVE` = path after `especifico/`; `CORE_PATH` = `core/` + `RELATIVE`.

6. **Compare** — fetch core content; diff vs local.

7. **Classify** (`diff-classification.md`, `customization-markers.md`)
   - Category: client-only | core fix | custom implementation | legacy | artifact
   - **Report Classificação:** `Para remover` | `Para modificar` | `Sem alteração` (Portuguese — per template)

8. **Report header** (both outputs when applicable) — include when known:
   - Core tag / commit if available
   - Client branch
   - Scope and ignored paths (legacy)

9. **`por arquivo` or `ambos`** — fill `templates/specifics/compare-by-file.md` →  
   `.memory/docs/specifics-sync/<YYYY-MM-DD>/01-analise-por-arquivo.md`  
   - Body date: `DD/MM/YYYY`
   - Per-file sections per template (Portuguese headings)

10. **`por tarefa` or `ambos`** — after file analysis, group per `task-grouping.md`; fill `templates/specifics/compare-by-task.md` →  
    `.memory/docs/specifics-sync/<YYYY-MM-DD>/02-analise-por-tarefa.md`

11. **Handoff** — paths to generated files, counts (`Para remover` / `Para modificar` / `Sem alteração`), high-impact highlights.

## Guardrails

- Never compare `main`/`HEAD`; only `target_release`.
- Never use `bin/` as comparison source.
- Never skip equal-to-core files in `01-analise-por-arquivo.md` when mode includes `por arquivo`.
- Never apply patches in this skill.
- Never dump full report body in chat.
