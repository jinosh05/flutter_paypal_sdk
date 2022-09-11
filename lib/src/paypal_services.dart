import 'dart:convert';

import 'package:flutter_paypal_sdk/src/constants/constants.dart';
import 'package:flutter_paypal_sdk/src/constants/error_jsons.dart';
import 'package:http/http.dart';
import 'package:http_auth/http_auth.dart';

class PaypalServices {
  final String clientId, secretKey;
  final bool sandboxMode;
  PaypalServices({
    required this.clientId,
    required this.secretKey,
    required this.sandboxMode,
  });

  Future<Map> getAccessToken() async {
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

  Future<Map> createPaypalPayment(transactions, String accessToken) async {
    String domain = sandboxMode ? Constants.sandboxUrl : Constants.directUrl;
    try {
      var header = {
        "content-type": "application/json",
        'Authorization': 'Bearer $accessToken'
      };
      var response = await post(
        Uri.parse("$domain${Constants.createPaymentBase}"),
        body: jsonEncode(transactions),
        headers: header,
      );

      final body = jsonDecode(response.body);

      if (response.statusCode == 201) {
        if (body["links"] != null && body["links"].length > 0) {
          List links = body["links"];

          String executeUrl = "";
          String approvalUrl = "";
          final item = links.firstWhere((o) => o["rel"] == "approval_url",
              orElse: () => null);
          if (item != null) {
            approvalUrl = item["href"];
          }
          final item1 = links.firstWhere((o) => o["rel"] == "execute",
              orElse: () => null);
          if (item1 != null) {
            executeUrl = item1["href"];
          }
          return {"executeUrl": executeUrl, "approvalUrl": approvalUrl};
        }
        return {};
      } else {
        return body;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, Object?>> executePayment(
      url, payerId, String accessToken) async {
    try {
      var header = {
        "content-type": "application/json",
        'Authorization': 'Bearer $accessToken'
      };
      var response = await post(
        Uri.parse(url),
        body: jsonEncode({"payer_id": payerId}),
        headers: header,
      );

      final body = jsonEncode(response.body);

      if (response.statusCode == 200) {
        return {'error': false, 'message': "Success", 'data': body};
      } else {
        return {
          'error': true,
          'message': "Payment inconclusive.",
          'data': body
        };
      }
    } catch (e) {
      return {'error': true, 'message': e, 'exception': true, 'data': null};
    }
  }
}
