---
description: HTTP Basic authentication, key scopes and how to rotate a key safely.
icon: key
---

# Authentication

Every Paysafe API uses **HTTP Basic authentication over TLS 1.2 or higher**. There are no bearer tokens, no OAuth flow and no request signing to implement.

## The header

Base64-encode `apiUsername:apiPassword` and send it as the `Authorization` header.

{% tabs %}
{% tab title="cURL" %}
```bash
# curl builds the header for you
curl "$PAYSAFE_BASE/paymenthub/v1/paymentmethods" \
  -u "$PAYSAFE_API_KEY:$PAYSAFE_API_SECRET"

# or build it yourself
AUTH=$(printf '%s:%s' "$PAYSAFE_API_KEY" "$PAYSAFE_API_SECRET" | base64)
curl "$PAYSAFE_BASE/paymenthub/v1/paymentmethods" \
  -H "Authorization: Basic $AUTH"
```
{% endtab %}

{% tab title="Node.js" %}
```javascript
const auth = Buffer.from(
  `${process.env.PAYSAFE_API_KEY}:${process.env.PAYSAFE_API_SECRET}`
).toString("base64");

const res = await fetch(`${base}/paymenthub/v1/paymentmethods`, {
  headers: { Authorization: `Basic ${auth}` },
});
```
{% endtab %}

{% tab title="Python" %}
```python
import base64, os, requests

auth = base64.b64encode(
    f"{os.environ['PAYSAFE_API_KEY']}:{os.environ['PAYSAFE_API_SECRET']}".encode()
).decode()

res = requests.get(
    f"{base}/paymenthub/v1/paymentmethods",
    headers={"Authorization": f"Basic {auth}"},
)
```
{% endtab %}

{% tab title="Java" %}
```java
String creds = System.getenv("PAYSAFE_API_KEY") + ":" + System.getenv("PAYSAFE_API_SECRET");
String auth  = Base64.getEncoder().encodeToString(creds.getBytes(StandardCharsets.UTF_8));

HttpRequest req = HttpRequest.newBuilder()
    .uri(URI.create(base + "/paymenthub/v1/paymentmethods"))
    .header("Authorization", "Basic " + auth)
    .build();
```
{% endtab %}
{% endtabs %}

## Key types

| Key | Where it is used | Can move money |
|---|---|---|
| **API key (secret)** | Server to server only | Yes |
| **Single-use token key** | Browser, via Paysafe JS or Checkout | No — creates tokens only |
| **Public API key** | Client-side configuration | No |

{% hint style="danger" %}
**The API secret must never reach a browser, a mobile binary or a public repository.** Anything shipped to a client can be extracted. Client-side card capture uses a single-use token key, which cannot authorize a payment on its own.
{% endhint %}

## Rotating a key

Paysafe supports two active key pairs per account, so you can rotate without downtime.

{% stepper %}
{% step %}
### Issue a second key

In the Merchant Portal, **Settings → API Keys → Create key**. The new secret is shown once.
{% endstep %}

{% step %}
### Deploy it

Roll the new credentials out to every service. Both keys are valid at this point, so a partial rollout is safe.
{% endstep %}

{% step %}
### Confirm nothing uses the old key

**Settings → API Keys** shows a last-used timestamp per key. Wait until the old key has been idle for longer than your longest batch interval.
{% endstep %}

{% step %}
### Revoke the old key

Revocation takes effect within seconds and cannot be undone.
{% endstep %}
{% endstepper %}

{% hint style="warning" %}
Rotate immediately if a secret is exposed — committed to a repository, pasted into a ticket or logged. Revoke first and repair the fallout afterwards; the alternative is someone else moving money on your account.
{% endhint %}

## Common failures

| Response | Cause | Fix |
|---|---|---|
| `401` with code `5279` | Malformed or missing header | Check the Base64 encoding has no newline |
| `401` with code `5270` | Key revoked or wrong environment | Test keys do not work in production, and vice versa |
| `403` | Key lacks permission for the endpoint | Ask your account manager to enable the product |
| Connection reset | TLS below 1.2 | Upgrade your HTTP client |

{% hint style="info" %}
`base64` on macOS and Linux does not wrap by default for short inputs, but some tools do. A wrapped header is the single most common cause of a `5279`.
{% endhint %}
