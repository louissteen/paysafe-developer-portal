---
description: >-
  The error envelope, which failures are safe to retry, and how to tell a
  decline from a bug.
icon: triangle-exclamation
---

# Errors and retries

## The error envelope

Every error, on every API, has the same shape.

```json
{
  "error": {
    "code": "5068",
    "message": "Either you submitted a request that is missing a mandatory field or the value of a field does not match the format expected.",
    "details": ["The card expiry date is in the past"],
    "fieldErrors": [
      { "field": "card.cardExpiry.year", "error": "Must be a future date" }
    ]
  }
}
```

`error.code` is stable and is what you should branch on. `error.message` is for humans and may be reworded.

## HTTP status

| Status | Meaning | Retry? |
|---|---|---|
| `400` | Malformed request | **No** — fix the request |
| `401` | Authentication failed | **No** — fix credentials |
| `402` | Transaction declined | **No** — a decline is an answer, not a failure |
| `403` | Not permitted for this account | **No** |
| `404` | No such resource | **No** |
| `409` | Duplicate `merchantRefNum` | **No** — you already have the result |
| `429` | Rate limited | **Yes** — honour `Retry-After` |
| `500`, `502`, `503`, `504` | Paysafe-side problem | **Yes** — with backoff |
| Timeout / connection reset | Unknown outcome | **Yes** — same `merchantRefNum` |

{% hint style="danger" %}
**A timeout is not a failure.** The payment may well have succeeded. Never retry with a fresh `merchantRefNum` after a timeout — reuse the original, or look the transaction up by it.
{% endhint %}

## A correct retry

```javascript
async function withRetry(fn, { attempts = 4 } = {}) {
  for (let i = 0; i < attempts; i++) {
    try {
      return await fn();
    } catch (err) {
      const retryable =
        err.status === 429 || err.status >= 500 || err.code === "ETIMEDOUT";
      if (!retryable || i === attempts - 1) throw err;

      const backoff = Math.min(2 ** i * 250, 4000);
      const jitter = Math.random() * 250;          // avoid a thundering herd
      await new Promise((r) => setTimeout(r, backoff + jitter));
    }
  }
}

// Safe because merchantRefNum is stable across attempts.
await withRetry(() =>
  paysafe.payments.create({
    merchantRefNum: `order-${orderId}`,
    amount: 4999,
    currencyCode: "USD",
    paymentHandleToken: token,
    settleWithAuth: true,
  })
);
```

## Recovering from an unknown outcome

If you retried and still do not know what happened, ask:

```bash
curl "$PAYSAFE_BASE/paymenthub/v1/payments?merchantRefNum=order-1481" \
  -u "$PAYSAFE_API_KEY:$PAYSAFE_API_SECRET"
```

An empty list means nothing was created and you may safely start again. A result means the payment exists — use its status.

## Declines are not errors

A `402` means the issuer said no. The integration worked perfectly. Branch on the decline code and tell the customer something useful.

| Code | Meaning | What to tell the customer |
|---|---|---|
| `3009` | Declined by issuer | "Your bank declined this. Try another card." |
| `3022` | Card reported lost or stolen | "This card cannot be used." Do not retry. |
| `3023` | Insufficient funds | "There aren't enough funds available." |
| `3024` | Issuer unavailable | "Try again in a moment." Retrying later is reasonable. |
| `3040` | Transaction not permitted | "This card can't be used for this purchase." |
| `3082` | Authentication required | Run 3-D Secure and re-submit. |

{% hint style="warning" %}
Never retry a hard decline (`3022`, `3040`) on a loop. Schemes fine merchants for excessive retries against a card the issuer has already refused.
{% endhint %}

## Rate limits

`429` responses carry a `Retry-After` header in seconds. Honour it — a fixed sleep will either waste time or get you limited again.

```javascript
if (res.status === 429) {
  const wait = Number(res.headers.get("retry-after") ?? 1) * 1000;
  await new Promise((r) => setTimeout(r, wait));
}
```
