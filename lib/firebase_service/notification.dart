import 'dart:convert';
import 'package:http/http.dart' as http;

Future<void> sendPushNotification(
    {required String deviceToken,
      required String title,
      required String body,
      required String image,
      required String orderID}) async {
  const String serverKey =
      'AAAAWPHMm5I:APA91bHYRrpBn79j822k01-hg-SGgF3A5k0hCCQTG2C8AeQ7MFSN9XANL3_8CkxLHwUAnk_CqtI1cxV3Pm7385l9bj_SMLCaSu4S1_rWSpKQx5cj-gy9nCRbj3An5cHAUA9vl7DOB3dS';

  final Map<String, dynamic> notification = {
    'body': body,
    'title': title,
    'sound': 'default',
    'image': image,
  };

  final Map<String, dynamic> message = {
    'notification': notification,
    'priority': 'high',
    'data': {
      'click_action': 'FLUTTER_NOTIFICATION_CLICK',
      'id': '1',
      'status': 'done',
      'order_id': orderID,
    },
    'to': deviceToken,
  };

  try {
    final http.Response response = await http.post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=$serverKey',
      },
      body: jsonEncode(message),
    );

    if (response.statusCode == 200) {
      print('Notification sent successfully');
    } else {
      print('Failed to send notification. Error: ${response.reasonPhrase}');
    }
  } catch (e) {
    print('Error sending notification: $e');
  }
}
