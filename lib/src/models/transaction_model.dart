// To parse this JSON data, do
//
//     final transactionModel = transactionModelFromJson(jsonString);

import 'dart:convert';

TransactionModel transactionModelFromJson(String str) =>
    TransactionModel.fromJson(json.decode(str));

String transactionModelToJson(TransactionModel data) =>
    json.encode(data.toJson());

class TransactionModel {
  TransactionModel({
    required this.amount,
    required this.description,
    required this.paymentOptions,
    required this.itemList,
  });

  TransactionAmount amount;
  String description;
  PaymentOptions paymentOptions;
  ItemListModel itemList;

  factory TransactionModel.fromJson(Map<String, dynamic> json) =>
      TransactionModel(
        amount: TransactionAmount.fromJson(json["amount"]),
        description: json["description"],
        paymentOptions: PaymentOptions.fromJson(json["payment_options"]),
        itemList: ItemListModel.fromJson(json["item_list"]),
      );

  Map<String, dynamic> toJson() => {
        "amount": amount.toJson(),
        "description": description,
        "payment_options": paymentOptions.toJson(),
        "item_list": itemList.toJson(),
      };
}

class TransactionAmount {
  TransactionAmount({
    required this.total,
    required this.currency,
    required this.paymentTotal,
  });

  double total;
  String currency;
  PaymentTotal paymentTotal;

  factory TransactionAmount.fromJson(Map<String, dynamic> json) =>
      TransactionAmount(
        total: json["total"],
        currency: json["currency"],
        paymentTotal: PaymentTotal.fromJson(json["details"]),
      );

  Map<String, dynamic> toJson() => {
        "total": total,
        "currency": currency,
        "details": paymentTotal.toJson(),
      };
}

class PaymentTotal {
  PaymentTotal({
    required this.subtotal,
    required this.shipping,
    required this.shippingDiscount,
  });

  double subtotal;
  String shipping;
  String shippingDiscount;

  factory PaymentTotal.fromJson(Map<String, dynamic> json) => PaymentTotal(
        subtotal: json["subtotal"],
        shipping: json["shipping"],
        shippingDiscount: json["shipping_discount"],
      );

  Map<String, dynamic> toJson() => {
        "subtotal": subtotal,
        "shipping": shipping,
        "shipping_discount": shippingDiscount,
      };
}

class ItemListModel {
  ItemListModel({
    required this.items,
    required this.shippingAddress,
  });

  List<ItemInfo> items;
  ShippingAddress? shippingAddress;

  factory ItemListModel.fromJson(Map<String, dynamic> json) => ItemListModel(
        items:
            List<ItemInfo>.from(json["items"].map((x) => ItemInfo.fromJson(x))),
        shippingAddress: json["shipping_address"] ??
            ShippingAddress.fromJson(json["shipping_address"]),
      );

  Map<String, dynamic> toJson() {
    print(items.map((e) => e.toJson()).toList());
    Map<String, dynamic> value = {
      "items": items.map((e) => e.toJson()).toList(),
      "shipping_address":
          shippingAddress == null ? null : shippingAddress!.toJson(),
    };

    return value;
  }
}

class ItemInfo {
  ItemInfo({
    required this.name,
    required this.quantity,
    required this.price,
    required this.currency,
  });

  String name;
  int quantity;
  double price;
  String currency;

  factory ItemInfo.fromJson(Map<String, dynamic> json) => ItemInfo(
        name: json["name"],
        quantity: json["quantity"],
        price: json["price"],
        currency: json["currency"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "quantity": quantity,
        "price": price,
        "currency": currency,
      };
}

class ShippingAddress {
  ShippingAddress({
    required this.recipientName,
    required this.line1,
    this.line2,
    required this.city,
    required this.countryCode,
    this.phone,
    this.state,
  });

  String recipientName;
  String line1;
  String? line2;
  String city;
  String countryCode;
  String? phone;
  String? state;

  factory ShippingAddress.fromJson(Map<String, dynamic> json) =>
      ShippingAddress(
        recipientName: json["recipient_name"],
        line1: json["line1"],
        line2: json["line2"],
        city: json["city"],
        countryCode: json["country_code"],
        phone: json["phone"],
        state: json["state"],
      );

  Map<String, dynamic> toJson() => {
        "recipient_name": recipientName,
        "line1": line1,
        "line2": line2,
        "city": city,
        "country_code": countryCode,
        "phone": phone,
        "state": state,
      };
}

/// Currently  using "INSTANT_FUNDING_SOURCE" as default
/// Refer Paypal before changing it
class PaymentOptions {
  PaymentOptions({
    this.allowedPaymentMethod = "INSTANT_FUNDING_SOURCE",
  });

  String allowedPaymentMethod;

  factory PaymentOptions.fromJson(Map<String, dynamic> json) => PaymentOptions(
        allowedPaymentMethod: json["allowed_payment_method"],
      );

  Map<String, dynamic> toJson() => {
        "allowed_payment_method": allowedPaymentMethod,
      };
}
