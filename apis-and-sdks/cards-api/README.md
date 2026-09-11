---
description: >-
  The long-standing card-processing interface. Fully supported, but new
  integrations should use the Payments API. 29 endpoints.
icon: clock-rotate-left
---

# Cards API

**Base path** `/cardpayments/v1` · **29 endpoints**

{% hint style="warning" %}
**Use the [Payments API](../payments-api/) for new integrations.** The Cards API is fully supported and is not deprecated, but new payment methods, network token features and local methods land in the Payments API first — and some never arrive here at all.
{% endhint %}

## When the Cards API is still the right answer

* You have an existing, working integration. There is no forced migration.
* You need a card-only flow with no wallet or local-method ambitions.
* You depend on an endpoint shape the Payments API models differently.

## Mapping to the Payments API

| Cards API | Payments API |
|---|---|
| `POST /auths` | `POST /payments` with `settleWithAuth: false` |
| `POST /auths/{id}/settlement` | `POST /payments/{id}/settle` |
| `POST /auths/{id}/void` | `POST /payments/{id}/void` |
| `POST /settlements/{id}/refund` | `POST /refunds` |
| `POST /originalcredits` | `POST /standalonecredits` |
| `POST /verifications` | `POST /verifications` |

The concepts match; the naming and the token model do not. A migration is mostly mechanical, but the move from raw card data to payment handles is the part worth planning.

## Network tokens

The Cards API can provision **network tokens** — scheme-issued tokens that replace the card number. They update automatically when a customer's card is reissued, which measurably reduces involuntary churn on subscriptions.

{% hint style="success" %}
Merchants moving stored cards to network tokens typically see a **2–4 point** improvement in approval rates on recurring billing, mostly from cards that would otherwise have expired.
{% endhint %}
