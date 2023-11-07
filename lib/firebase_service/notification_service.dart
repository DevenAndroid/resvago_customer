import 'dart:convert';
import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

import '../routers/routers.dart';

class NotificationService {
  FlutterLocalNotificationsPlugin localNotificationsPlugin = FlutterLocalNotificationsPlugin();
  AndroidInitializationSettings androidInitializationSettings =
      const AndroidInitializationSettings("@mipmap/ic_launcher");
  DarwinInitializationSettings darwinInitializationSettings = const DarwinInitializationSettings(
      requestAlertPermission: true,
      requestSoundPermission: true,
      requestBadgePermission: true,
      defaultPresentSound: true,
      defaultPresentAlert: true,
      defaultPresentBadge: true);
  AndroidNotificationDetails androidNotificationDetails =
      const AndroidNotificationDetails("raswago", "raswago_app", priority: Priority.max, importance: Importance.max);
  DarwinNotificationDetails darwinNotificationDetails = const DarwinNotificationDetails(
    presentSound: true,
  );
  initializeNotification() async {
    InitializationSettings initializationSettings =
        InitializationSettings(android: androidInitializationSettings, iOS: darwinInitializationSettings);
    await localNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (response) {
        if (response.payload != null) {
          log("payload....       ${response.payload}");
          Map<dynamic, dynamic> map = jsonDecode(response.payload.toString());
          if(map["order_id"] != null){
            Get.toNamed(MyRouters.myOrder);
          }
        }
      },
    ).catchError((e) {
      throw Exception(e);
    });
  }

  showSimpleNotification({
    required title,
    required body,
  }) {
    NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails, iOS: darwinNotificationDetails);
    localNotificationsPlugin.show(
        int.parse(DateTime.now()
            .millisecondsSinceEpoch
            .toString()
            .substring(DateTime.now().millisecondsSinceEpoch.toString().length - 5)),
        title,
        body,
        notificationDetails);
  }

  showNotificationWithPayLoad({
    required title,
    required body,
    required payload,
  }) {
    NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails, iOS: darwinNotificationDetails);
    localNotificationsPlugin
        .show(
            int.parse(DateTime.now()
                .millisecondsSinceEpoch
                .toString()
                .substring(DateTime.now().millisecondsSinceEpoch.toString().length - 5)),
            title,
            body,
            notificationDetails,
            payload: payload)
        .catchError((e) {
      throw Exception(e);
    });
  }

  showNotificationWithRemoteMessage({
    required RemoteMessage remoteMessage
  }) {
    NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails, iOS: darwinNotificationDetails);
    localNotificationsPlugin
        .show(
            int.parse(DateTime.now()
                .millisecondsSinceEpoch
                .toString()
                .substring(DateTime.now().millisecondsSinceEpoch.toString().length - 5)),
        remoteMessage.notification!.title,
        remoteMessage.notification!.body,
            notificationDetails,
            payload: jsonEncode(remoteMessage.data))
        .catchError((e) {
      throw Exception(e);
    });
  }

  hideAllNotifications(){
    localNotificationsPlugin.cancelAll();
  }

  showNotificationWithProgress({
    required title,
    required body,
    required payload,
    required int maxProgress,
    required int progress,
    required int progressId,
  }) {
    final AndroidNotificationDetails androidNotificationDetailsProgress = AndroidNotificationDetails(
        "dirise_channel", "dirise_channel_app",
        channelDescription: 'progress channel description',
        channelShowBadge: false,
        importance: Importance.max,
        priority: Priority.high,
        onlyAlertOnce: true,
        showProgress: true,
        maxProgress: maxProgress,
        progress: progress);
    final NotificationDetails notificationDetails = NotificationDetails(android: androidNotificationDetailsProgress);
    localNotificationsPlugin.show(progressId, title, body, notificationDetails, payload: payload).catchError((e) {
      throw Exception(e);
    });
  }
}
