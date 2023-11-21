import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_otp/email_otp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:resvago_customer/screen/otpscreen.dart';
import '../controller/logn_controller.dart';
import '../routers/routers.dart';
import '../widget/custom_textfield.dart';
import 'bottomnav_bar.dart';
import 'helper.dart';

enum LoginOption { Mobile, EmailPassword }

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool showOtpField = false;
  EmailOTP myauth = EmailOTP();
  String verificationId = "";
  String code = "+91";
  LoginOption loginOption = LoginOption.Mobile;
  TextEditingController emailController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final loginController = Get.put(LoginController());
  void checkPhoneNumberInFirestore() async {
    log(code + loginController.mobileController.text.trim());
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('customer_users')
        .where('mobileNumber', isEqualTo: code + loginController.mobileController.text.trim())
        .get();
    if (result.docs.isNotEmpty) {
      print(result.docs.first.data());
      Map kk = result.docs.first.data() as Map;
      print(kk["email"]);
      login(kk["email"].toString());
    } else if (loginController.mobileController.text.isEmpty) {
      Fluttertoast.showToast(msg: 'Please enter phone number');
    } else {
      Fluttertoast.showToast(msg: 'Phone Number not register yet Please Signup');
    }
  }

  void checkEmailInFirestore() async {
    final QuerySnapshot result =
        await FirebaseFirestore.instance.collection('customer_users').where('email', isEqualTo: emailController.text).get();
    if (result.docs.isNotEmpty) {
      myauth.setConfig(
          appEmail: "contact@hdevcoder.com",
          appName: "Email OTP",
          userEmail: emailController.text,
          otpLength: 6,
          otpType: OTPType.digitsOnly);
      if (await myauth.sendOTP() == true) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("OTP has been sent"),
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Oops, OTP send failed"),
        ));
      }
      setState(() {
        showOtpField = true;
      });
      return;
    } else {
      Fluttertoast.showToast(msg: 'Email not register yet Please Signup');
    }
  }


  login(String email) async {
    await FirebaseAuth.instance.signOut();
    await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: "123456");
    OverlayEntry loader = Helper.overlayLoader(context);
    Overlay.of(context).insert(loader);
    try {
      final String phoneNumber = code + loginController.mobileController.text.trim();
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) {
          log("Verification Failed: $credential");
        },
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
                email: email,
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
                    Row(
                      children: [
                        Radio(
                          value: LoginOption.Mobile,
                          groupValue: loginOption,
                          activeColor: Colors.white,
                          onChanged: (LoginOption? value) {
                            setState(() {
                              loginOption = value!;
                            });
                          },
                        ),
                        const Text(
                          "Login With Mobile Number",
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                    const SizedBox(width: 20),
                    Row(
                      children: [
                        Radio(
                          value: LoginOption.EmailPassword,
                          groupValue: loginOption,
                          activeColor: Colors.white,
                          onChanged: (LoginOption? value) {
                            setState(() {
                              loginOption = value!;
                            });
                          },
                        ),
                        const Text("Login With Email Address", style: TextStyle(color: Colors.white)),
                      ],
                    ),
                    if (loginOption == LoginOption.Mobile)
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Enter Mobile Number',
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            IntlPhoneField(
                              flagsButtonPadding: const EdgeInsets.all(8),
                              dropdownIconPosition: IconPosition.trailing,
                              dropdownIcon: const Icon(
                                Icons.arrow_drop_down_rounded,
                                color: Colors.white,
                              ),
                              controller: loginController.mobileController,
                              style: const TextStyle(color: Colors.white),
                              dropdownTextStyle: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                hintText: 'Enter your Mobile number',
                                hintStyle: const TextStyle(color: Colors.white),
                                filled: true,
                                enabled: true,
                                enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Color(0x63ffffff))),
                                focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Color(0x63ffffff))),
                                iconColor: Colors.white,
                                errorBorder: const OutlineInputBorder(borderSide: BorderSide(width: 1)),
                                fillColor: const Color(0x63ffffff).withOpacity(.2),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: const BorderSide(width: 1, color: Color(0x63ffffff)),
                                ),
                              ),
                              onCountryChanged: (phone){
                                setState(() {
                                  code = "+${phone.dialCode}";
                                  log(code.toString());
                                });
                              },
                              initialCountryCode: 'IN',
                              cursorColor: Colors.white,
                              keyboardType: TextInputType.number,
                              validator: MultiValidator([RequiredValidator(errorText: 'Please enter your mobile number')]).call,
                              onChanged: (phone) {
                                code = phone.countryCode.toString();
                                setState(() {});
                              },
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                          ],
                        ),
                      ),
                    if (loginOption == LoginOption.EmailPassword)
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          children: [
                            TextFormField(
                              controller: emailController,
                              cursorColor: Colors.white,
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                hintText: 'Enter Email',
                                hintStyle: const TextStyle(color: Colors.white),
                                suffixIcon: TextButton(
                                  onPressed: () {
                                    checkEmailInFirestore();
                                  },
                                  child: const Text('send',style: TextStyle(color: Colors.white),),
                                ),
                                filled: true,
                                fillColor: Colors.white.withOpacity(.10),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 16),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: const Color(0xFFffffff).withOpacity(.24)),
                                  borderRadius: BorderRadius.circular(6.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: const Color(0xFFffffff).withOpacity(.24)),
                                    borderRadius: const BorderRadius.all(Radius.circular(6.0))),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(color: const Color(0xFFffffff).withOpacity(.24), width: 3.0),
                                    borderRadius: BorderRadius.circular(6.0)),
                              ),
                              validator: MultiValidator([
                                RequiredValidator(errorText: 'Please enter your email'),
                                EmailValidator(errorText: 'Enter a valid email address'),
                              ]).call,
                              keyboardType: TextInputType.emailAddress,
                              // textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            if (!showOtpField)
                              TextFormField(
                                cursorColor: Colors.white,
                                style: const TextStyle(color: Colors.white),
                                controller: passwordController,
                                decoration: InputDecoration(
                                  filled: true,
                                  hintText: 'Enter Otp',
                                  hintStyle: const TextStyle(color: Colors.white),
                                  fillColor: Colors.white.withOpacity(.10),
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 16),
                                  // .copyWith(top: maxLines! > 4 ? AddSize.size18 : 0),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: const Color(0xFFffffff).withOpacity(.24)),
                                    borderRadius: BorderRadius.circular(6.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(

                                      borderSide: BorderSide(color: const Color(0xFFffffff).withOpacity(.24)),
                                      borderRadius: const BorderRadius.all(Radius.circular(6.0))),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(color: const Color(0xFFffffff).withOpacity(.24), width: 3.0),
                                      borderRadius: BorderRadius.circular(6.0)),
                                ),
                                validator: MultiValidator([
                                  RequiredValidator(errorText: 'Please enter your otp'),
                                ]).call,
                              )
                            else
                              TextFormField(
                                style: const TextStyle(color: Colors.white),
                                controller: otpController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  hintText: 'Enter Otp',
                                  hintStyle: const TextStyle(color: Colors.white),
                                  filled: true,
                                  fillColor: Colors.white.withOpacity(.10),
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 16),
                                  // .copyWith(top: maxLines! > 4 ? AddSize.size18 : 0),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: const Color(0xFFffffff).withOpacity(.24)),
                                    borderRadius: BorderRadius.circular(6.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: const Color(0xFFffffff).withOpacity(.24)),
                                      borderRadius: const BorderRadius.all(Radius.circular(6.0))),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(color: const Color(0xFFffffff).withOpacity(.24), width: 3.0),
                                      borderRadius: BorderRadius.circular(6.0)),
                                ),
                                validator: MultiValidator([
                                  RequiredValidator(errorText: 'Please enter your otp'),
                                ]).call,
                              ),
                          ],
                        ),
                      ),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          loginOption == LoginOption.EmailPassword
                              ? CommonButton(
                                  onPressed: () async {
                                    if (_formKey.currentState!.validate()) {
                                      if (await myauth.verifyOTP(otp: otpController.text) == true) {
                                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                          content: Text("OTP is verified"),
                                        ));
                                        FirebaseAuth.instance
                                            .signInWithEmailAndPassword(
                                          email: emailController.text.trim(),
                                          password: "123456",
                                        )
                                            .then((value) {
                                          Get.offAllNamed(MyRouters.bottomNavbar);
                                        });
                                      } else {
                                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                          content: Text("Invalid OTP"),
                                        ));
                                      }
                                    }
                                  },
                                  title: 'Login',
                                )
                              : CommonButton(
                                  onPressed: () async {
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
                                onTap: () async {},
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
              )).appPadding,
        ));
  }
}
