import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {

  String url = "";
  WebViewController? webViewController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PayPal Integration'),
      ),
      body: Center(
        child: url.isNotEmpty ?
        WebViewWidget(controller: webViewController!,)
            : ElevatedButton(
          onPressed: () async {
            try {
              final accessToken = await getAccessToken();
              final orderId = await createOrder(accessToken);
              initiatePayment(orderId);
            } catch (e) {
              print('Error: $e');
            }
          },
          child: Text('Pay with PayPal'),
        ),
      ),
    );
  }
 String clientId = "Ab5v6E4R-gNbD13BbcdgpzK0G66oJ8ij1Va8i85qzGTtgA4TXkmt2h4oRpCXGRTBQs8Fn1SMqgyVkQ19";
 String secret = "ELCzlUANZYqBS27CGrYqP3RNyoob11TbOj_J4kYp6QULFkDWh9veSi_zkpQoe8nu-VS3FN8XJf-o5WJx";
  Future<String> getAccessToken() async {
    final response = await http.post(
      Uri.parse('https://api.sandbox.paypal.com/v1/oauth2/token'),
      headers: {
        'Authorization': 'Basic ${base64Encode(utf8.encode('$clientId:$secret'))}',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: 'grant_type=client_credentials',
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      return responseData['access_token'];
    } else {
      throw Exception('Failed to obtain access token');
    }
  }

  Future<String> createOrder(String accessToken) async {
    final response = await http.post(
      Uri.parse('https://api.sandbox.paypal.com/v2/checkout/orders'),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'intent': 'CAPTURE',
        'purchase_units': [
          {'amount': {'currency_code': 'USD', 'value': '10.0'}}
        ]
      }),
    );

    if (response.statusCode == 201) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      return responseData['id'];
    } else {
      throw Exception('Failed to create order');
    }
  }

  void initiatePayment(String orderId) {
    final paymentUrl = 'https://www.sandbox.paypal.com/checkoutnow?token=$orderId';
    url = paymentUrl;
    webViewController = WebViewController();
    webViewController!.loadRequest(Uri.parse(url));
    setState(() {});
    launch(paymentUrl);
    print('Payment URL: $paymentUrl');
  }
}
