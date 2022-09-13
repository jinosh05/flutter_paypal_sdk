import 'package:flutter/material.dart';

import '../constants/sizes.dart';
import '../paypal_services.dart';
import '../widget/loading_widget.dart';
import 'network_error.dart';

class PaymentSuccess extends StatefulWidget {
  final Function onSuccess, onCancel, onError;
  final PaypalServices services;
  final String url, executeUrl, accessToken;
  const PaymentSuccess({
    super.key,
    required this.onSuccess,
    required this.onCancel,
    required this.onError,
    required this.url,
    required this.executeUrl,
    required this.accessToken,
    required this.services,
  });

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

  complete() async {
    final uri = Uri.parse(widget.url);
    final payerId = uri.queryParameters['PayerID'];
    if (payerId != null) {
      Map params = {
        "payerID": payerId,
        "paymentId": uri.queryParameters['paymentId'],
        "token": uri.queryParameters['token'],
      };
      setState(() {
        loading = true;
        loadingError = false;
      });

      Map resp = await widget.services
          .executePayment(widget.executeUrl, payerId, widget.accessToken);
      if (resp['error'] == false) {
        params['status'] = 'success';
        params['data'] = resp['data'];
        await widget.onSuccess(params);
        setState(() {
          loading = false;
          loadingError = false;
        });
        _popScreen();
      } else {
        if (resp['exception'] != null && resp['exception'] == true) {
          widget.onError({"message": resp['message']});
          setState(() {
            loading = false;
            loadingError = true;
          });
        } else {
          await widget.onError(resp['data']);
          _popScreen();
        }
      }
    } else {
      Navigator.of(context).pop();
    }
  }

  _popScreen() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    Sizes s = Sizes(context);
    return Scaffold(
      body: Expanded(
        child: loading
            ? LoadingWidget(s: s)
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
