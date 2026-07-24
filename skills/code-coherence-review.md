---
shortDescription: Reviews code and plans for logic coherence, correctness, and structural integrity.
usedBy: [reviewer]
version: 0.1.0
lastUpdated: 2026-07-02
---

## Purpose

A correct function that violates a naming rule can ship with a warning. A rule-compliant function with broken logic cannot ship at all. This skill checks the things that matter most — does the code make sense, does it survive real-world input, and does it respect the project's structural boundaries. It is the first pass in any review because nothing else matters until the code is coherent and correct.

## Procedure

1. **Logic coherence.** Read the work as a narrative. Trace the flow from entry point to exit. Check:
   - Does the algorithm solve what the task brief says it should?
   - Are there circular logic paths or infinite loops?
   - Do the data structures fit the problem, or is the code fighting its own model?
   - For plans: check for ambiguity (instructions that can be read two ways), logical gaps (steps that assume preconditions without establishing them), redundancy (duplicate steps), and contradictions.
   - For other work: review against the task brief's acceptance criteria. Stress-test for blindspots, ambiguity, and false assumptions.

2. **Dead code and obsolete artifacts.** Scan every changed file for code that is no longer useful or reachable. For each file, check:
   - **Unused functions and methods** — functions or methods defined but never called anywhere in the codebase. Run `rg -n 'func <name>'` or `rg -n 'def <name>'` to find definitions, then verify with `rg '<name>\('` that they are actually invoked elsewhere. If a function has zero callers, it is dead.
   - **Unused variables and constants** — variables or constants assigned but never read. Trace each assignment to its usage sites. Variables declared and initialized but never referenced in any subsequent statement are dead.
   - **Unused imports** — import statements for modules, packages, or symbols that are never referenced in the file. Compare every import against actual usage in the file body.
   - **Unreachable code** — code after `return`, `break`, `continue`, `raise`, `exit`, or `panic` statements within the same block. Code in conditional branches that can never be true (e.g., `if false`, `if 1 == 0`, or branches contradicted by earlier guards).
   - **Commented-out code blocks** — 3 or more consecutive lines of commented code without an explanatory comment justifying why the code is preserved. These are version control's job, not inline comments. If the comment explains the code is kept for migration reference, style example, or similar justification, do not flag. Otherwise, flag for removal.
   - **Obsolete TODO/FIXME comments** — TODO or FIXME comments that reference issues already resolved or code that no longer exists. Verify the context before flagging.
   - **Deprecated or superseded logic** — code paths that have been replaced by newer implementations but were not removed. Check for conditional branches that always take one path because a feature flag is permanently on/off, or old implementations kept "just in case" with no callers.

   For each finding, verify it is truly dead by searching the entire codebase for references. Do not flag something as dead if it is exported/public API, used via reflection, invoked dynamically, or called from test files.

3. **Correctness.** The logic is sound — now verify it survives real-world input. Walk each changed file and check:
   - Error paths — every error is handled or explicitly logged. No silent swallows.
   - Boundary conditions — off-by-one, nil/null, empty collections, zero values.
   - Concurrency — shared state is protected. No data races, no unguarded async mutations.
   - N+1 queries — loops that trigger a database query per iteration instead of batching.
   - Resource leaks — unclosed connections, file handles, channels, or transactions in error paths.
   - Retry logic — missing backoff, missing idempotency keys, thundering-herd potential on failure recovery.
   - Time handling — timezone assumptions, clock skew sensitivity, missing UTC normalization.
   - Stale reads — reading state, deciding, then acting without verifying the state still holds.
   - Missing indexes — new query patterns that will table-scan at production data volumes.
   - Missing timeouts — external calls (HTTP clients, database queries, third-party APIs) without a timeout. One slow dependency without a deadline cascades into a full system hang.
   - Backward compatibility — does this change break existing consumers? Removed or renamed fields, changed response shapes, stricter validation, or altered behavior on existing endpoints.
   - Incomplete work markers — `TODO`, `FIXME`, `HACK`, `XXX`, empty function bodies, stub implementations returning hardcoded values.
   - Test skip markers — `t.Skip()`, `pytest.mark.skip`, `.skip(`, `xit(`, `xdescribe(`, `xtest(`, or equivalent. Skipped tests hide regressions.

4. **Structural coherence.** Step back from individual lines. Read the `.context.md` files for affected directories to understand layer boundaries and directory purpose. Check:
   - Does the change respect those boundaries?
   - Are there new dependencies that break the dependency direction?
   - For plans: does any proposed change introduce a dependency that flows against the architecture's grain?

5. **Duplication detection.** Scan the changed code for logic, patterns, or methods that duplicate existing functionality in the codebase. For each changed file, check:
   - **Duplicated functions or methods** — functions that perform the same or nearly identical operations as existing functions elsewhere in the codebase. Compare the new function's logic, parameters, and return values against existing functions. Use `rg` to search for similar function names or patterns. If two functions differ only in minor details (e.g., one uses `log.Info`, the other uses `log.Debug`; one sorts ascending, the other descending with a flag), they should be consolidated.
   - **Duplicated logic blocks** — sequences of 5+ lines that appear in multiple places with identical or near-identical structure. Look for repeated patterns like data transformation pipelines, error handling and retry logic, validation sequences, database query patterns, HTTP request/response handling, or configuration parsing.
   - **Copy-pasted constants or configuration** — magic numbers, strings, or configuration values that appear in multiple places instead of being defined once as a constant or configuration.
   - **Reinvented utilities** — new implementations of functionality that already exists in standard libraries, third-party packages, or project utilities. Before flagging, verify the existing utility covers the use case.

   For each suspected duplication:
   1. Use `rg -n '<pattern>'` to find all occurrences of similar logic across the codebase
   2. Compare the implementations line by line
   3. If the duplication is substantial (5+ lines) and the variations are minor, flag it as a Warning
   4. Suggest consolidation: extract to a shared function, use a parameterized approach, or point to the existing utility

   Do not flag duplication if:
   - The duplicated code is in test files and is under 20 lines (test duplication is often acceptable for clarity). If test duplication exceeds 20 lines and the tests are clearly parameterizable, flag it as a Warning.
   - The code is intentionally duplicated for performance reasons (verify with comments)
   - The duplication spans different architectural layers and extracting it would create inappropriate dependencies

6. **Classify findings.** For each issue found, assign a severity:
   - **Blocker** — logic incoherence, correctness bug, architectural violation, plan contradiction, dead code that is exported/public API (misleading), massive duplication (20+ lines) with no abstraction. Must be fixed.
   - **Warning** — minor structural concern, edge case worth considering, dead code (unused private functions/variables), moderate duplication (5-19 lines). Should be addressed.
   - **Note** — observation or question. No action required.

## Guardrails

- Never skip the logic coherence step to jump to correctness. A correct implementation of broken logic is still broken.
- Never flag style, naming, or convention issues. Those belong to the quality review skill.
- Never flag dead code without verifying it is truly unused across the entire codebase. Search for all references before reporting.
- Never flag duplication without comparing the implementations line by line. Superficial similarity is not duplication — verify the logic, not just the structure.
