import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pin_code_fields/flutter_pin_code_fields.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:resvago_customer/routers/routers.dart';
import 'package:resvago_customer/screen/helper.dart';
import '../controller/logn_controller.dart';
import '../widget/custom_textfield.dart';
import 'bottomnav_bar.dart';

class OtpScreen extends StatefulWidget {
  String verificationId;
  String code;
  final String email;
  OtpScreen({Key? key, required this.verificationId, required this.code, required this.email}) : super(key: key);

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  TextEditingController otpController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final loginController = Get.put(LoginController());
  String verificationId = "";
  reSend() async {
    try {
      final String phoneNumber = widget.code + loginController.mobileController.text; // Include the country code
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
          Get.to(() => OtpScreen(verificationId: verificationId, code: widget.code, email: widget.email));
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          log("Auto Retrieval Timeout: $verificationId");
        },
      );
    } catch (e) {
      log("Error: $e");
    }
  }

  verifyOtp() async {
    try {
      await FirebaseAuth.instance.signOut();
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: widget.email, password: "123456");
      PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
        verificationId: widget.verificationId,
        smsCode: kIsWeb ? otpControllers.map((e) => e.text.trim()).join(""): otpController.text.trim(),
      );
      if (FirebaseAuth.instance.currentUser!.phoneNumber == null) {
        UserCredential userCredential = await FirebaseAuth.instance.currentUser!.linkWithCredential(phoneAuthCredential);
        log('Successfully signed in with phone number: ${userCredential.credential}');
        Get.offAllNamed(MyRouters.bottomNavbar);
      } else {
        final UserCredential authResult = await _auth.signInWithCredential(phoneAuthCredential);
        final User? user = authResult.user;
        log('Successfully signed in with phone number: $user');
        Get.offAllNamed(MyRouters.bottomNavbar);
      }
    } catch (e) {
      otpControllers.forEach((element) {
        element.text = "";
      });
      log("Error: $e");
    }
  }

  List<TextEditingController> otpControllers = List.generate(6, (index) => TextEditingController());

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
                              if(kIsWeb)
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: otpControllers.asMap().entries.map((e) => Flexible(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 15),
                                      child: Container(
                                        constraints: BoxConstraints(
                                            maxWidth: 50
                                        ),
                                        child: CommonTextFieldWidget(
                                          controller: e.value,
                                          textAlign: TextAlign.center,
                                          textAlignVertical: TextAlignVertical.center,
                                          textInputAction: TextInputAction.next,
                                          hint: '*',
                                          maxLength: 1,
                                          inputFormatters: [
                                            FilteringTextInputFormatter.digitsOnly
                                          ],
                                          onChanged: (v){
                                            if(v.isNotEmpty){
                                              FocusManager.instance.primaryFocus!.nextFocus();
                                            } else {
                                              FocusManager.instance.primaryFocus!.previousFocus();
                                            }
                                            if(otpControllers.map((e) => e.text.trim()).join("").length == 6){
                                              verifyOtp();
                                            }
                                          },
                                          validator: MultiValidator([
                                            RequiredValidator(errorText: 'Please enter your otp'),
                                          ]).call,
                                          keyboardType: TextInputType.text,
                                        ),
                                      ),
                                    ),
                                  )).toList(),
                                ) else
                              PinCodeFields(
                                  length: 6,
                                  controller: otpController,
                                  fieldBorderStyle: FieldBorderStyle.square,
                                  responsive: true,
                                  fieldHeight: 50.0,
                                  fieldWidth: 60.0,
                                  borderWidth: 1.0,
                                  activeBorderColor: Colors.white,
                                  activeBackgroundColor: Colors.white.withOpacity(.10),
                                  borderRadius: BorderRadius.circular(10.0),
                                  keyboardType: TextInputType.number,
                                  autoHideKeyboard: true,
                                  fieldBackgroundColor: Colors.white.withOpacity(.10),
                                  borderColor: Colors.white,
                                  textStyle: GoogleFonts.poppins(
                                    fontSize: 25.0,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  onComplete: (output) async {
                                    verifyOtp();
                                  }),
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
                                  reSend();
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
