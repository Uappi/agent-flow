---
shortDescription: Universal code quality conventions for all languages.
scope: coding
version: 0.3.0
lastUpdated: 2026-04-25
---

## Statement

### KISS

When choosing between a clever solution and a simple one, prefer simple. The simplest solution that fully solves the problem is correct. Complexity is a liability, not a feature. If a solution requires the reader to understand a design pattern, an algorithm, or a non-obvious language feature, a simpler alternative likely exists.

### DRY

Each piece of knowledge or behavior SHOULD have a single, unambiguous representation. When two code paths do the same thing, they should share a function, a variable, or a constant. If a change to one block requires an identical change to another, the duplication is a bug waiting to happen.

### Single Responsibility Principle

Functions, modules, and files SHOULD have one reason to change. A function that performs setup AND reporting, or parsing AND validation, has two responsibilities and SHOULD be split. When in doubt, ask: "if the requirements change, would these two operations change independently?" If yes, split. If no, keep together.

### Variable Naming

Variable names MUST convey intention or purpose, not describe content. Single-letter variable names MUST NOT be used.

### Function Naming

Function names SHOULD NOT embed infrastructure or tool names (e.g., `resolveOpencodeConfigPath`). Use generic terms that describe the role (`resolveSupportedCliConfigPath`). The function should survive a tool swap without needing a rename.

### Error Handling

Errors MUST always be logged. An error that passes without a log entry is a silent failure. Handling depends on context — if the error is non-critical, it may be logged and not propagated, but it must never be swallowed silently.

### Process-Killing Exceptions

Language constructs that terminate the process (`panic`, `os.Exit`, unhandled `throw`, `process.exit`, etc.) used during runtime SHOULD be flagged. They are acceptable during application startup or initialization — if a required dependency is missing, a config is invalid, or a precondition for running is unmet. Once the application is serving, process-killing constructs are frowned upon — failures SHOULD be handled through the language's error propagation mechanism.

### Data Trust Boundary

Data from outside the code — user input, database results, API responses, environment variables, file contents — SHOULD be treated as untrusted regardless of origin. A database row is no safer than a query parameter; both can carry injection payloads, malformed values, or stale state.

External data flowing directly into queries, templates, commands, or domain operations without validation SHOULD be flagged. The recommended pattern is to convert external data into a value object (or language-equivalent typed representation) before use in business logic — the constructor or factory becomes the single validation point.

### Testing

Complex logic MUST have unit tests. Test error messages MUST be descriptive and provide context. Secrets, certificates, and private keys MUST NOT be hardcoded in tests.

Tests MUST be independent — each test sets up and tears down its own state. Tests that depend on execution order or shared mutable state break silently when parallelized or reordered.

Test data SHOULD use factories or builders, not hardcoded literals. Hardcoded test data obscures which values matter for the assertion and which are incidental.

Tests MUST verify behavior (input to output), not implementation details. A test that breaks when internals are refactored without changing behavior is a maintenance burden, not a safety net.

### Schema Changes

Database schema modifications MUST be explicitly stated in any handoff or commit summary.

### Comments

Comments SHOULD be treated as a code smell. If a block needs a comment to be understood, review the logic first — the code itself may need to be clearer. Comments are acceptable only when the logic cannot speak for itself.

## Rationale

These conventions produce code that reads linearly, names that communicate intent, and tests that explain failures. They reduce cognitive load during review and make codebases navigable by both humans and agents who arrive without prior context. When a work repository provides `README.ai.md`, its local architecture and implementation conventions complement this rule and take precedence over generic model assumptions.
