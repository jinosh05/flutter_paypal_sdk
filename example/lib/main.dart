import 'package:flutter/material.dart';
import 'package:flutter_paypal_sdk/flutter_paypal_sdk.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Paypal',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Paypal Example'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String clientId =
          "AW1TdvpSGbIM5iP4HJNI5TyTmwpY9Gv9dYw8_8yW5lYIbCqf326vrkrp0ce9TAqjEGMHiV3OqJM_aRT0",
      secretKey =
          "EHHtTDjnmTZATYBPiGzZC_AZUfMpMAzj2VZUeqlFUrRJA_C0pQNCxDccB5qoRQSEdcOnnKQhycuOWdP9";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          child: TextButton(
              onPressed: () => {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) => PayWithPaypal(
                            sandboxMode: true,
                            clientId: clientId,
                            secretKey: secretKey,
                            returnURL: "https://samplesite.com/return",
                            cancelURL: "https://samplesite.com/cancel",
                            transactions: [
                              TransactionModel(
                                amount: TransactionAmount(
                                  total: 50.00,
                                  currency: "USD",
                                  paymentTotal: PaymentTotal(
                                    subtotal: 50.00,
                                    shipping: "1",
                                    shippingDiscount: "1",
                                  ),
                                ),
                                description:
                                    "The payment transaction description.",
                                paymentOptions: PaymentOptions(),
                                itemList: ItemListModel(
                                  items: [
                                    ItemInfo(
                                      name: "Chocolate Cake",
                                      quantity: 1,
                                      price: 25.00,
                                      currency: "USD",
                                    ),
                                    ItemInfo(
                                      name: "Chocolate Cake",
                                      quantity: 1,
                                      price: 25.00,
                                      currency: "USD",
                                    ),
                                  ],
                                  shippingAddress: ShippingAddress(
                                    recipientName: "jinosh",
                                    line1: 'Chennai',
                                    city: "Dubai",
                                    countryCode: "AE",
                                  ),
                                ),
                              ),
                            ],
                            note: "Contact us for any questions on your order.",
                            onSuccess: (Map params) async {
                              print("onSuccess: $params");
                            },
                            onError: (error) {
                              print("onError: $error");
                            },
                            onCancel: (params) {
                              print('cancelled: $params');
                            }),
                      ),
                    )
                  },
              child: const Text("Make Payment")),
        ));
  }
}
