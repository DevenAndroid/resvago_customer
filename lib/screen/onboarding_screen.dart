import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../routers/routers.dart';
import '../widget/apptheme.dart';
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
                      }
                      else {
                        loginLoaded = false;
                      }
                    });
                  },
                  itemBuilder: (context, index) {
                    if (OnBoardingData.length == index) {
                      loginLoaded = true;
                      return const LoginScreen();
                    }

                    loginLoaded = false;
                    return OnboardContent(
                      controller : controller,
                      indexValue: _pageIndex.value,
                      image: OnBoardingData[index].image.toString(),
                      title: OnBoardingData[index].title.toString(),
                      description: OnBoardingData[index].description.toString(),
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
              color:
              isActive ? const Color(0xffFFC529) : const Color(0xffFFC529).withOpacity(.40),
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
        required this.indexValue
      })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return  Column(

        children:[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(

                children: [
                 SizedBox(height: 40,),
                  Flexible(
                  child: SizedBox(
                  height: height * .45,
      width: width,
                    child: Image.asset(image,fit: BoxFit.contain,),
                  )  ),
                  SizedBox(height: 15,),
                  Column(
                    children: [
                      SizedBox(
                        height: height*.02,
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
                      SizedBox(height: height* .04,),
                      Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 26,
                          fontFamily: 'alegreyaSans',
                          color: Colors.black,
                          fontStyle: FontStyle.italic,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: height * .08,
                      ),
                      Text(
                        description,
                        style: const TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: 16,
                          fontFamily: 'Alegreya Sans',
                          color: Color(0xFF616772),
                          fontStyle: FontStyle.italic,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: height * .06,
                      ),
                    ],
                  ),
                ],
              ),
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
                    controller.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.ease);
                    if (indexValue == 2) {
                      // Get.toNamed(MyRouters.loginScreen);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      shape: CircleBorder(),
                      primary: const Color(0xFF3B5998),
                      textStyle: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w500)),
                  child: Icon(Icons.arrow_forward,size: 35,color: Colors.white,)
              )),
          SizedBox(
            height: height * .07,
          ),
        ]);
  }
}

