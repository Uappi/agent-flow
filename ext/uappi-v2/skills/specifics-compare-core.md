---
shortDescription: Compare especifico/ files against Wapstore core at release tag via GitLab.
usedBy: [specifics-sync]
product: uappi-v2
relatedTo: [gitlab-mcp, gitlab-api, glab]
version: 0.1.1
lastUpdated: 2026-05-27
---

## Purpose

Client repositories keep overrides in `especifico/` that must stay aligned with the compiled core. This skill compares each override file to its counterpart in the core GitLab repository at the **target** release tag supplied in the task brief (the version the client should be updated toward). The **installed** release from `.wapstore/build` is recorded in the report for context only — never used as the comparison tag unless the user explicitly sets the same value in "Versão alvo".

## Procedure

1. **Resolve paths** (follows: `ext/uappi-v2/rules/specifics/path-mapping.md`).
   - Client overrides live under `especifico/` (fixed).
   - `core_gitlab_project` = `agenciawebart/wapstore/wapstore` unless the task brief overrides.
   - `core_path_prefix` = `core/` (validate on first run via MCP).

2. **Resolve releases** (two distinct values):
   - **`target_release`** (required) — tag in task brief under `Versão alvo do core (tag)` (or equivalent). If missing or empty, stop with blocker: *informe a versão alvo do core no prompt; `.wapstore/build` é só a versão instalada atual.*
   - **`installed_release`** (informational) — read `.wapstore/build` field `release` when present; include both tags in the report header. Do not compare against `installed_release` unless it equals `target_release` because the user chose that tag.

3. **Resolve core access** — all fetches use **`target_release`** only: (prefer first available; Maestro validates via `skills/pre-dispatch-check.md`):

   | Priority | Path | Use when |
   |----------|------|----------|
   | A | **GitLab MCP** | `get_file_contents` works for project + tag |
   | B | **Local core clone** | Work tree or path in brief is `wapstore/wapstore` (or core repo) with tag checked out |
   | C | **`glab` / GitLab API** | Token in env; fetch file API at ref |
   | D | **Ephemeral clone** | `git clone` + `git checkout <tag>` to temp dir (last resort; document path in handoff) |

   Validate tag: read one anchor file under `core/` at that ref. On failure, stop with blocker.

4. **List client files:**

   ```bash
   find especifico/ -type f ! -name '.gitkeep' ! -name '.context.md' | sort
   ```

   Honor scope subdirectory from brief if provided.

5. **For each file**, compute:

   ```
   RELATIVE = path without leading "especifico/"
   CORE_PATH = core_path_prefix + RELATIVE
   ```

   Example: `especifico/wapstore/classes/Foo.class.php` → `core/wapstore/classes/Foo.class.php`

6. **Fetch core content** for `CORE_PATH` at tag using the resolved access path from step 3. Record which path was used in the report header.

7. **Classify:**

   | Core fetch result | Classification |
   |-------------------|----------------|
   | Not found at tag | **ADDITION** — client-only file |
   | Same as local | **IDENTICAL** — override has no effect |
   | Different | **MODIFIED** — produce diff |

8. **Sub-classify MODIFIED** (follows: `ext/uappi-v2/rules/specifics/diff-classification.md`, `customization-markers.md`):
   - Scan for `[ESPECÍFICO PERMANENTE]`, `[ESPECÍFICO TEMPORÁRIO]`, `ESPECÍFICO`
   - Apply priority: customização própria → correção do core → implementação customizada → legado → artefato

9. **Merge suggestion** for MODIFIED:
   - Port structural changes from core (new methods, properties, signatures)
   - Preserve marked client blocks
   - Never recommend blind full-file replace

10. **Write report** using `ext/uappi-v2/templates/specifics/compare-by-file.md` to:

    `.memory/docs/specifics-sync/<YYYY-MM-DD>/01-analise-por-arquivo.md`

11. **Summary** in handoff: counts, high-impact MODIFIED paths, IDENTICAL removal candidates.

## Guardrails

- Never compare against `main`, `master`, or `HEAD` of core.
- Never use `.wapstore/build` as `target_release` without the user stating that tag under "Versão alvo" in the prompt.
- Never treat `bin/` as primary truth — only `especifico/` vs GitLab core at tag.
- Never omit IDENTICAL files from the report.
- Never apply patches in this skill — compare only.
- MCP is preferred when available; local clone or API is equally valid when pre-dispatch confirmed access.
- If no path can read core at tag, stop — do not guess file contents.
