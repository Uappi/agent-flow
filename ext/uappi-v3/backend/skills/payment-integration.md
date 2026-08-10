---
shortDescription: Procedure for adding a new payment gateway integration to services/external.uappi.
usedBy: [coder]
relatedTo: [deno]
scope: payment-integration
product: uappi-v3/backend
version: 0.2.0
lastUpdated: 2026-07-27
---

## Purpose

This skill standardizes how a new payment gateway is added to `services/external.uappi` so it plugs into the existing gateway-agnostic pipeline without touching controllers, routes, or middleware. Every payment operation is dispatched by `paymentCode` through `src/models/payment/payment.map.ts::getPaymentDriver()`, so a new gateway is added purely as a set of classes implementing `PaymentInterface` plus one registration entry. This skill captures the file layout, naming conventions, mandatory registration step, and the interfaces/abstracts to implement, verified against the current Wapi integration (the only complete, active gateway) and the AppMax OAuth code (the only other non-stub code under `integrations/`).

## Procedure

1. **Confirm the runtime and HTTP-client policy before writing any code.**
`services/external.uappi` runs on Deno 2.5 / TypeScript with the Oak HTTP framework (`src/routes/payment.ts`) — follow Deno conventions (the `@/` import alias, explicit `.ts` specifiers, no `package.json`/`node_modules`). The gateway's HTTP client MUST be built on `RestClient` (`src/utils/RestClient.ts`), never raw `fetch()` (follows: `ext/uappi-v3/backend/rules/http-client.md`). Specialize it as `<Gateway>RestClient extends RestClient<GatewayErrorResponse>`, mirroring `AppMaxRestClient extends RestClient<AppMaxErrorResponse>` (`src/models/payment/integrations/appmax-api/v1/AppMaxRestClient.ts`). The Wapi integration's own HTTP client (`src/models/common/wapi/Wapi.ts`) is a bespoke internal client predating this pattern and proxies a legacy system (`https://wapi.webart.com.br`) — it is not `RestClient`-based and MUST NOT be copied as the HTTP-client template for a new gateway.

2. **Create the gateway folder using the versioned path convention.**
Place new integration code under `src/models/payment/integrations/<gateway>/<v>/` (kebab-case gateway slug, e.g. `appmax-api`, `mercado-pago`; version as `v1`, `v2`, …). The main class implementing `PaymentInterface` lives at `src/models/payment/integrations/<gateway>/<v>/<Gateway>.ts`. There are 29 gateway directories today under `src/models/payment/integrations/` (confirmed by directory listing); 26 have corresponding commented-out imports/entries in `payment.map.ts` and are empty stub classes (`export default class X {}`) that do not declare `implements PaymentInterface` — they are placeholders for future work, not evidence of a second working pattern. `picpay/v1/PicPay.ts` is a 27th empty stub with no trace at all (not even commented) in `payment.map.ts`. `appmax-api` is the 29th directory and the only one with real code, but it implements only an OAuth credentialing flow (`OAuthInterface`, `AppMax.ts`/`AppMaxApi.ts`) — not `PaymentInterface` — and is also absent from `payment.map.ts`. `wapi` is the only gateway that is both complete and registered (as the catch-all `'*'` entry, see step 7); treat it as the structural reference, understanding that it proxies a legacy system rather than talking to an acquirer/PSP directly.

3. **Follow the naming conventions.**
Classes are PascalCase, named after the gateway (e.g. `WapiPayment`, and by the same convention a future `Cielo`, `MercadoPago`). Since operations are always split into per-operation classes (step 5), prefix each with `<Gateway>Payment` + operation, e.g. `WapiPaymentTransaction`, `WapiPaymentCapture`, `WapiPaymentCancel`, `WapiPaymentConsultTransaction`, `WapiPaymentSetting`. Payload-translation classes take the suffix `FormatRequest`/`FormatResponse` (e.g. `WapiPaymentTransactionFormatRequest.ts`, `WapiPaymentTransactionFormatResponse.ts`) and live in a `format/` subfolder inside the operation's own folder. Gateway-specific raw request/response types live under `src/types/integrations/<gateway>/<v>/payment/request/` and `.../response/` — never reuse `src/types/payment/*` (the module's standardized, gateway-independent contract types) for a gateway's raw payload shape.

4. **Implement the top-level contract, `PaymentInterface`.**
`src/models/payment/integrations/PaymentInterface.ts` is an `interface` (not an abstract class — use `implements`, never `extends`). The class that implements it (e.g. `WapiPayment`) is the facade described in step 5: it declares `implements PaymentInterface` but holds no business logic itself, delegating every method's work to a dedicated per-operation class. Its verified signatures are:
```ts
settings(paymentCode :string) :Promise<PaymentSettingResponse[]>;
consult(payload :ConsultRequest) :Promise<ConsultResponse>;
transact(payload :CreateTransactionRequest) :Promise<CreateTransactionResponse>;
capture(payload :CaptureRequest) :Promise<CaptureResponse>;
cancel(payload :CancelRequest) :Promise<CancelResponse>;
webhook(payload :object) :PaymentWebhookResponse;
```
It does not declare `request`, `setRequest()`, `createCard`, or `removeCard`. (`createCard`/`removeCard` are intentionally unimplemented today — `CreateCardPaymentProcess.run()`/`RemoveCardPaymentProcess.run()`, `src/models/payment/process/`, just `return {}` without calling `getPaymentDriver()`; this is a deliberately deferred feature, not a gap to fill incidentally while adding an unrelated gateway.)

5. **Author the facade class `<Gateway>.ts` — one class per operation is mandatory.**
The class implementing `PaymentInterface` (e.g. `WapiPayment`, `src/models/payment/integrations/wapi/WapiPayment.ts`) MUST be a facade: it holds no business logic of its own — each of the six `PaymentInterface` methods MUST delegate to its own dedicated per-operation class. This is not optional and there is no "direct implementation" alternative, regardless of how simple the gateway is. Break `transact`/`capture`/`cancel`/`consult`/`settings` each into its own class with no shared base, under a per-operation subfolder (`Transaction/`, `Capture/`, `Cancel/`, `Consult/`, `Setting/`), e.g. `WapiPaymentTransaction` (`src/models/payment/integrations/wapi/v1/Transaction/WapiPaymentTransaction.ts`), mirroring `WapiPaymentTransaction`, `WapiPaymentCapture`, `WapiPaymentCancel`, `WapiPaymentConsultTransaction`, `WapiPaymentSetting` under `wapi/v1/`. The class's constructor takes the operation's payload and assigns it to its own typed `request` field (e.g. `private request :CreateTransactionRequest`); it exposes `send()` (the HTTP call, `public async send() :Promise<CreateTransactionResponse>`) and `format()` (`public format() :CreateTransactionResponse`, translating the raw gateway response via a sibling `<Op>FormatResponse` class in a `format/` subfolder inside the operation's own folder). The facade (`WapiPayment implements PaymentInterface`) then simply delegates each `PaymentInterface` method to `new <Gateway>Payment<Op>(payload).send()` — every method body is a one-line delegation, exactly as `WapiPayment.ts` does today for all six operations.

6. **Normalize gateway status via `PaymentStatus`.**
Create `src/models/payment/integrations/<gateway>/<Gateway>PaymentStatus.ts` extending the abstract class `src/models/payment/integrations/PaymentStatus.ts`. Its constructor takes `gatewayStatus :string` (do not override it unless you have a reason to) and the subclass must implement:
```ts
protected abstract statusMap() :StandardPaymentStatusMap;
```
`getStandardStatus()` (implemented on the base class) looks up `this.gatewayStatus` in that map and returns one of the four fixed values of `StandardPaymentStatus` (`src/models/payment/StandardPaymentStatus.ts`): `WAITING_PAYMENT`, `PAID`, `CANCELED`, `ERROR`. Reference implementation: `src/models/payment/integrations/wapi/WapiPaymentStatus.ts`.

7. **Register the gateway (mandatory).**
Add an import and an entry to `PAYMENT_MAP` in `src/models/payment/payment.map.ts`, keyed `'<gateway>-v<n>'` (e.g. `'cielo-v3'`, `'mercadopago-v1'`), pointing at the new class. Today `PAYMENT_MAP` has 26 commented-out named entries (all pointing at the 26 empty stub classes from step 2) and exactly one active entry, `'*': WapiPayment'`, which `getPaymentDriver()` falls back to for any `paymentCode` with no matching key. No route, controller, or middleware change is needed — `src/routes/payment.ts` is already generic over `paymentCode`, and `PAYMENT_MAP` is the only integration point in the HTTP flow. Skipping this step means the new gateway is simply unreachable; `getPaymentDriver()` will silently fall through to the `'*'` (Wapi) driver instead of the new class.

8. **Follow the payment-specific coding conventions.**
Explicit access modifiers on every implemented method, explicit typed returns (avoid `:any`) for new/modified code, and the per-item error-handling standard for `consult`/`transact`/`capture`/`cancel` are governed by a dedicated rule, not repeated here (follows: `ext/uappi-v3/backend/rules/payment-integration.md`).

## Guardrails

- Never implement business logic directly on the class that implements `PaymentInterface` — it MUST stay a facade, with every one of the six operations delegated to its own dedicated per-operation class (`<Gateway>Payment<Op>`); there is no "simple gateway" exception.
- Never let a gateway's HTTP exception propagate out of `consult`/`transact`/`capture`/`cancel` — catch it and return the operation's standardized response type with `success: false` (see `ext/uappi-v3/backend/rules/payment-integration.md`); letting it propagate through a batch's `Promise.all` (`src/models/payment/process/CreateTransactionProcess.ts`, `CapturePaymentProcess.ts`, `CancelPaymentProcess.ts`, `ConsultPaymentProcess.ts`) reduces the entire batch's result to `[]`, discarding every other item.
- Do not skip the `payment.map.ts` registration — an unregistered gateway is never resolved by `getPaymentDriver()`, which silently falls back to the `'*'` (Wapi) driver instead of raising an error.
- Do not treat the 26 commented-out stub classes in `payment.map.ts`, or the 27th (`picpay/v1/PicPay.ts`, absent from `payment.map.ts` entirely), as evidence of a working or intended pattern — they are empty (`export default class X {}`), don't declare `implements PaymentInterface`, and are deliberately unimplemented placeholders for future, separate merges.
- Do not treat `appmax-api` (`src/models/payment/integrations/appmax-api/v1/`) as a second reference gateway integration — it implements only an OAuth credentialing flow (`OAuthInterface`), not `PaymentInterface`, and is not registered in `payment.map.ts`. Use it only as the reference for the `RestClient` specialization pattern (`AppMaxRestClient`), not for transactional flow.
- Do not copy Wapi's own HTTP client (`src/models/common/wapi/Wapi.ts`) as the HTTP-client template for a new gateway — it is a bespoke client proxying a legacy system, not `RestClient`-based (see step 1).
- Do not implement `createCard`/`removeCard` as a side effect of adding a new gateway — they are a deliberately deferred feature, not part of `PaymentInterface`, and extending the interface to add them is a separate decision outside the scope of adding one gateway.
- There is no schema validation middleware for payment payloads — controllers only type-cast the parsed body (e.g. `as CreateTransactionRequest`), which has no runtime effect. Any payload validation a new integration needs must be implemented inside the integration or its `process/` layer.
