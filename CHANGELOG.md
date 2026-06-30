# Changelog

```log
0.9.2 - 2026/06/26
refactor(dispatch): consolidate providers to one per CLI — merge qwen into deepseek entry; users swap model names instead of adding new provider entries
docs(readme): update provider references — simplify Customization and FAQ sections to reflect one-per-CLI structure; mention OpenCode Go as coding plan for deepseek family
docs(contributing): add provider list policy — models are examples, not a registry; PRs/issues adding providers will be declined

0.9.1 - 2026/06/26
refactor(self-review): improve DRAFT rubric — add scope mode, goal, assumptions, rule contradictions, finalize sections, planned commits; add gather-evidence step; restructure procedure
refactor(reviewer): restructure plan adversarial review with progress file pattern — 8 review phases with disk-write gates; add completeness checks; align acceptance criteria and test spec checks to main framework

0.9.0 - 2026/06/26
refactor(architect): progressive plan construction with per-phase delta and complexity — playbook restructured with disk writes between each step; step 6 is rough phase outline, step 7 is per-phase loop (name methods, stress-test, complexity check, build); plan file is external memory
refactor(architect): replace global before/after with per-phase before/after
refactor(architect): add information flow trace — traces request path from user entry through layers and back
refactor(architect): add explicit method signatures per phase
refactor(architect): reference files per phase for Coder style matching
refactor(architect): cap test specs at 1 per lens per method
refactor(architect): expand Goal from one-sentence to problem-why-success
refactor(coder): step 5a checks plan reference files first
refactor(self-review): update DRAFT rubric for new plan structure
refactor(reviewer): update adversarial plan review for new structure

0.8.8 - 2026/06/25
feat(configure-cli): add explicit .memory subdirectory permissions — .memory/plan/*, .memory/todo/*, .memory/reviews/*, .memory/session/* added to edit and external_directory for all persona profiles; agents no longer prompt for permission to write to .memory subdirectories
feat(configure-cli): add mkdir permission to architect and reviewer — all agents now have mkdir * allowed; previously architect and reviewer were denied directory creation

0.8.7 - 2026/06/25
fix(review-loop): include untracked files in LOC measurement — LOC count command now adds `git ls-files --others --exclude-standard` line counts to `git diff HEAD --numstat` totals; new files were invisible to review tier selection

0.8.6 - 2026/06/25
fix(reviewer): enforce single-pass execution with immediate disk writes — playbook step 4 creates all progress files before reading any code, step 5 executes one complete pass at a time with findings written to disk immediately; red lines added to prevent holding findings in memory and starting next pass before current pass is fully written

0.8.5 - 2026/06/24
fix(configure-cli): robotic humor thinking budget 0→4096 — thinking re-enabled with minimal budget instead of disabled; reasoning effort mapped to low instead of none
fix(configure-cli): introvert thinking budget 10240→8192 — aligned with industry effort-level estimates for hard tasks
feat(configure-cli): vary top_p by humor — robotic 0.7, introvert 0.75, pragmatic 0.8, sympathetic 0.85, extrovert 0.85; deterministic roles get lower top_p for code precision, exploratory roles keep higher for design flexibility
feat(configure-cli): block destructive git commands on all personas — git clean, git reset, git rebase, git push --force, git push -f explicitly denied in bash permission profiles for all personas; prevents accidental history rewrites, untracked file deletion, and force pushes
refactor(personas): bump coder modelTier from tier-1 to tier-2 — fast model with no thinking insufficient for coding tasks that require reasoning about context, dependencies, and test design

0.8.4 - 2026/06/24
fix(self-review): adapt SHIELD dimensions for all pass types — S-dimension simplified, H-dimension generalized, E/L/D dimensions made pass-agnostic (grounding, evidence, external factors) instead of pass-specific; all dimensions now work for both full and focused reviews

0.8.3 - 2026/06/24
fix(self-review): SHIELD S-dimension handles focused reviews — rubric now explicitly scores based on required passes (focused pass only when task specifies focus, all three when no focus); eliminates ambiguity in scoring when task scopes to single pass

0.8.2 - 2026/06/24
fix(reviewer): restructure playbook for progress file discipline — step 3 reads skill(s) in full before proceeding, step 4 initializes progress files, step 5 executes each phase thoroughly with calming guidance; Identity adds depth-over-completeness principle; Red Line enforces progress file timing

0.8.1 - 2026/06/24
refactor(personas): align identities with main framework — all 5 persona identities trimmed to single paragraphs; operational guidance moved to Playbook/Red Lines, only character and principles remain

0.8.0 - 2026/06/24
refactor(reviewer): safety net identity — removed "three critics" framing; Reviewer is now the safety net that catches what was dropped, runs all three lenses (coherence, quality, security)
refactor(reviewer): trimmed Red Lines to persona-specific only — removed process-related prohibitions already covered by review skills and SHIELD rubric
refactor(review-loop): restore multi-dispatch tiers with <task> focus — Standard (2 dispatches) and Full (3 dispatches) tiers restored for MoE context window management; focus now stated in <task> itself, no separate `<review-focus>` block
refactor(self-review): remove `<review-focus>` references — SHIELD rubric updated for task-driven focus

0.7.9 - 2026/06/23
refactor(configure-cli): improve agentBindingBuilder() readability — eliminated nested if/else, consolidated jq calls into linear flow with separate conditionals for temperature, top_p, and thinking; each step builds on previous result for clear data flow
feat(configure-cli): emit reasoningEffort alongside reasoning.effort — flat `reasoningEffort` field added for opencode pass-through compatibility per docs (https://opencode.ai/docs/agents/#additional); both nested and flat formats emitted for max provider compatibility

0.7.8 - 2026/06/23
feat(configure-cli): dual-format thinking config — agent bindings emit both Anthropic (`thinking: {type, budgetTokens}`) and OpenAI (`reasoning: {effort}`) formats; disable works universally across SDKs
fix(configure-cli): replace enable_thinking with proper thinking/reasoning formats — `enable_thinking` was wrong parameter for both Anthropic and OpenAI SDK providers

0.7.7 - 2026/06/23
feat(personas): add Observations convention — dispatch notes instruct all personas to optionally include a `## Observations` section in their handoff for honest opinions, concerns, or patterns outside their deliverable; Maestro scans and saves to long-term memory, feeds relevant observations into subsequent dispatch context
feat(memory): add Observations section to long-term memory schema — dedicated section for persona specialist feedback that falls outside deliverables but may matter later
refactor(contextualizer): humor changed from introvert to robotic — thinking disabled, same temperature/topP as introvert (0.2/0.85)

0.7.6 - 2026/06/23
fix(memory): pre-create all .memory subdirectories in agent-memory skill — plan/, todo/, reviews/ added alongside session/; prevents failures when architect, task-tracking, or code-quality-review skills write before dirs exist

0.7.5 - 2026/06/22
fix(configure-cli): simplify .memory permissions to single glob pattern — `.memory/*` and `.memory/**/*` replaced with `.memory/**` for consistent matching; prevents permission prompts for build agent editing .memory/ files
fix(configure-cli): replace jq deep merge with shallow merge — `*` operator preserved stale budgetTokens when thinking disabled; `+` replaces agent objects entirely so disabled thinking has no budget field

0.7.4 - 2026/06/22
feat(configure-cli): add robotic humor — same temperature/topP as introvert (0.2/0.85) but thinking explicitly disabled; agentBindingBuilder handles "disabled" string for thinkingBudget
refactor(coder): tier-2 to tier-1, pragmatic to robotic — fast model with no thinking for explicit linear playbooks

0.7.3 - 2026/06/18
refactor(architect): reduce per-phase LOC target from 1000 to 600 with 800 hard cap — aligns with Standard review tier threshold, reduces need for Full tier reviews
feat(review): update adversarial review phase size threshold from 1000 to 800 LOC — enforces new per-phase hard cap
feat(review): add LOC threshold to DRAFT self-review — F criterion now checks phase LOC against 600 soft cap and 800 hard cap
fix(review): use `git diff HEAD` instead of `git diff` for LOC measurement — captures both staged and unstaged changes, prevents staged work from bypassing review

0.7.2 - 2026/06/18
fix(coder): make style absorption deterministic — run `ls` on target directory, read exactly two sibling files most similar in function, match structure/patterns/conventions exactly
feat(rules): add native tooling rule — coders should use Edit/Read/Write/Grep/Glob directly, not write scripts for file operations
feat(review): add style proximity verification — reviewer reads sibling files and compares against changed code before checking rules, project style takes precedence
refactor(review): restructure code-quality-review around progress file breadcrumbs — phases tracked in `.memory/reviews/`, findings written incrementally, style proximity after rule walk (context window management), dedup final step
refactor(review): lower review tier LOC thresholds — Unified <300, Standard 300-600, Full 600-1000, over 1000 must split via Contextualizer

0.7.1 - 2026/06/17
fix(configure-cli): add .memory/* alongside .memory/**/* in edit and external_directory for all personas — glob ** may not match direct children of .memory/; files like settings.conf and MEMORY.md were falling through to wildcard ask/deny
feat(rules): add method granularity rule — trivial wrapper functions (~5 LOC or fewer) are indirection without value; functions must do meaningful work
feat(rules): add method ordering rule — callees must be defined above callers for top-down readability
feat(rules): clarify data trust boundary — no separate parse functions when value object constructor already validates
fix(configure-cli): add rg (ripgrep) to bash allow list for all personas — file search is a read operation, same category as grep

0.7.0 - 2026/06/17
feat(configure-cli): add text processing and file manipulation utils to persona bash allow lists — sed, awk, tr, cut, uniq, wc on all profiles; touch, cp, mv, tee, xargs, ln on write-enabled personas
fix(configure-cli): add deny guards for read-only personas — sed -i and file manipulation tools explicitly denied on architect and reviewer to prevent bypassing edit permissions
fix(tests): update stale test assertions for permission defaults and model version checks

0.6.5 - 2026/06/16
fix(configure-cli): add .memory/**/* to edit and external_directory for build, architect, reviewer, and contextualizer — syncs .memory permissions with main framework; sub-agents can now write to .memory without prompting

0.6.4 - 2026/06/15
refactor(architect): reduce per-phase LOC target from 1500 to 1000 — smaller phases reduce cognitive burden and review complexity
feat(review): add phase dependency and size checklists to adversarial plan review — enforces 1000 LOC limit per phase, flags missing estimates as Blockers

0.6.3 - 2026/06/15
feat(architect): version plan files — each revision produces a new file (YYYY-MM-DD-<prefix>-<slug>-v<N>.md) instead of overwriting; first version is v0

0.6.2 - 2026/05/01
fix(skills/boot.md): add `.ignore` to gitignore loop — was missing `.ignore` entry that maestro-boot.sh already handles

0.6.1 - 2026/04/30
fix(configure-cli): change all personas from edit/bash deny to ask — write tools hidden when deny matches project root; compound commands (pipes, redirects) now prompt instead of silently failing
feat(boot): add ensureHiddenDirectoriesAreSearchable to maestro-boot-configure-cli.sh — creates .ignore at project root with !.agents/ and !.memory/ entries so AI tooling (glob/grep) can search hidden gitignored directories; ensureGitignoreEntry '.ignore' added to .gitignore

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
