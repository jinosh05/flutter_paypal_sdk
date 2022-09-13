import 'package:flutter/material.dart';
import 'package:flutter_paypal_sdk/src/paypal_services.dart';

import 'flutter_paypal_sdk.dart';

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

  String accessToken = "", executeUrl = "", approvalUrl = "";
  late PaypalServices services;
  List transactions = [
    {
      "amount": {
        "total": '10.12',
        "currency": "USD",
        "details": {
          "subtotal": '10.12',
          "shipping": '0',
          "shipping_discount": 0
        }
      },
      "description": "The payment transaction description.",
      "payment_options": {"allowed_payment_method": "INSTANT_FUNDING_SOURCE"},
      "item_list": {
        "items": [
          {
            "name": "A demo product",
            "quantity": 1,
            "price": '10.12',
            "currency": "USD"
          }
        ],

        // shipping address is not required though
        "shipping_address": {
          "recipient_name": "Jane Foster",
          "line1": "Travis County",
          "line2": "",
          "city": "Austin",
          "country_code": "US",
          "postal_code": "73301",
          "phone": "+00000000",
          "state": "Texas"
        },
      }
    }
  ];

  @override
  void initState() {
    services = PaypalServices(
        clientId: clientId, secretKey: secretKey, sandboxMode: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          child: Column(
            children: [
              TextButton(
                  onPressed: () async {
                    Map token = await services.getAccessToken();
                    print(token);
                    setState(() {
                      accessToken = token["token"];
                    });
                  },
                  child: Text("Get Token")),
              ElevatedButton(
                onPressed: () async {
                  Map transaction = await services.createPaypalPayment({
                    "intent": "sale",
                    "payer": {"payment_method": "paypal"},
                    "transactions": [
                      {
                        "amount": {
                          "total": "30.11",
                          "currency": "USD",
                          "details": {
                            "subtotal": "30.00",
                            "tax": "0.07",
                            "shipping": "0.03",
                            "handling_fee": "1.00",
                            "shipping_discount": "-1.00",
                            "insurance": "0.01"
                          }
                        },
                        "description":
                            "This is the payment transaction description.",
                        "custom": "EBAY_EMS_90048630024435",
                        "invoice_number": "48787589673",
                        "payment_options": {
                          "allowed_payment_method": "INSTANT_FUNDING_SOURCE"
                        },
                        "soft_descriptor": "ECHI5786786",
                        "item_list": {
                          "items": [
                            {
                              "name": "hat",
                              "description": "Brown color hat",
                              "quantity": "5",
                              "price": "3",
                              "tax": "0.01",
                              "sku": "1",
                              "currency": "USD"
                            },
                            {
                              "name": "handbag",
                              "description": "Black color hand bag",
                              "quantity": "1",
                              "price": "15",
                              "tax": "0.02",
                              "sku": "product34",
                              "currency": "USD"
                            }
                          ],
                          "shipping_address": {
                            "recipient_name": "Hello World",
                            "line1": "4thFloor",
                            "line2": "unit#34",
                            "city": "SAn Jose",
                            "country_code": "US",
                            "postal_code": "95131",
                            "phone": "011862212345678",
                            "state": "CA"
                          }
                        }
                      }
                    ],
                    "note_to_payer":
                        "Contact us for any questions on your order.",
                    "redirect_urls": {
                      "return_url": "https://example.com",
                      "cancel_url": "https://example.com"
                    }
                  }, accessToken);

                  print(transaction);
                  setState(() {
                    executeUrl = transaction["executeUrl"];
                    approvalUrl = transaction["approvalUrl"];
                  });
                },
                child: Text("Create transaction"),
              ),
              TextButton(
                  onPressed: () => {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (BuildContext context) => PayWithPaypal(
                                sandboxMode: false,
                                clientId: clientId,
                                secretKey: secretKey,
                                returnURL: "https://samplesite.com/return",
                                cancelURL: "https://samplesite.com/cancel",
                                transactions: transactions,
                                note:
                                    "Contact us for any questions on your order.",
                                onSuccess: (Map params) async {
                                  debugPrint("onSuccess: $params");
                                },
                                onError: (error) {
                                  debugPrint("onError: $error");
                                },
                                onCancel: (params) {
                                  debugPrint('cancelled: $params');
                                }),
                          ),
                        )
                      },
                  child: const Text("Make Payment")),
            ],
          ),
        ));
  }
}
