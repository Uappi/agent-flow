# Changelog

```log
0.6.0.1 - 2026/04/28
feat(uappi): import AgentFlow overlay while preserving Agent Starter Kit structure
feat(personas): add engineer, product-owner, documenter, and support personas with Uappi workflow triggers
feat(templates): add Monday/GitLab documentation, MR review, checklist, support triage, and RCA templates
feat(prompts): add ready-to-paste prompts for Uappi Monday/GitLab and support workflows
feat(rules): add support triage/RCA rules and restore clarification counsel
docs(mcp): add Cursor setup guides for GitLab and Monday MCPs
docs(readme): document Uappi fixed integrations and workflow outputs
docs(boot): add Portuguese friendly boot greeting with ready-to-use workflow prompts
docs(agents): keep AGENTS.md as the canonical framework entrypoint

0.6.0 - 2026/04/27
fix(personas/coder.md): restore corrupted file — all newlines were stripped into single line, adapted for starter kit (no cognitive-lens, simplified steps)
fix(personas/maestro.md): break dense Parse step into numbered sub-list for complex prompts, add `skills/dispatch.md` to every dispatch reference
fix(personas/maestro.md): add sub-agent output context to Review loop step, add task-tracking skill reference to Deliver step
fix(personas/architect.md): remove Confidence score section — redundant with DRAFT self-review
fix(skills/reviewer-handoff.md): remove Coverage checklist — already covered by SHIELD self-review, focus skill on handoff format only
delete(skills/reviewer-scoring.md): vestigial, checklist inlined into reviewer-handoff.md
fix(skills/assets/maestro-boot-configure-cli.sh): replace sed with awk for frontmatter and YAML extraction — macOS/BSD sed incompatibility
docs(readme): fix duplicate preferredModel paragraph, consolidate persona section
docs(personas/readme): bump schema to v0.1.1 for humor field addition
docs(skills/readme): remove reviewer-scoring from skills list

0.5.9 - 2026/04/25
fix(skills/maestro-boot-configure-cli.sh): accept host modelId as $1 to resolve correct provider when multiple providers share the same CLI (deepseek/qwen both use opencode), fallback to first match when omitted
fix(skills/boot.md): pass modelId to configure-cli.sh script
fix(skills/maestro-boot-configure-cli_test.sh): update personas directory paths from `personas` to `.agents/personas`

0.5.8 - 2026/04/25
fix(skills/maestro-boot-configure-cli.sh): personas directory path was `personas` instead of `.agents/personas` — script failed when run from project root
docs(readme): fix heading level for OpenCode Configuration (h4 → h3), fix CLI examples (codex for Codex, opencode for DeepSeek/Qwen), list all 6 pre-configured providers, replace "Providers table" references with "Providers list"/"entries", add asterisk footnote for "pure natural language" noting optional shell script and YAML provider block
docs(readme): downgrade MoE thinking budget section to FAQ question, add OpenCode auto-configuration note

0.5.7 - 2026/04/25
fix(skills/task-tracking): remove scratchpad offloading — too much overhead for starter kit
fix(skills/task-tracking): port explicitness from main framework's agent-todo — explicit ls command, mkdir+cat create command, target directory callout, truncate-on-close, git branch slug derivation, explicit location guardrail
docs(readme): replace demo.png with demo.jpg

0.5.6 - 2026/04/25
docs(readme): add restart instruction to OpenCode Configuration — opencode.json created on first run requires CLI restart
fix(skills/agent-memory): remove cycle-count reset and increment steps — removed from starter kit
fix(skills/agent-memory): renumber steps 1-7 and update cross-references

0.5.5 - 2026/04/25
fix(dispatch): replace "verbatim" instruction in step 5 with explicit "complete, unmodified" wording to prevent MoE literal interpretation
fix(dispatch): add "DO NOT LITERALLY OUTPUT THIS BRACKETED TEXT" guardrail to compose template placeholders

0.5.4 - 2026/04/25
fix(dispatch): OpenCode first-class support — host detection, native dispatch via task tool
fix(dispatch): rename <agent> to <identity> to prevent MoE confusion with dispatch envelope
fix(dispatch): clarify step 4 skip instruction (was "skip to step 5"), fix indentation inconsistency
fix(dispatch): clarify step 5 sed command execution and output storage

0.5.3 - 2026/04/25
fix(boot): preferredModel/modelTier resolution with multiple provider support — replace readPersonaModelId with resolvePersonaModelId, add isProviderOnSupportedCli membership check, extract readProvidersYamlBlock, consolidate resolveHumor* into resolveHumorAttributes, consolidate agentBindingBuilder into single jq invocation, remove detectCliConfigPath wrapper, move CLI guard before config file creation
fix(boot): fix guard order to avoid creating stray files outside the supported CLI
fix(dispatch): add deepseek provider, sort providers alphabetically, add --variant [effort] and --thinking to opencode CLI dispatch command
docs(code-quality): add KISS, DRY, SRP principles and function naming rule — avoid infrastructure/tool names in function names

0.5.2 - 2026/04/25
fix(personas/maestro): add dedicated "Load dispatch procedure" step — read dispatch.md IN FULL before any dispatch
fix(personas/maestro): plan review gate names Reviewer persona + adversarial skill + dispatch skill
fix(personas/coder): add (uses:)/(follows:) annotations to naked steps, make complex task threshold concrete (>5 files or >300 LOC)
fix(personas/contextualizer): handoff mentions TRACE self-review gate
fix(personas/architect): plan template references correct step 7 (was step 8) for self-review
fix(skills/context-maintenance.md): renumber duplicate step 6 to 7 in FEATURE-MAP section
fix(skills/review-loop.md): specify step 6 of contextualizer.md for review scoping dispatch
fix(skills/boot.md): clarify shell commands always use .agents/ prefix
fix(skills/task-tracking.md): usedBy scope expanded to [all]
fix(rules/README.md): remove superseded counsel/clarification entry
delete(rules/counsel/clarification.md): superseded by skills/agent-decision.md
fix(README.md): complete skills list from 12 to all 18 skills in alphabetical order

0.5.1 - 2026/04/25
feat(personas): add humor frontmatter field to all personas (architect/extrovert, coder/pragmatic, contextualizer/introvert, maestro/sympathetic, reviewer/pragmatic)
feat(personas): move parallel dispatch instruction from maestro identity to boot greet
docs(personas): add humor field schema to personas/README.md
feat(skills): add maestro-boot-configure-cli.sh — auto-detects OpenCode and writes persona agent bindings to opencode.json
fix(skills/boot.md): renumber steps (gap from cycle-check removal), add opencode.json to gitignore loop, add CLI configuration step before context, rewrite greet
feat(skills): add reviewer-architect-adversarial.md — adversarial plan validation with assumption attack and clean-rewrite check
refactor(skills): delete plan-critique.md — replaced by reviewer-architect-adversarial.md
docs(skills): update architect-self-review.md reference to adversarial skill
docs(skills): integrate FEATURE-MAP.md into contextualizer self-review rubric
docs(skills): update skills README table entry for plan-critique rename
feat(personas): change all personas to preferredModel: host for native dispatch
docs(personas): update preferredModel schema to include all providers and host semantics
feat(dispatch): add host provider entry for native dispatch routing
feat(dispatch): add Gemini provider, backtick Claude/Qwen model names, update codex tier-3 to gpt-5.5 and qwen tier-3 to qwen3.6-plus
fix(dispatch): Gemini CLI stdin clarification, Cursor auto-tier documentation, tier-3 ceiling guard, persona file validation and prompt injection guardrails
fix(dispatch): Gemini model names backticked, Qwen model names backticked, Gemini CLI dispatch fixed (removed redundant --prompt)
fix(dispatch): add tier-3 ceiling guard, clarify step 1 process-to-provider mapping, document Cursor auto-tier behavior
fix(dispatch): add guardrails for persona file validation and prompt injection sanitization

0.5.0 - 2026/04/24
feat(personas): wire self-review gates into all four personas (coder/GRASP, architect/DRAFT, contextualizer/TRACE, reviewer/SHIELD)
feat(personas): wire agent-decision.md into maestro parse step and dispatch skill for ambiguity escalation
feat(skills): donate coder-self-review.md — GRASP rubric for implementation self-evaluation
feat(skills): donate architect-self-review.md — DRAFT rubric for plan self-evaluation
feat(skills): donate contextualizer-self-review.md — TRACE rubric for context self-evaluation
feat(skills): donate reviewer-self-review.md — SHIELD rubric for unified reviewer self-evaluation
feat(skills): donate agent-decision.md — structured ambiguity escalation with FRAME rubric
refactor(personas): align contextualizer with FEATURE-MAP.md and trim verbose identity/purpose
refactor(skills): add FEATURE-MAP section to context-maintenance.md — contextualizer produces both .context.md and feature map every full scan
refactor: convert all markdown tables to lists across personas, skills, rules, and README files for MoE readability

0.4.4 - 2026/04/07
feat(skills): add review-loop.md — LOC-based tier selection with shapeshifter dispatch, split as pre-step
feat(skills): add reviewer-scoring.md with deterministic 6-item coverage checklist
refactor(skills): replace subjective confidence scale with deterministic coverage scoring in reviewer-handoff.md
feat(skills): add anti-rationalization guardrails to code-quality-review and code-sec-review
feat(coder): add style-absorption instruction to step 2 — read two files in same directory before writing
refactor(coder): sharpen Red Line — "never deviate from coding style" replaces "never override patterns"
feat(maestro): add Contextualizer-then-Architect sequence for complex tasks in step 3
feat(contextualizer): add structural brief mode and review scoping mode to playbook
feat(architect): add hard conditional on structural brief in step 2
feat(architect): add LOC estimation per phase and Estimated Total LOC to plan template
refactor(architect): raise phase-split threshold from ~1000 to ~1500 LOC
docs(README): add MoE thinking-budget guidance with article link

0.4.3 - 2026/04/03
feat(maestro): add plan review gate — dedicated step between Parse and Dispatch ensures plans pass review before implementation

0.4.2 - 2026/04/02
feat(skills): add plan-critique — adversarial plan validation (structural checks + assumption attack) before implementation begins
feat(skills): add reviewer-handoff — extract structured review summary format from reviewer persona to standalone skill
feat(reviewer): add plan-critique routing — plans go through adversarial validation before implementation
feat(reviewer): add file creation prohibition red line — findings belong in handoff, not loose files
feat(architect): add per-phase test specifications — happy path, error cases, and adversarial cases

0.4.1 - 2026/03/30
feat(dispatch): add providers codex and cursor to routing matrix

0.4.0 - 2026/03/27
feat(memory): add session memory — per-task session files with status tracking, resume flow, log entries, and active todo pointer
feat(memory): add signal tiers for long-term memory writes — strong (explicit), medium (correction), weak (wait)
feat(memory): add structured distillation — scan for corrections, struggles, decisions, preferences, and prune stale entries
feat(memory): add size discipline — 80-entry cap on long-term memory with aggressive pruning
feat(maestro): integrate session memory into playbook — update session before dispatch and after delivery

0.3.2 - 2026/03/27
feat(memory): add cycle counter — reset at boot, increment after each cycle, warn user at ≥7 cycles
feat(architect): save plans to .memory/plan/ so they survive session interruptions
feat(maestro): persist large prompts — dispatch Architect or create to-do for complex requests

0.3.1 - 2026/03/26
fix(agents,boot): symlink-aware paths — AGENTS.md references use .agents/ prefix, boot skill hints bare paths resolve under .agents/

0.3.0 - 2026/03/26
refactor: merge README boot content into AGENTS.md — single-hop boot
feat(skills): add loop-recovery — structured retry pivot/abandon with oscillation and drift detection
feat(skills): add code-sec-review — OWASP-aligned security code review checklist
feat(skills): add code-coherence-review — logic, correctness, and structural integrity checks
feat(skills): add code-quality-review — rules-walk procedure for coding standards compliance
feat(rules): add code-debugging edict — root cause before fix, three-strike rule, anti-rationalization
feat(rules): add clarification counsel — stop/proceed/escalate taxonomy, clarify-plan-act gates
feat(personas): rewrite reviewer — lean identity with three structured passes (coherence, quality, security), prompt injection red line
feat(rules): expand code-quality edict — data trust boundary, process-killing exceptions, richer testing, schema change disclosure
refactor(boot): load rules index only — Maestro reads rules/README.md, sub-agents read individual rules when dispatched
refactor(dispatch): expand rule loading from commandments-only to all tiers, add loop-recovery to dispatch notes

0.2.3 - 2026/03/10
feat(boot): add gitignore check — ensure .agents/ and .memory/ are in project .gitignore on startup
feat(boot): add auto-update — pull latest framework on session start, reboot if changes detected
feat(boot): add long-term memory loading and inline memory purge after framework update
feat(boot): replace vague Orient/First-run steps with deterministic context check via find
feat: add agent-memory skill — long-term memory across sessions
feat: add context-maintenance skill — .context.md schema and update rules
refactor(contextualizer): reference context-maintenance skill for .context.md schema
docs(readme): replace vague setup steps with deterministic shell commands (git clone, ln -s)
docs(readme): consolidate FAQ — merge Why This, Why Multi-Model, and Best Practices into FAQ section
docs(readme): add FAQ entries for auto-update, model assignment, and model-agnostic explanation with ELO reference
docs(readme): clean intro — fix tagline comma splice, drop fillers, replace "ultra-personalized" with "fully customizable"

0.2.2 - 2026/03/09
feat(maestro): surface pre-existing issues (bugs, tech debt, code smells) found by sub-agents during Deliver
feat(dispatch): instruct sub-agents to report pre-existing issues in a Discovered Issues handoff section
fix(maestro): strengthen commit guardrail — add Red Line, require unambiguous "commit" authorization (not just approval)

0.2.1 - 2026/03/06
refactor: rename CLAUDE.md to AGENTS.md for model-agnostic branding
docs(readme): merge intro and Motivation into two concise paragraphs, add provider examples and ELO requirement
refactor(maestro): update Identity — chief of staff role, accountability, clarification over prohibition
feat(maestro): add commit flow to Handoff — branch guard, user confirmation, git commandment reference

0.2.0 - 2026/03/05
feat(dispatch): add multi-provider routing with Providers table, host runtime detection, and native/CLI dispatch logic
feat(personas): add preferredModel frontmatter field for provider routing
refactor(dispatch): split overloaded step 1 into discrete steps (identify runtime, extract fields, select provider, decide dispatch mode)

0.1.0 - 2026/03/04
feat: initial release
feat: add 5 personas (maestro, architect, coder, reviewer, contextualizer)
feat: add dispatch skill with native subagent prompt assembly
feat: add boot skill for session startup
feat: add task-tracking skill for file-based to-do
feat: add git commandment and code-quality edict
feat: add schema definitions for personas, rules, and skills
```
