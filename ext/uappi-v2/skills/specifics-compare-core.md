---
shortDescription: Compare especifico/ files against Wapstore core at release tag via GitLab.
usedBy: [specifics-sync]
product: uappi-v2
relatedTo: [gitlab-mcp, gitlab-api, glab]
version: 0.2.0
lastUpdated: 2026-05-27
---

## Purpose

Compare `especifico/` to core on GitLab at `target_release`, classify per `rules/specifics/*`, write reports from templates. Do not apply changes. Do not paste full reports in chat — only paths and summary counts in handoff.

## Procedure

Follow `ext/uappi-v2/rules/specifics/workflow.md`.

1. **Resolve inputs**
   - **`target_release`** — task brief; if missing, stop.
   - **`report_mode`** — `por arquivo` | `por tarefa` | `ambos`; if missing, stop.
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
   - If the team uses `branch-{tag}` on core, verify it exists (create only when brief explicitly requests it).
   - If `client_branch` is set and the work tree is the client repo, checkout when possible; otherwise record the branch in the report header only.

4. **List files**

   ```bash
   find especifico/ -type f ! -name '.gitkeep' ! -name '.context.md' | sort
   ```

   Apply `ignored-paths.md`; honor scope from brief.

5. **Per file** — `RELATIVE` = path after `especifico/`; `CORE_PATH` = `core/` + `RELATIVE`.

6. **Compare** — fetch core content; diff vs local.

7. **Classify** (`diff-classification.md`, `customization-markers.md`)
   - Categoria: customização própria | correção do core | implementação customizada | legado | artefato
   - **Classificação no relatório:** Para remover (igual ao core) | Para modificar (diferente) | Sem alteração

8. **Report header** (both outputs when applicable) — include when known:
   - Tag core / commit se disponível
   - Branch cliente
   - Escopo e arquivos ignorados (legado)

9. **`por arquivo` or `ambos`** — fill `templates/specifics/compare-by-file.md` →  
   `.memory/docs/specifics-sync/<YYYY-MM-DD>/01-analise-por-arquivo.md`  
   - Data no corpo: `DD/MM/YYYY`
   - Seções por arquivo conforme template (Descrição do ESPECÍFICO, Comportamento do CORE, etc.)

10. **`por tarefa` or `ambos`** — after file analysis, group per `task-grouping.md`; fill `templates/specifics/compare-by-task.md` →  
    `.memory/docs/specifics-sync/<YYYY-MM-DD>/02-analise-por-tarefa.md`

11. **Handoff** — paths dos arquivos gerados, contagens (Para remover / Para modificar / Sem alteração), destaques de alto impacto.

## Guardrails

- Never compare `main`/`HEAD`; only `target_release`.
- Never use `bin/` as comparison source.
- Never skip IDENTICAL-equivalent files in `01-analise-por-arquivo.md` when mode includes por arquivo.
- Never apply patches in this skill.
- Never dump full report body in chat.
