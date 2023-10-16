
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pin_code_fields/flutter_pin_code_fields.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:resvago_customer/screen/login_screen.dart';
import '../controller/logn_controller.dart';

class OtpScreen extends StatefulWidget {
  String verificationId;

  OtpScreen({Key? key, required this.verificationId}) : super(key: key);

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final loginController = Get.put(LoginController());
  final formKey = GlobalKey<FormState>();
  TextEditingController otpController = TextEditingController();

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
                    child: Form(
                  key: formKey,
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
                              length: 4,
                              controller: otpController,
                              fieldBorderStyle: FieldBorderStyle.square,
                              responsive: false,
                              fieldHeight: 55.0,
                              fieldWidth: 55.0,
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
                              onComplete: (output) {
                                // Get.back();
                              },
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: Text(
                                'Enter the OTP Send to ${otpController.text}',
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
                                onPressed:
                                () async {
                                  try {
                                    PhoneAuthCredential phoneAuthCredential =
                                        PhoneAuthProvider.credential(
                                      verificationId: widget.verificationId,
                                      smsCode: otpController.text.trim(),
                                    );
                                    final UserCredential authResult =
                                        await _auth.signInWithCredential(
                                            phoneAuthCredential);
                                    final User? user = authResult.user;
                                    print(
                                        'Successfully signed in with phone number: ${user!.phoneNumber}');
                                    Get.to(const LoginScreen());
                                  } catch (e) {
                                    print("Error: $e");
                                  }
                                };
                              },
                              child: Center(
                                child: Text(
                                  'RESEND OTP',
                                  style: GoogleFonts.poppins(
                                      color: const Color(0xFFFFBA00),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            )
                          ])),
                )))));
  }
}
