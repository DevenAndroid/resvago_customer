import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:resvago_customer/screen/bottomnav_bar.dart';
import 'package:resvago_customer/screen/delivery_screen.dart';
import 'package:resvago_customer/screen/homepage.dart';
import 'package:resvago_customer/screen/myorder_screen.dart';
import 'package:resvago_customer/screen/checkout_for_dining/oder_screen.dart';
import 'package:resvago_customer/screen/profile_screen.dart';
import '../screen/delivery_screen/delivery_restaurnt_screen.dart';
import '../screen/helpcenter.dart';
import '../screen/login_screen.dart';
import '../screen/notification.dart';
import '../screen/onboarding_screen.dart';
import '../screen/privacypolicy.dart';
import '../screen/restaurant_category_screen.dart';
import '../screen/search_screen/search_singlerestaurant_screen.dart';
import '../screen/search_screen/searchlist_dining_screen.dart';
import '../screen/search_screen/searchlist_screen.dart';
import '../screen/signup_screen.dart';
import '../splash_screen.dart';

class MyRouters {
  static var splashScreen = "/splashScreen";
  static var onBoardingScreen = "/onBoardingScreen";
  static var loginScreen = "/loginScreen";
  static var signupScreen = "/signupScreen";
  static var homePageScreen = "/homePageScreen";
  static var deliveryPageScreen = "/deliveryPageScreen";
  static var deliveryScreen = "/deliveryScreen";
  static var oderScreen = "/oderScreen";
  static var profileScreen = "/profileScreen";
  static var bottomNavbar = "/bottomNavbar";
  static var singleProductScreen = "/singleProductScreen";
  static var restaurantsStepperScreen = "/restaurantsStepperScreen";
  static var searchListScreen = "/searchListScreen";
  static var searchRestaurantScreen = "/searchRestaurantScreen";
  static var searchDiningListScreen = "/searchDiningListScreen";
  static var restaurantCategoryScreen = "/restaurantCategoryScreen";
  static var privacyPolicyScreen = "/privacyPolicyScreen";
  static var myOrder = "/myOrder";
  static var notification = "/notification";
  static var helpCenterScreen = "/helpCenterScreen";

  static var route = [
    GetPage(name: '/', page: () => const SplashScreen()),
    GetPage(name: '/onBoardingScreen', page: () => const OnBoardingScreen()),
    GetPage(name: MyRouters.loginScreen, page: () => const LoginScreen()),
    GetPage(name: MyRouters.signupScreen, page: () => const SignUpScreen()),
    GetPage(name: MyRouters.homePageScreen, page: () => const HomePage()),
    GetPage(name: MyRouters.deliveryPageScreen, page: () => const DeliveryPage()),
    GetPage(name: MyRouters.deliveryScreen, page: () => const DeliveryScreen()),
    // GetPage(name: MyRouters.oderScreen, page: () => const OderScreen()),
    GetPage(name: MyRouters.profileScreen, page: () => const ProfileScreen()),
    GetPage(name: MyRouters.bottomNavbar, page: () => const BottomNavbar()),
    // GetPage(name: MyRouters.singleProductScreen, page: () =>  SingleRestaurantsScreen(restaurantItem: null, distance: '',)),
    // GetPage(name: MyRouters.restaurantsStepperScreen, page: () => const RestaurantsStepperScreen()),
    GetPage(name: MyRouters.searchListScreen, page: () => const SerachListScreen()),
    GetPage(name: MyRouters.searchRestaurantScreen, page: () => const SearchRestaurantScreen()),
    GetPage(name: MyRouters.searchDiningListScreen, page: () => const SearchListDiningScreen()),
    GetPage(name: MyRouters.restaurantCategoryScreen, page: () => const RestaurantCategoryScreen()),
    GetPage(name: MyRouters.privacyPolicyScreen, page: () => const PrivacyPolicy()),
    GetPage(name: MyRouters.myOrder, page: () => const MyOrder()),
    GetPage(name: MyRouters.notification, page: () => const NotificationScreen()),
    GetPage(name: MyRouters.helpCenterScreen, page: () => const HelpCenterScreen()),
    // GetPage(name: MyRouters.homePageScreen, page: () => const OtpScreen()),
  ];
}
