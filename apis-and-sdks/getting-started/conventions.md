---
description: >-
  Amounts, idempotency, pagination, timestamps and the rules that hold across
  every Paysafe API.
icon: ruler-combined
---

# API conventions

These rules apply to all eight APIs. Learn them once.

## Amounts are integers in the minor unit

{% hint style="danger" %}
`amount` is **always** an integer in the currency's smallest unit. There are no decimal amounts anywhere in the Paysafe APIs.
{% endhint %}

| Human amount | Currency | Exponent | Send |
|---|---|---|---|
| $49.99 | USD | 2 | `4999` |
| €1,250.00 | EUR | 2 | `125000` |
| ¥1,250 | JPY | 0 | `1250` |
| 1.500 KWD | KWD | 3 | `1500` |

The exponent for every supported currency is in [Currency codes](https://app.gitbook.com/s/s32UcT9FwtQGR4UN7RvJ/reference-information/currency-codes).

```javascript
// Do this
const minor = Math.round(displayAmount * 10 ** exponent);

// Not this — floating point will bite you
const minor = displayAmount * 100;  // 19.99 * 100 === 1998.9999999999998
```

## Idempotency via merchantRefNum

Every money-moving request takes a `merchantRefNum` — **your** identifier for the operation. Paysafe enforces uniqueness per account.

* Reuse the same value on a retry and you get the original result back, not a second charge.
* Reuse it for a genuinely different operation and you get `409 Conflict`.

```javascript
const ref = `order-${orderId}-attempt-1`;   // deterministic, derived from your data
// NOT: `order-${Date.now()}`               // a retry generates a new value and double-charges
```

{% hint style="warning" %}
Generate `merchantRefNum` from data you already have — an order id, an invoice number. A timestamp or a random UUID generated at call time defeats the whole mechanism, because a retry produces a different one.
{% endhint %}

## Pagination

List endpoints take `limit` (default 10, max 100) and `offset`, and return a `meta` block.

```json
{
  "meta": { "offset": 0, "limit": 10, "totalItems": 137 },
  "payments": [ ... ]
}
```

```javascript
async function* allPayments(params = {}) {
  let offset = 0;
  for (;;) {
    const page = await paysafe.payments.list({ ...params, limit: 100, offset });
    yield* page.payments;
    offset += page.payments.length;
    if (offset >= page.meta.totalItems || page.payments.length === 0) return;
  }
}
```

{% hint style="info" %}
Deep pagination over large result sets is slow. Filter by `merchantRefNum` or a date range rather than walking every page.
{% endhint %}

## Timestamps

All timestamps are **ISO 8601 in UTC**: `2026-09-11T14:23:05Z`. Send UTC; convert for display only.

## Identifiers

| Field | Owner | Shape |
|---|---|---|
| `id` | Paysafe | UUID, e.g. `8a8195ea-7b0f-4d23-9d4b-2c3f6e1a9b44` |
| `merchantRefNum` | You | Free-form string, max 255 chars, unique per account |

Store both. `id` is what support will ask for; `merchantRefNum` is how you find a transaction when a call timed out.

## Status values

| Status | Terminal | Meaning |
|---|---|---|
| `RECEIVED` | No | Accepted, not yet processed |
| `PENDING` | No | Waiting on an external party |
| `PROCESSING` | No | In flight |
| `HELD` | No | Held by risk rules |
| `COMPLETED` | Yes | Succeeded |
| `FAILED` | Yes | Did not succeed |
| `CANCELLED` | Yes | Cancelled before completion |

{% hint style="warning" %}
Treat any non-terminal status as "not yet decided". Do not release goods on `PENDING` — wait for the webhook or poll until the status is terminal.
{% endhint %}

## Field constraints

* Strings are UTF-8. A small set of characters is rejected everywhere — see [Global invalid characters](https://app.gitbook.com/s/s32UcT9FwtQGR4UN7RvJ/reference-information/global-invalid-characters.md).
* `country` is ISO 3166-1 alpha-2, uppercase. `GB`, never `UK`.
* `state` is the ISO 3166-2 subdivision code for US and Canadian addresses.
* Unknown fields in a request body are rejected, not ignored.
