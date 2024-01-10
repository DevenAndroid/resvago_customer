import 'dart:io';
import 'dart:ui';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:resvago_customer/routers/routers.dart';
import 'package:flutter/foundation.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Stripe.publishableKey = "pk_test_51HFC16KfptQuy0MRiIcEnoRjyw81a9ApmSqi7DyKY2jAkqh3AGmrMsGbGNYfqYY6o5ukM5b9GqnodYXYckV37WFm00ReA1XoUZ";
  // Stripe.instance.applySettings();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: "AIzaSyBN7-pBlJcY6p8stbdeDRgo-JVF6MO2K30",
          projectId: "resvago-ire",
          storageBucket: "resvago-ire.appspot.com",
          messagingSenderId: "382013840274",
          appId: "1:382013840274:web:8531827e5ad78ae7abff4b",
      ),
    );
  }
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
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


