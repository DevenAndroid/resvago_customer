import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:resvago_customer/screen/otpscreen.dart';

import '../routers/routers.dart';
import '../widget/custom_textfield.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController phoneNumberController = TextEditingController();
  String verificationId = "";

  Future<void> checkPhoneNumberInFirestore(String phoneNumber) async {
    try {
      // if(FirebaseAuth.instance.currentUser != null){
        try {
          final String phoneNumber = '+91${phoneNumberController.text}'; // Include the country code
          await _auth.verifyPhoneNumber(
            phoneNumber: phoneNumber,
            verificationCompleted: (PhoneAuthCredential credential) {},
            verificationFailed: (FirebaseAuthException e) {
              print("Verification Failed: $e");
            },
            codeSent: (String verificationId, [int? resendToken]) { // Update the parameter to accept nullable int
              print("Code Sent: $verificationId");
              this.verificationId = verificationId;
              Get.to(OtpScreen(verificationId: verificationId));

            },
            codeAutoRetrievalTimeout: (String verificationId) {
              print("Auto Retrieval Timeout: $verificationId");
            },
          );
        } catch (e) {
          print("Error: $e");
        }

    //   } else {
    // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
    // content: Text("Phone Number does not exit Please Sign Up"),
    // ));
    //   }
    } catch (e) {
      print('Error checking phone number in Firestore: $e');
    }
  }

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
                  physics: NeverScrollableScrollPhysics(),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 220,
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            'WELCOME BACK',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 28,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            'Login your account.',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontWeight: FontWeight.w300,
                              fontSize: 14,
                              // fontFamily: 'poppins',
                            ),
                          ),
                        ),

                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 25, vertical: 45),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
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
                               CommonTextFieldWidget(
                                controller: phoneNumberController,
                                textInputAction: TextInputAction.next,
                                hint: 'Enter your Mobile number',
                                keyboardType: TextInputType.number,
                              ),
                              const SizedBox(
                                height: 40,
                              ),
                               CommonButton(
                                onPressed: (){
                                  checkPhoneNumberInFirestore(phoneNumberController.text);                                },
                                title: 'Login',
                              ),
                              const SizedBox(
                                height: 45,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    height: 1,
                                    width: 120,
                                    color: Color(0xFFD2D8DC),
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
                              SizedBox(
                                height: 45,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width: 152,
                                    height: 60,
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
                                        SizedBox(
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
                                      height: 60,
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
                                          SizedBox(
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
                                height: 50,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Don't Have an Account?",
                                    style:
                                        GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 15),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Get.toNamed(MyRouters.signupScreen);
                                    },
                                    child: Text(
                                      '  Signup',
                                      style: GoogleFonts.poppins(
                                          color: const Color(0xFFFFBA00), fontWeight: FontWeight.w600, fontSize: 15),
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        )
                      ]),
                ))));
  }
}
