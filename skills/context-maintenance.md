---
shortDescription: How to maintain .context.md files and optionally docs/FEATURE-MAP.md as the project evolves.
usedBy: [coder, contextualizer]
version: 0.2.0
lastUpdated: 2026-04-24
---

## Purpose

Every directory in a project has a `.context.md` that orients whoever arrives next — human or agent. These files answer "what lives here" so that agents and developers can navigate the codebase without reading every file. If your project tracks features, maintain `docs/FEATURE-MAP.md` alongside `.context.md` files — the feature map answers "how does this feature work end-to-end." This skill defines when and how to keep both accurate as the project evolves, and the schemas they must follow.

## Procedure

### .context.md

1. **Scope.** Prefer scanning from `src/` as the root. Skip hidden/dot directories (`.vscode`, `.claude`, `.git`, `.github`, etc.) and generated, vendored, or ephemeral directories (`node_modules`, `dist`, `.cache`, `__pycache__`, `vendor`).

2. **Determine if an update is needed.** A `.context.md` update is required when a change alters the purpose of a directory, adds or removes files/dependencies, or changes naming conventions. Bug fixes, formatting, and refactors that preserve structure do not require updates.

3. **Write or update the `.context.md` inside the affected directory following the schema below.**

4. **Commit together.** The `.context.md` update MUST be in the same commit as the structural change. Do not defer.

### Schema

```markdown
<context path="relative/path" updated="YYYY-MM-DD">

One to two sentences describing what this directory contains and why it
exists.

## Summary

- filename.ext — short description of what this file does
- filename.ext — short description of what this file does
- subdirectory/ — short description of what this subdirectory contains

## Constraints

- MUST / MUST NOT statements. Non-negotiable constraints specific to this directory.

## Guidance

- SHOULD / SHOULD NOT statements. Recommendations that may be deviated from with justification.

</context>
```

**Schema notes:**

- The opening `<context>` tag carries the relative path and a last updated date.
- The description is prose, not a list. Answer "what is here" and "why does it exist."
- Summary covers every file and subdirectory. One line each.
- Constraints and Guidance are optional — only include them when the directory has rules worth stating. Use RFC-style language.
- Keep it short. This file will be read frequently by multiple agents.

### docs/FEATURE-MAP.md (Optional)

If your project tracks features, maintain `docs/FEATURE-MAP.md` alongside `.context.md` files. The feature map is an index that maps every user-facing feature to the code path that implements it.

5. **Determine if a feature map update is needed.** An update is required when a change:
   - Adds, removes, or renames a user-facing feature.
   - Alters the information flow of an existing feature (new layer, different service, changed entry point).
   - Moves or renames files that appear in an existing feature path.

   An update is NOT required for:
   - Bug fixes that do not change the flow.
   - Internal refactors that preserve the same entry points and layers.
   - Style, formatting, or test-only changes.

6. **If `docs/FEATURE-MAP.md` does not exist yet, create it** using this schema. If it exists, update only the affected entries.

```markdown
# Feature Map

> Auto-maintained index of every user-facing feature and the code path that implements it. Updated alongside the code — not after the fact.

## [Feature Name]

Brief description of what this feature does from the user's perspective.

**Flow:**

1. `path/to/entry-point.ext` — what happens here (e.g., route handler, CLI command)
2. `path/to/service.ext` — what happens here (e.g., validation, orchestration)
3. `path/to/repository.ext` — what happens here (e.g., persistence, external call)
4. `path/to/presenter.ext` — what happens here (e.g., response formatting, template rendering)

---
```

**Schema notes:**

- One section per feature, separated by horizontal rules.
- The feature name is the user-visible name, not an internal module name.
- The flow lists files in the order information travels — from entry point to final output.
- Each step is a file path plus a short phrase describing that file's role in the flow.
- Keep descriptions to one line. If a step needs more, the code or its `.context.md` should explain.
- If a feature branches (e.g., sync vs async path), show the primary path and note the branch.

## Guardrails

- Never invent purpose. If a directory's role is unclear after reading its contents, say so.
- If a constraint looks like it should apply project-wide rather than to this directory alone, flag it to the user but do not modify the `.agents/` directory. That directory is managed via git.
- Never add a feature to the map that you cannot trace end-to-end through the code. If the path is unclear, say so.
- Never update the `updated` date in a `.context.md` `<context>` tag unless the content of that file actually changed. Touching the date without a content change creates false drift signals.
