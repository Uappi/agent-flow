# Personas

Personas are specialized AI roles. Role-playing matters. Different perspectives trigger different reasoning patterns.

## Available Personas

- **maestro** — Orchestrates personas
- **architect** — Plans implementations
- **coder** — Software development
- **reviewer** — Reviews work output for quality
- **contextualizer** — Rebuilds .context.md files
- **engineer** — Documents features with technical and architectural evidence
- **product-owner** — Documents features in business language for non-technical readers
- **documenter** — Produces implementation delivery docs from Monday and GitLab evidence
- **support** — Handles support triage and RCA using the dedicated Uappi support board

## Uappi Workflow Triggers

- `Revisar merge/MR` — `reviewer` in GitLab MR review mode
- `Gerar checklist de testes` — `reviewer` in test-checklist mode
- `Documentação Técnica` — `engineer`
- `Documentação de Produto` — `product-owner`
- `Documentação de Implementação` — `documenter`
- `Análise suporte`, `Triagem suporte`, `Diagnóstico suporte`, `Documentação análise inicial` — `support` in triage mode
- `RCA suporte`, `Análise profunda suporte`, `Causa raiz suporte` — `support` in RCA mode

## Execution Model

Personas run as **subagents only**, never as the main agent. The exception is `maestro`, which runs as the main agent and orchestrates all personas.

## Isolation Principle

Personas MUST NOT reference framework internals (maestro, dispatch mechanics). A persona knows only what it needs to do its job — it receives a task, executes its playbook, and delivers a handoff. How it was invoked is not its concern.

## File Naming

Lowercase, short name. Use kebab-case when the persona name has multiple words: `reviewer.md`, `architect.md`, `product-owner.md`

## Schema (v0.1.1 // 2026-04-27)

### Frontmatter

- **`shortDescription`** (Required) — `Reviews code for quality and security`
- **`preferredModel`** (Optional) — `host`, `claude`, `codex`, `cursor`, `qwen`, `gemini`, or `[claude, codex]`
- **`modelTier`** (Required) — `tier-2`
- **`version`** (Required) — `0.1.0`
- **`lastUpdated`** (Required) — `2026-02-04`
- **`humor`** (Optional) — `pragmatic`

**`preferredModel`** selects which provider handles the persona. The value must match a `preferredModel` entry in the Providers table (`skills/dispatch.md`). Use `host` for native dispatch on the host runtime's own model. A single string routes to one provider; a list enables round-robin or fallback. When omitted, the persona runs on the host runtime's native provider.

**`modelTier`** declares the minimum capability class the persona requires. Tier classes: **tier-1** = fast/cheap, **tier-2** = balanced, **tier-3** = reasoning/smartest. The field is a floor, not a ceiling — a more capable tier may be selected at dispatch time depending on task complexity.

**`humor`** controls response temperature and thinking budget. Available values:

- `introvert` — temperature 0.2, thinking budget 10240
- `pragmatic` — temperature 0.25, thinking budget 12288
- `sympathetic` — temperature 0.3, thinking budget 14336
- `extrovert` — temperature 0.35, thinking budget 16384
- (omitted) — default temperature and thinking budget

Lower values produce more conservative, focused responses. Higher values encourage broader exploration and creative reasoning. Omit the field when no special temperature or thinking budget is needed.

### Body

- **Identity** (Required) — Written in second person. Establish a vivid character with a clear mindset, perspective, and tone. This is not a job description — it's a personality. What does this persona value? What annoys them? How do they approach problems? One to two paragraphs, no bullet points. Identity must not contain prohibitions, constraints, or "never" statements — those belong in Red Lines. Identity answers "who are you" not "what don't you do." Test: remove all Red Lines. If Identity still implies them, it's leaking.
- **Playbook** (Required) — Numbered steps the persona follows. Each step that loads a skill or rule must reference it inline with `(uses: path)` or `(follows: path)`. No naked steps. **Extraction rule**: if a step describes a reusable protocol, format, or procedure that another persona could also need, it belongs in `skills/`, not here. The step should reference the skill, not inline its contents. **Honesty rule**: every step must reflect something the agent can actually do given the execution model. Do not include steps the agent cannot verify or enforce at runtime — aspirational steps erode trust in the entire playbook.
- **Handoff** (Required) — One to two sentences. When is the job done and what is delivered. If it takes more than two sentences, you are over-specifying — extract the delivery format into a skill.
- **Red Lines** (Required) — Specific to this persona. Things this persona might be tempted to do but must not. Do not repeat commandments or playbook steps as prohibitions. Ask: "what mistake would this particular role make?"
- **Yield** (Optional) — Concrete situations where the persona must stop and return control to the user. Not vague categories — describe the actual trigger.
