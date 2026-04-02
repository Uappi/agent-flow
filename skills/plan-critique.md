---
shortDescription: Adversarial plan review — structural validation and assumption attack before implementation begins.
usedBy: [reviewer]
version: 0.0.1
lastUpdated: 2026-04-02
---

## Purpose

Code review catches bugs in what was built — this skill catches flaws in what is about to be built. The goal is to surface problems when fixing them costs a plan revision, not a code rewrite.

## Procedure

1. **Read the plan end-to-end.** Understand the goal, current state, target state, affected areas, phases, acceptance criteria, and confidence rating.

2. **Completeness checklist.** For each question, answer yes or no. A "no" is a Blocker.
   - Does the plan state a goal or objective (in any section or form)?
   - Does the plan describe the target state after implementation (in any section or form)?
   - Does the plan contain acceptance criteria (either in a dedicated section or inline within phases)?
   - If the project has existing tests or is greenfield, does every phase contain test specifications?

3. **Structural validation checklist.** Build two lists from the plan, then verify each item.
   - **Files to modify.** List every existing file path the plan says to change. For each, run: `test -f "path/to/file" && echo "EXISTS" || echo "MISSING"`. A "MISSING" is a Blocker.
   - **Files to create.** List every new file path the plan says to add. For each, run: `test -d "$(dirname "path/to/file")" && echo "EXISTS" || echo "MISSING"`. A "MISSING" parent directory is a Blocker.
   - **Named entities.** List every function name, type name, endpoint path, or interface name the plan mentions. For each, search the codebase: `grep -r "entity_name" -l` (narrow with `--include` for the project's language). Zero results is a Blocker.
   - **Phase ordering.** If the plan has multiple phases, write the dependency chain: Phase 1 → Phase 2 → etc. For each arrow, write what the earlier phase produces and what the later phase consumes. If a later phase consumes something no earlier phase produces, that is a Blocker. If the chain loops back to an earlier phase, that is a Blocker.
   - **Layer boundaries.** If the project documents its architecture (e.g., in `.context.md` or a dedicated architecture file), read it. For each file the plan touches, write which layer it belongs to. For each pair of files in different layers, write the dependency direction. If any dependency points from an inner layer to an outer layer, that is a Blocker.

4. **Coverage checklist.** Build two columns and cross-reference.
   - **Column A:** Number each acceptance criterion from the plan (or from the original request if the plan inherited them).
   - **Column B:** Number each implementation phase.
   - For each criterion in Column A, write which phase(s) in Column B deliver it. If a criterion has no matching phase, that is a Blocker (under-delivery).
   - For each phase in Column B, write which criterion(s) in Column A it serves. If a phase has no matching criterion, that is a Warning (orphan work).
   - For each test specification, write which criterion it verifies. If a test verifies no criterion, that is a Warning (wasted test).

5. **Assumption checklist.** Scan the plan for each pattern below. For each match, verify or flag.
   - **Library capability.** Does the plan say a library or framework can do something (e.g., "supports streaming", "has built-in validation")? Search the library's source or docs to confirm. Unverified: Warning.
   - **Schema existence.** Does the plan reference a database table, column, index, or migration by name? Search migration files or schema definitions to confirm it exists: `grep -r "table_or_column_name" -l` (narrow with `--include` for the project's language). Zero results: Warning.
   - **API contract.** Does the plan reference a response field, status code, or endpoint behavior from an external or internal API? Read the handler or client code to confirm the contract matches. Unverified: Warning.
   - **Environment.** Does the plan reference an environment variable, config key, or infrastructure resource (queue, bucket, cache) by name? Search config files and deployment manifests to confirm. Unverified: Warning.

6. **Scope checklist.** Compare the original request against the plan's target state, line by line.
   - List each distinct thing the original request asks for. For each, find the sentence in the target state that satisfies it. If no matching sentence exists, that is a Blocker (under-delivery).
   - List each file or abstraction the plan creates. For each, find the request sentence that motivated it. If no matching sentence exists and the plan does not explain why it is necessary, that is a Warning (scope creep).

7. **Phase dependency checklist.** For each phase, answer:
   - List every file this phase modifies or creates. Does any other phase modify or create the same file? If yes and neither phase declares a dependency on the other, that is a Warning (hidden coupling).
   - List every artifact this phase produces (a new file, a new table, a new endpoint). Does a later phase reference that artifact? If yes, is the dependency declared in the later phase's prerequisites? If not, that is a Warning (undocumented dependency).

8. **Assemble findings.** Collect all findings from steps 2–7. Each finding already has a severity (Blocker or Warning) assigned by the checklist that produced it. Findings that do not fit any checklist item but seem worth mentioning are Notes. Format each finding as:

   ```
   - [Step <N>: <check name>] Expected: <what the plan claims or requires>. Found: <what verification revealed>. Fix: <concrete action for the Architect>.
   ```

   Example:
   ```
   - [Step 3: File existence] Expected: `src/auth/handler.go` exists (plan says to modify it). Found: file does not exist. Fix: verify the correct path or remove from plan.
   - [Step 5: API contract] Expected: `GET /users` returns a `roles` field. Found: handler returns `permissions`, not `roles`. Fix: update plan to use the actual field name.
   ```

   Group findings under `### Blockers`, `### Warnings`, and `### Notes` headings so the output slots directly into the review handoff format (follows: `skills/reviewer-handoff.md`).

## Guardrails

- Never approve a plan you have not verified against the codebase. Reading the plan is not enough — check that what it references actually exists.
- Never flag simplicity concerns as Blockers. A plan that over-engineers is suboptimal, not broken. Simplicity issues are Warnings.
- Never critique the plan's writing style, formatting, or structure — only its substance. If the plan is clear enough to implement, its prose is fine.
