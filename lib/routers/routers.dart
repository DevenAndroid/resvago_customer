import 'package:get/get_navigation/src/routes/get_route.dart';

import '../screen/onboarding_screen.dart';
import '../splash_screen.dart';

class MyRouters {
  static var splashScreen = "/splashScreen";
  static var onBoardingScreen = "/onBoardingScreen";

  static var route = [
    GetPage(name: '/', page: () => const SplashScreen()),
    GetPage(name: '/onBoardingScreen', page: () => const OnBoardingScreen())
  ];
}
