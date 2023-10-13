import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widget/custom_textfield.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);
  static var signupScreen = "/signupScreen";

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
            child: Container(
                height: Get.height,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.fill,
                        image: AssetImage(
                          "assets/images/login.png",
                        ))),
                child: SingleChildScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 210,
                        ),

                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            'Create Account',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 26,
                              // fontFamily: 'poppins',
                            ),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 18),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Enter Your Name',
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              const CommonTextFieldWidget(
                                textInputAction: TextInputAction.next,
                                hint: 'Enter Your Name',
                                keyboardType: TextInputType.number,
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              Text(
                                'Enter Email',
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              const CommonTextFieldWidget(
                                textInputAction: TextInputAction.next,
                                hint: 'Enter your Email',
                                keyboardType: TextInputType.text,
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              Text(
                                'Enter Mobile number',
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              const CommonTextFieldWidget(
                                textInputAction: TextInputAction.next,
                                hint: 'Enter your Mobile number',
                                keyboardType: TextInputType.number,
                              ),
                              const SizedBox(
                                height: 25,
                              ),
                              const CommonButton(
                                title: 'Create Account',
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    height: 1,
                                    width: 120,
                                    color: const Color(0xFFD2D8DC),
                                  ),
                                  //SizedBox(width: 10,),
                                  Text('Or Login with',
                                      style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                      )),
                                  //SizedBox(width: 10,),
                                  Container(
                                    height: 1,
                                    width: 120,
                                    color: Color(0xFFD2D8DC),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width: 152,
                                    height: 55,
                                    decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(.10),
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(color: Colors.white.withOpacity(.35))),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          'assets/icons/facrebook.png',
                                          height: 27,
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          'Facebook',
                                          style: GoogleFonts.poppins(
                                              fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white),
                                        )
                                      ],
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {},
                                    child: Container(
                                      width: 152,
                                      height: 55,
                                      decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(.10),
                                          borderRadius: BorderRadius.circular(10),
                                          border: Border.all(color: Colors.white.withOpacity(.35))),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            'assets/icons/google.png',
                                            height: 25,
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            'Google',
                                            style: GoogleFonts.poppins(
                                                fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 60,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Already Have an Account?",
                                    style:
                                        GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 15),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      // Get.toNamed(MyRouters.signupScreen);
                                    },
                                    child: Text(
                                      '  Login',
                                      style: GoogleFonts.poppins(
                                          color: Color(0xFFFFBA00), fontWeight: FontWeight.w600, fontSize: 15),
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        )
                        // SizedBox(height: 25),
                        // Text(
                        //   'Enter Mobile number',
                        //   style: TextStyle(
                        //     color: Colors.white,
                        //     fontSize: 16,
                        //   ),
                        // ),
                        // SizedBox(
                        //   height: 2,
                        // ),
                        // SizedBox(
                        //   height: 2,
                        // ),
                      ]),
                ))));
  }
}
