# AgentFlow — Uappi

> Uappi fork of Agent Starter Kit. Describe what you need in plain language; the Maestro agent breaks it into tasks and routes each one to a specialized AI model.

Agent Starter Kit is a Natural Language AI Harness (NLAH) — multi-model, pure Markdown, zero dependencies. The smartest model orchestrates while cheaper, faster ones handle the routine work — extending your premium coding plan (such as Claude Code) instead of burning it on everything.

It's model-agnostic: orchestrate on Claude, plan on Kimi, review on Qwen, or any combination you choose.

![Boot sequence demo](docs/demo.jpg)
_Maestro booted on a Clean Architecture Go project — gitignore, auto-update, memory, rules, and 33 context files created automatically._

This fork keeps the Agent Starter Kit structure so upstream updates remain easy to merge, while adding Uappi-specific personas, prompts, templates, and rules for Monday, GitLab, documentation, and support workflows.

## How It Works

The **Maestro** is the conductor. It receives user requests, decomposes them, and dispatches work to specialized personas:

- **Architect** — plans implementations, defines before/after states
- **Coder** — writes software following the plan
- **Reviewer** — checks work for correctness and quality
- **Contextualizer** — documents project structure for orientation
- **Engineer** — documents features from technical and architectural evidence
- **Product Owner** — documents features in business language
- **Documenter** — produces implementation delivery docs from Monday and GitLab
- **Support** — handles support triage and RCA using the dedicated support board

Each persona has an identity (who they are), a playbook (what they do), a handoff format (what they deliver), and red lines (what they must not do).

Each persona also declares a `humor` style — which controls temperature and thinking budget — plus a self-review rubric that scores its own work before delivery. The `preferredModel` field routes work to the right provider automatically. You can route every persona to the same model and skip multi-provider routing entirely if you prefer.

The framework **learns as it works**. Corrections, preferences, and lessons are captured to long-term memory and carried into every future session. Interrupted work is tracked in session files so the next boot can resume where the last one stopped.

## Uappi Workflows

| Trigger | Persona | Output |
| --- | --- | --- |
| `Revisar merge/MR` | Reviewer | `.memory/docs/code-review/review-merge-<ID>-<topic>.md` |
| `Gerar checklist de testes` | Reviewer | `.memory/docs/checklists/checklist-merge-<ID>-<topic>.md` |
| `Documentação Técnica` | Engineer | `.memory/docs/features/feat-<name>-tech.md` |
| `Documentação de Produto` | Product Owner | `.memory/docs/features/feat-<name>-prod.md` |
| `Documentação de Implementação` | Documenter | `.memory/docs/implementations/implementation-<ID>-<topic>.docx` |
| `Análise suporte` / `Triagem suporte` | Support | `.memory/docs/support/triagem/triagem-<ID>-<topic>.md` |
| `RCA suporte` / `Análise profunda suporte` | Support | `.memory/docs/support/rca/rca-<ID>-<topic>.md` |

Fixed integrations:

- Monday product/engineering/docs/MR board: `18383662197`
- Monday support board: `8463166451`
- GitLab project: `agenciawebart/wapstore/wapstore`

Ready-to-paste prompts live in `prompts/`. Output templates live in `templates/`. Cursor MCP setup guides live in `docs/mcp/`. Support-specific rules and flow notes are indexed in `support/README.md`.

## Setup

1. Clone into `.agents/` inside your project:

   ```bash
   cd /path/to/your/project
   git clone git@github.com:Uappi/agent-flow.git .agents
   ```

2. Symlink the entry file to the project root:

   ```bash
   ln -s .agents/AGENTS.md AGENTS.md
   ```

3. Start the AI agent (e.g., `claude`, or whatever CLI you use).
4. Say **"Por favor, siga as instruções de AGENTS.md."** — this boots the Maestro and loads the framework.
5. The Maestro orchestrates everything. On first run, it automatically dispatches the Contextualizer to map the codebase.
6. (Optional) Customize — add personas, rules, skills, and providers to fit your project (see Customization below).

### OpenCode Configuration

The framework works with any AI CLI — Claude Code, Codex, opencode, or any tool that can accept a prompt via `stdin`. No harness requires special configuration to use the personas, rules, and skills. OpenCode is the first-class supported target with native persona agent binding.

If you're running OpenCode and have [`yq`](https://github.com/mikefarah/yq) and [`jq`](https://jqlang.org/) installed, the boot sequence auto-detects it and writes `opencode.json` at the project root with persona agent bindings.

**On the first run, `opencode.json` is created from scratch — restart the CLI so the new agent bindings are picked up.**

Each persona gets a named agent with its model (read from frontmatter), humor-based temperature and thinking budget, and permission profiles. The script is idempotent — subsequent runs update existing bindings rather than create duplicates.

If the tools aren't installed or you're using a different CLI, the script exits silently and no configuration is needed.

## Structure

```
personas/    Specialized AI roles (who does the work)
rules/       Constraints organized by authority level
skills/      Reusable procedures and protocols
prompts/     Ready-to-paste workflow prompts
templates/   Output templates used by Uappi workflows
docs/mcp/    Cursor MCP setup guides for GitLab and Monday
support/     Support workflow index
```

## Rules Hierarchy

- **Commandments** — absolute, never bypassed
- **Edicts** — authoritative within scope, not bent
- **Counsel** — wise guidance, may be deviated from with justification

## Skills

Skills codify procedures that personas reference. They answer "how to do X" so personas can focus on "what to do."

- **agent-decision** — persona decision-making framework with self-review rubrics
- **agent-memory** — long-term and session memory across sessions
- **architect-self-review** — DRAFT self-review rubric — plan quality gate
- **boot** — session startup sequence
- **code-coherence-review** — logic coherence, correctness, and structural integrity checks
- **code-quality-review** — rules-walk procedure for coding standards compliance
- **code-sec-review** — OWASP-aligned security code review checklist
- **coder-self-review** — GRASP self-review rubric — implementation quality gate
- **context-maintenance** — schema and rules for `.context.md` files and `docs/FEATURE-MAP.md`
- **contextualizer-self-review** — TRACE self-review rubric — context generation quality gate
- **dispatch** — how the Maestro assembles and sends work to personas
- **loop-recovery** — structured recovery and escalation for retry loops
- **review-loop** — LOC-based review tier selection with shapeshifter dispatch
- **reviewer-architect-adversarial** — adversarial plan validation and assumption attack
- **reviewer-handoff** — structured review summary format with verdict logic
- **reviewer-self-review** — SHIELD self-review rubric — unified reviewer quality gate
- **task-tracking** — file-based to-do for multi-step work

## Customization

- **Dispatch** — edit `skills/dispatch.md` to match your CLI agents. The Providers list and CLI Dispatch section are pre-configured for Claude Code, Codex, Cursor, DeepSeek, Gemini, and Qwen. Add entries for any other provider/model you use.
- Add new personas to `personas/` following the schema in `personas/README.md`
- Add rules to `rules/commandments/`, `rules/edicts/`, or `rules/counsel/`
- Add skills to `skills/` following the schema in `skills/README.md`
- Modify existing files to match your project's needs

Each directory has a README with the full schema definition.

## FAQ

### Why this over other harnesses?

GSD, GStack, and Gas Town are software — they lock you into dependencies, runtimes, and rigid workflows. Agent Starter Kit is **pure natural language**\*. Every persona, rule, and skill is a Markdown file you can edit with zero installation or build step.

Most harnesses are built around dense, expensive models and burn thousands of tokens on guidance you'll never use. This kit is a **scalpel**: minimal by design, tuned for cheaper MoE models like DeepSeek, GLM, Kimi, and Qwen. You pay only for the context you need. When your project grows, you extend it — add a persona, tweak a rule, swap a provider — all in plain text. Other tools produce code once and walk away. This framework learns, remembers, and adapts across every session.

*\* Almost — one optional shell script for OpenCode auto-configuration and a YAML provider list in `skills/dispatch.md`. No runtimes, no dependencies, no build steps.*

### Why multi-model?

Coding plans are routinely quantized and rate-limited weeks after launch — the version you fell in love with gradually loses sharpness as the provider optimizes for throughput. A multi-model harness fights this in three ways:

1. **Resilience.** Spreading work across providers means you're less affected when any single plan degrades. If one provider tightens limits or loses quality, shift that persona's `preferredModel` to another entry in the Providers list.
2. **Token conservation.** The orchestrator (Maestro) only handles routing and decomposition. Token-heavy roles like Architect and Coder are delegated to other capable models, so your premium plan lasts longer.
3. **Fresh eyes.** Different models catch different things. A reviewer running on a separate provider will flag issues that the coder's model normalized.

### What do I need to run this?

A coding plan or API key for each provider you route to. We recommend coding plans — **Claude Code** (Anthropic), **Codex** (OpenAI), and **Alibaba Model Studio** (Qwen) offer flat-rate pricing with generous token allowances designed for agentic workflows. API keys work too, but plans are more cost-effective for sustained use. Each provider needs its CLI tool installed (e.g., `claude` for Claude Code, `codex` for Codex, `opencode` for DeepSeek or Qwen). If you only route to one provider, one plan is enough.

### How does the Maestro use multiple models from a single CLI?

The dispatch skill (`skills/dispatch.md`) handles this automatically. When a persona's `preferredModel` matches the host runtime (e.g., you're running Claude Code and the persona wants `claude`), the Maestro dispatches natively using the host's built-in subagent mechanism (e.g., the Task tool). When the `preferredModel` points to a different provider (e.g., `qwen`), the Maestro shells out to that provider's CLI tool (e.g., `opencode`) by piping the assembled prompt via `stdin`. The Providers list in `skills/dispatch.md` maps each model to its CLI — add entries for any provider you want to use.

### Can I use this with just one model?

Yes. Set every persona's `preferredModel` to your host runtime (e.g., `claude`) and the framework runs entirely within a single provider. You still benefit from the structured decomposition, review pipeline, and long-term memory — just without the multi-model routing.

### How should I assign models to personas?

Each persona declares a `preferredModel` in its frontmatter — this is what the Maestro uses to route work. Keep premium models as the orchestrator (Maestro makes routing decisions and manages context — short, high-leverage interactions worth the cost). For the rest, match the model to the persona's job using role-specific benchmarks:

- **Coder** — [LiveCodeBench](https://artificialanalysis.ai/evaluations/livecodebench) (real-world coding tasks)
- **Architect** — [Artificial Analysis Long Context Reasoning](https://artificialanalysis.ai/evaluations/artificial-analysis-long-context-reasoning) (multi-step reasoning across large contexts)
- **Reviewer** — [IFBench](https://artificialanalysis.ai/evaluations/ifbench) (instruction following and constraint verification)

These benchmarks are examples — new ones emerge frequently. Pick whatever benchmark best measures the capability each role needs, then set `preferredModel` accordingly in the persona's frontmatter.

### Does the framework auto-update?

Yes. On every session start, the boot sequence runs `git -C .agents pull`. If the pull brings changes, the Maestro reads the changelog, purges any long-term memory entries that the update made obsolete, and reboots with the new instructions.

### What does "model-agnostic" mean? Which models are supported?

Any model with a CLI tool that can accept a prompt via `stdin` works. As a quality floor, we recommend models scoring 1300+ ELO on [GDPval-AA](https://artificialanalysis.ai/evaluations/gdpval-aa) — a benchmark for general-purpose reasoning. Below that threshold, personas may struggle with multi-step tasks.

### What thinking token budget should I use for MoE models?

If you use Mixture-of-Experts models (Kimi, Qwen, DeepSeek, or similar), cap thinking tokens at **16,000** in your CLI's configuration. Research across 121+ code review dispatches found that MoE models regress past this threshold — higher budgets cause models to qualify findings, soften severity, and rationalize away bugs they previously found. Dense models (Claude, Seed) do not exhibit this regression and can use higher budgets safely. See [Overfed, Overthought, Overasked](https://ntorga.com/overfed-overthought-overasked-stop-sabotaging-your-ai/) for the full research.

If you're running OpenCode, the boot sequence already sets per-persona thinking budgets based on humor profiles — no manual configuration needed.
