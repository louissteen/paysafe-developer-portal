---
description: >-
  Characters rejected in every text field, across every Paysafe API, regardless
  of encoding.
icon: ban
---

# Global invalid characters

These characters are rejected in **every** text field of **every** Paysafe API. A request containing one returns `400` with error code `5068` and a `fieldErrors` entry naming the offending field.

| Character | Hex | Description |
|---|---|---|
| `"` | `22` | Double quotes (or speech marks) |
| `;` | `3B` | Semicolon |
| `^` | `5E` | Caret, circumflex |
| `*` | `2A` | Asterisk |
| `<` | `3C` | Less than (or open angled bracket) |
| `[` | `5B` | Opening square bracket |
| `]` | `5D` | Closing square bracket |
| `\` | `5C` | Backslash |

{% hint style="warning" %}
The restriction applies to the **decoded value**, not the wire format. JSON-escaping a double quote as `\"` does not help — the decoded value still contains it, and the field is still rejected.
{% endhint %}

## Where this bites

The fields most often affected are ones populated from user input or from another system:

* `holderName` — names with unusual punctuation
* `description` and `merchantDescriptor` — free-text order descriptions
* `street` and `street2` — addresses copied from a third party
* `merchantRefNum` — reference numbers built from another system's ids

## Sanitizing

Strip on input rather than at the API boundary, so the customer sees a clear message instead of a failed payment.

{% tabs %}
{% tab title="JavaScript" %}
```javascript
const INVALID = /["`;^*<\[\]\\]/g;

export function sanitize(value) {
  return value.replace(INVALID, "").trim();
}

// Better: reject at input time so the customer can fix it.
export function validate(value, field) {
  const bad = [...new Set(value.match(INVALID) ?? [])];
  if (bad.length) {
    throw new ValidationError(
      `${field} cannot contain ${bad.map((c) => `"${c}"`).join(", ")}`
    );
  }
  return value;
}
```
{% endtab %}

{% tab title="Python" %}
```python
import re

INVALID = re.compile(r'["\;\^\*<\[\]\\]')

def sanitize(value: str) -> str:
    return INVALID.sub("", value).strip()

def validate(value: str, field: str) -> str:
    bad = sorted(set(INVALID.findall(value)))
    if bad:
        raise ValidationError(
            f"{field} cannot contain {', '.join(repr(c) for c in bad)}"
        )
    return value
```
{% endtab %}

{% tab title="Java" %}
```java
private static final Pattern INVALID = Pattern.compile("[\"\;\\^\\*<\\[\\]\\\\]");

public static String sanitize(String value) {
    return INVALID.matcher(value).replaceAll("").trim();
}

public static String validate(String value, String field) {
    Matcher m = INVALID.matcher(value);
    if (m.find()) {
        throw new ValidationException(field + " contains an invalid character");
    }
    return value;
}
```
{% endtab %}
{% endtabs %}

{% hint style="info" %}
Silently stripping characters changes data the customer typed. Prefer rejecting with a clear message on any field a person fills in, and reserve stripping for values you generate yourself.
{% endhint %}
