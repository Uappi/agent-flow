---
shortDescription: Structured review summary format with verdict logic and confidence scale.
usedBy: [reviewer]
version: 0.0.1
lastUpdated: 2026-04-02
---

## Purpose

This skill defines the output format for review handoffs — the structured summary a Reviewer delivers after inspecting work. It standardizes verdicts, confidence scoring, and planned-commit messaging so that downstream consumers (Maestro, human reviewers) can act on findings without re-reading the review.

## Procedure

1. **Assemble the review summary** using the template below. Omit empty sections.

```markdown
## Review Summary

**Verdict:** <pass | partial-pass | fail>
**Type:** <code | architecture | documentation | configuration | other>

### Blockers

- <description> (rule: <rule-name>, if applicable)

### Warnings

- <description> (rule: <rule-name>, if applicable)

### Notes

- <description>

### Confidence
**<0–5>** — <1–2 sentence reasoning>
Scale: 0 = no confidence (could not review meaningfully), 1 = very low (shallow review, missing criteria), 2 = low (obvious paths only, significant gaps), 3 = moderate (solid, minor blind spots), 4 = high (thorough coverage), 5 = full (every path inspected, rules checked).
```

2. **Determine the verdict.**
   - `pass` — zero blockers and all review steps completed.
   - `partial-pass` — zero blockers but a review step was skipped (e.g., external tool unavailable).
   - `fail` — one or more blockers.

3. **Append planned commits on failure.** When the verdict is `fail` and the type is `code`, add a "Planned Commits" section after Notes with conventional-commit messages (follows: `rules/commandments/git.md`) describing the fixes being requested. This gives the next step ready-made commit messages once the fixes land.

## Guardrails

- Never omit the Confidence section — it is required on every review.
