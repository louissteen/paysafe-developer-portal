---
description: >-
  ISO 4217 currency codes supported by Paysafe, with the exponent that determines
  how amounts are expressed in the minor unit.
icon: circle-dollar-to-slot
---

# Currency codes

Every monetary `amount` in the Paysafe APIs is an **integer in the currency's minor unit**. The *exponent* below tells you how many decimal places that currency has, and therefore how to convert a human-readable amount into the integer the API expects.

{% hint style="warning" %}
Sending `amount: 10.99` will be rejected. Send `amount: 1099` with `currencyCode: "USD"`.
{% endhint %}

## Converting an amount

{% tabs %}
{% tab title="Exponent 2" %}
Most currencies (USD, EUR, GBP) use two decimal places.

```
$10.99 USD  ->  amount: 1099,  currencyCode: "USD"
```
{% endtab %}

{% tab title="Exponent 0" %}
Currencies with no minor unit (JPY, KRW, CLP) are sent as-is.

```
¥1,250 JPY  ->  amount: 1250,  currencyCode: "JPY"
```
{% endtab %}

{% tab title="Exponent 3" %}
A few currencies (BHD, KWD, TND, JOD) use three decimal places.

```
1.500 KWD   ->  amount: 1500,  currencyCode: "KWD"
```
{% endtab %}
{% endtabs %}

## Supported currencies

| Currency | ISO Code | Exponent Number |
|---|---|---|
| Argentine Peso | ARS | 2 |
| Australian Dollar | AUD | 2 |
| Azerbaijanian Manat | AZN | 2 |
| Bahraini Dinar | BHD | 3 |
| Belarusian Ruble | BYR | 0 |
| Bolivian Boliviano | BOB | 2 |
| Bosnia and Herzegovina Convertible Mark | BAM | 2 |
| Brazilian Real | BRL | 2 |
| Bulgarian Lev | BGN | 2 |
| Canadian Dollar | CAD | 2 |
| Chilean Peso | CLP | 2 |
| China Yuan Renminbi | CNY | 2 |
| Columbian Peso | COP | 2 |
| Costa Rican Colon | CRC | 2 |
| Croatian Kuna | HRK | 2 |
| Czech Koruna | CZK | 2 |
| Danish Krone | DKK | 2 |
| Dominican Peso | DOP | 2 |
| East Caribbean Dollar | XCD | 2 |
| Egyptian Pound | EGP | 2 |
| Ethiopian Birr | ETB | 2 |
| Euro | EUR | 2 |
| Fiji Dollar | FJD | 2 |
| Georgian Lari | GEL | 2 |
| Guatemala Quetzal | GTQ | 2 |
| Haiti Goude | HTG | 2 |
| Honduran Lempira | HNL | 2 |
| Hong Kong Dollar | HKD | 2 |
| Hungarian Forint | HUF | 2 |
| Indian Rupee | INR | 2 |
| Indonesia Rupiah | IDR | 2 |
| Jamaican Dollar | JMD | 2 |
| Japanese Yen | JPY | 0 |
| Jordanian Dinar | JOD | 3 |
| Kazakhstan Tenge | KZT | 2 |
| Kenyan Shilling | KES | 2 |
| Korean Won | KRW | 0 |
| Kuwaiti Dinar | KWD | 3 |
| Latvian Lats | LVL | 2 |
| Lebanese Pound | LBP | 2 |
| Libyan Dinars | LYD | 3 |
| Malawi Kwacha | MWK | 2 |
| Mauritius Rupee | MUR | 2 |
| Mexican Peso | MXN | 2 |
| Moldovan Leu | MDL | 2 |
| Moroccan Dirham | MAD | 2 |
| New Israeli Shekel | ILS | 2 |
| New Zealand Dollar | NZD | 2 |
| Nigerian Naira | NGN | 2 |
| Norwegian Krone | NOK | 2 |
| Omani Rial | OMR | 3 |
| Pakistan Rupee | PKR | 2 |
| Panamanian Balboa | PAB | 2 |
| Paraguayan Guarani | PYG | 0 |
| Peruvian Sol | PEN | 2 |
| Philippine Peso | PHP | 2 |
| Polish Zloty | PLN | 2 |
| Pound Sterling | GBP | 2 |
| Qatari Rial | QAR | 2 |
| Romanian New Leu | RON | 2 |
| Russian Ruble | RUB | 2 |
| Rwandan Franc | RWF | 0 |
| Saudi Arabian Riyal | SAR | 2 |
| Serbian Dinar | RSD | 2 |
| Singapore Dollar | SGD | 2 |
| South African Rand | ZAR | 2 |
| Sri Lanka Rupee | LKR | 2 |
| Swedish Krona | SEK | 2 |
| Swiss Franc | CHF | 2 |
| Syrian Pound | SYP | 2 |
| Taiwan New Dollar | TWD | 2 |
| Thai Baht | THB | 2 |
| Trinidad and Tobago Dollar | TTD | 2 |
| Tunisian Dinar | TND | 3 |
| Turkish Lira | TRY | 2 |
| Ukranian Hryunia | UAH | 2 |
| UAE Dirham | AED | 2 |
| Uruguay Peso | UYU | 2 |
| US Dollar | USD | 2 |
| Venezuelan Bolivar | VEF | 2 |
| Viet Nam Dong | VND | 0 |
