---
description: >-
  Cards, bank transfers, digital wallets and cash — 70 payment methods behind a
  single REST contract.
icon: credit-card
---

# Payments

Paysafe processes card payments, local bank transfers, digital wallets and cash vouchers through one API. You integrate once; enabling a new payment method afterwards is a configuration change, not a code change.

## How a payment works

Every payment follows the same three-step shape, whichever method the customer picks.

```mermaid
sequenceDiagram
    autonumber
    participant C as Customer
    participant Y as Your server
    participant P as Paysafe
    participant A as Acquirer / scheme

    C->>Y: Chooses a payment method
    Y->>P: Create payment handle
    P-->>Y: paymentHandleToken (single use)
    opt Method needs authentication
        Y->>C: Redirect (3DS, bank login, wallet)
        C->>P: Authenticates
        P-->>Y: Handle status = PAYABLE
    end
    Y->>P: Create payment (token, amount, currency)
    P->>A: Authorize
    A-->>P: Approved
    P-->>Y: status = COMPLETED
    Y->>C: Confirmation
```

The payment handle is the important idea: it is a **single-use token** standing in for whatever instrument the customer chose. Your server never sees a card number, so your PCI scope stays small and the same code path handles a Visa card and an iDEAL bank transfer.

## Capture models

{% tabs %}
{% tab title="Auth and settle" %}
Authorize now, capture later. Use this when you ship goods after the order.

```json
{ "settleWithAuth": false }
```

Funds are held on the customer's card, then captured with a separate call to `POST /payments/{id}/settle`. Authorizations typically expire after 7 days.
{% endtab %}

{% tab title="Sale" %}
Authorize and capture in one call. Use this for digital goods and anything delivered immediately.

```json
{ "settleWithAuth": true }
```

This is the default in most SDKs and the right choice unless you have a reason to split the two.
{% endtab %}

{% tab title="Partial capture" %}
Capture less than you authorized — a shipped subset of a basket, for example.

```json
{ "amount": 2499 }
```

Send the partial amount on the settle call. The remaining authorization is released automatically.
{% endtab %}
{% endtabs %}

## What to read next

<table data-view="cards"><thead><tr><th></th><th></th><th data-hidden data-card-target data-type="content-ref"></th></tr></thead><tbody><tr><td><strong>Quickstart</strong></td><td>A working payment in ten minutes.</td><td><a href="https://app.gitbook.com/s/YjnAGVmcGiEiZme2Neu4/getting-started/quickstart">Quickstart</a></td></tr><tr><td><strong>Payments API reference</strong></td><td>All 38 endpoints, with request and response schemas.</td><td><a href="https://app.gitbook.com/s/YjnAGVmcGiEiZme2Neu4/payments-api/">Payments API</a></td></tr><tr><td><strong>Payment handles</strong></td><td>How tokenization works and when handles expire.</td><td><a href="https://app.gitbook.com/s/YjnAGVmcGiEiZme2Neu4/payment-handles-api/">Payment Handles API</a></td></tr></tbody></table>
