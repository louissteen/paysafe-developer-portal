---
description: >-
  Embedded Wallets, Skrill and NETELLER acceptance, and fiat-to-crypto
  on-ramping.
icon: wallet
---

# Wallets

Paysafe's wallet products cover two distinct jobs: giving your customers a balance inside your own product, and accepting payment from customers who already hold a Paysafe wallet.

## Embedded Wallets

A white-label wallet that lives inside your application. Customers add funds from a card or bank account, hold a balance in one or more currencies, spend it with you, and withdraw what is left.

{% stepper %}
{% step %}
### Create the wallet

One call per customer, after your own sign-up flow completes. Returns a `walletId` you store against your user record.
{% endstep %}

{% step %}
### Complete KYC

Wallets cannot transact until the customer clears identity checks. Submit identity data and documents, then poll for the verification tier.
{% endstep %}

{% step %}
### Fund it

Deposits arrive from cards, bank transfers or another Paysafe wallet. Each deposit settles to a currency-specific balance.
{% endstep %}

{% step %}
### Spend and withdraw

Spend against the balance with a normal payment, transfer between wallets, or withdraw to the customer's original funding source.
{% endstep %}
{% endstepper %}

{% hint style="warning" %}
KYC requirements vary by jurisdiction and by the limits you want to offer. Verification tiers, and the documents each tier needs, are configured on your account — confirm them with your implementation manager before you design the UI.
{% endhint %}

## Digital Wallets

Accept payment from customers who hold a **Skrill** or **NETELLER** wallet, and pay out to those wallets. Common in gaming, trading and marketplaces where payouts matter as much as acceptance.

## Crypto On-Ramp

Let customers buy cryptocurrency with fiat held in a Skrill wallet. Quotes are valid for 60 seconds; available assets depend on the customer's jurisdiction.

<table data-view="cards"><thead><tr><th></th><th></th><th data-hidden data-card-target data-type="content-ref"></th></tr></thead><tbody><tr><td><strong>Embedded Wallets API</strong></td><td>30 endpoints — wallets, balances, deposits, withdrawals, transfers, KYC.</td><td><a href="https://app.gitbook.com/s/XSPACE_APIS/embedded-wallets-api/">Embedded Wallets API</a></td></tr><tr><td><strong>Digital Wallets API</strong></td><td>21 endpoints — Skrill and NETELLER acceptance, payouts, Crypto On-Ramp.</td><td><a href="https://app.gitbook.com/s/XSPACE_APIS/digital-wallets-api/">Digital Wallets API</a></td></tr><tr><td><strong>Embedded Wallets SDK</strong></td><td>Pre-built web and mobile wallet surfaces.</td><td><a href="https://app.gitbook.com/s/XSPACE_APIS/sdks/embedded-wallets-sdk.md">Embedded Wallets SDK</a></td></tr></tbody></table>
