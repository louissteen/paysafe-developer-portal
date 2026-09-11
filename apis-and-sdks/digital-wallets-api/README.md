---
description: >-
  Accept and pay out to Skrill and NETELLER, and on-ramp fiat to crypto.
  21 endpoints.
icon: money-bill-transfer
---

# Digital Wallets API

**Base path** `/digitalwallets/v1` · **21 endpoints**

Skrill and NETELLER are Paysafe-owned wallets with tens of millions of account holders, concentrated in gaming, trading and cross-border commerce. This API accepts payments from them and pays out to them.

## Acceptance and payout

{% columns %}
{% column width="50%" %}
### Accepting

The customer is redirected to the wallet, authenticates, and approves the payment. Funds are guaranteed on approval — there is no chargeback mechanism equivalent to cards.
{% endcolumn %}

{% column width="50%" %}
### Paying out

Send funds to a wallet by email address or wallet id. Payouts usually land in seconds, which is why the method is common where fast withdrawal is a competitive feature.
{% endcolumn %}
{% endcolumns %}

{% hint style="info" %}
Wallet payments do not carry card-scheme chargeback rights. Disputes run through Paysafe's own process instead, which is generally faster and less costly — but the protections differ, so do not reuse your card dispute logic unchanged.
{% endhint %}

## Crypto On-Ramp

Customers buy cryptocurrency with fiat held in their Skrill wallet.

{% stepper %}
{% step %}
### Quote

Request a quote for a fiat amount and a target asset. It returns the rate, the fee breakdown and an expiry — quotes are valid for **60 seconds**.
{% endstep %}

{% step %}
### Order

Execute against a live quote. An expired quote is rejected; request a fresh one rather than retrying.
{% endstep %}

{% step %}
### Settle

The asset is credited to the customer's crypto balance. The order reaches a terminal status within minutes.
{% endstep %}
{% endstepper %}

{% hint style="warning" %}
Available assets depend on the customer's jurisdiction, and the list changes as regulation moves. Always call the assets endpoint for the specific customer rather than hard-coding a list in your UI.
{% endhint %}
