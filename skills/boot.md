---
shortDescription: Session startup — gitignore, auto-update, memory, rules, context, and greet.
usedBy: [maestro]
version: 0.3.3
lastUpdated: 2026-03-26
---

## Purpose

Every session starts cold. The Maestro needs to ensure the project is wired correctly, the framework is up to date, load the project's rules, and understand the codebase before it can dispatch work effectively. This skill defines the boot sequence that brings the Maestro from zero to ready.

## Path Convention

All framework files live under `.agents/`. Markdown references within the framework use bare paths for readability — always resolve them under `.agents/`.

## Procedure

1. **Gitignore.** Ensure `.agents/` and `.memory/` are in the project's `.gitignore`. Run:

   ```bash
   touch .gitignore
   grep -qxF '.agents/' .gitignore || echo '.agents/' >> .gitignore
   grep -qxF '.memory/' .gitignore || echo '.memory/' >> .gitignore
   ```

2. **Framework pull.** Run:

   ```bash
   git -C .agents pull
   ```

   - If the pull brought changes:
     - Read the `CHANGELOG.md` in `.agents` to understand what changed.
     - Purge obsolete long-term memory entries — compare `.memory/long-term.md` against the changelog and remove any entry that the update now handles natively.
     - Stop and reboot — re-read the Maestro persona from the top so updated instructions take effect.
   - If already up to date, continue.

3. **Memory.** Load long-term memory (uses: `skills/agent-memory.md`).

4. **Load the rules index.** Read `rules/README.md` to know what rules are available and their scopes. Do not read the individual rule files — sub-agents will read them when dispatched.

5. **Context.** Verify the project has context files. Run:

   ```bash
   find . -name ".context.md" -not -path "*/node_modules/*" -not -path "*/.git/*" -not -path "*/vendor/*" -not -path "*/.cache/*" -print -quit
   ```

   - If `find` produces no output, no `.context.md` files exist. Dispatch the **Contextualizer** (uses: `personas/contextualizer.md`) before proceeding.

6. **Greet.** Greet the user and wait for instructions.

## Guardrails

- Never skip rule loading. Dispatching without rules means dispatching without constraints.
- Never skip the framework pull. An outdated `.agents` directory means outdated instructions.
