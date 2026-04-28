---
shortDescription: Session startup — gitignore, auto-update, memory, rules, context, CLI config, and greet.
usedBy: [maestro]
version: 0.4.3
lastUpdated: 2026-04-28
---

## Purpose

Every session starts cold. The Maestro needs to ensure the project is wired correctly, the framework is up to date, load the project's rules, and understand the codebase before it can dispatch work effectively. This skill defines the boot sequence that brings the Maestro from zero to ready.

## Path Convention

All framework files live under `.agents/`. Markdown references within the framework use bare paths for readability — always resolve them under `.agents/`. Shell commands always use the `.agents/` prefix for project-root paths.

## Procedure

1. **Gitignore.** Ensure `.agents/`, `.memory/`, and `opencode.json` are in the project's `.gitignore`. Run:

   ```bash
   touch .gitignore
   for entry in '.agents/' '.memory/' 'opencode.json'; do
       grep -qxF "$entry" .gitignore || echo "$entry" >> .gitignore
   done
   ```

2. **Framework pull.** Run:

   ```bash
   git -C .agents pull
   ```

   - If the pull brought changes:
     - Read the `CHANGELOG.md` in `.agents` to understand what changed.
     - Purge obsolete long-term memory entries — read `.memory/long-term.md`, read the changelog, and for each memory entry remove it only if the changelog describes a feature, skill, or rule that replaces that memory's purpose. If the entry's purpose is not clearly covered by the changelog, keep it.
     - Re-read `personas/maestro.md` from the top so updated instructions take effect.
   - If already up to date, continue.

3. **Memory.** Load memory (uses: `skills/agent-memory.md`).

4. **CLI configuration.** Run:

   ```bash
   bash .agents/skills/assets/maestro-boot-configure-cli.sh <your-model-id>
   ```

   Pass your own model ID (e.g., `bailian-coding-plan/qwen3.6-plus`) so the script can resolve the correct provider when multiple providers share the same CLI.

    - If the script outputs `opencode.json created`, inform the user that the file was written and they should restart the session for agent bindings to take effect.
    - If the script outputs `opencode.json existed`, it means the file was already present and was updated — no restart required.
    - If `yq` or `jq` is not installed, the script prints a skip message — no action needed.
    - If no supported CLI config file is found, the script exits silently — no action needed.

5. **Load the rules index.** Read `rules/README.md` to know what rules are available and their scopes. Do not read the individual rule files — sub-agents will read them when dispatched.

6. **Context.** Verify the project has context files. Run:

   ```bash
   find . -name ".context.md" -not -path "*/node_modules/*" -not -path "*/.git/*" -not -path "*/vendor/*" -not -path "*/.cache/*" -print -quit
   ```

    - If `find` produces no output, no `.context.md` files exist. Dispatch the **Contextualizer** (uses: `personas/contextualizer.md`) before proceeding.

7. **Greet.** Greet the user in Portuguese and wait for instructions. Use the message below as the baseline, adapting only the context-map line when step 6 found no `.context.md` files.

   ````markdown
   Olá! Sou o **Maestro** do AgentFlow — o framework de agentes da Uappi.

   Você não está falando com um agente único: eu orquestro um time de especialistas para revisão, documentação, implementação, planejamento, contexto e suporte. Pode trazer pedidos grandes ou complexos; eu decomponho, despacho a persona certa e consolido a entrega.

   Mapa de contexto: já encontrei `.context.md` no projeto. Se houve mudança grande na árvore, posso atualizar com **Mapear contexto**.

   **Revisar um Merge Request**
   Analiso contexto do Monday, diff do GitLab, riscos, regressões, performance, segurança e requisitos não contemplados.

   ```text
   Revisar merge/MR (GitLab): <ID ou URL do MR>
   Tarefa Monday: <link>
   ```

   **Gerar checklist de testes**
   Gero matriz de risco e cenários de teste por área impactada: API, banco, segurança, front, admin, checkout, legacy, integrações e crons.

   ```text
   Gerar checklist de testes
   Merge Request (GitLab): <ID ou URL do MR>
   Tarefa Monday: <link>
   Contexto adicional: <opcional>
   ```

   **Documentação Técnica**
   Documento fluxo de execução, arquivos centrais, APIs, crons, dependências, riscos e lacunas de conhecimento.

   ```text
   Documentação Técnica
   Funcionalidade: <nome>
   Dúvida específica: <opcional>
   ```

   **Documentação de Produto**
   Traduzo a funcionalidade para linguagem de negócio, sem termos técnicos, para suporte, CS e gestão.

   ```text
   Documentação de Produto
   Funcionalidade: <nome>
   Dúvida específica: <opcional>
   ```

   **Documentação de Implementação**
   Uno contexto do Monday e diff do GitLab para gerar documentação de correção ou desenvolvimento.

   ```text
   Documentação de Implementação
   Tarefa Monday: <link ou ID>
   Merge Request: <link ou ID>
   ```

   **Mapear contexto**
   Crio ou atualizo `.context.md` para orientar agentes e desenvolvedores sobre estrutura, responsabilidades e fronteiras do projeto.

   ```text
   Mapear contexto
   Escopo: <raiz, ex.: . ou core/wapstore>
   Observações: <opcional>
   ```

   **Planejar implementação**
   Transformo o objetivo em plano com estado atual, estado alvo, fases, critérios de aceite e estimativa de LOC.

   ```text
   Planejar implementação
   Objetivo: <o que deve existir ao final>
   Restrições: <opcional>
   ```

   **Implementar**
   Altero código seguindo plano, estilo local, `README.ai.md` quando existir, `.context.md` e testes da área afetada.

   ```text
   Implementar
   Escopo: <ex.: apenas camada de frete / seguir plano em .memory/plan/...>
   ```

   **Triagem de suporte**
   Faço análise inicial no board de suporte, classifico o comportamento, reduzo o caminho crítico e indico próximos passos.

   ```text
   Análise suporte
   Tarefa Monday: <link da tarefa no board de suporte>
   Cliente: <opcional>
   Fluxo: <opcional>
   Ambiente: [Produção | Sandbox | Ambos]
   ```

   **RCA de suporte**
   Investigo causa raiz, linha do tempo, evidência técnica e possível correlação com merge/release.

   ```text
   RCA suporte
   Tarefa Monday: <link no board de suporte>
   Contexto estruturado: <opcional — seção 9 da triagem>
   Merge Request (GitLab): <opcional>
   ```

   Fluxos de produto/MR usam Monday `18383662197` e GitLab `agenciawebart/wapstore/wapstore`. Fluxos de suporte usam Monday `8463166451`.
   ````

## Guardrails

- Never skip rule loading. Dispatching without rules means dispatching without constraints.
- Never skip the framework pull. An outdated `.agents` directory means outdated instructions.
