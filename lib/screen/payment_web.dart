import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({Key? key}) : super(key: key);

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String url = "";
  InAppWebViewController? webViewController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PayPal Integration'),
      ),
      body: Center(
        child: url.isNotEmpty
            ? InAppWebView(
          initialUrlRequest: URLRequest(url: WebUri(url)),
          onWebViewCreated: (controller) {
            webViewController = controller;
            if (url.isNotEmpty) {
              // Load the URL only when the webViewController is created
              webViewController!.loadUrl(urlRequest: URLRequest(url: WebUri(url)));
            }
          },
        )
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
          {
            'amount': {'currency_code': 'USD', 'value': '10.0'}
          }
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

    if (webViewController != null) {
      webViewController!.loadUrl(urlRequest: URLRequest(url: WebUri(paymentUrl)));
      setState(() {
        url = paymentUrl;
      });
    } else {
      print('WebViewController is null. Unable to load URL.');
    }

    // launch(paymentUrl);
    print('Payment URL: $paymentUrl');
  }

  // void initiatePayment(String orderId) {
  //   final paymentUrl = 'https://www.sandbox.paypal.com/checkoutnow?token=$orderId';
  //   url = paymentUrl;
  //   if (webViewController != null) {
  //     webViewController!.loadUrl(urlRequest: URLRequest(url: WebUri(paymentUrl)));
  //     setState(() {});
  //   } else {
  //     print('WebViewController is null. Unable to load URL.');
  //   }
  //
  //   // launch(paymentUrl);
  //   print('Payment URL: $paymentUrl');
  // }
}

//
// import 'package:flutter/material.dart';
// import 'package:flutter_stripe/flutter_stripe.dart';
//
// class MyHomePage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Stripe Demo'),
//       ),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: () async {
//             // Call a function to initiate the payment process
//             await startPayment(context);
//           },
//           child: Text('Pay with Stripe'),
//         ),
//       ),
//     );
//   }
//
//   Future<void> startPayment(BuildContext context) async {
//     final paymentSheet = PaymentSheetTest();
//     await paymentSheet.initPaymentSheet();
//     await paymentSheet.showPaymentSheet();
//   }
// }
//
// class PaymentSheetTest {
//   Future<void> initPaymentSheet() async {
//     await Stripe.instance.initPaymentSheet(
//       paymentSheetParameters: SetupPaymentSheetParameters(
//         paymentIntentClientSecret: "sk_test_51HFC16KfptQuy0MReb7O2QgCymx7pd1Xnjp9ztWewS3viW365MlbznP45WUljSuSrddN56PtCwL2mcz1iP52eBq100JNdBY3IY",
//         merchantDisplayName: "Ashish",
//       ),
//     );
//   }
//
//   Future<void> showPaymentSheet() async {
//     await Stripe.instance.presentPaymentSheet();
//   }
// }
//

// import 'dart:convert';
// import 'dart:developer';
// import 'package:flutter/material.dart';
// import 'package:flutter_stripe/flutter_stripe.dart';
// import 'package:http/http.dart' as http;
// class PaymentDemo extends StatelessWidget {
//   const PaymentDemo({Key? key}) : super(key: key);
//   Future<void> initPayment(
//       {required String email,
//         required double amount,
//         required BuildContext context}) async {
//     try {
//       // 1. Create a payment intent on the server
//       final response = await http.post(
//           Uri.parse('https://us-central1-resvago-ire.cloudfunctions.net/stripePaymentIntentRequest'),
//           body: {
//             'email': email,
//             'amount': amount.toString(),
//           });
//
//       final jsonResponse = jsonDecode(response.body);
//       log(jsonResponse.toString());
//       // 2. Initialize the payment sheet
//       await Stripe.instance.initPaymentSheet(
//           paymentSheetParameters: SetupPaymentSheetParameters(
//             paymentIntentClientSecret: jsonResponse['paymentIntent'],
//             merchantDisplayName: 'Grocery Flutter course',
//             customerId: jsonResponse['customer'],
//             customerEphemeralKeySecret: jsonResponse['ephemeralKey'],
//             // testEnv: true,
//             // merchantCountryCode: 'SG',
//           ));
//       await Stripe.instance.presentPaymentSheet();
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Payment is successful'),
//         ),
//       );
//     } catch (errorr) {
//       if (errorr is StripeException) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('An error occured ${errorr.error.localizedMessage}'),
//           ),
//         );
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('An error occured $errorr'),
//           ),
//         );
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//           child: ElevatedButton(
//             child: const Text('Pay 20\$'),
//             onPressed: () async {
//               await initPayment(
//                   amount: 50.0, context: context, email: 'email@test.com');
//             },
//           )),
//     );
//   }
// }
