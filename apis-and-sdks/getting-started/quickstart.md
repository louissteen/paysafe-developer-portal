---
description: Take a card payment end to end against the test environment.
icon: bolt
---

# Quickstart

By the end of this page you will have created a payment handle, used it to take a $49.99 payment, and read the result back. Everything runs against the test environment, so no funds move.

**You will need** a test account and its API key — see [Create a test account](https://app.gitbook.com/s/VQHBBY7AKKsm5pK8l7Ix/get-started/create-a-test-account.md).

{% stepper %}
{% step %}
### Set your credentials

```bash
export PAYSAFE_API_KEY="your-api-username"
export PAYSAFE_API_SECRET="your-api-password"
export PAYSAFE_BASE="https://api.test.paysafe.com"
```

{% hint style="danger" %}
Never commit these, and never ship them to a browser or a mobile binary. The API secret authorizes money movement.
{% endhint %}
{% endstep %}

{% step %}
### Create a payment handle

A payment handle is a single-use token standing in for the customer's instrument. In production the card details come from Paysafe JS or Checkout and never touch your server; here we send a test card directly so the example is self-contained.

{% tabs %}
{% tab title="cURL" %}
```bash
curl -X POST "$PAYSAFE_BASE/paymenthub/v1/paymenthandles" \
  -u "$PAYSAFE_API_KEY:$PAYSAFE_API_SECRET" \
  -H "Content-Type: application/json" \
  -d '{
    "merchantRefNum": "ref-5f2c1a90",
    "transactionType": "PAYMENT",
    "paymentType": "CARD",
    "amount": 4999,
    "currencyCode": "USD",
    "card": {
      "cardNum": "4111111111111111",
      "cardExpiry": { "month": 11, "year": 2029 },
      "cvv": "123",
      "holderName": "Jane Ellery"
    },
    "billingDetails": {
      "street": "100 Queen Street West",
      "city": "Toronto",
      "state": "ON",
      "country": "CA",
      "zip": "M5H 2N2"
    }
  }'
```
{% endtab %}

{% tab title="Node.js" %}
```javascript
const handle = await paysafe.paymentHandles.create({
  merchantRefNum: "ref-5f2c1a90",
  transactionType: "PAYMENT",
  paymentType: "CARD",
  amount: 4999,
  currencyCode: "USD",
  card: {
    cardNum: "4111111111111111",
    cardExpiry: { month: 11, year: 2029 },
    cvv: "123",
    holderName: "Jane Ellery",
  },
  billingDetails: {
    street: "100 Queen Street West",
    city: "Toronto",
    state: "ON",
    country: "CA",
    zip: "M5H 2N2",
  },
});

console.log(handle.paymentHandleToken); // "SC1a-Hm2T9Kd8pQ"
```
{% endtab %}

{% tab title="Python" %}
```python
handle = paysafe.payment_handles.create(
    merchant_ref_num="ref-5f2c1a90",
    transaction_type="PAYMENT",
    payment_type="CARD",
    amount=4999,
    currency_code="USD",
    card={
        "cardNum": "4111111111111111",
        "cardExpiry": {"month": 11, "year": 2029},
        "cvv": "123",
        "holderName": "Jane Ellery",
    },
    billing_details={
        "street": "100 Queen Street West",
        "city": "Toronto",
        "state": "ON",
        "country": "CA",
        "zip": "M5H 2N2",
    },
)

print(handle.payment_handle_token)  # "SC1a-Hm2T9Kd8pQ"
```
{% endtab %}
{% endtabs %}

The response contains a `paymentHandleToken` and `status: "PAYABLE"`. Keep the token — it expires in **15 minutes** and can be used **once**.
{% endstep %}

{% step %}
### Take the payment

{% tabs %}
{% tab title="cURL" %}
```bash
curl -X POST "$PAYSAFE_BASE/paymenthub/v1/payments" \
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
const payment = await paysafe.payments.create({
  merchantRefNum: "ref-5f2c1a90",
  amount: 4999,
  currencyCode: "USD",
  paymentHandleToken: handle.paymentHandleToken,
  settleWithAuth: true,
});

console.log(payment.status); // "COMPLETED"
```
{% endtab %}

{% tab title="Python" %}
```python
payment = paysafe.payments.create(
    merchant_ref_num="ref-5f2c1a90",
    amount=4999,
    currency_code="USD",
    payment_handle_token=handle.payment_handle_token,
    settle_with_auth=True,
)

print(payment.status)  # "COMPLETED"
```
{% endtab %}
{% endtabs %}

A `status` of `COMPLETED` means the payment was authorized and captured.

{% hint style="warning" %}
`amount` must match the amount on the handle. `settleWithAuth: true` captures immediately; set it to `false` if you ship goods later and want to capture separately.
{% endhint %}
{% endstep %}

{% step %}
### Read it back

```bash
curl "$PAYSAFE_BASE/paymenthub/v1/payments?merchantRefNum=ref-5f2c1a90" \
  -u "$PAYSAFE_API_KEY:$PAYSAFE_API_SECRET"
```

Looking a payment up by your own `merchantRefNum` is the correct way to recover from a timeout — see [Errors and retries](errors-and-retries.md).
{% endstep %}
{% endstepper %}

## What to do next

<table data-view="cards"><thead><tr><th></th><th></th><th data-hidden data-card-target data-type="content-ref"></th></tr></thead><tbody><tr><td><strong>Stop sending card data</strong></td><td>Move card capture into Paysafe JS so your servers stay out of PCI scope.</td><td><a href="../sdks/paysafe-js.md">Paysafe JS</a></td></tr><tr><td><strong>Handle the result asynchronously</strong></td><td>Subscribe to webhooks instead of polling.</td><td><a href="https://app.gitbook.com/s/s32UcT9FwtQGR4UN7RvJ/tutorials/handling-webhooks.md">Handling webhooks</a></td></tr><tr><td><strong>Store the card</strong></td><td>Save the instrument for repeat and recurring payments.</td><td><a href="../customer-vault-api/">Customer Vault API</a></td></tr><tr><td><strong>Go live</strong></td><td>The checklist before you switch to production credentials.</td><td><a href="https://app.gitbook.com/s/s32UcT9FwtQGR4UN7RvJ/guides/going-live.md">Go live checklist</a></td></tr></tbody></table>
