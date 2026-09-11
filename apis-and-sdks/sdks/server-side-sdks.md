---
description: >-
  Java, PHP, Node.js, Python and .NET libraries for the Paysafe REST APIs.
icon: server
---

# Server-side SDKs

All five libraries are generated from the same OpenAPI specifications that produce this documentation, so the models and this reference cannot disagree.

| Language | Version | Requires |
|---|---|---|
| Java | 2.0.0 | Java 11+ |
| PHP | 3.2.0 | PHP 8.1+ |
| Node.js | 4.1.0 | Node 18+ |
| Python | 2.4.0 | Python 3.9+ |
| .NET | 3.0.0 | .NET 6+ |

## Install

{% tabs %}
{% tab title="Node.js" %}
```bash
npm install paysafe
```
{% endtab %}

{% tab title="Python" %}
```bash
pip install paysafe
```
{% endtab %}

{% tab title="Java" %}
```xml
<dependency>
  <groupId>com.paysafe</groupId>
  <artifactId>paysafe-sdk</artifactId>
  <version>2.0.0</version>
</dependency>
```
{% endtab %}

{% tab title="PHP" %}
```bash
composer require paysafe/paysafe-sdk
```
{% endtab %}

{% tab title=".NET" %}
```bash
dotnet add package Paysafe
```
{% endtab %}
{% endtabs %}

## Configure

{% tabs %}
{% tab title="Node.js" %}
```javascript
import Paysafe from "paysafe";

export const paysafe = new Paysafe({
  apiKey: process.env.PAYSAFE_API_KEY,
  apiSecret: process.env.PAYSAFE_API_SECRET,
  environment: "test",
  timeout: 30_000,
  maxRetries: 3,
});
```
{% endtab %}

{% tab title="Python" %}
```python
from paysafe import Paysafe

paysafe = Paysafe(
    api_key=os.environ["PAYSAFE_API_KEY"],
    api_secret=os.environ["PAYSAFE_API_SECRET"],
    environment="test",
    timeout=30,
    max_retries=3,
)
```
{% endtab %}

{% tab title="Java" %}
```java
Paysafe paysafe = Paysafe.builder()
    .apiKey(System.getenv("PAYSAFE_API_KEY"))
    .apiSecret(System.getenv("PAYSAFE_API_SECRET"))
    .environment(Environment.TEST)
    .timeout(Duration.ofSeconds(30))
    .maxRetries(3)
    .build();
```
{% endtab %}

{% tab title="PHP" %}
```php
$paysafe = new Paysafe\Client([
    'apiKey'      => getenv('PAYSAFE_API_KEY'),
    'apiSecret'   => getenv('PAYSAFE_API_SECRET'),
    'environment' => 'test',
    'timeout'     => 30,
    'maxRetries'  => 3,
]);
```
{% endtab %}
{% endtabs %}

## What the SDKs do for you

* **Retries** with exponential backoff on `429` and `5xx`, respecting `Retry-After`. Never on `4xx`.
* **Pagination** as a lazy iterator, so you do not manage `offset` by hand.
* **Typed models** generated from the specs, with editor completion.
* **Structured errors** carrying `code`, `message` and `fieldErrors`.
* **Logging hooks** that redact card numbers and credentials before anything is written.

{% hint style="info" %}
Not every REST operation is exposed as a typed method. All five SDKs provide a raw request escape hatch for anything unsupported, so you never have to abandon the SDK to reach one endpoint.
{% endhint %}

## Webhooks

Every SDK ships a signature verifier. Use it — do not compare strings yourself.

```javascript
app.post("/webhooks/paysafe",
  express.raw({ type: "application/json" }),
  (req, res) => {
    let event;
    try {
      event = paysafe.webhooks.constructEvent(
        req.body,                              // the RAW body, not parsed JSON
        req.headers["paysafe-signature"],
        process.env.PAYSAFE_WEBHOOK_SECRET
      );
    } catch {
      return res.sendStatus(400);
    }

    res.sendStatus(200);                       // acknowledge first
    void handleAsync(event);                   // then do the slow work
  });
```

{% hint style="danger" %}
Verification needs the **raw request body**. If a JSON body-parser runs first, the bytes are re-serialized and every signature check fails.
{% endhint %}
