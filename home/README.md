---
title: It starts here.
description: >-
  Welcome, developers of the world. Everything you need to integrate with
  Paysafe — payments, wallets and merchant onboarding — in one place.
icon: house
cover: .gitbook/assets/hero-home.jpg
coverY: 0
layout:
  width: wide
  cover:
    visible: true
    size: hero
  title:
    visible: true
  description:
    visible: true
  tableOfContents:
    visible: false
  outline:
    visible: false
  pagination:
    visible: false
---

# It starts here.

{% columns %}
{% column width="58%" %}
Paysafe moves money for thousands of businesses across 120 countries and 70 payment methods — cards, bank transfers, digital wallets and cash.

Whatever you are building, the integration starts with one REST API, one set of credentials and a test environment that behaves exactly like production.

{% hint style="info" %}
**New here?** The [quickstart](https://app.gitbook.com/s/XSPACE_APIS/getting-started/quickstart) takes a card payment end to end in about ten minutes, using a test account you can create for free.
{% endhint %}
{% endcolumn %}

{% column width="42%" %}
<table data-view="cards" data-full-width="false"><thead><tr><th></th><th></th><th data-hidden data-card-target data-type="content-ref"></th></tr></thead><tbody><tr><td><strong>Start building</strong></td><td>Take your first payment in ten minutes.</td><td><a href="https://app.gitbook.com/s/XSPACE_APIS/getting-started/quickstart">Quickstart</a></td></tr><tr><td><strong>Browse the API</strong></td><td>200 endpoints across eight REST APIs.</td><td><a href="https://app.gitbook.com/s/XSPACE_APIS/">API reference</a></td></tr><tr><td><strong>Get a test account</strong></td><td>Free sandbox credentials, no contract.</td><td><a href="https://developer.paysafe.com/en/support/">Sign up</a></td></tr></tbody></table>
{% endcolumn %}
{% endcolumns %}

***

## Build payment and wallet solutions

Four ways to accept money, from a fully hosted checkout to a raw REST integration. Most teams start with Paysafe Checkout and move down the stack as their requirements grow.

<table data-view="cards"><thead><tr><th></th><th></th><th></th><th data-hidden data-card-target data-type="content-ref"></th><th data-hidden data-type="files"></th></tr></thead><tbody><tr><td><strong>Payments API</strong></td><td>Connect your application to our REST-based Payments API to process payments across every method Paysafe supports.</td><td><em>Full control · Server-side</em></td><td><a href="https://app.gitbook.com/s/XSPACE_APIS/payments-api/">Payments API</a></td><td><a href=".gitbook/assets/icon-payments-api.svg">icon-payments-api.svg</a></td></tr><tr><td><strong>Paysafe Checkout</strong></td><td>A customizable, secure checkout accepting every enabled payment method through a single integration.</td><td><em>Fastest · Hosted</em></td><td><a href="https://app.gitbook.com/s/XSPACE_APIS/sdks/paysafe-checkout.md">Paysafe Checkout</a></td><td><a href=".gitbook/assets/icon-checkout.svg">icon-checkout.svg</a></td></tr><tr><td><strong>Paysafe JS</strong></td><td>Embed payment fields directly in your own form. Sensitive data never touches your servers, so PCI scope stays at SAQ A.</td><td><em>Your UI · PCI-light</em></td><td><a href="https://app.gitbook.com/s/XSPACE_APIS/sdks/paysafe-js.md">Paysafe JS</a></td><td><a href=".gitbook/assets/icon-paysafe-js.svg">icon-paysafe-js.svg</a></td></tr><tr><td><strong>Embedded Wallets</strong></td><td>Give your customers a wallet inside your product — add funds, hold balances, spend and withdraw.</td><td><em>Balances · Payouts</em></td><td><a href="https://app.gitbook.com/s/XSPACE_APIS/embedded-wallets-api/">Embedded Wallets</a></td><td><a href=".gitbook/assets/icon-wallet.svg">icon-wallet.svg</a></td></tr></tbody></table>

***

## Take a payment in four lines

The shortest path from credentials to an approved authorization. Swap in your own API key and run it against the test environment — no funds move.

{% tabs %}
{% tab title="cURL" %}
```bash
curl -X POST https://api.test.paysafe.com/paymenthub/v1/payments \
  -u "$PAYSAFE_API_KEY:$PAYSAFE_API_SECRET" \
  -H "Content-Type: application/json" \
  -d '{
    "merchantRefNum": "ref-5f2c1a90",
    "amount": 4999,
    "currencyCode": "USD",
    "paymentHandleToken": "SC1a-Hm2T9Kd8pQ",
    "settleWithAuth": true
  }'
```
{% endtab %}

{% tab title="Node.js" %}
```javascript
import Paysafe from "paysafe";

const paysafe = new Paysafe({
  apiKey: process.env.PAYSAFE_API_KEY,
  apiSecret: process.env.PAYSAFE_API_SECRET,
  environment: "test",
});

const payment = await paysafe.payments.create({
  merchantRefNum: "ref-5f2c1a90",
  amount: 4999,                 // $49.99 — always the minor unit
  currencyCode: "USD",
  paymentHandleToken: "SC1a-Hm2T9Kd8pQ",
  settleWithAuth: true,
});

console.log(payment.status); // "COMPLETED"
```
{% endtab %}

{% tab title="Python" %}
```python
from paysafe import Paysafe

paysafe = Paysafe(
    api_key=os.environ["PAYSAFE_API_KEY"],
    api_secret=os.environ["PAYSAFE_API_SECRET"],
    environment="test",
)

payment = paysafe.payments.create(
    merchant_ref_num="ref-5f2c1a90",
    amount=4999,                  # $49.99 — always the minor unit
    currency_code="USD",
    payment_handle_token="SC1a-Hm2T9Kd8pQ",
    settle_with_auth=True,
)

print(payment.status)  # "COMPLETED"
```
{% endtab %}

{% tab title="Java" %}
```java
Paysafe paysafe = Paysafe.builder()
    .apiKey(System.getenv("PAYSAFE_API_KEY"))
    .apiSecret(System.getenv("PAYSAFE_API_SECRET"))
    .environment(Environment.TEST)
    .build();

Payment payment = paysafe.payments().create(
    PaymentRequest.builder()
        .merchantRefNum("ref-5f2c1a90")
        .amount(4999L)               // $49.99 — always the minor unit
        .currencyCode("USD")
        .paymentHandleToken("SC1a-Hm2T9Kd8pQ")
        .settleWithAuth(true)
        .build());

System.out.println(payment.getStatus()); // COMPLETED
```
{% endtab %}

{% tab title="PHP" %}
```php
<?php
$paysafe = new Paysafe\Client([
    'apiKey'      => getenv('PAYSAFE_API_KEY'),
    'apiSecret'   => getenv('PAYSAFE_API_SECRET'),
    'environment' => 'test',
]);

$payment = $paysafe->payments->create([
    'merchantRefNum'      => 'ref-5f2c1a90',
    'amount'              => 4999,   // $49.99 — always the minor unit
    'currencyCode'        => 'USD',
    'paymentHandleToken'  => 'SC1a-Hm2T9Kd8pQ',
    'settleWithAuth'      => true,
]);

echo $payment->status; // "COMPLETED"
```
{% endtab %}
{% endtabs %}

{% hint style="warning" %}
`amount` is always an integer in the currency's **minor unit**. `4999` is $49.99. Sending `49.99` will be rejected — see [currency codes](https://app.gitbook.com/s/XSPACE_SUPPORT/reference-information/currency-codes).
{% endhint %}

***

## Why teams build on Paysafe

{% columns %}
{% column width="25%" %}
### Global reach

**120 countries · 70 payment methods · 40 currencies.** Cards, bank transfers, wallets and cash, behind one API contract.
{% endcolumn %}

{% column width="25%" %}
### Built for scale

**99.99% platform availability.** Active-active processing across regions, with automatic acquirer failover on soft declines.
{% endcolumn %}

{% column width="25%" %}
### Compliance included

**PCI DSS Level 1.** Tokenization, network tokens and 3-D Secure 2.x keep you out of scope and inside PSD2 SCA rules.
{% endcolumn %}

{% column width="25%" %}
### Real support

**Named integration engineers.** Sandbox parity with production, and a support team that has seen your edge case before.
{% endcolumn %}
{% endcolumns %}

***

## Create onboarding solutions

If you onboard merchants of your own — a marketplace, a platform, a PayFac — Paysafe can underwrite and board them for you.

<table data-view="cards"><thead><tr><th></th><th></th><th data-hidden data-card-target data-type="content-ref"></th></tr></thead><tbody><tr><td><strong>Applications API</strong></td><td>A white-labelled merchant onboarding experience using our REST-based API, with bulk submission for high-volume platforms.</td><td><a href="https://app.gitbook.com/s/XSPACE_APIS/applications-api/">Applications API</a></td></tr><tr><td><strong>Simplified Onboarding</strong></td><td>A ready-made online application form that requires no development work at all. Send merchants a link and track decisions in the portal.</td><td><a href="https://app.gitbook.com/s/XSPACE_SUPPORT/guides/simplified-onboarding.md">Simplified Onboarding</a></td></tr></tbody></table>

***

## Client and server SDKs

Drop-in libraries for the languages and platforms most Paysafe integrations are built on.

<table data-view="cards"><thead><tr><th></th><th></th><th data-hidden data-card-target data-type="content-ref"></th></tr></thead><tbody><tr><td><strong>Server-side</strong></td><td>Java · PHP · Node.js · Python · .NET</td><td><a href="https://app.gitbook.com/s/XSPACE_APIS/sdks/server-side-sdks.md">Server-side SDKs</a></td></tr><tr><td><strong>Mobile</strong></td><td>Android · iOS · React Native</td><td><a href="https://app.gitbook.com/s/XSPACE_APIS/sdks/mobile-sdks.md">Mobile SDKs</a></td></tr><tr><td><strong>Web</strong></td><td>Paysafe JS · Paysafe Checkout</td><td><a href="https://app.gitbook.com/s/XSPACE_APIS/sdks/paysafe-js.md">Paysafe JS</a></td></tr><tr><td><strong>Embedded Wallets SDK</strong></td><td>Web and mobile wallet surfaces</td><td><a href="https://app.gitbook.com/s/XSPACE_APIS/sdks/embedded-wallets-sdk.md">Embedded Wallets SDK</a></td></tr></tbody></table>

***

## What's new

The five most recent documentation and API changes. The [full changelog](https://app.gitbook.com/s/XSPACE_CHANGELOG/) goes back to March 2025 and is filterable by product.

| Date | Change | Area |
|---|---|---|
| August 2026 | Shopify payment method extension for Skrill, PaysafeCash, PaysafeCard and BLIK | Shopping carts |
| July 2026 | PHP SDK documentation expanded — local payment methods, webhooks, logging | SDKs |
| June 2026 | **Breaking:** Android SDK now requires `initializeObserver` before tokenization | Mobile SDKs |
| May 2026 | Pay with Crypto launched; BLIK and ePay added via Skrill Quick Checkout | Payment methods |
| April 2026 | Google Pay Payouts, Merchant Termination Inquiry API, Apple Pay Recurring | Payments API |

***

## Guides and articles

{% columns %}
{% column width="50%" %}
### Popular guides

* [Accept your first card payment](https://app.gitbook.com/s/XSPACE_SUPPORT/tutorials/accept-a-card-payment.md)
* [Store a card for recurring billing](https://app.gitbook.com/s/XSPACE_SUPPORT/tutorials/recurring-payments.md)
* [Handle webhooks reliably](https://app.gitbook.com/s/XSPACE_SUPPORT/tutorials/handling-webhooks.md)
* [Go live checklist](https://app.gitbook.com/s/XSPACE_SUPPORT/guides/going-live.md)
{% endcolumn %}

{% column width="50%" %}
### From the Paysafe blog

* [How to accept credit card payments](https://www.paysafe.com/en/blog/)
* [What is PayFac as a Service?](https://www.paysafe.com/en/blog/)
* [Reducing false declines with network tokens](https://www.paysafe.com/en/blog/)
* [PSD2 SCA: what changed and what it costs you](https://www.paysafe.com/en/blog/)
{% endcolumn %}
{% endcolumns %}

***

{% include ".gitbook/includes/support-footer.md" %}
