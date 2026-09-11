---
description: >-
  How Paysafe versions its APIs, what counts as a breaking change, and how long
  old versions are supported.
icon: code-branch
---

# API versioning policy

## Versions in the path

Every Paysafe API carries its major version in the URL:

```
https://api.paysafe.com/paymenthub/v1/payments
https://api.paysafe.com/threedsecure/v2/authentications
```

A major version is stable for its lifetime. We do not change the meaning of an existing field, remove a field, or alter a response shape within a major version.

## What is not a breaking change

These can ship at any time, so your integration must tolerate them:

* **A new optional request field.** Ignore what you do not use.
* **A new response field.** Parse leniently; do not fail on unknown properties.
* **A new enum value.** Handle unrecognized values with a sensible default rather than throwing.
* **A new endpoint.**
* **A new error code** within an existing HTTP status.

{% hint style="warning" %}
The most common integration failure on an otherwise compatible release is a strict deserializer rejecting an unknown field. Configure your JSON parser to ignore unknown properties — in Jackson, `FAIL_ON_UNKNOWN_PROPERTIES=false`.
{% endhint %}

## What is a breaking change

These only ever arrive in a new major version:

* Removing or renaming a field
* Changing a field's type or its meaning
* Making an optional request field required
* Removing an endpoint or an enum value
* Changing the HTTP status for an existing condition

## Support window

| Stage | Duration | What it means |
|---|---|---|
| **Current** | — | Actively developed; new features land here |
| **Maintenance** | 24 months from the next major release | Security and correctness fixes only |
| **End of life** | — | No longer served |

Entering maintenance is announced at least **12 months** in advance, here and by email to technical contacts on the account.

## SDK versioning

SDKs follow semantic versioning independently of the APIs they wrap. An SDK major bump does not imply an API major bump — the Java SDK 2.0.0 release in June 2026, for example, still targets Payments API v1.

| Change | SDK version |
|---|---|
| New method for a new endpoint | Minor |
| New optional parameter | Minor |
| Bug fix | Patch |
| Renamed or removed method | Major |
| Minimum language version raised | Major |

{% hint style="info" %}
Pin an exact SDK version in production and upgrade deliberately. An SDK minor release can pull in a transitive dependency change — as the Cardinal SDK upgrade in the Android SDK showed.
{% endhint %}
