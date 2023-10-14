import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:resvago_customer/screen/homepage.dart';

import '../routers/routers.dart';
import '../widget/custom_textfield.dart';

class OtpScreen extends StatefulWidget {
  String verificationId;
   OtpScreen({Key? key, required this.verificationId}) : super(key: key);

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController otpController = TextEditingController();


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
                            'Enter Otp.',
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
                                'Enter Otp',
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
                                controller: otpController,
                                textInputAction: TextInputAction.next,
                                hint: 'Enter your Otp',
                                keyboardType: TextInputType.number,
                              ),
                              const SizedBox(
                                height: 40,
                              ),
                              CommonButton(
                                onPressed: () async {
                                  try {
                                    PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
                                      verificationId: widget.verificationId,
                                      smsCode: otpController.text.trim(),
                                    );
                                    final UserCredential authResult = await _auth.signInWithCredential(phoneAuthCredential);
                                    final User? user = authResult.user;
                                    print('Successfully signed in with phone number: ${user!.phoneNumber}');
                                    Get.to(HomePage());
                                  } catch (e) {
                                    print("Error: $e");
                                  }
                                },
                                title: 'Login',
                              ),
                              const SizedBox(
                                height: 45,
                              )
                            ],
                          ),
                        )
                      ]),
                ))));
  }
}
