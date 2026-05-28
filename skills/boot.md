---
shortDescription: Session startup — gitignore, auto-update, memory, rules, context, CLI config, caveman, and greet.
usedBy: [maestro]
version: 0.5.2
lastUpdated: 2026-05-28
---

## Purpose

Every session starts cold. The Maestro needs to ensure the project is wired correctly, the framework is up to date, load the project's rules, and understand the codebase before it can dispatch work effectively. This skill defines the boot sequence that brings the Maestro from zero to ready.

## Path Convention

All framework files live under `.agents/`. Markdown references within the framework use bare paths for readability — always resolve them under `.agents/`. Shell commands always use the `.agents/` prefix for project-root paths.

## Procedure

Before step 1, enforce this startup behavior:
- Do not send acknowledgement-only messages (for example, "I read the instructions").
- Do not continue to dispatch, planning, or general conversation before boot finishes.
- Boot is complete only after step 9 greeting is sent.

1. **Gitignore.** Ensure `.agents/`, `.memory/`, and `opencode.json` are in the project's `.gitignore`. Run:

   ```bash
   touch .gitignore
   for entry in '.agents/' '.memory/' 'opencode.json' '.ignore'; do
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

4. **Product profile.** Read and follow `skills/product-profile.md`. Store `activeProducts` and per-product `repoKind` in the current session file under `## Product Context`. Note `activeProducts` for step 8 — no other `ext/` reads until the greeting block.

5. **CLI configuration.** Run:

   ```bash
   bash .agents/skills/assets/maestro-boot-configure-cli.sh <your-model-id>
   ```

   Pass your own model ID (e.g., `bailian-coding-plan/qwen3.6-plus`) so the script can resolve the correct provider when multiple providers share the same CLI.

    - If the script outputs `opencode.json created`, inform the user that the file was written and they should restart the session for agent bindings to take effect.
    - If the script outputs `opencode.json existed`, it means the file was already present and was updated — no restart required.
    - If `yq` or `jq` is not installed, the script prints a skip message — no action needed.
    - If no supported CLI config file is found, the script exits silently — no action needed.

6. **Load the rules index.** Read `rules/README.md` to know what rules are available and their scopes. Do not read the individual rule files — sub-agents will read them when dispatched.

7. **Context.** Verify the project has context files. Run:

   ```bash
   find . -name ".context.md" -not -path "*/node_modules/*" -not -path "*/.git/*" -not -path "*/vendor/*" -not -path "*/.cache/*" -print -quit
   ```

   Note the result — it is used in step 9.

8. **Caveman.** Activate only when caveman is available **to the current host runtime** — never because it exists on another IDE on the same machine (e.g. caveman in Cursor while running OpenCode).

   1. **Identify host runtime** — same procedure as `skills/dispatch.md` step 1 (`ps -p $PPID -o comm=` → `opencode`, `cursor-agent`, `claude`, `codex`, etc.). Store the host id for this session.
   2. **Host skills list** — if the runtime exposes an available-skills list, `caveman` must appear **there** to count as available. Do not infer availability from skills installed for other hosts.
   3. **Resolve on disk (current host only)** — run:

      ```bash
      bash .agents/skills/assets/maestro-boot-caveman-resolve.sh
      ```

      - `caveman: active host=<id> path=...` — skill exists for this host (project copy or host-specific install path).
      - `caveman: skip host=<id> reason=not_installed_for_host` — no skill for this host; **do not** activate and **do not** append the caveman greeting line.

   **Activate** when step 2 **or** step 3 reports availability. Otherwise skip silently. When activating, read the resolved skill file and apply **`/caveman ultra`**. Persist until `stop caveman` or `normal mode`. Code, commits, PR bodies, and sub-agent dispatch prompts stay normal.

   **Greeting exception:** step 9 uses the mandatory contract below in `pt-BR` (not caveman). Append the line below **only if** step 8 activated caveman — never on `caveman: skip`:

   > Modo **caveman** (`ultra`) ativo nas próximas respostas. Diga **normal mode** ou **stop caveman** para desligar.

9. **Greet.** Send the greeting below to the user now. This is the final and mandatory action of boot — do not add preamble, do not summarize, do not defer. Boot is not complete until this message is sent.

   If step 7 produced no output, append this line at the end of the greeting before sending:
   > Ainda não há mapa de contexto no repositório. Use o prompt de mapeamento de contexto com o escopo desejado para gerá-lo, ou diga se prefere seguir sem um.

   **Greeting contract (mandatory):**
   - Start with exactly:
      - `Olá! Sou o **Maestro** do AgentFlow.`
   - Right after the opening line, check the result of step 3 (session memory):
      - If there are `paused` or `in-progress` sessions, include a "Sessões em aberto" section listing them and ask the user to choose one action:
        1. `Retomar uma sessão específica`; or
        2. `Começar nova atividade`.
      - If there are no open sessions, continue the greeting normally without this section.
   - Then list available capabilities grouped by category. Do **not** read the template files — output this block as-is:

     **Geral**
     - Mapear contexto — `prompts/general/context-mapping.md`
     - Planejar implementação — `prompts/general/implementation-plan.md`
     - Implementar — `prompts/general/implementation.md`

     **Tarefa**
     - Revisar merge/MR — `prompts/task/code-review.md`
     - Gerar checklist de testes — `prompts/task/test-checklist.md`
     - Documentação Técnica — `prompts/task/tech-doc.md`
     - Documentação de Produto — `prompts/task/product-doc.md`
     - Documentação de Implementação — `prompts/task/implementation.md`

     **Suporte**
     - Análise inicial — `prompts/support/initial-analysis.md`
     - RCA — `prompts/support/rca.md`

   - If step 4 left `activeProducts` non-empty, append one category per id immediately after **Suporte** (same bullet format as above). For each `<product-id>` in `activeProducts`:
     - **Heading:** title from the first `# ` line in `ext/<product-id>/README.md`, or `<product-id>` if missing.
     - **Bullets:** one per `ext/<product-id>/prompts/**/*.md` file — path `ext/<product-id>/<relative-path>`.
     - **Label:** first non-empty line of that prompt (strip a trailing `:`); if missing, use the filename without `.md`.
     - Read only those README first lines and prompt first lines — not prompt bodies, `ROUTING.md`, skills, or rules.

   - End with exactly:
     > Diga qual fluxo quer usar e mostro o template para copiar e preencher.

   **Greeting ends here.**

   If both the step 7 context appendix and the step 8 caveman appendix apply, send in this order: greeting contract (including mandatory end line) → context appendix → caveman appendix.

## Guardrails

- Never skip rule loading. Dispatching without rules means dispatching without constraints.
- Never skip the framework pull. An outdated `.agents` directory means dispatching with stale instructions.
