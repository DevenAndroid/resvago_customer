import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:email_auth/email_auth.dart';
import 'package:email_otp/email_otp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:resvago_customer/screen/otpscreen.dart';
import '../controller/logn_controller.dart';
import '../routers/routers.dart';
import '../widget/custom_textfield.dart';
import 'email_otp_verification.dart';
import 'helper.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String verificationId = "";
  final _formKey = GlobalKey<FormState>();
  final loginController = Get.put(LoginController());
  void checkPhoneNumberInFirestore() async {
    log(code + loginController.mobileController.text.trim());
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('customer_users')
        .where('mobileNumber', isEqualTo: code + loginController.mobileController.text.trim())
        .get();
    if (result.docs.isNotEmpty) {
      login();
    } else {
      Fluttertoast.showToast(msg: 'Phone Number not register yet Please Signup');
    }
  }

  login() async {
    log(code + loginController.mobileController.text.trim());
    OverlayEntry loader = Helper.overlayLoader(context);
    Overlay.of(context).insert(loader);
    try {
      final String phoneNumber = code + loginController.mobileController.text.trim();
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) {},
        verificationFailed: (FirebaseAuthException e) {
          log("Verification Failed: $e");
        },
        codeSent: (String verificationId, [int? resendToken]) {
          // Update the parameter to accept nullable int
          log("Code Sent: $verificationId");
          this.verificationId = verificationId;
          Get.to(() => OtpScreen(
                verificationId: verificationId,
                code: code,
              ));
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          log("Auto Retrieval Timeout: $verificationId");
        },
      );
      Helper.hideLoader(loader);
    } catch (e) {
      Helper.hideLoader(loader);
    }
  }

  Future<void> sendOtpEmail(String email) async {
    final HttpsCallable callable = FirebaseFunctions.instance.httpsCallable('sendOtpEmail');
    try {
      final result = await callable.call({'email': email});
      print(result.data);
    } catch (error) {
      print('Error sending OTP email: $error');
    }
  }

  // Future<void> sendVerificationEmail() async {
  //   try {
  //     print('Verification email sent.');
  //     User? user = FirebaseAuth.instance.currentUser;
  //     print('Verification email sent.${user!.phoneNumber}');
  //     if (user != null && !user.emailVerified) {
  //       await user.sendEmailVerification();
  //       print('Verification email sent.');
  //     }
  //   } catch (error) {
  //     print('Error sending verification email: $error');
  //   }
  // }
  Future<void> sendVerificationEmail() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        await user.sendEmailVerification();
        print('Verification email sent to ${user.email}');
      } else {
        print('User not signed in.');
      }
    } catch (error) {
      print('Error sending verification email: $error');
    }
  }

  void checkEmailVerification() {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      if (user.emailVerified) {
        print('Email is verified.');
        // Proceed with your application logic
      } else {
        print('Email is not verified.');
        // Show a message to the user to check their email for verification
      }
    } else {
      print('User not signed in.');
    }
  }

  EmailOTP myauth = EmailOTP();

  String code = "+91";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Container(
              decoration: const BoxDecoration(
                  image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage(
                  "assets/images/login.png",
                ),
              )),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child:
                      Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
                    const SizedBox(
                      height: 200,
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
                    const SizedBox(
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
                      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
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
                          IntlPhoneField(
                            cursorColor: Colors.white,
                            dropdownIcon: const Icon(
                              Icons.arrow_drop_down_rounded,
                              color: Colors.white,
                            ),
                            dropdownTextStyle: const TextStyle(color: Colors.white),
                            style: const TextStyle(color: Colors.white),
                            flagsButtonPadding: const EdgeInsets.all(8),
                            dropdownIconPosition: IconPosition.trailing,
                            controller: loginController.mobileController,
                            decoration: const InputDecoration(
                                hintStyle: TextStyle(color: Colors.white),
                                labelText: 'Phone Number',
                                labelStyle: TextStyle(color: Colors.white),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(),
                                ),
                                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white))),
                            initialCountryCode: 'IN',
                            onChanged: (phone) {
                              code = phone.countryCode.toString();
                              setState(() {});
                            },
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          CommonButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                checkPhoneNumberInFirestore();
                              }
                            },
                            title: 'Login',
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            'Customer Booking?',
                            style: GoogleFonts.poppins(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            'Sign in as a business',
                            style: GoogleFonts.poppins(color: const Color(0xFFFAAF40), fontSize: 16, fontWeight: FontWeight.w600),
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
                                width: 110,
                                color: const Color(0xFFD2D8DC),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  // sendOtpEmail("anjalikumari5845@gmail.com");
                                  myauth.setConfig(
                                      appEmail: "contact@hdevcoder.com",
                                      appName: "Email OTP",
                                      userEmail: "anjalikumari5845@gmail.com",
                                      otpLength:6,
                                      otpType: OTPType.digitsOnly);
                                  if (await myauth.sendOTP() == true) {
                                    showToast("OTP has been sent");
                                    Get.to(() => EmailOtpScreen(myauth: myauth));
                                  } else {
                                    showToast("Oops, OTP send failed");
                                  }
                                },
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
                                        'assets/icons/facrebook.png',
                                        height: 27,
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        'Facebook',
                                        style:
                                            GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  sendVerificationEmail();
                                },
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
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        'Google',
                                        style:
                                            GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white),
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
                            crossAxisAlignment: CrossAxisAlignment.end,
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
                ),
              )),
        ));
  }
}
