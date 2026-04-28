---
shortDescription: Session startup — gitignore, auto-update, memory, rules, context, CLI config, and greet.
usedBy: [maestro]
version: 0.4.3
lastUpdated: 2026-04-28
---

## Purpose

Every session starts cold. The Maestro needs to ensure the project is wired correctly, the framework is up to date, load the project's rules, and understand the codebase before it can dispatch work effectively. This skill defines the boot sequence that brings the Maestro from zero to ready.

## Path Convention

All framework files live under `.agents/`. Markdown references within the framework use bare paths for readability — always resolve them under `.agents/`. Shell commands always use the `.agents/` prefix for project-root paths.

## Procedure

1. **Gitignore.** Ensure `.agents/`, `.memory/`, and `opencode.json` are in the project's `.gitignore`. Run:

   ```bash
   touch .gitignore
   for entry in '.agents/' '.memory/' 'opencode.json'; do
       grep -qxF "$entry" .gitignore || echo "$entry" >> .gitignore
   done
   ```

2. **Framework pull.** Run:

   ```bash
   git -C .agents pull
   ```

   - If the pull brought changes:
     - Read the `CHANGELOG.md` in `.agents` to understand what changed.
     - Purge obsolete long-term memory entries — read `.memory/long-term.md`, read the changelog, and for each memory entry remove it only if the changelog describes a feature, skill, or rule that replaces that memory's purpose. If the entry's purpose is not clearly covered by the changelog, keep it.
     - Re-read `personas/maestro.md` from the top so updated instructions take effect.
   - If already up to date, continue.

3. **Memory.** Load memory (uses: `skills/agent-memory.md`).

4. **CLI configuration.** Run:

   ```bash
   bash .agents/skills/assets/maestro-boot-configure-cli.sh <your-model-id>
   ```

   Pass your own model ID (e.g., `bailian-coding-plan/qwen3.6-plus`) so the script can resolve the correct provider when multiple providers share the same CLI.

    - If the script outputs `opencode.json created`, inform the user that the file was written and they should restart the session for agent bindings to take effect.
    - If the script outputs `opencode.json existed`, it means the file was already present and was updated — no restart required.
    - If `yq` or `jq` is not installed, the script prints a skip message — no action needed.
    - If no supported CLI config file is found, the script exits silently — no action needed.

5. **Load the rules index.** Read `rules/README.md` to know what rules are available and their scopes. Do not read the individual rule files — sub-agents will read them when dispatched.

6. **Context.** Verify the project has context files. Run:

   ```bash
   find . -name ".context.md" -not -path "*/node_modules/*" -not -path "*/.git/*" -not -path "*/vendor/*" -not -path "*/.cache/*" -print -quit
   ```

    - If `find` produces no output, no `.context.md` files exist. Dispatch the **Contextualizer** (uses: `personas/contextualizer.md`) before proceeding.

7. **Greet.** Greet the user in Portuguese and wait for instructions. The first user-visible message after boot MUST be assembled at runtime (do not hardcode the full prompt bodies in this skill).

   Required behavior for the greeting:
   - Keep the opening short (`Maestro` intro + context-map line).
   - Include workflow examples in the same boot message, but load them from the corresponding files in `prompts/` at runtime.
   - Preserve each prompt text exactly as written in its source file.
   - If a prompt file is missing, skip only that item and explicitly report which file was not found.

   Prompt sources:
   - `prompts/monday-gitlab/code-review.md`
   - `prompts/monday-gitlab/test-checklist.md`
   - `prompts/monday-gitlab/tech-doc.md`
   - `prompts/monday-gitlab/product-doc.md`
   - `prompts/monday-gitlab/implementation.md`
   - `prompts/support/initial-analysis.md`
   - `prompts/support/rca.md`

   The final greeting must still mention fixed integrations: Monday `18383662197` and GitLab `agenciawebart/wapstore/wapstore` for product/MR flows, and Monday `8463166451` for support flows.

## Guardrails

- Never skip rule loading. Dispatching without rules means dispatching without constraints.
- Never skip the framework pull. An outdated `.agents` directory means outdated instructions.
