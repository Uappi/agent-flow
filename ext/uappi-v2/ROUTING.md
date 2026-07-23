# Uappi v2 — Maestro routing

Read this file when `uappi-v2` is in `activeProducts` (session `## Product Context`).

## Prompt → persona

| Trigger | Persona path | Mode |
|---------|--------------|------|
| First line of `prompts/task/specifics-compare.md` (`Comparar específicos:`) | `ext/uappi-v2/personas/specifics-sync.md` | compare |
| Equivalent user intent (e.g. sync client specifics with core) when `repoKind: client` | same | compare |
| First line of `ext/uappi-v2/prompts/general/requirements-gathering.md` (`Levantar requisitos`) | `ext/uappi-v2/personas/requirements-elicitor.md` | elicit (per-round re-dispatch — see `## Requirements Chain` below) |

## Gates

- **`repoKind: core`:** Do **not** dispatch `specifics-sync`. Tell the user the comparador requires a **client** repository with `especifico/` and `.wapstore/build`, or an absolute client path and target release in the brief.
- **`repoKind: client`:** Dispatch `specifics-sync` only after `skills/pre-dispatch-check.md` passes.
- **Requirements gathering has no `repoKind` gate** — dispatchable in both `client` and `core` repos, unlike `specifics-sync` (which requires `client`). No `especifico/`/`.wapstore/build` check applies to this flow.

## Apply phase

After compare, if the user confirms applying patches, dispatch `personas/coder.md` with handoff from `specifics-sync` and skill `ext/uappi-v2/skills/specifics-apply-patches.md`. Run `skills/review-loop.md`.

## Requirements Chain

`ext/uappi-v2/prompts/general/requirements-gathering.md` opens a 4-stage chain. Stage 1 is a variable-length dialogue loop, not a single dispatch — the mechanism below is load-bearing and must not be redesigned ad hoc.

1. **Elicitor dialogue loop.** Because personas dispatch non-interactively, Maestro re-dispatches `ext/uappi-v2/personas/requirements-elicitor.md` once per conversational round, passing the accumulated dialogue transcript (original ask + every prior question/answer pair) each time. Maestro relays the Elicitor's question/challenge/reaction to the analyst in chat, waits for her reply, and repeats. **The standard review-loop (`skills/review-loop.md`) does NOT run after these intermediate rounds** — only a single question/challenge/idea is being relayed each time, not a deliverable.
2. **Recap approval checkpoint.** On explicit request, the Elicitor produces a synthesis ending in an itemized recap. When the analyst sends an explicit agreement message (e.g. "concordo com tudo" — not silence, not partial agreement), the review-loop runs once against the approved recap before it becomes drafting input. If this review fails, re-dispatch `ext/uappi-v2/personas/requirements-elicitor.md` for a revised recap, with the reviewer's findings attached, then re-review — the same generic rule as `skills/review-loop.md`: re-dispatch whichever persona produced the failing output.
3. **Writer.** Dispatch `ext/uappi-v2/personas/requirements-writer.md` with the approved recap and the analyst's literal agreement message. It saves `ext/uappi-v2/templates/general/requirements.md` to `.memory/docs/requirements/<slug>/requisitos.md` and returns the path. The review-loop runs once against this output. If this review fails, re-dispatch `ext/uappi-v2/personas/requirements-writer.md` with the reviewer's findings attached, then re-review — same generic rule.
4. **Validator.** Dispatch `ext/uappi-v2/personas/requirements-validator.md` with that path. It appends findings to the same document's `### Pontos de Atenção` section in place. The review-loop runs once against this output. If this review fails, re-dispatch `ext/uappi-v2/personas/requirements-validator.md` with the reviewer's findings attached, then re-review — same generic rule.
5. **Architect intake.** Dispatch `personas/architect.md` (core, unchanged) with the validated document (path and content) supplied as research context in the task brief — its existing playbook step 1 already accepts supplied research context.

**Summary of where the review-loop fires:** exactly 3 checkpoints (recap approval, Writer output, Validator output) — never mid-dialogue during step 1's rounds. This is an explicit, intentional exception to Maestro's generic Playbook step 6 ("every dispatched sub-agent's output goes through the review-loop") for this one chain's exploratory stage. At every one of the 3 checkpoints, a failed review re-dispatches whichever persona produced the failing output (Elicitor for the recap, Writer for `requisitos.md`, Validator for the appended findings) with the reviewer's findings attached, then re-reviews — the standard `skills/review-loop.md` convention, not a bespoke mechanism.

## Dispatch paths

Use `ext/uappi-v2/personas/specifics-sync.md` (not `personas/specifics-sync.md`).

Rules: all `ext/uappi-v2/rules/specifics/*.md` with scope `specifics-sync`.

Skills: `ext/uappi-v2/skills/specifics-compare-core.md` (compare); `specifics-apply-patches.md` (apply).

Reports: `01-analise-por-arquivo.md` and/or `02-analise-por-tarefa.md` per brief field **Relatório** (`por arquivo` | `por tarefa` | `ambos`) — templates in `templates/specifics/`. Full report body saved to disk only, not in chat.

Use `ext/uappi-v2/personas/requirements-elicitor.md`, `ext/uappi-v2/personas/requirements-writer.md`, `ext/uappi-v2/personas/requirements-validator.md` (not core `personas/...`).

No scoped rules for this flow — `ext/uappi-v2/rules/` currently holds only `specifics/*` (scope `specifics-sync`); none apply here, and no new scope is introduced.

Templates: `ext/uappi-v2/templates/general/requirements.md`.
