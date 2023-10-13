import 'package:get/get_navigation/src/routes/get_route.dart';

import '../screen/login_screen.dart';
import '../screen/onboarding_screen.dart';
import '../screen/signup_screen.dart';
import '../splash_screen.dart';

class MyRouters {
  static var splashScreen = "/splashScreen";
  static var onBoardingScreen = "/onBoardingScreen";
  static var loginScreen = "/loginScreen";
  static var signupScreen = "/signupScreen";

  static var route = [
    GetPage(name: '/', page: () => const SplashScreen()),
    GetPage(name: '/onBoardingScreen', page: () => const OnBoardingScreen()),

    GetPage(name: MyRouters.loginScreen, page: () => const LoginScreen()),

    GetPage(name: MyRouters.signupScreen, page: () => const SignUpScreen()),
  ];
}
