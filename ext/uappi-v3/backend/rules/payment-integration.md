---
shortDescription: Access-modifier, typed-return, and per-item error-handling conventions for payment integrations in services/external.uappi.
scope: payment-integration
product: uappi-v3/backend
version: 0.1.0
lastUpdated: 2026-07-27
---

## Statement

In any new or modified class under `src/models/payment/integrations/` (`services/external.uappi`):

- Every implemented method MUST declare an explicit access modifier (`public`, `private`, or `protected`). The only exception is a method declared on an `interface` (e.g. `PaymentInterface`, `src/models/payment/integrations/PaymentInterface.ts`), which cannot carry an access modifier by TypeScript syntax. Legacy methods predating this convention MUST NOT be retrofitted solely to satisfy it — apply it to new and modified code only.
- Methods SHOULD declare an explicit typed return type, avoiding `:any` for new or modified code. Same legacy carve-out as above.
- For `consult`, `transact`, `capture`, and `cancel` operations, errors MUST be caught and translated into the standardized response object for that operation with `success: false`, rather than thrown or left to reject the caller's promise. When an operation is invoked over a batch (as `consult`/`transact`/`capture`/`cancel` are from `src/models/payment/process/*.ts` via `Promise.all`), a single item's failure MUST NOT be allowed to reject the batch's `Promise.all` and reduce the whole batch to `[]`— each item MUST resolve independently, successfully or with `success: false`, preserving the other items' results.

## Rationale

Payment integration code is read and extended by future contributors and AI agents dispatched against this codebase; unmarked access levels and implicit `any` returns make it ambiguous which surface is the class's real contract versus incidental implementation detail, increasing the odds a modification breaks an unstated assumption. The error-handling rule exists because the current batch processes (`CreateTransactionProcess`, `CapturePaymentProcess`, `CancelPaymentProcess`, `ConsultPaymentProcess`, all in `src/models/payment/process/`) wrap their `Promise.all(...)` in a single `try/catch` that returns `[]` for the entire batch on any rejection — one gateway failing on one item today silently discards every other item's result. `WapiPaymentTransaction.send()` (`src/models/payment/integrations/wapi/v1/Transaction/WapiPaymentTransaction.ts`) already avoids this by catching its own error and returning a typed response with `success: false` instead of throwing, so the batch's `Promise.all` never sees a rejection from it. Every current and future gateway integration must follow that same shape so batch operations degrade per-item instead of all-or-nothing.
