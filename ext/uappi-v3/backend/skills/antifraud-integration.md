---
shortDescription: Procedure for adding a new antifraud provider integration to services/external.uappi.
usedBy: [coder]
relatedTo: [deno]
scope: antifraud-integration
product: uappi-v3/backend
version: 0.2.0
lastUpdated: 2026-07-22
---

## Purpose

This skill standardizes how a new antifraud provider is added to `services/external.uappi` so it plugs into the existing provider-agnostic pipeline without touching controllers, routes, or the generic batch processes. The antifraud layer dispatches every operation by `antiFraudCode` through `models/antifraud/antifraud.map.ts`, so a new provider is added purely as a set of extension classes plus one registration entry. This skill captures the exact file layout, naming conventions, mandatory registration step, and the interfaces/abstracts to implement, verified against the current ClearSale and Konduto integrations.

## Procedure

1. **Confirm the runtime and HTTP-client policy before writing any code.**
`services/external.uappi` runs on Deno 2.5 / TypeScript with the Oak HTTP framework — follow Deno conventions (import maps via the `@/` alias, no `package.json`/`node_modules`). The provider's HTTP client MUST be built on `RestClient`, never raw `fetch()` (follows: `ext/uappi-v3/backend/rules/http-client.md`). The existing `KondutoApi`/`ClearsaleStartApi`/`ClearsaleTotalApi` raw-`fetch` clients are accepted technical debt and are not a template to copy.

2. **Create the provider folder using the versioned, moment-scoped path convention.**
Place all provider code under `src/models/antifraud/integrations/<provider>/<v>/<moment>/` (for example `signifyd/v3/checkout/`). Always use a version subfolder even when the provider has only one API variant today, to leave room for future versions. The `<moment>` segment is mandatory and its value is always one of the two operation moments defined by `AntiFraudOperation` (`Uappi\Clients\Integration\AntiFraud\AntiFraudOperation` in `services/integration.uappi`), spelled exactly as the enum's string value — `checkout` or `post-sale` (kebab-case, corresponding to the moment-specific suffix of the provider's own compound `antiFraudCode` — e.g. the `checkout`/`post-sale` half of `signifyd-checkout`/`signifyd-post-sale` — never the `antiFraudCode` itself, and never `postSale`/`post_sale`). Only create the moment subfolder(s) the provider actually needs: a provider registered for a single moment gets exactly one moment subfolder (e.g. `signifyd/v3/checkout/` alone, if that is its only `payment_anti_fraud` registration); a provider registered for both moments (two distinct `antiFraudCode`s, e.g. `signifyd-checkout` and `signifyd-post-sale`) gets two sibling moment subfolders under the same version — `signifyd/v3/checkout/` and `signifyd/v3/post-sale/` — each a complete, independent implementation (own facade, own HTTP client, own status parser, own `create`/`consult`/`webhook`/`settings` subfolders) with no inheritance between them. When a provider exposes genuinely distinct API variants on top of that (as ClearSale does with `start` and `total`), give each variant its own complete, independent subfolder the same way. Either way — moments or variants — shared logic lives in a `common/` folder placed as a sibling of the folders it is shared between (e.g. `clearsale/common/` beside `clearsale/start/` and `clearsale/total/`; equally, `<provider>/<v>/common/` beside `<provider>/<v>/checkout/` and `<provider>/<v>/post-sale/`) — never duplicated, never inherited.

3. **Follow the naming conventions.**
Class and file names are PascalCase, prefixed with the provider name (`Konduto`, `ClearsaleStart`, `ClearsaleTotal`). Use the spelling `Clearsale` (lowercase internal `s`), never `ClearSale`. Within each provider version/moment folder, group process classes into per-operation subfolders: `create/`, `consult/`, `webhook/`, `settings/`. Request/response native types are declared as `type` (not `interface`) and named `<Provider>[<Operation>]<Entity>[Request|Response]Type`. Every process class implements `run()` (contract `src/models/ProcessInterface.ts`) and exposes no other public methods. Use `import type { ... }` for type-only imports; give every public/protected method a short pt-BR JSDoc comment.

4. **Author the facade class `<Provider>.ts`.**
Create `src/models/antifraud/integrations/<provider>/<v>/<moment>/<Provider>.ts` implementing `AntiFraudInterface` (`src/models/antifraud/interfaces/AntiFraudInterface.ts`), whose four methods are `consult(request)`, `create(request)`, `getWebhookResponse(request)`, and `settings()`. The facade holds no business logic — each method delegates to a dedicated process class (see `Konduto.ts`, `ClearsaleStart.ts`, `ClearsaleTotal.ts`). For an operation the provider does not support, throw `UappiError` with the relevant id instead of implementing it — `ClearsaleStart.getWebhookResponse` throws `UappiError('UAPPI_EXTERNAL_WEBHOOK_NOT_IMPLEMENTED')` as the reference pattern.

5. **Author the HTTP client `<Provider>Api.ts`.**
Create `src/models/antifraud/integrations/<provider>/<v>/<moment>/<Provider>Api.ts` with no business logic — only URL building and HTTP calls. Declare a `<Provider>RestClient extends RestClient<ProviderErrorResponse>` (mirroring `AppMaxRestClient extends RestClient<AppMaxErrorResponse>` and `MelhorEnvioRestClient extends RestClient<string>`) and use it inside `<Provider>Api.ts` (follows: `ext/uappi-v3/backend/rules/http-client.md`). Expose `getRequestedUrl()` so the calling process can populate `this.response.requestedUrl` for auditing. Decide and document whether the client throws `HttpError` on non-2xx responses or returns the raw body — the existing integrations are inconsistent (`ClearsaleTotalApi`/`ClearsaleStartApi` throw `HttpError`; `KondutoApi` does not), so pick one deliberately.

6. **Author the status enum and its parser.**
Create `src/models/antifraud/integrations/<provider>/<v>/<moment>/<Provider>Status.ts` (an enum of the provider's native status codes) and `Parse<Provider>StatusProcess.ts`, which maps each native status to `StandardAntiFraudStatus` (`src/models/antifraud/StandardAntiFraudStatus.ts` — the canonical enum `PENDING` / `APPROVED` / `REPROVED` / `ERROR`). See `ParseKondutoStatusProcess.ts` and `ParseClearsaleTotalStatusProcess.ts` for reference mappings.

7. **Author the `create` operation.**
Create `create/<Provider>CreateTransactionProcess.ts` extending `AntiFraudTransactionAbstract` (`src/models/antifraud/AntiFraudTransactionAbstract.ts`). It MUST implement `maskMap` (a `Record<string, keyof typeof Mask>`) and `buildRequest()`. Build the native payload in a sibling `create/<Provider>CreateTransactionFormatRequestProcess.ts` that translates the standard `CreateAntiFraudTransactionRequestType` into the provider's native request shape. Apply masks only after the provider call via `this.applyMask()` at the end of `run()` — never mask data before sending it to the provider. Wrap the HTTP call in a `try/catch`: always call `sendToAPM(error)`, and if `error instanceof HttpError`, set `this.response.response = error.toJson()`; do not let the exception propagate to the parent batch process.

8. **Author the `consult` operation.**
Create `consult/<Provider>ConsultTransactionProcess.ts` extending `AntiFraudConsultAbstract` (`src/models/antifraud/AntiFraudConsultAbstract.ts`); the concrete class supplies `run()`. Use the same `try/catch` + `sendToAPM` + `error.toJson()` error handling as the create process.

9. **Author the `webhook` operation only if the provider supports webhooks.**
When applicable, create `webhook/<Provider>WebhookProcess.ts` extending `AntiFraudWebhookAbstract<T>` (`src/models/antifraud/AntiFraudWebhookAbstract.ts`), implementing `extractWebhookData()` and `buildNotificationResponse()`. The confirmation body is provider-specific (Konduto returns `{ status: 'ok' }`, ClearsaleTotal returns `{ success: true }`) — return whatever the provider's API requires. If the provider has no webhook, skip this file and throw `UappiError` from the facade instead (see step 4, per `ClearsaleStart`).

10. **Author the `settings` operation.**
Create `settings/<Provider>ConsultSettingProcess.ts` extending `AntiFraudConsultSettingsAbstract` (`src/models/antifraud/AntiFraudConsultSettingsAbstract.ts`). Implement `getSettings()` to return the provider-specific credential/config settings; the base `run()` concatenates them with the three default settings (`min-value`, `cancel-on-failure`, `capture-on-approval`) automatically — do not re-add those.

11. **Declare the provider's native types.**
Add native request/response/webhook types under `src/types/integrations/<provider>/<v>/<moment>/create/request/`, `.../create/response/`, and `.../webhook/`, mirroring the structure of `src/types/integrations/konduto` and `src/types/integrations/clearsale`. Also declare the `ProviderErrorResponse` type used as the `RestClient` generic (step 5).

12. **Register the provider (mandatory), one entry per moment.**
Add the new facade instance to `src/models/antifraud/antifraud.map.ts` in the `antiFrauds: Record<string, AntiFraudInterface>` map, keyed by the `antiFraudCode` the Core/gateway sends (for example `'novo-provedor'`). When a provider implements both moments, register each moment's facade under its own `antiFraudCode` (e.g. `'signifyd-checkout'` and `'signifyd-post-sale'`) — the same mechanism already used for `'clearsale-start'`/`'clearsale-total'`, just extended to moment-based splits; there is no combined entry. Without an entry, `getAntiFraud(antiFraudCode)` returns `undefined` and that moment is unreachable. No changes are needed in `controllers/`, `routes/`, or the generic `process/*` files — they are provider-agnostic and depend only on this map.

## Guardrails

- Never copy the raw-`fetch` pattern from `KondutoApi`/`ClearsaleStartApi`/`ClearsaleTotalApi` — those are accepted debt, not precedent (see `ext/uappi-v3/backend/rules/http-client.md`).
- Never let a provider HTTP exception propagate out of a `*TransactionProcess` — the batch processes turn any thrown exception into an empty `[]` result for the whole lot, so per-item resilience depends on each process catching its own error and marking the item `success: false`.
- Do not mask PII before sending to the provider; masking is applied only to `this.response.request` after the call.
- Do not skip the `antifraud.map.ts` registration — an unregistered provider is never resolved by `getAntiFraud` and silently does nothing.
