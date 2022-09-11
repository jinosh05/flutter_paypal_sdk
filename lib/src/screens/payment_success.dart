import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../constants/sizes.dart';
import 'network_error.dart';

class PaymentSuccess extends StatefulWidget {
  final Function onSuccess, onCancel, onError;
  // final PaypalServices services;
  final String url, executeUrl, accessToken;
  const PaymentSuccess(
      {super.key,
      required this.onSuccess,
      required this.onCancel,
      required this.onError,
      required this.url,
      required this.executeUrl,
      required this.accessToken});

  @override
  State<PaymentSuccess> createState() => _PaymentSuccessState();
}

class _PaymentSuccessState extends State<PaymentSuccess> {
  bool loading = true;
  bool loadingError = false;
  @override
  void initState() {
    super.initState();
    complete();
  }

  complete() async {}
  @override
  Widget build(BuildContext context) {
    Sizes s = Sizes(context);
    return Scaffold(
      body: Container(
        child: loading
            ? Center(
                child: SpinKitFadingCircle(
                  size: s.h10,
                  color: const Color(0xFFEB920D),
                ),
              )
            : loadingError
                ? NetworkErrorScr(
                    loadData: complete, message: "Something went wrong,")
                : Center(
                    child: Text(
                      "Payment Success",
                      style: TextStyle(
                          fontSize: s.h2,
                          color: Colors.black,
                          fontWeight: FontWeight.w800),
                    ),
                  ),
      ),
    );
  }
}
