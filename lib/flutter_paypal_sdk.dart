library flutter_paypal_sdk;

export 'src/models/transaction_model.dart';

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_paypal_sdk/src/constants/constants.dart';
import 'package:flutter_paypal_sdk/src/paypal_services.dart';
import 'package:flutter_paypal_sdk/src/screens/network_error.dart';
import 'package:flutter_paypal_sdk/src/widget/loading_widget.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'src/constants/sizes.dart';
import 'src/models/transaction_model.dart';
import 'src/screens/payment_success.dart';

class PayWithPaypal extends StatefulWidget {
  final Function onSuccess, onCancel, onError;
  final String returnURL, cancelURL, note, clientId, secretKey;
  final List<TransactionModel> transactions;
  final bool sandboxMode;
  const PayWithPaypal(
      {super.key,
      required this.onSuccess,
      required this.onCancel,
      required this.onError,
      required this.returnURL,
      required this.cancelURL,
      required this.note,
      required this.clientId,
      required this.secretKey,
      required this.transactions,
      required this.sandboxMode});

  @override
  State<PayWithPaypal> createState() => _PayWithPaypalState();
}

class _PayWithPaypalState extends State<PayWithPaypal> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  String checkoutUrl = '';
  String navUrl = '';
  String executeUrl = '';
  String accessToken = '';
  bool loading = true;
  bool pageloading = true;
  bool loadingError = false;
  late PaypalServices services;
  int pressed = 0;

  Map getOrderParams() {
    List<TransactionModel> transaction = widget.transactions;
    String transactionString = "[";
    for (var i = 0; i < transaction.length; i++) {
      transactionString =
          transactionString + transactionModelToJson(transaction[i]);
      if (i == transaction.length - 1) {
        transactionString = transactionString + "]";
      }
    }
    debugPrint("Transactions : $transactionString ");
    Map<String, dynamic> temp = {
      "intent": "sale",
      "payer": {"payment_method": "paypal"},
      "transactions": jsonDecode(transactionString),
      "note_to_payer": widget.note,
      "redirect_urls": {
        "return_url": widget.returnURL,
        "cancel_url": widget.cancelURL
      }
    };

    log(temp.toString());
    return temp;
  }

  loadPayment() async {
    setState(() {
      loading = true;
    });
    try {
      Map getToken = await services.getAccessToken();
      if (getToken['token'] != null) {
        accessToken = getToken['token'];
        final transactions = getOrderParams();
        final res =
            await services.createPaypalPayment(transactions, accessToken);
        if (res["approvalUrl"] != null) {
          setState(() {
            checkoutUrl = res["approvalUrl"].toString();
            navUrl = res["approvalUrl"].toString();
            executeUrl = res["executeUrl"].toString();
            loading = false;
            pageloading = false;
            loadingError = false;
          });
        } else {
          widget.onError(res);
          setState(() {
            loading = false;
            pageloading = false;
            loadingError = true;
          });
        }
      } else {
        widget.onError("${getToken['message']}");

        setState(() {
          loading = false;
          pageloading = false;
          loadingError = true;
        });
      }
    } catch (e) {
      widget.onError(e);
      setState(() {
        loading = false;
        pageloading = false;
        loadingError = true;
      });
    }
  }

  JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'Toaster',
        onMessageReceived: (JavascriptMessage message) {
          widget.onError(message.message);
        });
  }

  @override
  void initState() {
    super.initState();
    services = PaypalServices(
      sandboxMode: widget.sandboxMode,
      clientId: widget.clientId,
      secretKey: widget.secretKey,
    );
    setState(
      () {
        navUrl =
            widget.sandboxMode ? Constants.sandboxUrl : Constants.directUrl;
      },
    );

    // Enable hybrid composition.
    // will update this in future for Other Platforms too
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();

    loadPayment();
  }

  @override
  Widget build(BuildContext context) {
    Sizes s = Sizes(context);
    return WillPopScope(
      onWillPop: () async {
        if (pressed < 2) {
          setState(() {
            pressed++;
          });
          final snackBar = SnackBar(
            content: Text(
              'Press back ${3 - pressed} more times to cancel transaction',
            ),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: GestureDetector(
            child: const Icon(
              Icons.close,
              color: Constants.paypalBlue,
            ),
            onTap: () => Navigator.pop(context),
          ),
          leadingWidth: s.w3,
          title: Container(
            padding: EdgeInsets.symmetric(horizontal: s.w2, vertical: s.h1),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.4),
              borderRadius: BorderRadius.circular(
                s.h2,
              ),
            ),
            child: Expanded(
                child: Row(
              children: [
                Icon(
                  Icons.lock_outline,
                  color: Uri.parse(navUrl).hasScheme
                      ? Colors.green.shade100
                      : Colors.blue,
                  size: s.h2,
                ),
                SizedBox(width: s.w1),
                Expanded(
                  child: Text(
                    navUrl,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: s.h2,
                    ),
                  ),
                ),
              ],
            )),
          ),
          actions: [
            SizedBox(width: pageloading ? s.w1 : 0),
            pageloading ? LoadingWidget(s: s) : const SizedBox()
          ],
        ),
        body: loading
            ? LoadingWidget(
                s: s,
                radius: s.h10,
              )
            : loadingError
                ? NetworkErrorScr(
                    loadData: loadPayment, message: "Something went wrong,")
                : WebView(
                    initialUrl: checkoutUrl,
                    javascriptMode: JavascriptMode.unrestricted,
                    allowsInlineMediaPlayback: true,
                    onWebResourceError: (error) {
                      log(error.errorType.toString());
                    },
                    gestureNavigationEnabled: true,
                    onWebViewCreated: (WebViewController webViewController) {
                      _controller.complete(webViewController);
                    },
                    javascriptChannels: <JavascriptChannel>{
                      _toasterJavascriptChannel(context),
                    },
                    navigationDelegate: (NavigationRequest request) async {
                      if (!Uri.parse(request.url).isAbsolute) {
                        return NavigationDecision.prevent;
                      }
                      if (request.url.contains(widget.returnURL)) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PaymentSuccess(
                                    url: request.url,
                                    services: services,
                                    executeUrl: executeUrl,
                                    accessToken: accessToken,
                                    onSuccess: widget.onSuccess,
                                    onCancel: widget.onCancel,
                                    onError: widget.onError,
                                  )),
                        );
                      }
                      if (request.url.contains(widget.cancelURL)) {
                        final uri = Uri.parse(request.url);
                        await widget.onCancel(uri.queryParameters);
                        _popScreen();
                      }
                      return NavigationDecision.navigate;
                    },
                    onPageStarted: (String url) {
                      setState(() {
                        pageloading = true;
                        loadingError = false;
                      });
                    },
                    onPageFinished: (String url) {
                      log(url);
                      setState(() {
                        navUrl = url;
                        pageloading = false;
                      });
                    },
                  ),
      ),
    );
  }

  void _popScreen() {
    Navigator.of(context).pop();
  }
}
