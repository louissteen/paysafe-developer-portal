---
description: >-
  How AVS results work, what each response code means, and how to act on them
  without rejecting good customers.
icon: location-check
---

# Address Verification Service

AVS compares the billing address the customer gives you against the one the card issuer holds. It is a **signal**, not a verdict — and treating it as a verdict is an expensive mistake.

## Response codes

| Code | Street | ZIP / postcode | Typical action |
|---|---|---|---|
| `X` | Match | 9-digit match | Accept |
| `Y` | Match | 5-digit match | Accept |
| `A` | Match | No match | Review |
| `W` | No match | 9-digit match | Review |
| `Z` | No match | 5-digit match | Review |
| `N` | No match | No match | Review or decline |
| `U` | Unavailable | Unavailable | Accept — issuer does not support AVS |
| `R` | Retry | Retry | Retry the transaction |
| `S` | Not supported | Not supported | Accept |
| `E` | Error | Error | Accept — do not penalize |

## Interpreting the result

{% hint style="warning" %}
**Do not decline on `N` alone.** Legitimate causes are everywhere: the customer moved, they typed their work address, the issuer holds an old record, or the address format differs. Declining every `N` will cost you more in good customers than it saves in fraud.
{% endhint %}

AVS is most useful combined with other signals:

```javascript
function riskScore({ avs, cvv, amountMinor, isNewCustomer }) {
  let score = 0;

  if (avs === "N") score += 30;
  else if (["A", "W", "Z"].includes(avs)) score += 10;
  // U, S, E carry no penalty — the issuer simply didn't answer.

  if (cvv === "N") score += 40;           // a CVV mismatch matters far more
  if (amountMinor > 50_000) score += 15;
  if (isNewCustomer) score += 10;

  return score;                            // >60 review, >80 decline
}
```

{% hint style="info" %}
A **CVV mismatch** is a much stronger fraud signal than an address mismatch. If you weight only one, weight that.
{% endhint %}

## Coverage

AVS is supported by issuers in the **United States, Canada and the United Kingdom**. Elsewhere you will mostly see `U` or `S`, which mean "no answer" — never treat them as a failure.

## Requesting a check

AVS runs automatically when you send `billingDetails` with a card payment. Send the full address — a ZIP-only submission can only ever return a partial match.

```json
{
  "billingDetails": {
    "street": "100 Queen Street West",
    "city": "Toronto",
    "state": "ON",
    "country": "CA",
    "zip": "M5H 2N2"
  }
}
```

State and province codes must be ISO 3166-2 — see [State codes](../reference-information/state-codes.md) and [Province codes](../reference-information/province-codes.md).
