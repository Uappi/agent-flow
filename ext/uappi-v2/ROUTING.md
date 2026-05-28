# Uappi v2 — Maestro routing

Read this file when `uappi-v2` is in `activeProducts` (session `## Product Context`).

## Prompt → persona

| Trigger | Persona path | Mode |
|---------|--------------|------|
| First line of `prompts/task/specifics-compare.md` (`Comparar específicos:`) | `ext/uappi-v2/personas/specifics-sync.md` | compare |
| Equivalent user intent (e.g. sync específicos com o core) when `repoKind: client` | same | compare |

## Gates

- **`repoKind: core`:** Do **not** dispatch `specifics-sync`. Tell the user the comparador needs a **client** repository with `especifico/` and `.wapstore/build`, or an absolute client path + release in the brief.
- **`repoKind: client`:** Dispatch `specifics-sync` only after `skills/pre-dispatch-check.md` passes.

## Apply phase

After compare, if the user confirms applying patches, dispatch `personas/coder.md` with handoff from `specifics-sync` and skill `ext/uappi-v2/skills/specifics-apply-patches.md`. Run `skills/review-loop.md`.

## Dispatch paths

Use `ext/uappi-v2/personas/specifics-sync.md` (not `personas/specifics-sync.md`).

Rules: all `ext/uappi-v2/rules/specifics/*.md` with scope `specifics-sync`.

Skills: `ext/uappi-v2/skills/specifics-compare-core.md` (compare); `specifics-apply-patches.md` (apply).

Reports: `01-analise-por-arquivo.md` and/or `02-analise-por-tarefa.md` per **Relatório** in the brief — templates in `templates/specifics/`. Full report body saved to disk only, not in chat.
