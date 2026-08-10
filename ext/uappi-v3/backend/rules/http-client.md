---
shortDescription: Integrations in services/external.uappi must build their HTTP client on the shared RestClient, never on raw fetch.
scope: external-integration
product: uappi-v3/backend
version: 0.2.0
lastUpdated: 2026-07-22
---

## Statement

Any new or modified integration under `services/external.uappi` — payment, antifraud, oauth, shipping (frete), ERP, or any future integration domain added to the service — MUST build its HTTP client on the shared `RestClient` (`src/utils/RestClient.ts`) via the specialization pattern already used elsewhere in the codebase: declare a `<Provider>RestClient extends RestClient<ProviderErrorResponse>` and use it inside the provider's `<Provider>Api.ts`. This is already the pattern in payment (`AppMaxRestClient extends RestClient<AppMaxErrorResponse>`, `src/models/payment/integrations/appmax-api/v1/AppMaxRestClient.ts`) and shipping (`MelhorEnvioRestClient extends RestClient<string>`, `src/models/shipping/integrations/melhor-envio/v2/MelhorEnvioRestClient.ts`), and it MUST be followed by every other domain's providers as well.

The `<Provider>Api.ts` client MUST NOT call `fetch()` directly. Header assembly, body serialization, and HTTP error surfacing (`HttpResponse` / `HttpError` / `sendToAPM`) MUST be delegated to `RestClient` rather than re-implemented.

The three existing raw-`fetch` clients — `KondutoApi`, `ClearsaleStartApi`, and `ClearsaleTotalApi` — are accepted technical debt from an early phase of the project (before `RestClient` existed as a shared client). They MUST NOT be treated as precedent or copied when writing a new integration. Migrating them onto `RestClient` is a natural candidate improvement, not a valid alternative pattern to replicate.

## Rationale

Each raw-`fetch` client re-implements header construction, base-URL joining, JSON serialization, and non-2xx error handling by hand. This has already produced inconsistent behavior across providers — for example, `KondutoApi` returns the raw JSON body even on non-2xx responses while `ClearsaleTotalApi` throws `HttpError` on failure — which means callers cannot rely on a uniform error contract. `RestClient` already solves all of this in one place: it builds headers (including `Authorization` and basic auth), serializes objects and `URLSearchParams`, wraps responses in `HttpResponse`, and raises a typed `HttpError` routed through `sendToAPM` on failure. Building every new integration on it removes the duplication, gives every provider the same error surface, and keeps every integration domain in `services/external.uappi` — payment, antifraud, oauth, shipping, ERP, and whatever comes next — consistent with one another instead of each accumulating its own bespoke HTTP handling.
