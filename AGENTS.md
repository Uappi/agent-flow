# AGENTS.md

A style book for code that reads itself. Internalize the reasoning, apply the judgment, write code that the next reader can follow without reverse-engineering.

## Code Shape

Getting function boundaries right means the reader never reassembles scattered logic or untangles mixed concerns. Three questions: what to extract, what to unify, what to keep together.

### Function Extraction

Extract a function when it performs a transformation through genuine logic — input processed into distinct output. Inline a function when its body delegates to a single call with trivial wrapping (rename, forward, reformat). A 60-line function performing one operation is correct; a 5-line function that wraps another call is indirection. The test: removing the function and inlining its body at the call site — does the caller lose clarity or gain it?

### Duplication

Two code paths that share knowledge require synchronized edits — a change to one demands the same change to the other. Unify them. Two code paths that look similar but answer different questions are two responsibilities that happen to resemble each other. Shared code couples them; when one question evolves the other drags. The test: would a requirement change affect both paths identically? Identical → unify. Divergent → the resemblance is coincidental, keep separate.

### Single Responsibility

One reason to change per function, module, file. A function that parses input and validates it and builds the domain object from the parsed values has one reason to change — the input contract; all three steps share its fate. A function that parses input and validates it and then maps to a separate domain model has two reasons — the input contract and the domain model change independently. The test: "if the requirements change, would these operations change independently?" Independent → split. Shared fate → keep together — length is not the signal.

### Readability Over Performance

When choosing between a clever solution and a simple one, prefer simple. Clever patterns — `Array.from` with callbacks, Fisher-Yates shuffles, bitwise hacks, dense one-liners, or any construct that requires prior knowledge to understand — should be avoided. Use plain loops and simple logic. Every line should read as plain English to a human who has never seen the codebase. Performance optimization is justified only when a measured bottleneck demands it.

## Naming and Communication

The reader should learn what a variable holds or a function does from the name without inspecting the body. When the name fails, a comment takes its place — and a comment that explains what the code does is compensation for a name that failed. Logging is the third channel: the message that surfaces at 3am is a search key, not prose.

### Naming

Names convey intention and purpose, not content. `runIndex` says it's a loop counter for runs; `i` says nothing. `resolvedPaths` says these went through resolution; `paths` restates the type. `numberWithinRange` says what `%` produced. The bare operation says how, not what.

- Compound names when a single word lacks specificity (`collectionName`, not `name`).
- Single-letter names are forbidden — no `i`, `j`, `n`, `e`. Every variable needs a descriptive name.
- Functions describe what they produce, not how they produce it (`resolveLoadoutPaths`, not `emitYqUnionQuery`).
- Names survive a tool swap (`fetchMessagingUsers`, not `fetchSlackUsers`).
- Booleans answer a question in their name (`IsAdmin`, `HasSession`, `ShouldRetry`).
- Type in the name when ambiguous from context (`rawRandomInteger`, not `rawRandomNumber`).
- Parameters make sense from the signature alone, without reading the call site.

### Comments Are a Signal

When code needs a comment to explain what it does, the names or the structure failed — the comment is compensation. A comment earns its place when an external constraint forces a decision that naming and structure cannot clarify — a workaround for an upstream bug, a performance choice that contradicts the readable version. The comment explains why, never what.

### Logging

PascalCase without spaces — `UserCreated`, `PaymentFailed`, `TokenExpired`. Greppable, unambiguous word boundaries. A log message is a search key.

## Flow and Structure

The reader should follow the happy path without indentation, see where every value comes from, and encounter each function before meeting its callers.

### Control Flow

Guard clauses first: handle the invalid case, return early, keep the happy path unindented and visible. Avoid `else` in logic — the early return already expressed the branch. `else` is acceptable in metalanguages such as templates, where early return is not available and two visible branches aid comprehension. When multiple `if` blocks test the same variable, a `switch` or strategy dispatch says "I am branching on this one thing" more clearly than stacked conditionals.

Visible assignment: when a function returns a value, the reader sees where it lands. An API that mutates in place hides the origin of every value; restructuring so the assignment is explicit (`result := transform(input)`) makes the data flow visible. No `=` sign means the reader traces the call to learn what changed.

### Structure

- Functions ordered top-down: a function is defined above its first caller, so the reader understands each piece before meeting the code that uses it.
- Constructors sit immediately after their type declaration — the type and its constructor are one concept.
- Lines kept short enough to read without horizontal scrolling.

### Style Proximity

Before writing or editing a file, read one or two sibling files in the same directory — pick those most similar in function to the change. Match their structure, naming, and patterns. Code that follows the rules but contradicts local convention creates a seam the next reader trips over — a patchwork quilt. The rules say what good code looks like in the abstract; the siblings say what good code looks like here. When the existing codebase contradicts a rule in this book, follow the local convention and flag the divergence — consistency within the file's neighborhood outweighs abstract correctness.

## Boundaries

External data and external failures are where production breaks — they need explicit, single-point handling so the rest of the code can assume safe input and loud errors.

### Data Enters Untrusted

User input, database results, API responses, environment variables, file contents — all enter untrusted, regardless of origin. A database row is no safer than a query parameter; both carry stale state or malformed values.

- The value object's constructor is the single validation point: if data passes construction, it's safe downstream.
- Raw external data flows into queries, templates, or commands only after construction.
- The constructor is the parse function — a standalone `parseFoo(raw)` alongside a `Foo` with a validating constructor is the same operation expressed twice.

### Errors Are Loud

An error that passes without a log entry is a silent failure — the kind that surfaces at 3am as "it just stopped working." Errors are always logged.

- Propagation depends on context: a side-effect failure may log and continue; a critical failure propagates through the language's error mechanism.
- Process termination (`panic`, `os.Exit`, `throw`) is a startup tool — when a required dependency is missing or config is invalid, failing fast is correct. Once serving, every failure is graceful because a serving process that crashes takes its users with it.

### Hardcoding

Content that originates from a backend, API, or config should not be hardcoded in source. One source of truth — a hardcoded value drifts from the config the next reader will edit.

### Dependency Audit on Feature Change

When adding a feature or mechanism that changes the behavior of an existing dependency (config file, registry, shared data structure), audit the affected dependency for: shared entries that belong in a shared layer, entries the new mechanism makes redundant, and logic the new mechanism fully replaces. The feature is not complete until duplicates are removed.

### Schema Changes

Database schema modifications should be explicitly stated in any handoff or commit summary.

## Verification

Tests and debugging exist to catch what the author missed — they fail their purpose when they test implementation instead of behavior, or treat symptoms instead of causes.

### Testing as Behavior Verification

Tests verify behavior: given this input, the output is this. A test that breaks when internals are refactored without changing behavior is testing the wrong thing — it's a maintenance burden wearing a safety net's clothes. Table-driven tests express the variation cleanly. Infrastructure tests hit real external APIs because mocking at the boundary hides the integration failure that's the whole point of testing there. Secrets stay out of tests. Each test file owns its setup and teardown inline — independence across files, order-dependence allowed within a file when it reflects a natural workflow.

Each test file should handle its own setup and teardown inline — a test that leaves state behind poisons the next test's assumptions. Test setup helpers belong inside the test function (as a closure or local function), prefixed with the test name, or encapsulated in a struct — not as package-level functions. When helpers are extracted to the file level, setup helpers go above the test and teardown goes at the end of the file.

### Debugging as Investigation

Root cause before fix. Read the error, reproduce the failure, check recent changes, trace the data flow to origin — treating symptoms creates new bugs while the original one keeps growing. One fix at a time, because bundling makes it impossible to know which change resolved the issue. After three failed attempts, the approach is the problem, not the attempt — stop and reconsider the framing. "Should work now" is confidence without evidence; "already tested" ignores that code changed since; "trivial change" is how production breaks; "I see the problem" is seeing the symptom, not the cause. When stuck, find a working example of the same pattern in the codebase and diff it against the broken one — the difference is more informative than the error message.

### Code Review

Review focuses on three areas, each with its own skill: coherence — logic, correctness, structural alignment (`skills/code-coherence-review.md`); quality — coding standards, naming, style (`skills/code-quality-review.md`); security — OWASP, attack surface, data flow (`skills/code-sec-review.md`). A change touching auth, external input, or data flow always warrants review; a one-line typo fix does not. For large changes, split the review — one pass per focus — so each reviewer goes deep. Findings must be verified against the codebase before acting on them. A reviewer reads and reports — it creates no files in the codebase; all findings belong in the review handoff.

## Native Tooling

Use native file operation tools (Edit, Read, Write, Grep, Glob) directly. Writing scripts (Python, Bash, etc.) to perform file reads, edits, searches, or any file system operation creates unnecessary friction — scripts require authorization and review. The native tools are purpose-built for these operations and execute without approval overhead.

## Git

Conventional commit prefixes (`feat:`, `fix:`, `refactor:`, `docs:`, `test:`, `chore:`), short single-phrase messages — if the message needs to describe too much, the commit should have been split. One logical change per commit: when staged work spans concerns, split — each commit independently rollbackable. Branch names follow the same prefixes: `feat-*`, `fix-*`, `refactor-*`, `docs-*`, `test-*`, `chore-*`. Avoid squash and rebase — merge commits preserve the true history; rewriting history risks destroying work and misleading anyone who reads the log.

## Context Maintenance

When a change alters a directory's purpose, structure, or key dependencies, update its `.context.md` in the same commit — a stale context file misleads the next reader (follows: `skills/context-maintenance.md`). When a change adds, removes, or alters a user-facing feature, update `docs/FEATURE-MAP.md` — a stale feature map sends the next reader down the wrong path. Both are part of the logical change, separate concerns.

## Frontend

Every piece of UI is a component with a single responsibility. Components should model their states explicitly (loading, empty, populated, error) and handle each one. State that affects multiple components lives in a shared store; state that affects only one stays local. Follow the existing design system — when it lacks what is needed, flag it rather than inventing a pattern. Interactive UI components should be keyboard-navigable.
