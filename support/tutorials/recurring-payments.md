---
description: >-
  Store a card, flag credentials on file correctly, and bill on a schedule
  without losing customers to avoidable declines.
icon: repeat
---

# Recurring payments

Recurring billing has two halves: storing the instrument, and charging it later with the right scheme flags. The second half is where approval rates are won and lost.

## Store the card

The first payment is a normal, customer-present payment — with one addition: you tell Paysafe to keep the instrument.

{% stepper %}
{% step %}
### Get consent, visibly

Before you store anything, the cardholder must agree, and you must tell them what will happen: the amount, the frequency, and how to cancel.

{% hint style="danger" %}
This is not a formality. A stored-credential transaction without documented consent loses every chargeback it attracts, and schemes fine merchants who do it at scale.
{% endhint %}
{% endstep %}

{% step %}
### Create the profile and store the card

```javascript
const profile = await paysafe.customerVault.profiles.create({
  merchantCustomerId: `cust-${userId}`,
  firstName: "Jane",
  lastName: "Ellery",
  email: "jane.ellery@example.com",
});

const card = await paysafe.customerVault.cards.create(profile.id, {
  singleUseToken: tokenFromBrowser,     // from Paysafe JS
});

await db.users.saveCardToken(userId, profile.id, card.id);
```
{% endstep %}

{% step %}
### Take the first payment as customer-initiated

```javascript
await paysafe.payments.create({
  merchantRefNum: `sub-${subscriptionId}-1`,
  amount: 1999,
  currencyCode: "USD",
  paymentHandleToken: handleFromStoredCard,
  settleWithAuth: true,
  storedCredential: {
    type: "RECURRING",
    occurrence: "INITIAL",          // this is the first of a series
  },
});
```
{% endstep %}
{% endstepper %}

## Bill on a schedule

Later charges are **merchant-initiated**. Flag them as such.

```javascript
await paysafe.payments.create({
  merchantRefNum: `sub-${subscriptionId}-${cycleNumber}`,
  amount: 1999,
  currencyCode: "USD",
  paymentHandleToken: handleFromStoredCard,
  settleWithAuth: true,
  storedCredential: {
    type: "RECURRING",
    occurrence: "SUBSEQUENT",
    initialTransactionId: firstPaymentId,   // links the series
  },
});
```

{% hint style="warning" %}
`initialTransactionId` is what tells the issuer this is a continuation of an authenticated series. Omitting it is the most common cause of recurring declines that "worked last month" — and it also forfeits the SCA exemption in Europe.
{% endhint %}

## Handling failures

Not every decline deserves a retry, and retrying the wrong ones gets you fined.

| Code | Meaning | Retry? |
|---|---|---|
| `3023` | Insufficient funds | Yes — 3 attempts over 7 days |
| `3024` | Issuer unavailable | Yes — within hours |
| `3009` | Generic decline | Once, after several days |
| `3022` | Lost or stolen | **Never** — ask for a new card |
| `3040` | Not permitted | **Never** |
| Expired card | Card expired | Update the card first |

```javascript
const RETRYABLE = new Set(["3023", "3024", "3009"]);
const SCHEDULE  = [1, 3, 7];    // days after the original attempt

async function onDecline(subscriptionId, code, attempt) {
  if (!RETRYABLE.has(code) || attempt >= SCHEDULE.length) {
    return dunning.startRecovery(subscriptionId, code);
  }
  return scheduler.retryIn(subscriptionId, SCHEDULE[attempt], attempt + 1);
}
```

## Reduce declines before they happen

{% hint style="success" %}
**Use network tokens.** A network token updates itself when the issuer reissues the card, so a customer who gets a new card in the post does not silently churn. Merchants moving stored cards onto network tokens typically recover 2–4 points of approval rate on recurring billing.
{% endhint %}

* **Retry at a sensible hour** in the cardholder's timezone — approval rates are measurably better outside the early hours.
* **Warn before you charge.** A pre-billing email reduces both declines and disputes.
* **Stop promptly on cancellation.** Charging after cancellation is the fastest route to a chargeback you will lose.
