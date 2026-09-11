---
description: >-
  Test cards, forced declines and the gaps between the sandbox and production.
icon: flask
---

# Testing and simulations

The test environment runs the same code as production on separate infrastructure. It validates identically and returns identical response shapes — it simply never moves money.

## Test cards

| Card number | Brand | Outcome |
|---|---|---|
| `4111 1111 1111 1111` | Visa | Approved |
| `5454 5454 5454 5454` | Mastercard | Approved |
| `3782 8224 6310 005` | Amex | Approved |
| `6011 0000 0000 0004` | Discover | Approved |
| `4000 0000 0000 0002` | Visa | Declined — insufficient funds (`3023`) |
| `4000 0000 0000 0069` | Visa | Declined — expired card |
| `4000 0000 0000 0127` | Visa | Declined — incorrect CVV |
| `4000 0000 0000 0119` | Visa | Processing error (`5xx`) |
| `4000 0000 0000 3220` | Visa | 3-D Secure challenge required |
| `4000 0000 0000 3063` | Visa | 3-D Secure frictionless |

Any future expiry and any 3-digit CVV pass validation (4 digits for Amex).

## Simulations

Test cards cover common outcomes. For anything else — a specific decline code, a `HELD` status, a delayed settlement — create a **simulation**, which forces the outcome of your next matching transaction.

```bash
curl -X POST "$PAYSAFE_BASE/paymenthub/v1/simulations" \
  -u "$PAYSAFE_API_KEY:$PAYSAFE_API_SECRET" \
  -H "Content-Type: application/json" \
  -d '{
    "merchantRefNum": "test-held-flow",
    "forceStatus": "HELD",
    "forceErrorCode": null
  }'
```

Simulations are matched by `merchantRefNum`, apply once, and exist only in the test environment.

## What test does not reproduce

{% hint style="warning" %}
* **Settlement timing.** Instant in test. ACH and EFT take days in production; SEPA takes one to two business days.
* **Issuer behaviour.** Real declines depend on the cardholder's bank, their balance and their fraud rules. Test declines are deterministic.
* **Interchange and scheme fees.** Not calculated.
* **Throughput.** Test is rate-limited to 20 requests/second — never size capacity from it.
* **3-D Secure UX.** Test uses a stub ACS, not the cardholder's real bank screen.
{% endhint %}

## What to test before go-live

{% stepper %}
{% step %}
### The happy path

An approved payment, a settlement, a full refund and a partial refund.
{% endstep %}

{% step %}
### Every decline you handle

Each code in your decline-message map. Confirm the customer sees something useful and your order state is correct.
{% endstep %}

{% step %}
### The timeout path

Kill the connection mid-request, then re-send with the same `merchantRefNum`. You must get the original result, not a second charge. **This is the test teams most often skip and most often regret.**
{% endstep %}

{% step %}
### Webhook delivery

Return a `500` deliberately and confirm the retry arrives and is deduplicated. Then confirm a replayed event does not double-fulfil an order.
{% endstep %}

{% step %}
### 3-D Secure, both ways

A frictionless authentication and a challenge, including a challenge the customer abandons.
{% endstep %}
{% endstepper %}

{% hint style="info" %}
Test data is wiped periodically. Do not build long-running fixtures that assume a transaction from last month still exists.
{% endhint %}
