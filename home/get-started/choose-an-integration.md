---
description: >-
  Four ways to accept a payment, and an honest account of the trade-off each one
  makes.
icon: signs-post
---

# Choose an integration

The four acceptance products differ in one dimension: **how much of the payment surface you build yourself**. More control costs more work and more PCI scope.

| | Paysafe Checkout | Paysafe JS | Payments API | Embedded Wallets |
|---|---|---|---|---|
| **You build** | A button | Your own form layout | Everything | Wallet UX inside your app |
| **PCI scope** | SAQ A | SAQ A | SAQ D | SAQ A |
| **Time to first payment** | Hours | Days | Weeks | Weeks |
| **Payment methods** | All enabled | Cards, Apple Pay, Google Pay | All enabled | Wallet balance + funding |
| **UI control** | Themeable | Full | Full | Full |
| **Best for** | Getting live fast | Branded checkout | Complex flows, marketplaces | Balances and payouts |

## Decision guide

{% stepper %}
{% step %}
### Do your customers hold a balance with you?

If they add funds, spend over time and withdraw — that is **Embedded Wallets**, regardless of what else you use.
{% endstep %}

{% step %}
### Do you need the checkout to look like your product?

If no, use **Paysafe Checkout**. It is themeable, hosted, and the fastest route to a live payment.
{% endstep %}

{% step %}
### Is a card form inside your own page enough?

If yes, use **Paysafe JS**. You lay out the page; Paysafe owns the iframed fields that touch card data, so you stay at SAQ A.
{% endstep %}

{% step %}
### Anything else

Use the **Payments API** directly. Split captures, marketplace flows, unusual local methods and server-to-server orchestration all live here.
{% endstep %}
{% endstepper %}

{% hint style="success" %}
These are not mutually exclusive. A common shape is Paysafe Checkout for first-time customers and the Payments API with stored payment handles for returning ones.
{% endhint %}

## Next

* [Create a test account](create-a-test-account.md)
* [Quickstart](https://app.gitbook.com/s/XSPACE_APIS/getting-started/quickstart)
