---
description: >-
  Get sandbox credentials, find your API key, and understand what the test
  environment does and does not simulate.
icon: flask
---

# Create a test account

The test environment is a full copy of the production platform. It runs the same code, returns the same response shapes and enforces the same validation — it simply never moves money.

{% stepper %}
{% step %}
### Request access

Sign up through the [developer portal](https://developer.paysafe.com/en/support/). A test account is free and needs no contract.
{% endstep %}

{% step %}
### Find your API key

In the Merchant Portal, open **Settings → API Keys**. You will see an **API username** and an **API password**.

{% hint style="danger" %}
The API password is shown **once**. Store it in your secret manager immediately — Paysafe cannot recover it, only reissue it.
{% endhint %}
{% endstep %}

{% step %}
### Authenticate

Both APIs use HTTP Basic authentication over TLS. Base64-encode `apiUsername:apiPassword`:

```bash
export PAYSAFE_AUTH=$(printf '%s:%s' "$PAYSAFE_API_KEY" "$PAYSAFE_API_SECRET" | base64)
curl https://api.test.paysafe.com/paymenthub/v1/paymentmethods \
  -H "Authorization: Basic $PAYSAFE_AUTH"
```
{% endstep %}

{% step %}
### Take a test payment

Follow the [quickstart](https://app.gitbook.com/s/YjnAGVmcGiEiZme2Neu4/getting-started/quickstart) with a test card.
{% endstep %}
{% endstepper %}

## Test cards

| Card number | Brand | Behaviour |
|---|---|---|
| `4111 1111 1111 1111` | Visa | Approved |
| `5454 5454 5454 5454` | Mastercard | Approved |
| `3782 8224 6310 005` | Amex | Approved |
| `4000 0000 0000 0002` | Visa | Declined — insufficient funds |
| `4000 0000 0000 0069` | Visa | Declined — expired card |
| `4000 0000 0000 0119` | Visa | Processing error |
| `4000 0000 0000 3220` | Visa | 3-D Secure challenge required |

Any future expiry date and any three-digit CVV will pass validation (four digits for Amex).

## What test does not simulate

{% hint style="warning" %}
* **Settlement timing.** Funds settle instantly in test; in production ACH and EFT take days.
* **Issuer behaviour.** Real declines depend on the cardholder's issuer. Test declines are deterministic, driven by the card number or an explicit simulation.
* **Scheme fees and interchange.** Not calculated in test.
* **Production rate limits.** Test limits are lower — do not use test to size your throughput.
{% endhint %}

For deterministic outcomes beyond the test card list, create a **simulation** — it forces a specific status or decline code on your next transaction. See the [Payment Handles API](https://app.gitbook.com/s/YjnAGVmcGiEiZme2Neu4/payment-handles-api/).
