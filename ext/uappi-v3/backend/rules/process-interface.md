---
shortDescription: Classes implementing ProcessInterface must expose only run() as public; every other method must be protected or private.
scope: process-interface
product: uappi-v3/backend
version: 0.1.0
lastUpdated: 2026-07-27
---

## Statement

Any class under `services/external.uappi` that `implements ProcessInterface` (`src/models/ProcessInterface.ts`) MUST expose exactly one `public` method: `run()`. Every other method on that class MUST be declared `protected` or `private` — never left implicit (which TypeScript treats as public), and never declared as a second `public` method. This applies across every domain that implements the interface — `payment/`, `antifraud/`, `erp/`, `shipping/`, `oauth/`, and `marketplace/` alike — not to payment specifically.

Choose between `protected` and `private` by whether a subclass is expected to override or call the helper: use `protected` when the method is part of a template-method or abstract-base pattern a subclass may need (as in `MarketplaceIntegrationProcessAbstract.validateCredentials()` and `.postValidateCredentials()`, `src/models/marketplace/integrations/common/MarketplaceIntegrationProcessAbstract.ts`); use `private` when the helper is purely internal to that concrete class with no expected subclassing (as in `RunAntiFraudWebhookProcess`'s fields or `AppMaxGetOAuthRedirectUrlProcess`'s `authenticate()`/`authorize()`/`buildResponse()`).

This rule composes with, and does not duplicate, the access-modifier convention in `payment-integration.md`. That rule requires every method under `src/models/payment/integrations/` to declare an explicit modifier at all (`public`, `private`, or `protected`) instead of leaving it implicit. This rule adds a further constraint specific to `ProcessInterface` implementers, service-wide: of the explicit modifiers `payment-integration.md` requires, only `run()` may ever be `public`. Read together: declare a modifier on every method (`payment-integration.md`), and on a `ProcessInterface` implementer that modifier must be `protected` or `private` for everything except `run()` (this rule).

As with `payment-integration.md`'s access-modifier convention, this is a forward-looking rule: legacy classes that already declare `run()` without the explicit `public` keyword are not required to be retrofitted solely to satisfy this rule. Apply it to new and modified `ProcessInterface` implementers.

## Rationale

`run()` is the sole contract member of `ProcessInterface` and the only method any caller is entitled to invoke. The actual external callers are the HTTP controllers — e.g. `Payment.transact()` (`src/controllers/payment/Payment.ts`), `AntiFraud`'s handlers (`src/controllers/antifraud/AntiFraud.ts`), and `ErpWebhookController.parse()` (`src/controllers/erp/ErpWebhookController.ts`) — each of which instantiates a `ProcessInterface` implementer and calls `.run()` on it, nothing else. Domain resolver functions like `getPaymentDriver()`, `getAntiFraud()`, `getErp()`, and `getShippingDriver()` run in the opposite direction: they are invoked *from inside* a process's own `run()` implementation as part of its internal orchestration (e.g. `CreateTransactionProcess.run()` calls `getPaymentDriver(payment.code).transact(...)`), not the reverse — they resolve a driver/integration interface (`PaymentInterface`, `AntiFraudInterface`, `ErpInterface`, etc.), not a `ProcessInterface` implementer. Every other method on the class is an internal implementation detail of that specific process. Declaring a helper `public`, or leaving it implicit and therefore public by TypeScript default, leaks internal structure, invites callers to bypass the intended `run()` entry point, and blurs the actual contract surface down to "whatever happens to be reachable" instead of "exactly what `ProcessInterface` promises." Scoping every non-`run()` method to `protected` or `private` keeps the single entry point enforceable by the type system itself rather than by convention alone — a caller that tries to reach past `run()` gets a compile error, not just a code-review comment.
