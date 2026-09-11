---
description: >-
  A white-label wallet inside your product — balances, deposits, withdrawals,
  transfers and KYC. 30 endpoints.
icon: wallet
---

# Embedded Wallets API

**Base path** `/embeddedwallets/v1` · **30 endpoints**

Embedded Wallets gives your customers a balance they hold with you: they add funds, keep money in one or more currencies, spend it in your product, and withdraw what is left.

## The model

| Resource | What it is |
|---|---|
| **Wallet** | One per customer. Holds balances and a KYC state. |
| **Balance** | Per currency. A wallet can hold several at once. |
| **Deposit** | Money in, from a card, bank account or another wallet. |
| **Withdrawal** | Money out, to the customer's funding source. |
| **Transfer** | Money moved between two Paysafe wallets. |
| **Transaction** | The unified ledger view across all of the above. |
| **KYC** | Identity verification gating what the wallet may do. |

## KYC tiers

A wallet cannot transact until it clears verification. Tiers and limits are configured per account and per jurisdiction.

| Tier | Typically requires | Typically allows |
|---|---|---|
| `UNVERIFIED` | Nothing | Nothing |
| `BASIC` | Name, date of birth, address | Low deposit and balance caps |
| `STANDARD` | Government ID document | Standard caps, withdrawals enabled |
| `ENHANCED` | Proof of address, source of funds | High caps, cross-border transfers |

{% hint style="warning" %}
Exact requirements and limits are regulatory and vary by country. Confirm yours with your implementation manager before designing the onboarding UI — the tier names are stable, the thresholds are not.
{% endhint %}

## Balances are per currency

A wallet holding USD and EUR has two balances. There is no implicit conversion: a withdrawal in EUR draws on the EUR balance and fails if it is short, even when the USD balance would cover it.

```json
{
  "walletId": "8a8195ea-7b0f-4d23-9d4b-2c3f6e1a9b44",
  "balances": [
    { "currencyCode": "USD", "available": 124500, "pending": 0 },
    { "currencyCode": "EUR", "available": 8000, "pending": 2500 }
  ]
}
```

`available` is spendable now. `pending` is committed to an in-flight operation and is not.

## Freezing

`freeze` suspends all movement — used for suspected fraud or a compliance review. Balances are preserved; nothing moves in or out until `unfreeze`. Closing requires a zero balance.
