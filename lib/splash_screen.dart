import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:resvago_customer/screen/bottomnav_bar.dart';
import 'package:resvago_customer/screen/onboarding_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_service/firebase_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  FirebaseService service = FirebaseService();
  Future<void> checkUserAuth() async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    User? user = _auth.currentUser;
    if (user != null) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const BottomNavbar()));
    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      bool _seen = (prefs.getBool('seen') ?? false);

      if (_seen) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const BottomNavbar()));
      } else {
        await prefs.setBool('seen', true);
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const OnBoardingScreen()));
      }
      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(builder: (context) => const OnBoardingScreen()),
      // );
    }
  }

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), () async {
      checkUserAuth();
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
          SizedBox(height: 80, width: 80, child: Center(child: Image.asset('assets/images/splash.png'))),
          const Center(child: Image(image: AssetImage('assets/images/Resvago.png'))),
        ],
      ),
    );
  }
}
