---
shortDescription: Detect active product extensions from the work repository and persist repoKind for dispatch.
usedBy: [maestro]
version: 0.1.2
lastUpdated: 2026-05-28
---

## Purpose

Product-specific personas, skills, and rules live under `ext/<product-id>/`. The core orchestrator MUST NOT load those assets unless the work repository matches that product's signals. This skill registers products, runs detection at boot, and writes the result into the current session file so Maestro and dispatch can gate routing.

## Procedure

1. **Initialize** `activeProducts: []` and replace only the `## Product Context` block in the current session file (uses: `skills/agent-memory.md`). **Do not** alter `## Status`, `## Last Active`, `## Current Task`, `## Active Todo`, or `## Log`.

2. **Evaluate `uappi-v2`** in order — stop at the first matching kind.

   **Client repo** (`repoKind: client`) — **both** MUST be true:

   ```bash
   find . -maxdepth 3 -type d -name especifico 2>/dev/null | head -1 | grep -q .
   test -f .wapstore/build
   ```

   When matched:
   - Parse release: `release=$(grep -o '"release"[[:space:]]*:[[:space:]]*"[^"]*"' .wapstore/build | head -1 | sed 's/.*"\([^"]*\)"$/\1/')`
   - Append `uappi-v2` to `activeProducts`
   - Write context:

     ```yaml
     uappi-v2:
       repoKind: client
       installed_release: <parsed>
     ```

   **Core repo** (`repoKind: core`) — evaluate only if client did not match. **Any one** signal suffices:

   ```bash
   url=$(git remote get-url origin 2>/dev/null || true)
   echo "$url" | grep -q 'wapstore/wapstore' && echo "$url" | grep -vq '/clientes/'
   ```

   ```bash
   test -d core/wapstore
   ```

   When matched:
   - Append `uappi-v2` to `activeProducts`
   - Write context (only `repoKind` — comparador and gates read nothing else from session for core):

     ```yaml
     uappi-v2:
       repoKind: core
     ```

3. **Evaluate `uappi-v3/backend`** — **any one** signal suffices:

   **Core repo** (`repoKind: core`) — stop at the first true signal:

   ```bash
   # Signal A — README declares V3
   grep -q "Uappi V3 Backend" README.ai.md 2>/dev/null

   # Signal B — microservices directory present (at least one *.uappi service)
   find . -maxdepth 2 -type d -name "*.uappi" 2>/dev/null | grep -q .

   # Signal C — API gateway present (doc-only checkout)
   test -d apis/api.uappi.com.br
   ```

   > **Backend signals only.** All three signals above are backend-specific. A match activates `ext/uappi-v3/backend/` exclusively. Do NOT activate or read `ext/uappi-v3/frontend/` based on these signals — that subdirectory is the frontend extension and has its own detection logic (not yet defined).

   When matched:
   - Append `uappi-v3/backend` to `activeProducts`
   - Write context:

     ```yaml
     uappi-v3:
       repoKind: core
     ```

4. **Persist** under `## Product Context` in the current session file:

   ```markdown
   ## Product Context

   activeProducts: [uappi-v2, uappi-v3/backend]
   <yaml blocks per matched product>
   ```

5. **Return to boot** — do not read `ext/` file contents here; only ids and `repoKind`.

## Maestro usage

- Maestro routes Uappi extension workflows via `ext/uappi-v2/ROUTING.md` when `uappi-v2` is active — read `## Product Context` for `repoKind`.
- If `uappi-v2.repoKind` is `core`, do **not** dispatch — explain the flow requires a **client** repo with `especifico/` and `.wapstore/build`, or an absolute client path + release in the task brief.
- If `uappi-v2` is absent but the user triggers the comparador prompt, dispatch only after `especifico/` exists at the work root (or supplied path) and **Versão alvo** is in the brief.
- Maestro routes Uappi V3 feature-doc workflows via `ext/uappi-v3/backend/ROUTING.md` when `uappi-v3/backend` is active.

## Guardrails

- Never assume `uappi-v2` on repos without signals unless the user explicitly forces the product in the task brief — still validate `especifico/` for compare mode.
- Never rename the client folder `especifico/` — detection uses that name on disk.
- Product context is session-scoped; re-run this skill on boot each session.
- Never rewrite or truncate `## Log` when updating product context.
