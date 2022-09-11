import 'package:flutter/painting.dart';

class Constants {
  static const String noNetPng = 'assets/no_network.png';

  static const String sandboxUrl = "https://api.sandbox.paypal.com";

  static const String directUrl = "https://api.paypal.com";

  static const String accessTokenBase =
      "/v1/oauth2/token?grant_type=client_credentials";

  static const String createPaymentBase = "/v1/payments/payment";

  static const Color paypalBlue = Color(0xff253B80);
}
