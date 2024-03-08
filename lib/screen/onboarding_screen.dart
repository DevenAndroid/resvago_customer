import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:resvago_customer/screen/bottomnav_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../routers/routers.dart';
import '../widget/apptheme.dart';
import 'language_change_screen.dart';
import 'login_screen.dart';
import 'onboarding_list.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  PageController controller = PageController();
  final RxInt _pageIndex = 0.obs;
  bool loginLoaded = false;
  updateLanguage(String gg) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString("app_language", gg);
  }

  RxString selectedLAnguage = "English".obs;
  checkLanguage() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? appLanguage = sharedPreferences.getString("app_language");
    if (appLanguage == null || appLanguage == "English") {
      Get.updateLocale(const Locale('en', 'US'));
      selectedLAnguage.value = "English";
    } else if (appLanguage == "Spanish") {
      Get.updateLocale(const Locale('es', 'ES'));
      selectedLAnguage.value = "Spanish";
    } else if (appLanguage == "French") {
      Get.updateLocale(const Locale('fr', 'FR'));
      selectedLAnguage.value = "French";
    } else if (appLanguage == "Arabic") {
      Get.updateLocale(const Locale('ar', 'AE'));
      selectedLAnguage.value = "Arabic";
    }
  }

  final keyIsFirstLoaded = 'is_first_loaded';

  Future<void> showDialogLanguage(context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? isFirstLoaded = prefs.getBool(keyIsFirstLoaded);
    if (isFirstLoaded == null) {
      return showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          child: const Icon(
                            Icons.clear_rounded,
                            color: Colors.black,
                          ),
                          onTap: () {
                            Get.back();
                            Get.back();
                            Get.back();
                            Get.back();
                            prefs.setBool(keyIsFirstLoaded, false);
                          },
                        )
                      ],
                    ),
                    RadioListTile(
                        value: "English",
                        groupValue: selectedLAnguage.value,
                        title: const Text(
                          "English",
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xff000000)),
                        ),
                        onChanged: (value) {
                          locale = const Locale('en', 'US');
                          Get.updateLocale(locale);
                          selectedLAnguage.value = value!;
                          // updateLanguage("English");
                          Get.back();

                          if (kDebugMode) {
                            print(selectedLAnguage);
                          }
                        }),
                    RadioListTile(
                        value: "Spanish",
                        groupValue: selectedLAnguage.value,
                        title: const Text(
                          "Spanish",
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xff000000)),
                        ),
                        onChanged: (value) {
                          locale = const Locale('es', 'ES');
                          Get.updateLocale(locale);
                          selectedLAnguage.value = value!;
                          // updateLanguage("Spanish");
                          Get.back();
                          if (kDebugMode) {
                            print(selectedLAnguage);
                          }
                        }),
                    RadioListTile(
                        value: "French",
                        groupValue: selectedLAnguage.value,
                        title: const Text(
                          "French",
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xff000000)),
                        ),
                        onChanged: (value) {
                          locale = const Locale('fr', 'FR');
                          Get.updateLocale(locale);
                          selectedLAnguage.value = value!;
                          // updateLanguage("French");
                          Get.back();
                          if (kDebugMode) {
                            print(selectedLAnguage);
                          }
                        }),
                    RadioListTile(
                        value: "Arabic",
                        groupValue: selectedLAnguage.value,
                        title: const Text(
                          "Arabic",
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xff000000)),
                        ),
                        onChanged: (value) {
                          locale = const Locale('ar', 'AE');
                          Get.updateLocale(locale);
                          selectedLAnguage.value = value!;
                          // updateLanguage("Arabic");
                          Get.back();
                          if (kDebugMode) {
                            print(selectedLAnguage);
                          }
                        }),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Get.back();
                            Get.back();
                            Get.back();
                            Get.back();
                            updateLanguage(selectedLAnguage.value);
                            prefs.setBool(keyIsFirstLoaded, false);
                          },
                          child: Container(
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: AppTheme.primaryColor),
                              child: const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  "Update",
                                  style: TextStyle(color: Colors.white),
                                ),
                              )),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
          });
    }
  }
  @override
  void initState() {
    super.initState();
    controller = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  int currentIndex = 0;
  RxInt currentIndex12 = 0.obs;
  RxBool currentIndex1 = false.obs;
  bool isActive = false;
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialogLanguage(context);
    });
    return Scaffold(
        body: SafeArea(
      child: Stack(
        children: [
          PageView.builder(
              itemCount: OnBoardingData.length + 1,
              controller: controller,
              physics: loginLoaded ? const NeverScrollableScrollPhysics() : const BouncingScrollPhysics(),
              pageSnapping: true,
              onPageChanged: (index) {
                setState(() {
                  _pageIndex.value = index;
                  if (OnBoardingData.length == index) {
                    loginLoaded = true;
                  } else {
                    loginLoaded = false;
                  }
                });
              },
              itemBuilder: (context, index) {
                if (OnBoardingData.length == index) {
                  loginLoaded = true;
                  // Future.delayed(Duration(milliseconds: 100)).then((value) {
                  //   Get.offAll(()=> LoginScreen());
                  // });
                  Future.delayed(Duration(milliseconds: 100)).then((value) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const BottomNavbar()),
                    );
                  });
                }
                loginLoaded = false;
                return OnboardContent(
                  controller: controller,
                  indexValue: _pageIndex.value,
                  image: OnBoardingData[min(index, OnBoardingData.length-1)].image.toString(),
                  title: OnBoardingData[min(index, OnBoardingData.length-1)].title.toString(),
                  description: OnBoardingData[min(index, OnBoardingData.length-1)].description.toString(),
                );
              }),
        ],
      ),
    ));
  }
}

class CustomIndicator extends StatelessWidget {
  final bool isActive;

  const CustomIndicator({
    Key? key,
    required this.isActive,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.center,
        child: Container(
          alignment: Alignment.center,
          width: isActive ? 35 : 10,
          height: 10,
          decoration: BoxDecoration(
              border: Border.all(width: 1, color: AppTheme.backgroundcolor),
              color: isActive ? const Color(0xffFFC529) : const Color(0xffFFC529).withOpacity(.40),
              borderRadius: const BorderRadius.all(Radius.circular(30))),
        ));
  }
}

class OnboardContent extends StatelessWidget {
  final String image, title, description;
  final int indexValue;
  PageController controller = PageController();

  OnboardContent(
      {Key? key,
      required this.controller,
      required this.image,
      required this.title,
      required this.description,
      required this.indexValue})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Column(children: [
      Expanded(
        child: Column(
          children: [
            const SizedBox(
              height: 40,
            ),
            Flexible(
                child: SizedBox(
              height: height * .45,
              width: width,
              child: Image.asset(
                image,
                fit: BoxFit.contain,
              ),
            )),
            const SizedBox(
              height: 15,
            ),
            Column(
              children: [
                SizedBox(
                  height: height * .02,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ...List.generate(
                        OnBoardingData.length,
                        (index) => Padding(
                              padding: const EdgeInsets.only(right: 10.0),
                              child: CustomIndicator(
                                isActive: index == indexValue,
                              ),
                            )),
                  ],
                ),
                SizedBox(
                  height: height * .04,
                ),
                Text(
                  title,
                  style: GoogleFonts.alegreyaSans(
                    fontWeight: FontWeight.w400,
                    fontSize: 36,
                    color: AppTheme.onboardingColor,
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: height * .07,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Text(
                    description,
                    style:  GoogleFonts.alegreyaSans(
                      fontWeight: FontWeight.w400,
                      fontSize: 17,
                      color: AppTheme.onboardingDescColor,
                      fontStyle: FontStyle.italic,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  height: height * .06,
                ),
              ],
            ),
          ],
        ),
      ),
      Container(
          height: height * .08,
          width: width * .95,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
          ),
          child: ElevatedButton(
              onPressed: () {
                controller.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.ease);
                if (indexValue == 2) {
                  // Get.toNamed(MyRouters.loginScreen);
                }
              },
              style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  backgroundColor: Color(0xff3B5998),
                  textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
           child: Image.asset(height:23,width: 23,'assets/icons/arrow.png'),)),
      SizedBox(
        height: height * .07,
      ),
    ]);
  }
}
