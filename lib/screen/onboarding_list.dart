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
    title: "You first",
    img: "assets/images/onBordingNew.JPG",

    description: 'We don’t charge you order fees. We don’t spy on you. We just help you enjoy your meals ',

  ),
  OnBoarding(
    title: "Beautifully-designed menus",
    img: "assets/images/Group 1000004213.png",
    description: 'Every menu item is manually reviewed by our team',

  ),
  OnBoarding(
    title: "Unbeatable rates",
    img: "assets/images/Onboeading3.png",
    description: 'We don’t charge any order fees. Delivery fees go where they belong.',

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
    title: "You first",

    description: 'We don’t charge you order fees. We don’t spy on you. We just help you enjoy your meals',

  ),
  OnBoardModelResponse(
    image: AppAssets.onboarding,
    title: "Beautifully-designed menus",
    description: 'Every menu item is manually reviewed by our team',

  ),
  OnBoardModelResponse(
    image: AppAssets.onboarding,
    title: "Unbeatable rates",
    description: 'We don’t charge any order fees. Delivery fees go where they belong.',

  )
];