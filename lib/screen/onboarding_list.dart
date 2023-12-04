import 'package:get/get.dart';

import '../widget/appassets.dart';


class OnBoarding {
  String title;
  String img;
  String description;

  OnBoarding(
      {required this.title, required this.img,required this.description,});
}

List<OnBoarding> page1 = [
  OnBoarding(
    title: "You first".tr,
    img: "assets/images/onboarding2.png",
    description: 'We don’t charge you order fees. We don’t spy on you. We just help you enjoy your meals'.tr,

  ),
  OnBoarding(
    title: "Beautifully-designed  menus".tr,
    img: "assets/images/onboarding.png",
    description: 'Every menu item is manually reviewed by our team'.tr,

  ),
  OnBoarding(
    title: "Unbeatable rates".tr,
    img: "assets/images/onbording3.png",
    description: 'We don’t charge any order fees. Delivery fees go where they belong.'.tr,

  ),

];


class OnBoardModelResponse {
  final String? image, title, description;


  OnBoardModelResponse({
    this.image,
    this.title,
    this.description,
  });
}

List<OnBoardModelResponse> OnBoardingData = [
  OnBoardModelResponse(
    image: AppAssets.onboarding,
    title: "You first".tr,

    description: 'We don’t charge you order fees. We don’t spy on you. We just help you enjoy your meals'.tr,

  ),
  OnBoardModelResponse(
    image: AppAssets.onboarding2,
    title: "Beautifully-designed menus".tr,
    description: 'Every menu item is manually reviewed by our team'.tr,

  ),
  OnBoardModelResponse(
    image: AppAssets.onboarding3,
    title: "Unbeatable rates".tr,
    description: 'We don’t charge any order fees. Delivery fees go where they belong.'.tr,

  )
];