import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_otp/email_otp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:resvago_customer/screen/forgot_password.dart';
import 'package:resvago_customer/screen/otpscreen.dart';
import 'package:resvago_customer/screen/two_step_verification.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../controller/logn_controller.dart';
import '../model/profile_model.dart';
import '../routers/routers.dart';
import '../widget/custom_textfield.dart';
import 'bottomnav_bar.dart';
import 'helper.dart';
import 'dart:math';

enum LoginOption { Mobile, EmailPassword }

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool showOtpField = false;
  bool passwordSecure = true;
  EmailOTP myauth = EmailOTP();
  String verificationId = "";
  String code = "+353";
  LoginOption loginOption = LoginOption.Mobile;
  TextEditingController emailController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final loginController = Get.put(LoginController());
  void checkPhoneNumberInFirestore() async {
    if (loginController.mobileController.text.isEmpty) {
      Fluttertoast.showToast(msg: 'Please enter phone number');
      return;
    }
    print(code + loginController.mobileController.text.trim());
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('customer_users')
        .where('mobileNumber', isEqualTo: code + loginController.mobileController.text.trim())
        .get();
    if (result.docs.isNotEmpty) {
      print(result.docs.first.data());
      Map kk = result.docs.first.data() as Map;
      print(kk["email"]);
      if (kk["deactivate"] == true) {
        Fluttertoast.showToast(msg: 'Your account has been deactivated, Please contact administrator');
      } else {
        // login(kk["email"].toString());
      }
    } else {
      Fluttertoast.showToast(msg: 'Phone Number not register yet Please Signup');
    }
  }

  String otp = '';
  void generateOTP() {
    int otpLength = 6;
    Random random = Random();
    String otpCode = '';
    for (int i = 0; i < otpLength; i++) {
      otpCode += random.nextInt(10).toString();
    }
    setState(() {
      otp = otpCode;
    });
  }

  void checkEmailInFirestore() async {
    OverlayEntry loader = Helper.overlayLoader(context);
    Overlay.of(context).insert(loader);
    generateOTP();
    final QuerySnapshot result =
        await FirebaseFirestore.instance.collection('customer_users').where('email', isEqualTo: emailController.text).get();
    if (result.docs.isNotEmpty) {
      print("gfdgdgh" + result.docs.first.toString());
      Map kk = result.docs.first.data() as Map;
      if (kk["deactivate"] == false) {
        try {
          await FirebaseAuth.instance
              .signInWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text.trim(),
          )
              .then((value) async {
            Helper.hideLoader(loader);
            SharedPreferences pref = await SharedPreferences.getInstance();
            pref.setString("password", passwordController.text.trim());
            if (!kIsWeb) {
              if (kk["twoStepVerification"] == true) {
              } else {
                Fluttertoast.showToast(msg: 'Login successfully');
              }
            } else {
              if (kk["twoStepVerification"] == true) {
              } else {}
            }
            if (kk["twoStepVerification"] == true) {
              FirebaseFirestore.instance.collection("send_mail").add({
                "to": emailController.text.trim(),
                "message": {
                  "subject": "This is a otp email",
                  "html": "Your otp is $otp",
                  "text": "asdfgwefddfgwefwn",
                }
              }).then((value) {
                if (!kIsWeb) {
                  Fluttertoast.showToast(msg: 'Otp email sent to ${emailController.text.trim()}');
                }
                else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("Otp email sent to ${emailController.text.trim()}"),
                  ));
                }
                Get.to(() => TwoStepVerificationScreen(email: emailController.text, password: passwordController.text, otp: otp));
              });
            } else {
              FirebaseFirestore.instance.collection("send_mail").add({
                "to": emailController.text.trim(),
                "message": {
                  "subject": "This is a otp email",
                  "html": "You have logged in new device",
                  "text": "asdfgwefddfgwefwn",
                }
              });
              Get.offAllNamed(MyRouters.bottomNavbar);
            }
          });
          return;
        } catch (e) {
          Helper.hideLoader(loader);
          print(e.toString());
          if (!kIsWeb) {
            if (e.toString() ==
                "[firebase_auth/invalid-credential] The supplied auth credential is incorrect, malformed or has expired.") {
              Fluttertoast.showToast(msg: "credential is incorrect");
            } else {
              Fluttertoast.showToast(msg: e.toString());
            }
          }  else {
            if (e.toString() == "[firebase_auth/invalid-credential] The supplied auth credential is incorrect, malformed or has expired.") {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text("credential is incorrect"),
              ));
            }
            else{
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(e.toString()),
              ));
            }
          }
        }
      } else {
        Helper.hideLoader(loader);
        if (!kIsWeb) {
          Fluttertoast.showToast(msg: 'Your account has been deactivated, Please contact administrator');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Your account has been deactivated, Please contact administrator"),
          ));
        }
      }
    } else {
      Helper.hideLoader(loader);
      if (!kIsWeb) {
        Fluttertoast.showToast(msg: 'Email not register yet Please Signup');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Email not register yet Please Signup"),
        ));
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    generateOTP();
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
                    // Row(
                    //   children: [
                    //     Radio(
                    //       value: LoginOption.Mobile,
                    //       groupValue: loginOption,
                    //       activeColor: Colors.white,
                    //       onChanged: (LoginOption? value) {
                    //         setState(() {
                    //           loginOption = value!;
                    //         });
                    //       },
                    //     ),
                    //     const Text(
                    //       "Login With Mobile Number",
                    //       style: TextStyle(color: Colors.white),
                    //     ),
                    //   ],
                    // ),
                    const SizedBox(width: 20),
                    // Row(
                    //   children: [
                    //     Radio(
                    //       value: LoginOption.EmailPassword,
                    //       groupValue: loginOption,
                    //       activeColor: Colors.white,
                    //       onChanged: (LoginOption? value) {
                    //         setState(() {
                    //           loginOption = value!;
                    //         });
                    //       },
                    //     ),
                    //     const Text("Login With Email Address", style: TextStyle(color: Colors.white)),
                    //   ],
                    // ),
                    // if (loginOption == LoginOption.Mobile)
                    //   Padding(
                    //     padding: const EdgeInsets.all(12),
                    //     child: Column(
                    //       crossAxisAlignment: CrossAxisAlignment.start,
                    //       children: [
                    //         Text(
                    //           'Enter Mobile Number',
                    //           style: GoogleFonts.poppins(
                    //             color: Colors.white,
                    //             fontSize: 14,
                    //           ),
                    //         ),
                    //         const SizedBox(
                    //           height: 5,
                    //         ),
                    //         IntlPhoneField(
                    //           flagsButtonPadding: const EdgeInsets.all(8),
                    //           dropdownIconPosition: IconPosition.trailing,
                    //           dropdownIcon: const Icon(
                    //             Icons.arrow_drop_down_rounded,
                    //             color: Colors.white,
                    //           ),
                    //           controller: loginController.mobileController,
                    //           style: const TextStyle(color: Colors.white),
                    //           dropdownTextStyle: const TextStyle(color: Colors.white),
                    //           decoration: InputDecoration(
                    //             hintText: 'Enter your Mobile number',
                    //             hintStyle: const TextStyle(color: Colors.white),
                    //             filled: true,
                    //             enabled: true,
                    //             enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Color(0x63ffffff))),
                    //             focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Color(0x63ffffff))),
                    //             iconColor: Colors.white,
                    //             errorBorder: const OutlineInputBorder(borderSide: BorderSide(width: 1)),
                    //             fillColor: const Color(0x63ffffff).withOpacity(.2),
                    //             border: OutlineInputBorder(
                    //               borderRadius: BorderRadius.circular(5),
                    //               borderSide: const BorderSide(width: 1, color: Color(0x63ffffff)),
                    //             ),
                    //           ),
                    //           onCountryChanged: (phone) {
                    //             setState(() {
                    //               code = "+${phone.dialCode}";
                    //               print(code.toString());
                    //             });
                    //           },
                    //           initialCountryCode: 'IE',
                    //           cursorColor: Colors.white,
                    //           keyboardType: TextInputType.number,
                    //           validator: MultiValidator([RequiredValidator(errorText: 'Please enter your mobile number')]).call,
                    //           onChanged: (phone) {
                    //             code = phone.countryCode.toString();
                    //             setState(() {});
                    //           },
                    //         ),
                    //         const SizedBox(
                    //           height: 15,
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // if (loginOption == LoginOption.EmailPassword)
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        children: [
                          CommonTextFieldWidget(
                            controller: emailController,
                            textInputAction: TextInputAction.next,
                            hint: 'Enter your email',
                            keyboardType: TextInputType.emailAddress,
                            validator: MultiValidator([
                              RequiredValidator(errorText: 'Please enter your email'),
                              EmailValidator(errorText: 'Enter a valid email address'),
                            ]).call,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          CommonTextFieldWidget(
                              obscureText: passwordSecure,
                              controller: passwordController,
                              textInputAction: TextInputAction.next,
                              hint: 'Enter your password',
                              keyboardType: TextInputType.text,
                              suffix: GestureDetector(
                                  onTap: () {
                                    passwordSecure = !passwordSecure;
                                    setState(() {});
                                  },
                                  child: Icon(
                                    passwordSecure ? Icons.visibility_off : Icons.visibility,
                                    size: 20,
                                    color: Colors.white,
                                  )),
                              validator: MultiValidator([
                                RequiredValidator(errorText: "Password is required"),
                                MinLengthValidator(8,
                                    errorText: 'Password must be at least 8 characters, with 1 special character & 1 numerical'),
                                PatternValidator(r"(?=.*\W)(?=.*?[#?!@$%^&*-])(?=.*[0-9])",
                                    errorText: "Password must be at least with 1 special character & 1 numerical"),
                              ])),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 15),
                        child: GestureDetector(
                          onTap: () {
                            Get.to(() => ForgotPassword());
                          },
                          child: Text(
                            'Forgot Password',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontWeight: FontWeight.w300,
                              fontSize: 14,
                              // fontFamily: 'poppins',
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // loginOption == LoginOption.EmailPassword
                          //     ?
                          CommonButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                FocusManager.instance.primaryFocus!.unfocus();
                                checkEmailInFirestore();
                              }
                            },
                            title: 'Login'.tr,
                          ),
                          const SizedBox(
                            height: 20,
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
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              'Sign in as a business',
                              style:
                                  GoogleFonts.poppins(color: const Color(0xFFFAAF40), fontSize: 16, fontWeight: FontWeight.w600),
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
                                behavior: HitTestBehavior.translucent,
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
                            height: 30,
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: GestureDetector(
                              onTap: () {
                                Get.to(() => BottomNavbar());
                              },
                              child: Text(
                                'Customer Booking?',
                                style: GoogleFonts.poppins(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ]),
                ),
              )).appPadding,
        ));
  }
}
