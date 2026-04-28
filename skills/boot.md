---
shortDescription: Session startup — gitignore, auto-update, memory, rules, context, CLI config, and greet.
usedBy: [maestro]
version: 0.4.4
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

   Note the result — it is used in step 7.

7. **Greet.** Send the greeting below to the user now. This is the final and mandatory action of boot — do not add preamble, do not summarize, do not defer. Boot is not complete until this message is sent.

   If step 6 produced no output, append this line at the end of the greeting before sending:
   > Ainda não há mapa de contexto no repositório. Use o bloco **Mapear contexto** com o escopo desejado para gerá-los, ou diga se prefere seguir sem.

   **Greeting starts here:**

   ---

   Olá! Sou o **Maestro** do AgentFlow — framework de agentes da Uappi. Aqui está tudo o que consigo fazer por você:

   ---

   **Revisar um Merge Request**
   Acesso o contexto da tarefa no Monday e o diff completo no GitLab. Analiso riscos, efeitos colaterais, performance, regressão e requisitos não contemplados. Gero o relatório em `.memory/docs/code-review/`.

   ```text
   Revisar merge/MR (GitLab): <ID ou URL do MR>
   Tarefa Monday: <link>
   ```

   ---

   **Gerar checklist de testes**
   Mapeio os arquivos alterados no MR e gero um checklist completo com matriz de risco por área (API, banco, segurança, checkout, legacy, integrações e crons). Salvo em `.memory/docs/checklists/`.

   ```text
   Gerar checklist de testes
   Merge Request (GitLab): <ID ou URL do MR>
   Tarefa Monday: <link>
   Contexto adicional: <opcional>
   ```

   ---

   **Documentação Técnica**
   Analiso o código e documento o fluxo de execução, arquivos centrais, APIs, crons, dependências e lacunas de conhecimento. Salvo em `.memory/docs/features/`.

   ```text
   Documentação Técnica
   Funcionalidade: <nome>
   Dúvida específica: <opcional>
   ```

   ---

   **Documentação de Produto**
   Documento a funcionalidade em linguagem de negócio, sem termos técnicos. Output legível por suporte, CS e gestão. Salvo em `.memory/docs/features/`.

   ```text
   Documentação de Produto
   Funcionalidade: <nome>
   Dúvida específica: <opcional>
   ```

   ---

   **Documentação de Implementação**
   Busco o contexto no Monday e o diff no GitLab. Identifico automaticamente se é correção ou feature e aplico o template correto. Salvo em `.memory/docs/implementations/`.

   ```text
   Documentação de Implementação
   Tarefa Monday: <link ou ID>
   Merge Request: <link ou ID>
   ```

   ---

   **Mapear contexto**
   Percorro diretórios relevantes e crio ou atualizo `.context.md` para orientar agentes e desenvolvedores sobre estrutura, responsabilidades e fronteiras do projeto.

   ```text
   Mapear contexto
   Escopo: <raiz, ex.: . ou core/wapstore>
   Observações: <opcional>
   ```

   ---

   **Planejar implementação**
   Transformo o objetivo em plano com estado atual, estado alvo, fases, critérios de aceite e estimativa de LOC.

   ```text
   Planejar implementação
   Objetivo: <o que deve existir ao final>
   Restrições: <opcional>
   ```

   ---

   **Implementar**
   Escrevo ou altero código no repositório conforme o plano (se houver) ou um escopo delimitado. Tarefas complexas sem plano podem ser devolvidas para `Planejar implementação` antes.

   ```text
   Implementar
   Escopo: <ex.: apenas camada de frete / seguir plano em .memory/plan/...>
   ```

   ---

   **Análise suporte**
   Triagem backend com classificação, próximo passo e checklist de evidências. Saída em `.memory/docs/support/triagem/`.

   ```text
   Análise suporte: <link da tarefa do Monday (board de suporte)>

   Contexto adicional (opcional):
   - Cliente:
   - Fluxo:
   - Suspeita:
   - Observações:
   - Ambiente: [Produção | Sandbox | Ambos]
   - Já testado:
   ```

   *(Gatilhos equivalentes: `Triagem suporte`, `Diagnóstico suporte`, `Documentação análise inicial`.)*

   ---

   **RCA suporte**
   Análise profunda da causa raiz, linha do tempo e correlação com merge/diff no GitLab. Saída em `.memory/docs/support/rca/`.

   ```text
   RCA suporte: <link da tarefa do Monday (board de suporte)>

   Contexto estruturado (preferencial: copie a seção 9 do relatório de triagem):

   Contexto adicional (opcional):
   - Release atual:
   - Release anterior:
   - Merge/MR:
   - Fluxo:
   - Sintoma observado:
   ```

   *(Gatilhos equivalentes: `Análise profunda suporte`, `Causa raiz suporte`.)*

   ---

   *Fluxos de produto/MR/documentação usam Monday `18383662197` e GitLab `agenciawebart/wapstore/wapstore`.*

   *Fluxos de suporte usam Monday `8463166451` e o mesmo GitLab quando precisar de diff de MR.*

   **Greeting ends here.**

## Guardrails

- Never skip rule loading. Dispatching without rules means dispatching without constraints.
- Never skip the framework pull. An outdated `.agents` directory means dispatching with stale instructions.
