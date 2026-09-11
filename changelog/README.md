---
description: >-
  Every documentation and API change, newest first. Filter by product using the
  tags in the top right.
icon: clock-rotate-left
layout:
  width: wide
  title:
    visible: true
  description:
    visible: true
  tableOfContents:
    visible: false
  outline:
    visible: true
  pagination:
    visible: false
  tags:
    visible: true
---

# Changelog

{% columns %}
{% column width="50%" %}
Everything shipped across the Paysafe developer platform since March 2025 — new payment methods, SDK releases, API additions and documentation rewrites.

Entries are tagged by product. Use the filter controls at the top right of the timeline to narrow to the ones you care about, and subscribe to the [RSS feed](https://developer.paysafe.com/) to get them as they land.
{% endcolumn %}

{% column width="50%" %}
{% hint style="warning" %}
**Breaking changes** carry the `Breaking change` tag. There is one in the current window: the **Cardinal SDK observer requirement** in the Android SDK, June 2026. If you ship an Android integration, read that entry before upgrading.
{% endhint %}
{% endcolumn %}
{% endcolumns %}

{% updates format="full" %}

{% update date="2026-08-14" tags="shopping-carts,payment-methods" %}
## Shopify payment method extensions

Documentation for the Shopify payment method extension now covers **Skrill**, **PaysafeCash**, **PaysafeCard** and **BLIK** alongside the existing card integration.

Each method has its own setup section in the Shopping Carts documentation, covering the configuration fields Shopify requires and the merchant account settings each method depends on.
{% endupdate %}

{% update date="2026-07-22" tags="sdks,payments-api" %}
## PHP SDK documentation expanded

The PHP SDK reference for the Payments API gained six new sections:

* Unsupported HTTP requests, and the raw-request escape hatch for reaching them
* Local payment methods
* OpenAPI-led model generation
* Webhooks, including signature verification
* Logging, with credential and card-number redaction
* Worked examples end to end

If you built against the PHP SDK before this, the logging section is worth reading — the default configuration writes more than most teams expect.
{% endupdate %}

{% update date="2026-06-18" tags="sdks,breaking" %}
## Android SDK: Cardinal SDK breaking change

The Cardinal SDK upgrade in Paysafe Android SDK **2.1.0** requires explicit observer initialization. Call `initializeObserver(lifecycleOwner)` before any tokenization call.

```kotlin
val paysafe = PaysafeSDK.Builder()
    .setAPIKey(BuildConfig.PAYSAFE_SINGLE_USE_TOKEN_KEY)
    .setEnvironment(Environment.TEST)
    .build()

paysafe.initializeObserver(this)   // now required
```

{% hint style="danger" %}
Without it, 3-D Secure challenges never return a result and the payment hangs silently — no exception, no callback. Add the call before you upgrade.
{% endhint %}

The same release adds form field styling options: border colour and radius, field height, and per-state colours for focus and error.
{% endupdate %}

{% update date="2026-06-04" tags="sdks,payments-api" %}
## Java SDK 2.0.0

The Java SDK reaches **2.0.0**, with documentation covering unsupported HTTP requests, local payment methods, OpenAPI-led model generation, webhooks, logging and examples — bringing it in line with the PHP SDK.
{% endupdate %}

{% update date="2026-05-27" tags="payment-methods" %}
## BLIK via Skrill Quick Checkout

**BLIK**, the Polish bank transfer scheme, is now available through Skrill Quick Checkout. Consumers approve the payment in their own bank's mobile app using a six-digit code.

BLIK is the dominant online payment method in Poland — worth enabling for any merchant with meaningful Polish traffic.
{% endupdate %}

{% update date="2026-05-27" tags="payment-methods" %}
## ePay via Skrill Quick Checkout

**ePay**, a Bulgarian eWallet, is now supported through Skrill Quick Checkout. Customers pay from their ePay wallet balance.
{% endupdate %}

{% update date="2026-05-13" tags="payment-methods" %}
## Pay with Crypto

Merchants can now accept cryptocurrency directly. The customer pays in crypto; you receive fiat, with conversion handled by Paysafe, so there is no exchange-rate exposure on your balance sheet.
{% endupdate %}

{% update date="2026-05-06" tags="payments-api" %}
## Partial Authorization Service in Paysafe Checkout

A new Paysafe Checkout page documents **Partial Authorization Service (PAS)** in the hosted checkout flow.

PAS matters for prepaid and gift cards that may not cover the full basket: instead of declining outright, it authorizes what is available and reports the shortfall, so you can collect the remainder on a second instrument.
{% endupdate %}

{% update date="2026-04-23" tags="payments-api" %}
## Google Pay Payouts

**Google Pay Payouts** are documented for the Payments API, covering closed-loop payout key concepts and the requirements for enabling them on an account.
{% endupdate %}

{% update date="2026-04-16" tags="onboarding" %}
## Merchant Termination Inquiry API

A new API reference for screening sub-merchants against **Mastercard MATCH Pro** and the **Visa terminated merchant** databases.

{% hint style="warning" %}
Screen before you board. Boarding a listed merchant exposes your own portfolio to scheme action, and the check takes one call.
{% endhint %}
{% endupdate %}

{% update date="2026-04-09" tags="cards-api" %}
## Apple Pay Recurring Payments

Cards API documentation now covers **Apple Pay recurring and subscription payments** through the Paysafe REST API, including the merchant token requirements Apple imposes on recurring flows.
{% endupdate %}

{% update date="2026-04-02" tags="shopping-carts" %}
## ACH, EFT and PayPal in shopping carts

Shopify Paysafe Checkout (Redirect) adds **ACH** and **EFT**. The official WooCommerce integration adds **Google Pay**, **ACH**, **EFT** and **PayPal**.
{% endupdate %}

{% update date="2026-03-26" tags="payments-api,cards-api" %}
## Credentials-on-File documentation rewritten

Credentials-on-File documentation has been comprehensively revised for both the Payments API and the Cards API, adding flow breakdowns, the full list of supported flows, compliance guidance and recommendations for improving acceptance.

{% hint style="info" %}
Correct credentials-on-file flagging measurably improves recurring approval rates. If your stored-credential integration predates this rewrite, it is worth re-reading.
{% endhint %}
{% endupdate %}

{% update date="2026-03-19" tags="onboarding" %}
## Fixed: Payfac Sub-merchant API mislabelled

Several pages referred to the **Payfac Sub-merchant API** as the **Clone API**. All instances are corrected.
{% endupdate %}

{% update date="2026-03-12" tags="payments-api" %}
## Apple Pay Recurring Transactions

The Payments API Apple Pay documentation now covers recurring and subscription transactions.
{% endupdate %}

{% update date="2026-02-19" tags="payment-methods" %}
## Openbucks

**Openbucks**, a United States gift card payment solution, is now supported by the Payments API.
{% endupdate %}

{% update date="2026-02-12" tags="sdks" %}
## React Native SDK

Documentation for the **Paysafe React Native SDK** is published, covering integration of the Android SDK into React Native applications.
{% endupdate %}

{% update date="2026-02-05" tags="sdks,payment-methods" %}
## Google Pay for Paysafe JS and Checkout

A new Google Pay integration page for **Paysafe JS** covers updated tokenization examples, use of the `show` function, and the Google Pay-specific setup fields.

**Paysafe Checkout** gains Google Pay setup instructions and configuration fields in the same release.
{% endupdate %}

{% update date="2026-02-05" tags="sdks,breaking" %}
## Paysafe JS: badBin renamed to binNotification

The `badBin` event is renamed **`binNotification`**. The old name no longer fires.

```javascript
// Before
instance.fields().on("badBin", handler);

// After
instance.fields().on("binNotification", handler);
```

Apple Pay button **height and width** are now configurable in Paysafe JS in the same release.
{% endupdate %}

{% update date="2026-01-22" tags="cards-api" %}
## Apple Pay payload documentation

The **Integrating Paysafe REST API** page in the Apple Pay (Cards API) documentation has been revised, and split into two new sub-pages:

* **Encrypted payload** — using the encrypted Apple Pay payment token with the Paysafe REST API
* **Decrypted payload** — passing decrypted Apple Pay card data to the Paysafe REST API
{% endupdate %}

{% update date="2025-12-11" tags="shopping-carts" %}
## Shopify Embedded Credit Card

**Shopify Embedded Credit Card** documentation is added to the Shopping Carts section.
{% endupdate %}

{% update date="2025-11-20" tags="cards-api" %}
## Network tokenization test cards updated

Test card numbers in the **Network Tokenization Testing** section have been revised.
{% endupdate %}

{% update date="2025-10-23" tags="payment-methods" %}
## iDEAL

**iDEAL**, the Dutch bank transfer scheme, is now supported by the Payments API. iDEAL is the dominant online payment method in the Netherlands.
{% endupdate %}

{% update date="2025-10-09" tags="shopping-carts" %}
## WooCommerce documentation v3

The official WooCommerce documentation is upgraded to **version 3**.
{% endupdate %}

{% update date="2025-09-25" tags="sdks" %}
## Apple Pay QR code scanning

**Paysafe Checkout** and **Paysafe JS** now support Apple Pay QR code scanning for iOS 18+ users, letting a customer on desktop complete payment with their phone.
{% endupdate %}

{% update date="2025-09-18" tags="payments-api" %}
## About Card Payments revamped

The **About Card Payments** page in the Payments API documentation has been rewritten.
{% endupdate %}

{% update date="2025-09-11" tags="payment-methods" %}
## RTP for Pay by Bank (US)

**Pay by Bank (US)** withdrawals now support the **RTP** network, enabling near-instant payouts to US bank accounts.
{% endupdate %}

{% update date="2025-08-21" tags="payments-api" %}
## Payment handles section added

The **Get Started** page in the Payments API documentation is revamped, and a dedicated **payment handles** section is introduced — the concept that keeps card data off your servers.

The **Apple Pay Payouts** page is revised in the same release.
{% endupdate %}

{% update date="2025-06-26" tags="cards-api" %}
## External network tokens

A new **External Network Tokens** page is added to the Network Tokenization documentation, for merchants who provision tokens through their own token requestor.
{% endupdate %}

{% update date="2025-06-12" tags="shopping-carts" %}
## Shopify, and WooCommerce plugin coverage

**Shopify** is added to the Shopping Carts section. WooCommerce content is expanded with separate pages for Paysafe's official plugin and the third-party VanboDevelops plugin.
{% endupdate %}

{% update date="2025-06-05" tags="sdks" %}
## PHP SDK released

The **PHP SDK** for the Payments API joins the server-side SDK family. Transaction flows in the Java SDK documentation are amended in the same release.
{% endupdate %}

{% update date="2025-05-21" tags="sdks,payments-api" %}
## Java SDK released

A **server-side SDK section** is established for the Payments API, and the **Java SDK** is the first release in it.
{% endupdate %}

{% update date="2025-05-07" tags="onboarding" %}
## Onboarding fields revised

**Onboarding Fields** information in the Applications API documentation has been revised.
{% endupdate %}

{% update date="2025-04-24" tags="sdks" %}
## GitHub links for Mobile SDKs

Mobile SDK pages now carry direct **GitHub download links**.

DPAN card information for **Google Pay** on the Test Cards page is revised in the same release.
{% endupdate %}

{% update date="2025-04-17" tags="sdks,payments-api" %}
## Checkout riskCallback reorganized

`riskCallback` parameters for **Paysafe Checkout** have been reorganized.

Delayed withdrawal processing information for **Pay by Bank (US)** is revised.
{% endupdate %}

{% update date="2025-04-10" tags="payments-api" %}
## Integration Upgrades section

A new **Integration Upgrades** section is created for merchants migrating from legacy Paysafe solutions to current ones.
{% endupdate %}

{% update date="2025-04-03" tags="payment-methods" %}
## EPS refunds

A refund payment page is added to the **EPS** payment method documentation.
{% endupdate %}

{% update date="2025-03-20" tags="payment-methods" %}
## EPS

**EPS**, an Austrian bank transfer solution, is now supported.
{% endupdate %}

{% update date="2025-03-13" tags="cards-api" %}
## Address Verification Service documentation

A dedicated **Address Verification Service (AVS)** documentation page is established, covering response codes and how to act on them.
{% endupdate %}

{% endupdates %}
