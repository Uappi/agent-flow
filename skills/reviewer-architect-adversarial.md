---
shortDescription: Adversarial plan review — structural validation and assumption attack before implementation begins.
usedBy: [reviewer]
version: 0.5.0
lastUpdated: 2026-06-26
---

## Purpose

A plan that survives adversarial scrutiny before implementation saves hours of rework after. Code review catches bugs in what was built — this skill catches flaws in what is about to be built. It validates the plan's structural soundness (do the referenced files and APIs exist? do phases cover all acceptance criteria?) and then attacks its assumptions (where will this break? what is the plan taking for granted?). The goal is to surface problems when fixing them costs a plan revision, not a code rewrite.

## Procedure

1. **Read the plan end-to-end.** Understand the goal, information flow, phases (each with before/after, method signatures, and test specs), acceptance criteria, and scope mode rationale.

2. **Initialize the progress file.** Create `.memory/reviews/review-architecture-<timestamp>.md` and save it before proceeding:

   ```markdown
   # Architecture Review Progress

   ## Status
   - Last updated: <timestamp>
   - Overall: In Progress

   ## Phases
   - [ ] 1. Completeness
   - [ ] 2. Structural validation
   - [ ] 3. Coverage
   - [ ] 4. Assumptions
   - [ ] 5. Standards
   - [ ] 6. Scope
   - [ ] 7. Phase dependencies
   - [ ] 8. Phase size

   ## Findings
   ```

   Do not proceed until the file exists on disk.

3. **Completeness.** For each question, answer yes or no. A "no" is a Blocker. Write findings to the progress file under `## Findings` with heading `### Completeness`. Mark phase 1 as `[x]`. Save the file before proceeding to step 4.
   - Does the plan contain a `## Goal` section with at least one sentence?
   - Does the plan contain a `## Information Flow` section that traces the request path through layers?
   - Does the plan state a scope mode with rationale?
   - Does every phase contain `**Before:**` and `**After:**` entries with at least one sentence each?
   - Does every phase contain a `**Methods:**` section with at least one explicit method signature?
   - Does every phase contain acceptance criteria (numbered and measurable)?
   - Does every phase contain test specifications (Good, Bad, Ugly) for each method?
   - Does every phase contain a stress test section (Inversion, Subtraction, Weakest link)?
   - Does every phase contain `**Planned commits:**` with at least one conventional commit message?
   - Does the plan contain `## Feature Map Changes`, `## Changelog`, and `## Estimated Total LOC` sections?
   - **Clean rewrite check.** Does the plan file contain ZERO strikethrough markup (`~~text~~`), "Revised:" annotations, "no longer" phrasing, or diff-style markers (e.g., `[was: X]`, `(removed)`, `+added`/`-removed`)? If any are present, the Architect annotated a previous version instead of rewriting it — this is a Blocker. The fix is a clean rewrite from scratch, not a touch-up.

4. **Structural validation.** Build lists from the plan, then verify each item. Write findings to the progress file under `### Structural validation`. Mark phase 2 as `[x]`. Save the file before proceeding to step 5.
   - **Information flow.** Does the `## Information Flow` section trace a complete path from user entry point through each layer to infrastructure and back? Missing layers or handoffs: Warning. Completely absent or incoherent: Blocker.
   - **Method signatures.** For each phase, list every method signature in the `**Methods:**` section. Verify names follow the project's naming conventions (responsibility-first, no tool names, compound names). Names that are vague or violate conventions: Warning.
   - **Reference files.** Does each phase list at least one reference file? Missing from one or more phases: Warning.
   - **Files to modify.** List every existing file path the plan says to change. For each, run: `test -f "path/to/file" && echo "EXISTS" || echo "MISSING"`. A "MISSING" is a Blocker.
   - **Files to create.** List every new file path the plan says to add. For each, run: `test -d "$(dirname "path/to/file")" && echo "EXISTS" || echo "MISSING"`. A "MISSING" parent directory is a Blocker.
   - **Named entities claimed as existing.** List every function name, type name, endpoint path, or interface name the plan references as already existing in the codebase. For each, search the codebase: `grep -r "entity_name" -l` (adapt file extensions to the project's languages if you want to narrow results). Zero results is a Blocker. Entities the plan proposes to create are excluded — those are new, not existing.
   - **Phase ordering.** If the plan has multiple phases, write the dependency chain: Phase 1 → Phase 2 → etc. For each arrow, write what the earlier phase produces and what the later phase consumes. If a later phase consumes something no earlier phase produces, that is a Blocker. If the chain loops back to an earlier phase, that is a Blocker.
   - **Layer boundaries.** If the project documents its architecture (e.g., in `.context.md`, an architecture skill, or a dedicated architecture file), read it. For each file the plan touches, write which layer it belongs to. For each pair of files in different layers, write the dependency direction. If any dependency points from an inner layer to an outer layer, that is a Blocker.

5. **Coverage.** Build columns and cross-reference. Write findings to the progress file under `### Coverage`. Mark phase 3 as `[x]`. Save the file before proceeding to step 6.
   - **Column A:** Number each acceptance criterion from the plan.
   - **Column B:** Number each implementation phase.
   - For each criterion in Column A, write which phase(s) in Column B deliver it. If a criterion has no matching phase, that is a Blocker (under-delivery).
   - For each phase in Column B, write which criterion(s) in Column A it serves. If a phase has no matching criterion, that is a Warning (orphan work).
   - **Test cap check.** For each method in each phase, count test specs per lens (Good, Bad, Ugly). More than 1 per lens per method: Warning (over-specification).
   - For each test specification, write which criterion it verifies. If a test verifies no criterion, that is a Warning (wasted test).

6. **Assumptions.** Scan the plan for each pattern below. For each match, verify or flag. Write findings to the progress file under `### Assumptions`. Mark phase 4 as `[x]`. Save the file before proceeding to step 7.
   - **Library capability.** Does the plan say a library or framework can do something (e.g., "supports streaming", "has built-in validation")? Confirm by checking, in order: the library's README, its official documentation, then its source code. Stop at the first source that answers the question. Unverified: Warning.
   - **Schema existence.** Does the plan reference a database table, column, index, or migration by name? Search migration files or schema definitions to confirm it exists: `grep -r "table_or_column_name" -l` (adapt file extensions to the project's languages). Zero results: Warning.
   - **API contract.** Does the plan reference a response field, status code, or endpoint behavior from an external or internal API? Read the handler or client code to confirm the contract matches. Unverified: Warning.
   - **Environment.** Does the plan reference an environment variable, config key, or infrastructure resource (queue, bucket, cache) by name? Search config files and deployment manifests to confirm. Unverified: Warning.

7. **Standards.** Read every rule loaded in the `<rules>` block. For each plan phase that specifies an implementation approach (library choice, pattern, query style, error handling strategy, naming convention), verify the approach does not contradict any loaded rule. A contradiction is a Blocker. Write findings to the progress file under `### Standards`. Mark phase 5 as `[x]`. Save the file before proceeding to step 8.

8. **Scope.** Compare the original request against the plan's phases and information flow, line by line. Write findings to the progress file under `### Scope`. Mark phase 6 as `[x]`. Save the file before proceeding to step 9.
   - List each distinct thing the original request asks for. For each, find the phase or information flow segment that satisfies it. If no matching segment exists, that is a Blocker (under-delivery).
   - List each file or abstraction the plan creates. For each, find the request sentence that motivated it. If no matching sentence exists and the plan does not explain why it is necessary, that is a Warning (scope creep).

9. **Phase dependencies.** For each phase, answer. Write findings to the progress file under `### Phase dependencies`. Mark phase 7 as `[x]`. Save the file before proceeding to step 10.
   - List every file this phase modifies or creates. Does any other phase modify or create the same file? If yes and neither phase declares a dependency on the other, that is a Warning (hidden coupling).
   - List every artifact this phase produces (a new file, a new table, a new endpoint). Does a later phase reference that artifact? If yes, is the dependency declared in the later phase's prerequisites? If not, that is a Warning (undocumented dependency).

10. **Phase size.** For each phase, check the estimated LOC (lines of code: insertions + deletions). Write findings to the progress file under `### Phase size`. Mark phase 8 as `[x]`. Save the file before proceeding to step 11.
    - **LOC threshold.** Does the phase estimate exceed 800 LOC? If yes, that is a Blocker — the phase must be split into smaller phases. The Architect persona targets ~600 LOC per phase with an 800 LOC hard cap (follows: `personas/architect.md` step 8C).
    - **Missing estimate.** Does the phase have an estimated LOC? If not, that is a Blocker — every phase must include an LOC estimate.

11. **Assemble findings.** Read the progress file. For each finding, verify the severity:
    - **Blocker** — logic incoherence, missing required section, file/entity not found, architectural violation, unmet acceptance criterion. Must be fixed.
    - **Warning** — minor structural concern, edge case, over-specification, orphan work. Should be addressed.
    - **Note** — observation or question. No action required.

    Format each finding as:

    ```
    - [<phase>: <check name>] Expected: <what the plan claims or requires>. Found: <what verification revealed>. Fix: <concrete action for the Architect>.
    ```

    Example:
    ```
    - [Structural validation: File existence] Expected: `src/auth/handler.go` exists (plan says to modify it). Found: file does not exist. Fix: verify the correct path or remove from plan.
    ```

    Group findings under `### Blockers`, `### Warnings`, and `### Notes` headings. Set Overall status to `Complete`. Deliver using the handoff format (follows: `skills/reviewer/reviewer-handoff.md`).

## Guardrails

- Never approve a plan you have not verified against the codebase. Reading the plan is not enough — check that what it references actually exists.
- Never flag simplicity concerns as Blockers. A plan that over-engineers is suboptimal, not broken. Simplicity issues are Warnings.
- Never critique the plan's writing style, formatting, or structure — only its substance. If the plan is clear enough to implement, its prose is fine. The clean rewrite check (step 3) is a structural requirement, not a style critique.
