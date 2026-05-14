---
shortDescription: Diffs especifico/ files against the installed core version via GitLab MCP.
usedBy: [maestro, reviewer]
scope: uappi-v2
relatedTo: [gitlab-mcp]
version: 0.1.0
lastUpdated: 2026-05-14
---

## Purpose

Client repositories contain an `especifico/` folder that overrides core files. Over time these overrides can become stale, redundant, or misaligned with the current core version. This skill compares every file in `especifico/` against its counterpart in the core at the exact installed release, fetching core content via the GitLab MCP — no local core clone required. The output is a structured report that drives a concrete decision for each file: remove, rebase, or keep.

## Procedure

1. **Locate `especifico/`.** Find the folder from the project CWD:

   ```bash
   find . -maxdepth 3 -type d -name "especifico" | head -1
   ```

   If not found, stop and report — the skill cannot proceed.

2. **Read the installed release.**

   ```bash
   cat .wapstore/build
   # → {"release":"v2.8.12.2","date":"..."}
   ```

   Parse the `release` field. If the file does not exist, stop and report. Never guess the version.

3. **Validate the core repository link.** If the GitLab URL of the core repo was not provided in the initial prompt, escalate via `skills/agent-decision.md` before proceeding — never assume or infer the repository.

   Expected format: full GitLab URL, e.g. `https://gitlab.com/org/uappi`.
   Derive the project path for MCP calls: everything after `gitlab.com/` → `org/uappi`.

4. **List `especifico/` files**, excluding metadata:

   ```bash
   find especifico/ -type f \
     ! -name ".gitkeep" \
     ! -name ".context.md" \
     | sort
   ```

5. **For each file, fetch the core counterpart via GitLab MCP.**

   Compute the core path — `especifico/` mirrors `core/` directly:

   ```
   RELATIVE = file path without the "especifico/" prefix
   # e.g. classes/Vue/Vue.class.php
   CORE_PATH = "core/" + RELATIVE
   # e.g. core/classes/Vue/Vue.class.php
   ```

   Call the GitLab MCP:

   ```
   mcp_GitLab_get_file_contents(
     project_path: "<namespace/project>",
     file_path:    "<CORE_PATH>",
     ref:          "<release-tag>"
   )
   ```

6. **Classify each file** by the MCP response:

   | MCP result | Classification |
   |---|---|
   | File not found (`404`) | **ADDITION** — does not exist in the core |
   | Content identical to the local file | **IDENTICAL** — override has no effect |
   | Content differs | **MODIFIED** — generate diff |

   For MODIFIED files, generate the diff:

   ```bash
   diff <(echo "<mcp-content>") "especifico/<RELATIVE>"
   ```

7. **Sub-classify MODIFIED files by comment marker.** Check the local file for the markers defined in the project `.context.md`:

   - Contains `[ESPECÍFICO TEMPORÁRIO]` → temporary override, expected to be removed after a core update
   - Contains `[ESPECÍFICO PERMANENTE]` → permanent business rule, keep indefinitely
   - No marker → **NEEDS CLASSIFICATION**

8. **Produce the report** in Markdown:

   ````markdown
   ## Summary

   - Installed release: <tag>
   - Core: <link>
   - Total files in especifico/: N
   - Identical: N
   - Additions: N
   - Modified: N (temporary: N | permanent: N | unclassified: N)

   ## Identical — removal candidates

   - `<path>` — identical to core at <tag>

   ## Additions — no core counterpart

   - `<path>`

   ## Modified

   ### `<path>` [TEMPORARY | PERMANENT | NEEDS CLASSIFICATION]

   ```diff
   <diff>
   ```

   ## Recommended actions

   - **Identical**: remove from `especifico/` — they add nothing
   - **Unclassified**: add `[ESPECÍFICO TEMPORÁRIO]` or `[ESPECÍFICO PERMANENTE]`
   - **Temporary**: check whether the change has already been merged into the core at this version
   ````

## Guardrails

- Never compare against `HEAD` or `main` of the core — always use the exact installed release tag.
- Never assume the core link when not provided; escalate via `agent-decision.md`.
- Do not modify any files — this skill is read-only analysis. Fixes are the Coder's responsibility after the report is reviewed.
- Do not omit IDENTICAL files from the report — they are direct removal candidates.
