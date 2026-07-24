---
shortDescription: Debugging methodology — root cause before fix, strike limits, anti-rationalization.
scope: coding
version: 0.0.1
lastUpdated: 2026-03-25
---

## Statement

### Root Cause First

Coders MUST NOT propose or apply a fix before completing a root cause investigation. Reading error messages, reproducing the failure, checking recent changes, and tracing the data flow to the origin — these are mandatory before any code change. Treating symptoms instead of causes wastes time and creates new bugs.

### One Fix at a Time

Each fix attempt MUST be a single, isolated change. Bundling multiple fixes in one attempt makes it impossible to determine which change resolved the issue — or which introduced a new one. "While I'm here" improvements are prohibited during debugging.

### The Three-Strike Rule

After three failed fix attempts for the same issue, the coder MUST stop and question whether the approach is fundamentally wrong. Three failures is strong evidence of an architectural problem, a misunderstood requirement, or missing context. In interactive sessions, the coder MUST NOT attempt a fourth fix without explicit user direction — present what was tried, why each attempt failed, and what alternatives exist. In non-interactive dispatches, follow the loop-recovery skill (`skills/loop-recovery.md`) which provides the escalation path.

### Anti-Rationalization

The following rationalizations MUST be treated as red flags that trigger a return to root cause investigation:

- "Should work now" — confidence is not evidence. Run the test.
- "Already tested earlier" — code changed since then. Test again.
- "Trivial change" — trivial changes break production. Verify.
- "Quick fix for now, investigate later" — later never comes. Investigate now.
- "I see the problem" — seeing symptoms is not understanding root cause. Trace the data flow.
- "It's probably X" — probably is not diagnosed. Confirm before fixing.

### Compare Before Fixing

When a pattern or integration is broken, coders SHOULD locate a working example of the same pattern in the codebase and compare it against the broken version before proposing changes. The difference between working and broken code is often more informative than the error message.

## Rationale

Systematic debugging (investigate, hypothesize, test, fix) resolves issues in minutes. Random fix attempts ("try this and see") spiral into hours of thrashing. The three-strike rule prevents sunk-cost escalation — when three different approaches fail, the problem is not the approach but the understanding. The anti-rationalization list catches the most common patterns where agents skip investigation and jump to guessing.
