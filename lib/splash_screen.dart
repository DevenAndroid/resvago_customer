import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resvago_customer/routers/routers.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3)).then((value) {

      Get.offAllNamed(MyRouters.onBoardingScreen);
    });
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color(0xff3B5998),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
             height: 80,
              width: 80,
              child: Center(child: Image.asset('assets/images/splash.png'))),
          Center(child: const Image(image: AssetImage('assets/images/Resvago.png'))),
        ],
      ),
    );
  }
}
