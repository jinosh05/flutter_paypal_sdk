import 'dart:convert';

import 'package:flutter_paypal_sdk/src/constants/constants.dart';
import 'package:flutter_paypal_sdk/src/constants/error_jsons.dart';
import 'package:http_auth/http_auth.dart';

class PaypalServices {
  final String clientId, secretKey;
  final bool sandboxMode;
  PaypalServices({
    required this.clientId,
    required this.secretKey,
    required this.sandboxMode,
  });

  getAccessToken() async {
    String domain = sandboxMode ? Constants.sandboxUrl : Constants.directUrl;
    try {
      var client = BasicAuthClient(clientId, secretKey);
      var response =
          await client.post(Uri.parse("$domain${Constants.accessTokenBase}"));
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        return {
          'error': false,
          'message': "Success",
          'token': body["access_token"]
        };
      } else {
        return ErrorJsons.invalidCredentials;
      }
    } catch (e) {
      return ErrorJsons.noInternetError;
    }
  }
}
