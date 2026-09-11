---
description: Android, iOS and React Native SDKs for native card capture.
icon: mobile-screen
---

# Mobile SDKs

The mobile SDKs capture card data inside a Paysafe-controlled view and return a single-use token, so your app binary never handles a card number.

| Platform | Version | Requires |
|---|---|---|
| Android | 2.1.0 | API 24+ (Android 7.0) |
| iOS | 2.0.3 | iOS 14+ |
| React Native | 1.3.0 | RN 0.72+ |

## Install

{% tabs %}
{% tab title="Android" %}
```kotlin
// build.gradle.kts
dependencies {
    implementation("com.paysafe:paysafe-android:2.1.0")
}
```
{% endtab %}

{% tab title="iOS" %}
```swift
// Package.swift
.package(url: "https://github.com/paysafegroup/paysafe-ios", from: "2.0.3")
```

Or with CocoaPods:

```ruby
pod 'PaysafeSDK', '~> 2.0.3'
```
{% endtab %}

{% tab title="React Native" %}
```bash
npm install @paysafe/react-native-sdk
cd ios && pod install
```
{% endtab %}
{% endtabs %}

## Initialize

{% tabs %}
{% tab title="Android" %}
```kotlin
val paysafe = PaysafeSDK.Builder()
    .setAPIKey(BuildConfig.PAYSAFE_SINGLE_USE_TOKEN_KEY)
    .setEnvironment(Environment.TEST)
    .setCurrencyCode("USD")
    .build()

// Required since the Cardinal SDK change in June 2026.
paysafe.initializeObserver(this)
```

{% hint style="danger" %}
**Breaking change, June 2026.** The Cardinal SDK upgrade requires `initializeObserver(lifecycleOwner)` before any tokenization call. Without it, 3-D Secure challenges never return a result and the payment silently hangs.
{% endhint %}
{% endtab %}

{% tab title="iOS" %}
```swift
let paysafe = try PaysafeSDK(
    apiKey: Secrets.paysafeSingleUseTokenKey,
    environment: .test,
    currencyCode: "USD"
)
```
{% endtab %}

{% tab title="React Native" %}
```javascript
import { PaysafeSDK } from "@paysafe/react-native-sdk";

await PaysafeSDK.initialize({
  apiKey: Config.PAYSAFE_SINGLE_USE_TOKEN_KEY,
  environment: "TEST",
  currencyCode: "USD",
});
```
{% endtab %}
{% endtabs %}

## Tokenize

{% tabs %}
{% tab title="Android" %}
```kotlin
paysafe.tokenize(
    TokenizeOptions(
        merchantRefNum = "order-$orderId",
        amount = 4999,
        transactionType = TransactionType.PAYMENT,
        paymentType = PaymentType.CARD,
    )
) { result ->
    when (result) {
        is Result.Success -> sendToBackend(result.token)
        is Result.Failure -> showError(result.error.displayMessage)
    }
}
```
{% endtab %}

{% tab title="iOS" %}
```swift
paysafe.tokenize(
    options: TokenizeOptions(
        merchantRefNum: "order-\(orderId)",
        amount: 4999,
        transactionType: .payment,
        paymentType: .card
    )
) { result in
    switch result {
    case .success(let token): sendToBackend(token)
    case .failure(let error): showError(error.displayMessage)
    }
}
```
{% endtab %}

{% tab title="React Native" %}
```javascript
try {
  const { token } = await PaysafeSDK.tokenize({
    merchantRefNum: `order-${orderId}`,
    amount: 4999,
    transactionType: "PAYMENT",
    paymentType: "CARD",
  });
  await sendToBackend(token);
} catch (e) {
  showError(e.displayMessage);
}
```
{% endtab %}
{% endtabs %}

## Styling the card fields

Since June 2026 the Android SDK exposes additional form field styling options — border colour and radius, field height, label and error typography, and per-state colours.

```kotlin
paysafe.setFieldStyle(
    FieldStyle(
        borderColor = Color.parseColor("#E4E4E7"),
        borderColorFocused = Color.parseColor("#5A28FF"),
        borderColorError = Color.parseColor("#D42054"),
        cornerRadius = 8.dp,
        textSize = 16.sp,
    )
)
```

{% hint style="warning" %}
Ship the **single-use token key** in your app, never the API secret. Mobile binaries are trivially decompiled — treat anything in the bundle as public.
{% endhint %}
