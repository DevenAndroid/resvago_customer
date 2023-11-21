import 'package:get/get.dart';

import '../widget/appStrings.dart';
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
    title: AppStrings.youFirst.tr,
    img: "assets/images/onboarding2.png",

    description: AppStrings.weDontChargeYou,

  ),
  OnBoarding(
    title: AppStrings.beautifullyDesigned.tr,
    img: "assets/images/onboarding.png",
    description:  AppStrings.everyMenuItemIs

  ),
  OnBoarding(
    title:  AppStrings.unbeatableRates,
    img: "assets/images/onbording3.png",
    description: AppStrings.weDontChargeAnyOrder,

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
    title: AppStrings.youFirst.tr,

    description: AppStrings.weDontChargeYou,

  ),
  OnBoardModelResponse(
    image: AppAssets.onboarding2,
    title: AppStrings.beautifullyDesigned.tr,
    description: AppStrings.everyMenuItemIs

  ),
  OnBoardModelResponse(
    image: AppAssets.onboarding3,
    title: AppStrings.unbeatableRates,
    description: AppStrings.weDontChargeAnyOrder,

  )
];