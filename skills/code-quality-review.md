---
shortDescription: Reviews code and plans against the project's coding rules.
usedBy: [reviewer]
version: 0.2.0
lastUpdated: 2026-07-09
---

## Purpose

A code review without a checklist drifts toward gut feeling — catching whatever the reviewer happens to notice while missing what they don't. This skill turns the project's coding rules into a repeatable review procedure. It tells the reviewer exactly what to inspect and in what order.

## Procedure

1. **Initialize the progress file.** Create `.memory/reviews/review-quality-<timestamp>.md`:

   ```markdown
   # Quality Review Progress
   
   ## Status
   - Last updated: <timestamp>
   - Overall: In Progress
   
   ## Phases
   - [ ] 1. Collect applicable rules
   - [ ] 2. Walk work against rules
   - [ ] 3. Verify style proximity
   - [ ] 4. Dedup findings
   
   ## Files
   - [ ] <path>
   - [ ] <path>
   
   ## Findings
   ```

2. **Collect the applicable rules.** Load all files from `rules/code/`. Also load any applicable rules (e.g., `rules/git.md`). Classify each rule's statements by RFC language:
   - **MUST / MUST NOT / SHALL / SHALL NOT** — violations are always Blockers. No exceptions.
   - **SHOULD / SHOULD NOT** — violations require justification visible in the code (a comment, a design note, or a `.context.md` entry). If the justification is clear, it is a Warning. If absent or unclear, it is a Blocker.

   If the codebase uses a specific language (e.g. Go), include the language-specific rule file if one exists. If the language has no dedicated file, apply only the general rules.

   Mark phase 1 as `[x]` in the progress file.

3. **Walk the work against every rule and classify findings.** Check each statement in each loaded rule file against the changed code or plan. Do not skip rules, do not paraphrase — the rules are the source of truth. Classify each issue found:
   - **Blocker** — MUST violation, unjustified SHOULD violation, readability violation (cryptic code is always a blocker). Must be fixed.
    - **Warning** — justified SHOULD deviation, minor inconsistency. Should be addressed.
   - **Note** — style suggestion beyond what rules mandate. No action required.

   After reviewing each changed file, update the progress file: mark the file as `[x]` with finding counts, add findings under `## Findings`:

   ```
   ### <file-path>
   
   **Blockers:**
   - <file>:<line> — <what violates which rule>. (rule: <rule-file-name>)
   
   **Warnings:**
   - <file>:<line> — <what violates which rule>. (rule: <rule-file-name>)
   
   **Notes:**
   - <file>:<line> — <observation>
   ```

   Mark the file as reviewed. Move to the next file only after the progress file is saved. Mark phase 2 as `[x]` when all files are reviewed.

4. **Verify style proximity.** For each changed file, run `ls` on its directory. Read one or two sibling files — pick those most similar in function to the changed code. Compare the changed code against the siblings. Flag any structural or pattern mismatch as a Warning.

   Add style findings to the progress file under each file's section. Mark phase 3 as `[x]`.

5. **Dedup findings.** Review all findings in the progress file. If a style proximity finding overlaps with a rule-based finding (e.g., both caught the same naming issue — one as style mismatch, one as rule violation), keep the rule-based finding and remove the style duplicate. The rule finding has a specific rule reference; the style finding is redundant.

   Mark phase 4 as `[x]` and set Overall to `Complete`. If review is interrupted, the progress file shows which phases were completed.

## Guardrails

- Never flag a SHOULD deviation as a blocker when justification is documented. SHOULD is guidance, not law — documented justification earns a warning, not a veto.
- Never invent rules. If an issue does not trace back to a loaded `code-` rule, it is a Note at most.
- Do not invent violations. If a pattern match is ambiguous, skip it rather than rationalizing it into a finding.
