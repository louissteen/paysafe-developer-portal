# Table of contents

* [APIs & SDKs](README.md)

## Getting started

* [Quickstart](getting-started/quickstart.md)
* [Authentication](getting-started/authentication.md)
* [Environments](getting-started/environments.md)
* [API conventions](getting-started/conventions.md)
* [Errors and retries](getting-started/errors-and-retries.md)

## Payments API

* [Overview](payments-api/README.md)
* ```yaml
  type: builtin:openapi
  props:
    models: true
    downloadLink: true
  dependencies:
    spec:
      ref:
        kind: openapi
        spec: paysafe-payments-v1
  ```

## Payment Handles API

* [Overview](payment-handles-api/README.md)
* ```yaml
  type: builtin:openapi
  props:
    models: true
    downloadLink: true
  dependencies:
    spec:
      ref:
        kind: openapi
        spec: paysafe-payment-handles-v1
  ```

## Cards API

* [Overview](cards-api/README.md)
* ```yaml
  type: builtin:openapi
  props:
    models: true
    downloadLink: true
  dependencies:
    spec:
      ref:
        kind: openapi
        spec: paysafe-cards-v1
  ```

## Customer Vault API

* [Overview](customer-vault-api/README.md)
* ```yaml
  type: builtin:openapi
  props:
    models: true
    downloadLink: true
  dependencies:
    spec:
      ref:
        kind: openapi
        spec: paysafe-customer-vault-v1
  ```

## 3D Secure API

* [Overview](threeds-api/README.md)
* ```yaml
  type: builtin:openapi
  props:
    models: true
    downloadLink: true
  dependencies:
    spec:
      ref:
        kind: openapi
        spec: paysafe-threeds-v2
  ```

## Embedded Wallets API

* [Overview](embedded-wallets-api/README.md)
* ```yaml
  type: builtin:openapi
  props:
    models: true
    downloadLink: true
  dependencies:
    spec:
      ref:
        kind: openapi
        spec: paysafe-embedded-wallets-v1
  ```

## Digital Wallets API

* [Overview](digital-wallets-api/README.md)
* ```yaml
  type: builtin:openapi
  props:
    models: true
    downloadLink: true
  dependencies:
    spec:
      ref:
        kind: openapi
        spec: paysafe-digital-wallets-v1
  ```

## Applications API

* [Overview](applications-api/README.md)
* ```yaml
  type: builtin:openapi
  props:
    models: true
    downloadLink: true
  dependencies:
    spec:
      ref:
        kind: openapi
        spec: paysafe-applications-v1
  ```

## SDKs

* [All SDKs](sdks/README.md)
* [Paysafe JS](sdks/paysafe-js.md)
* [Paysafe Checkout](sdks/paysafe-checkout.md)
* [Server-side SDKs](sdks/server-side-sdks.md)
* [Mobile SDKs](sdks/mobile-sdks.md)
* [Embedded Wallets SDK](sdks/embedded-wallets-sdk.md)
