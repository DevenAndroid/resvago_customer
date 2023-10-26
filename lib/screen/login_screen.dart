import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:resvago_customer/screen/otpscreen.dart';

import '../controller/logn_controller.dart';
import '../routers/routers.dart';
import '../widget/custom_textfield.dart';
import 'otpscreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final loginController = Get.put(LoginController());

  // TextEditingController phoneNumberController = TextEditingController();
  String verificationId = "";
  final _formKey = GlobalKey<FormState>();

  Future<bool> addUserToFirestore(String phoneNumber) async {
    final response = await FirebaseFirestore.instance.collection('users').where("phoneNumber", isEqualTo: phoneNumber).get();

    if (response.docs.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Phone Number does not exit Please Sign Up")));
      return false;
    } else {
      return true;
    }
  }

  Future<void> checkPhoneNumberInFirestore(String phoneNumber) async {
    try {
      // if(FirebaseAuth.instance.currentUser != null){
      try {
        final String phoneNumber = '+91${loginController.mobileController.text}'; // Include the country code
        await _auth.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          verificationCompleted: (PhoneAuthCredential credential) {},
          verificationFailed: (FirebaseAuthException e) {
            print("Verification Failed: $e");
          },
          codeSent: (String verificationId, [int? resendToken]) {
            // Update the parameter to accept nullable int
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
          physics: AlwaysScrollableScrollPhysics(),
          child: Container(

              decoration: const BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.fill,
                      image: AssetImage(
                        "assets/images/login.png",
                      ))),
              child: Form(
                key: _formKey,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 180,
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
                        padding: EdgeInsets.symmetric(horizontal: 25, vertical: 25),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Enter email or phone number',
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
                              controller: loginController.mobileController,
                              // textInputAction: TextInputAction.next,
                              // length: 10,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "field is required";
                                } else {
                                  return null;
                                }
                              },
                              hint: 'Enter email or phone number',
                              keyboardType: TextInputType.text,
                            ),
                            const SizedBox(
                              height: 40,
                            ),
                            CommonButton(
                              onPressed: () {
                                Get.toNamed(MyRouters.bottomNavbar);
                                // if (!_formKey.currentState!.validate()) return;
                                // addUserToFirestore("+91${loginController.mobileController.text}").then((value) {
                                //   if (value == true) {
                                //     checkPhoneNumberInFirestore("${loginController.mobileController.text}");
                                //   }
                                // });
                              },
                              title: 'Login',
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Text(
                              'Customer Booking?',
                              style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              'Sign in as a business',
                              style: GoogleFonts.poppins(
                                  color: Color(0xFFFAAF40),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600
                              ),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  height: 1,
                                  width: 110,
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
                                  width: 110,
                                  color: Color(0xFFD2D8DC),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 30,
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
                                  style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 15),
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
              )),
        ));
  }
}
