import 'dart:convert';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert' as convert;
import 'package:http_auth/http_auth.dart';
import 'package:url_launcher/url_launcher.dart';

class PaypalServices {
  String domain = "https://api.sandbox.paypal.com"; // for sandbox mode
  String clientId = 'AYBmWmZ1iXnGwAqSsmGdqTZFeJ6RYu-rBjGWFLnuX-kDfvLqa8qp75RPCzhaetorPoFrxqZJu0cPccd_';
  String secret = 'EJIKzLSexzl_2VKzn9aoNa_J6tpdDFzz4zgm2xAPxw3WWZvkInjPW8wGVlRk-zvz5QhFiCbPrJrtBy8H';

  // for getting the access token from Paypal
  Future<String?> getAccessToken() async {
    try {
      var client = BasicAuthClient(clientId, secret);
      var response = await client.post(Uri.parse('$domain/v1/oauth2/token?grant_type=client_credentials'));
      if (response.statusCode == 200) {
        final body = convert.jsonDecode(response.body);
        return body["access_token"];
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }
}


class PayPalService {
  final String clientId;
  final String secret;
  final String baseURL = 'https://api-m.sandbox.paypal.com/v1';

  PayPalService({required this.clientId, required this.secret});

  Future<String> getAccessToken() async {
    final response = await http.post(
      Uri.parse('$baseURL/oauth2/token'),
      headers: {
        'Authorization': 'Basic ${base64Encode(utf8.encode('$clientId:$secret'))}',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: 'grant_type=client_credentials',
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return data['access_token'];
    } else {
      throw Exception('Failed to get access token');
    }
  }

  String? accessToken;
  Future<String> createOrder() async {
    accessToken = await getAccessToken();
    var url = Uri.parse('https://api-m.sandbox.paypal.com/v2/checkout/orders');

    var response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${accessToken}',
      },
      body: jsonEncode({
        'intent': 'CAPTURE',
        'purchase_units': [
          {
            'amount': {'currency_code': 'USD', 'value': '10.00'}
          }
        ],
        'application_context': {
          'return_url': 'https://your-website.com/payment-success',
          'cancel_url': 'https://your-website.com/payment-cancel',
        },
      }),
    );

    if (response.statusCode == 201) {
      var jsonResponse = jsonDecode(response.body);
      print("sdgfgfdhgdh" + jsonResponse.toString());
      String orderId = jsonResponse['id'];
      final approvalUrl = jsonResponse['links'].firstWhere((link) => link['rel'] == 'approve')['href'];
      launch(approvalUrl);
      return orderId;
    } else {
      print(response.body); // Log the response for debugging
      throw Exception('Failed to create order');
    }
  }

  Future<void> capturePayment(String orderId) async {
    print("orderId${orderId}");
    var url = Uri.parse('https://api.sandbox.paypal.com/v2/checkout/orders/$orderId/capture');
    var response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 201) {
      var jsonResponse = jsonDecode(response.body);
      print('Payment captured successfully${jsonResponse.toString()}');
    } else {
      if (response.statusCode == 401) {
        throw Exception('Unauthorized to capture payment');
      } else {
        if (response.statusCode == 422) {
          throw Exception('Failed to capture payment${response.statusCode}');
        } else {
          throw Exception('Failed to capture payment${response.statusCode}');
        }
      }
    }
  }
}
