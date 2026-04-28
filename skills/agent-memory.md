---
shortDescription: Long-term and session memory across sessions.
usedBy: [maestro]
version: 0.2.1
lastUpdated: 2026-04-25
---

## Purpose

Agents start cold every session — lessons learned, user preferences, and interrupted work vanish the moment a conversation ends. This skill defines a file-based memory system with two layers: long-term memory (accumulated project knowledge that feeds into every sub-agent dispatch) and session memory (a running interaction log that lets the next session pick up with full context). Together they close a self-learning loop: feedback given once is remembered forever, and work interrupted once can be resumed with the complete conversation trail.

## Procedure

1. **Check for the memory directory.** Look for `.memory/` at the project root. If it does not exist, create it with `long-term.md` (initialized with the section headers from the long-term schema below) and a `session/` subdirectory (empty).

2. **Read session memory at session start.** List all files in `.memory/session/`. For each file with status `paused` or `in-progress`, read its Current Task and last few log entries. Present the list to the user and ask which action to take:
   - **Resume** a paused session — that session becomes the current session. If it has an Active Todo, read the todo and include its unchecked items in the summary.
   - **Start new** — create a new session file in `.memory/session/` (naming convention below). Any existing paused sessions remain on disk for later.
   - Files with status `done` are stale — ignore them.

3. **Read long-term memory.** Read `.memory/long-term.md`. This step is read-only — do not modify long-term memory here.

4. **Record lessons as they surface.** Watch for learning signals throughout the session — do not wait for the user to explicitly frame something as "feedback." Three signal tiers govern when to write:
   - **Strong signal — explicit statement.** The user says "I prefer X," "always do Y," "never do Z." Record immediately.
   - **Medium signal — correction.** The user modifies, rejects, or overrides a sub-agent's output. Extract the underlying preference or rule.
   - **Weak signal — implicit pattern.** The user consistently does X across multiple interactions but has never stated it. Do not record yet — wait for a strong or medium signal to confirm.

   Write mechanics: one line per entry. Before appending, scan the section for duplicates or contradictions. If a new entry contradicts an existing one, replace the old entry.

5. **Update session memory on every interaction.** After each meaningful interaction — user request, sub-agent dispatch, sub-agent handoff, user feedback, or decision — update the current session file:
   - **Log entry:** Append a one-line summary prefixed with timestamp and actor to the Log section.
   - **Timestamp:** Run `date '+%Y-%m-%d %H:%M'` — never guess or reuse prior values. Use `%Y-%m-%d` for the `Last Active` field and the full `%Y-%m-%d %H:%M` for the log entry prefix.
   - **Active Todo:** When a sub-agent creates a todo (uses: `skills/task-tracking.md`), set the field to the todo file path. When the todo is closed, clear the field.

6. **Distill session into long-term memory before closing.** When the session ends, scan the session log for reusable lessons. Extract corrections (user changed or rejected output), failed approaches (what did not work and why), and decisions (structural or architectural choices). Verify that preferences stated during the session were captured in step 4 — capture any that were missed. Prune existing entries that are superseded or stale.

   Write insight, not inventory. "User prefers small focused PRs" is a lesson. "User asked for a small PR on 2026-03-18" is a log entry — it belongs in session memory, not long-term. Append new entries using the same deduplication rules as step 4.

7. **Mark session complete or paused.** After distillation (or if the session ends mid-work), set the status in the current session file to `done` or `paused` respectively. The next session start will pick it up in step 2.

## Schemas

### Long-term memory (`long-term.md`)

```markdown
## Preferences

- <one preference per line>

## Feedback

- <one feedback entry per line>

## Learned Rules

- <one rule per line>

## Discovered Issues

- <one issue per line — pre-existing bugs, tech debt, or code smells found during work but outside the current task's scope>

## Project Notes

- <one note per line>
```

The five sections above are the defaults. Maestro may create additional sections when an entry does not fit any existing one. New sections follow the same entry format.

**Schema notes:**

- Entries are plain text, one line each. No nested lists, no multi-line blocks.
- Deduplication and contradiction replacement happen at write time (step 5).
- The user may prune or reorganize manually at any time.

**Size discipline:**

- Target: under 80 entries total across all sections. When approaching this threshold, prune aggressively during distillation (step 6).
- Every entry must answer: "Will this actually help a future session?" If not, it does not belong.
- Prefer updating an existing entry over adding a new one when they cover the same concern.

### Session memory (`.memory/session/<slug>.md`)

```markdown
## Status

<in-progress | paused | done>

## Last Active

YYYY-MM-DD

## Current Task

<brief description of what is being worked on>

## Active Todo

<path to the active todo file, e.g. `.memory/todo/2026-02-18-feat-user-auth.md` — omit section if no todo exists>

## Log

- `YYYY-MM-DD HH:MM` **[actor]** <what happened>
- `YYYY-MM-DD HH:MM` **[actor]** <what happened>
```

**Naming convention:** Each session file is `.memory/session/<slug>.md`, where `<slug>` is a short kebab-case summary of the task (e.g., `refactor-auth-module.md`, `feat-user-auth.md`). Multiple session files can coexist — one per task.

**Actor values:** `user`, or the persona name — e.g. `maestro`, `architect`, `coder`, `reviewer`.

**Example** (`.memory/session/refactor-auth-module.md`):

```markdown
## Status

paused

## Last Active

2026-02-18

## Current Task

Refactor auth module into a separate package.

## Active Todo

.memory/todo/2026-02-18-refactor-auth-module.md

## Log

- `2026-02-18 14:02` **[user]** Asked to refactor the auth module into a separate package.
- `2026-02-18 14:02` **[maestro]** Dispatched architect to draft a refactor plan.
- `2026-02-18 14:10` **[architect]** Returned a plan: extract auth into `pkg/auth`, update imports, add tests.
- `2026-02-18 14:11` **[user]** Approved the plan but asked to skip tests for now.
- `2026-02-18 14:11` **[maestro]** Noted preference (skip tests). Dispatched coder with the approved plan.
- `2026-02-18 14:25` **[coder]** Completed phase 1. 8 files changed. Phase 2 pending.
- `2026-02-18 14:26` **[maestro]** Session paused — user stepping away. Phase 2 remains.
```

**Schema notes:**

- **Status** is `in-progress`, `paused`, or `done`.
- **Active Todo** records the path to the current todo file (uses: `skills/task-tracking.md`). When resuming a paused session, the Maestro must read this file and relay its unchecked items to the sub-agent so work picks up where it stopped. Omit the section entirely when no todo exists. Clear it when the todo is closed.
- **Log** is append-only within a session. Each entry is a single line.
- **Keep entries concise.** Record only what matters for resuming: what was requested, what was dispatched, what was delivered, and what decisions were made. Skip intermediate chatter, routine acknowledgements, and details that can be recovered from the code or commit history. The log is a breadcrumb trail, not a transcript.
- When resuming a session, keep the existing log and continue appending.

## Guardrails

- Never write from weak signals alone. Record explicit statements and corrections (strong and medium signals). Do not record implicit patterns until confirmed by a stronger signal.
- Never leave a stale session file. If work is complete, set status to `done`. If the session ends mid-work, set status to `paused`. Either way the log must reflect the last thing that happened.
- Never store sensitive data (credentials, tokens, secrets) in either memory file.
- Never let sub-agents write directly to `.memory/`. Memory writes are Maestro's responsibility — sub-agents return output, Maestro decides what to remember.
