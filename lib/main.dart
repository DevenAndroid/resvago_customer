import 'dart:io';
import 'dart:ui';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:resvago_customer/routers/routers.dart';
import 'package:flutter/foundation.dart';
import 'package:resvago_customer/widget/local_string.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Permission.notification.isDenied.then((value) {
  //   if (value) {
  //     Permission.notification.request();
  //   }
  // });
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: "AIzaSyBCol-O-qoqmOCLI_aRN0PeJ5KPvGPVQB8",
        projectId: "resvago-b7bd4",
        messagingSenderId: "671324938172",
        appId: "1:671324938172:web:d017a2cf72416c24aed5b9",
        storageBucket: "resvago-b7bd4.appspot.com",
      ),
    );
  } else{
    await Firebase.initializeApp();
  }
  await FirebaseMessaging.instance.requestPermission(
    sound: true,
    provisional: true,
    criticalAlert: true,
    carPlay: true,
    badge: true,
    announcement: true,
    alert: true,

  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  updateLanguage() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getString("app_language") == null ||
        sharedPreferences.getString("app_language") == "english") {
      Get.updateLocale(const Locale('en', 'US'));
    } else {
      Get.updateLocale(const Locale('es', 'ES'));
    }
  }

  @override
  void initState() {
    super.initState();
    updateLanguage();
  }
  @override
  Widget build(BuildContext context) {

    return GetMaterialApp(
      translations: LocaleString(),
      locale: const Locale('en', 'US'),
      title: 'Flutter Demo',
      scrollBehavior: MaterialScrollBehavior().copyWith(
        dragDevices: {PointerDeviceKind.mouse, PointerDeviceKind.touch, PointerDeviceKind.stylus, PointerDeviceKind.unknown},
      ),
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
          focusColor:  Colors.transparent,
          hoverColor:  Colors.transparent,
          scaffoldBackgroundColor: const Color(0xffF6F6F6)),
      debugShowCheckedModeBanner: false,
      initialRoute: "/",
      getPages: MyRouters.route,
    );
  }
}


