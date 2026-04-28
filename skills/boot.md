---
shortDescription: Session startup — gitignore, auto-update, memory, rules, context, CLI config, and greet.
usedBy: [maestro]
version: 0.4.4
lastUpdated: 2026-04-28
---

## Purpose

Every session starts cold. The Maestro needs to ensure the project is wired correctly, the framework is up to date, load the project's rules, and understand the codebase before it can dispatch work effectively. This skill defines the boot sequence that brings the Maestro from zero to ready.

## Path Convention

All framework files live under `.agents/`. Markdown references within the framework use bare paths for readability — always resolve them under `.agents/`. Shell commands always use the `.agents/` prefix for project-root paths.

## Procedure

Before step 1, enforce this startup behavior:
- Do not send acknowledgement-only messages (for example, "li as instruções").
- Do not continue to dispatch, planning, or general conversation before boot finishes.
- Boot is complete only after step 7 greeting is sent.

1. **Gitignore.** Ensure `.agents/`, `.memory/`, and `opencode.json` are in the project's `.gitignore`. Run:

   ```bash
   touch .gitignore
   for entry in '.agents/' '.memory/' 'opencode.json'; do
       grep -qxF "$entry" .gitignore || echo "$entry" >> .gitignore
   done
   ```

   This step is idempotent: if an entry already exists in `.gitignore`, do not add it again. Never duplicate existing lines.

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

   Note the result — it is used in step 7.

7. **Greet.** Send the greeting below to the user now. This is the final and mandatory action of boot — do not add preamble, do not summarize, do not defer. Boot is not complete until this message is sent.

   If step 6 produced no output, append this line at the end of the greeting before sending:
   > Ainda não há mapa de contexto no repositório. Use o bloco **Mapear contexto** com o escopo desejado para gerá-los, ou diga se prefere seguir sem.

   Build the greeting dynamically from prompt templates instead of hardcoding examples.

   **Greeting contract (mandatory):**
   - Start with exactly:
     - `Olá! Sou o **Maestro** do AgentFlow — framework de agentes da Uappi.`
   - Then list available prompt templates by reading these files under `.agents/`:
     - `prompts/general/context-mapping.md`
     - `prompts/general/implementation-plan.md`
     - `prompts/general/implementation.md`
     - `prompts/monday-gitlab/code-review.md`
     - `prompts/monday-gitlab/test-checklist.md`
     - `prompts/monday-gitlab/tech-doc.md`
     - `prompts/monday-gitlab/product-doc.md`
     - `prompts/monday-gitlab/implementation.md`
     - `prompts/support/initial-analysis.md`
     - `prompts/support/rca.md`
   - For each file, render:
     1. a short capability title inferred from the first line (e.g., `Revisar merge/MR`);
     2. the full prompt template content in a fenced `text` block, preserving line breaks and placeholders;
     3. the source path (for traceability).
   - End with fixed integration notes:
     - product/MR/docs flows: Monday `18383662197`, GitLab `agenciawebart/wapstore/wapstore`
     - support flows: Monday `8463166451`, same GitLab project

   **Greeting ends here.**

## Guardrails

- Never skip rule loading. Dispatching without rules means dispatching without constraints.
- Never skip the framework pull. An outdated `.agents` directory means dispatching with stale instructions.
