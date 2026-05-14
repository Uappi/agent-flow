---
shortDescription: Produces a structural brief from .context.md files for codebase orientation.
usedBy: [contextualizer]
version: 0.1.0
lastUpdated: 2026-05-14
---

## Purpose

When a task requires planning or review of a multi-file codebase region, a quick orientation document is needed that maps modules, boundaries, and information flow — without generating full `.context.md` files. This skill defines that format and how to produce it.

## Procedure

1. Read `.context.md` files for the directories relevant to the task. If no `.context.md` files exist, scan the directory structure and file names directly.
2. Map modules: for each relevant directory, extract its purpose and key files.
3. Map boundaries: identify which modules communicate with which, and what the interface contracts are.
4. Map information flow: trace how data moves between modules or directories for the task's scope.
5. Produce the structural brief in this exact format:

   ```
   ## Structural Brief

   ### Modules
   - [directory]: [purpose, key files]

   ### Boundaries
   - [what talks to what, interface contracts]

   ### Information Flow
   - [data flow between modules or directories]
   ```

## Guardrails

- Never invent module purpose. If a directory's role is unclear, say so rather than guess.
- Never add boundaries or flow steps you cannot verify from code or `.context.md` files.
- Keep entries to one line each — this is an orientation document, not full documentation.
