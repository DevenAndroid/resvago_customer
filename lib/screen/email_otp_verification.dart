import 'dart:developer';
import 'package:email_otp/email_otp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pin_code_fields/flutter_pin_code_fields.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:resvago_customer/screen/helper.dart';
import '../controller/logn_controller.dart';
import 'bottomnav_bar.dart';


class EmailOtpScreen extends StatefulWidget {
  final EmailOTP myauth ;
  const EmailOtpScreen({super.key, required this.myauth});

  @override
  State<EmailOtpScreen> createState() => _EmailOtpScreenState();
}

class _EmailOtpScreenState extends State<EmailOtpScreen> {
  TextEditingController otpController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final loginController = Get.put(LoginController());
  String verificationId = "";

  Future<void> verifyOTP(String email, String enteredOTP) async {
    try {
      AuthCredential credential = EmailAuthProvider.credential(email: email, password: enteredOTP);
      await _auth.signInWithCredential(credential);
      Get.to(()=>const BottomNavbar());
      if (kDebugMode) {
        print('Sign in successful: ${_auth.currentUser?.email}');
      }
    } catch (error) {
      if (kDebugMode) {
        print('Error signing in: $error');
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
            child: Container(
                height: Get.height,
                width: Get.width,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.fill,
                        image: AssetImage(
                          "assets/images/login.png",
                        ))),
                child: SingleChildScrollView(
                    child: Padding(
                        padding: const EdgeInsets.only(left: 4.0, right: 4),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: size.height * 0.26,
                              ),
                              Align(
                                alignment: Alignment.center,
                                child: Text(
                                  'Sent OTP  to verify your number',
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 18,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),

                              const SizedBox(
                                height: 20,
                              ),
                              PinCodeFields(
                                  length: 6,
                                  controller: otpController,
                                  fieldBorderStyle: FieldBorderStyle.square,
                                  responsive: true,
                                  fieldHeight: 50.0,
                                  fieldWidth: 60.0,
                                  borderWidth: 1.0,
                                  activeBorderColor: Colors.white,
                                  activeBackgroundColor:
                                  Colors.white.withOpacity(.10),
                                  borderRadius: BorderRadius.circular(10.0),
                                  keyboardType: TextInputType.number,
                                  autoHideKeyboard: true,
                                  fieldBackgroundColor:
                                  Colors.white.withOpacity(.10),
                                  borderColor: Colors.white,
                                  textStyle: GoogleFonts.poppins(
                                    fontSize: 25.0,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  onComplete: (output) async {
                                    verifyOTP("anjalikumari5845@gmail.com",otpController.text.trim().toString());
                                  }
                              ),
                              Align(
                                alignment: Alignment.center,
                                child: Text(
                                  'Enter the OTP Send to ${loginController.phoneNumberController.text.toString()}',
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 18,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              InkWell(
                                onTap: () {

                                },
                                child: Center(
                                  child: Text(
                                    'RESEND OTP',
                                    style: GoogleFonts.poppins(
                                        color: const Color(0xFFFFBA00), fontWeight: FontWeight.w600, fontSize: 16),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              )
                            ]))))));
  }
}
