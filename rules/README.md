# Rules

Rules are constraints — short, direct, and non-procedural. A rule that needs multiple pages to explain is likely a skill in disguise.

## Rule Hierarchy

- **Commandments** (`rules/commandments/`) — sacred, absolute, never bypassed.
- **Edicts** (`rules/edicts/`) — authoritative within their scope, shall not be bent.
- **Counsel** (`rules/counsel/`) — wise guidance, may be deviated from with justification.

## Available Rules

- **`commandments/git`** — Conventional commits, branch naming, commit style (coding)
- **`edicts/code-quality`** — Universal naming, testing, and quality conventions (coding)
- **`edicts/code-debugging`** — Root cause before fix, three-strike rule, anti-rationalization (coding)
- **`counsel/clarification`** — Ambiguity taxonomy for when to stop, proceed, or escalate (communication)
- **`support/support-initial-analysis`** — Initial backend support triage from a supplied support task link (support)
- **`support/support-root-cause-analysis`** — Support RCA with technical root cause and MR/PR correlation (support)
- **`global.mdc`** — Optional Cursor always-apply compatibility rule that points back to `AGENTS.md`

Product-scoped rules for extensions live under `ext/<product-id>/rules/` (e.g. `ext/uappi-v2/rules/specifics/`). They are listed at dispatch only when that product is active — see `docs/guide/product-extensions.md`.

## File Naming

Lowercase, hyphenated. Scoped rules are prefixed with the persona or domain they target: `coder-formatting.md`, not `formatting.md`. Universal rules carry no prefix.

## Schema (v0.1.0 // 2026-03-04)

### Frontmatter

- **`shortDescription`** (Required) — What the rule enforces in one sentence. Example: `Mandates .context.md updates on structural changes`
- **`scope`** (Required) — Task category this rule applies to. Example: `coding`
- **`version`** (Required) — Semantic version. Example: `0.1.0`
- **`lastUpdated`** (Required) — Last modification date. Example: `2026-02-05`

### Body

- **Statement** (Required) — The rule itself. Use RFC-style language: MUST, MUST NOT, SHOULD, SHALL, SHALL NOT. As short as the constraint allows.
- **Rationale** (Required) — Why this rule exists. One paragraph. Without rationale, rules feel arbitrary and get ignored.
