---
shortDescription: Session startup — gitignore, auto-update, memory, rules, context, CLI config, caveman, and greet.
usedBy: [maestro]
version: 0.4.7
lastUpdated: 2026-05-22
---

## Purpose

Every session starts cold. The Maestro needs to ensure the project is wired correctly, the framework is up to date, load the project's rules, and understand the codebase before it can dispatch work effectively. This skill defines the boot sequence that brings the Maestro from zero to ready.

## Path Convention

All framework files live under `.agents/`. Markdown references within the framework use bare paths for readability — always resolve them under `.agents/`. Shell commands always use the `.agents/` prefix for project-root paths.

## Procedure

Before step 1, enforce this startup behavior:
- Do not send acknowledgement-only messages (for example, "I read the instructions").
- Do not continue to dispatch, planning, or general conversation before boot finishes.
- Boot is complete only after step 8 greeting is sent.

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

   Note the result — it is used in step 8.

7. **Caveman.** Do not assume a specific IDE. Resolve the caveman skill in this order:

   1. **Host skills** — if the runtime exposes an available-skills list and `caveman` is listed, read that skill definition.
   2. **Project copy** — `.agents/skills/caveman/SKILL.md`, then `.agents/skills/caveman.md`.
   3. **User install** — first existing file among common host paths (probe with `test -f`):

      ```bash
      for f in \
        "${HOME}/.cursor/skills/caveman/SKILL.md" \
        "${HOME}/.claude/skills/caveman/SKILL.md" \
        "${HOME}/.codex/skills/caveman/SKILL.md" \
        "${HOME}/.config/caveman/SKILL.md"; do
        [ -f "$f" ] && echo "$f" && break
      done
      ```

   If none resolve, skip silently. Otherwise read the skill in full and activate **`/caveman full`** — always `full`, never `ultra` or other levels unless the user overrides later in the session. Persist until `stop caveman` or `normal mode`. Code, commits, PR bodies, and sub-agent dispatch prompts stay normal.

   **Greeting exception:** step 8 uses the mandatory contract below in `pt-BR` (not caveman). If step 7 activated caveman, append **after** "Greeting ends here." exactly one line:

   > Modo **caveman** (`full`) ativo nas próximas respostas. Diga **normal mode** ou **stop caveman** para desligar.

8. **Greet.** Send the greeting below to the user now. This is the final and mandatory action of boot — do not add preamble, do not summarize, do not defer. Boot is not complete until this message is sent.

   If step 6 produced no output, append this line at the end of the greeting before sending:
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

   - End with exactly:
     > Diga qual fluxo quer usar e mostro o template para copiar e preencher.

   **Greeting ends here.**

   If both the step 6 context appendix and the step 7 caveman appendix apply, send in this order: greeting contract (including mandatory end line) → context appendix → caveman appendix.

## Guardrails

- Never skip rule loading. Dispatching without rules means dispatching without constraints.
- Never skip the framework pull. An outdated `.agents` directory means dispatching with stale instructions.
