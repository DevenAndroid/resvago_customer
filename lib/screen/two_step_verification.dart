import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_otp/email_otp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controller/logn_controller.dart';
import '../routers/routers.dart';
import '../widget/custom_textfield.dart';
import 'helper.dart';
import 'dart:math';

enum TwoStepVerification { Mobile, EmailPassword }

class TwoStepVerificationScreen extends StatefulWidget {
  String email;
  String password;
  TwoStepVerificationScreen({super.key, required this.email, required this.password});

  @override
  State<TwoStepVerificationScreen> createState() => _TwoStepVerificationScreenState();
}

class _TwoStepVerificationScreenState extends State<TwoStepVerificationScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool showOtpField = false;
  EmailOTP myauth = EmailOTP();
  String verificationId = "";
  String code = "+353";
  TwoStepVerification loginOption = TwoStepVerification.Mobile;
  TextEditingController emailController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final loginController = Get.put(LoginController());

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
    generateOTP();
    final QuerySnapshot result =
        await FirebaseFirestore.instance.collection('customer_users').where('email', isEqualTo: widget.email).get();
    if (result.docs.isNotEmpty) {
      Map kk = result.docs.first.data() as Map;
      if (kk["deactivate"] == false) {
        FirebaseFirestore.instance.collection("send_mail").add({
          "to": widget.email,
          "message": {
            "subject": "This is a otp email",
            "html": "Your otp is $otp",
            "text": "asdfgwefddfgwefwn",
          }
        }).then((value) {
          if (!kIsWeb) {
            Fluttertoast.showToast(msg: 'Otp send successfully');
          } else {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Otp send successfully"),
            ));
          }
        });
        setState(() {
          showOtpField = true;
        });
        return;
      } else {
        if (!kIsWeb) {
          Fluttertoast.showToast(msg: 'Your account has been deactivated, Please contact administrator');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Your account has been deactivated, Please contact administrator"),
          ));
        }
      }
    } else {
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
    if (widget.email.isNotEmpty) {
      emailController.text = widget.email;
    }
    FirebaseAuth.instance.signOut();
    generateOTP();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Container(
              height: Get.height,
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
                        'Please verify your account',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
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
                                  if (_formKey.currentState!.validate()) {
                                    checkEmailInFirestore();
                                  }
                                },
                                child: const Text(
                                  'send',
                                  style: TextStyle(color: Colors.white),
                                ),
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
                          // if (!showOtpField)
                          TextFormField(
                            cursorColor: Colors.white,
                            style: const TextStyle(color: Colors.white),
                            controller: otpController,
                            maxLength: 6,
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
                          )
                        ],
                      ),
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
                                if (otpController.text.isEmpty) {
                                  if (!kIsWeb) {
                                    Fluttertoast.showToast(msg: 'Please enter otp');
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                      content: Text("Please enter otp"),
                                    ));
                                  }
                                } else if (otp != otpController.text || otpController.text.length < 6) {
                                  if (!kIsWeb) {
                                    Fluttertoast.showToast(msg: 'Invalid otp');
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                      content: Text("Invalid otp"),
                                    ));
                                  }
                                } else {
                                  OverlayEntry loader = Helper.overlayLoader(context);
                                  Overlay.of(context).insert(loader);
                                  FirebaseAuth.instance
                                      .signInWithEmailAndPassword(
                                    email: widget.email,
                                    password: widget.password,
                                  )
                                      .then((value) {
                                    Helper.hideLoader(loader);
                                    if (!kIsWeb) {
                                      Fluttertoast.showToast(msg: 'Verify otp successfully');
                                    } else {
                                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                        content: Text("Verify otp successfully"),
                                      ));
                                    }
                                    Get.offAllNamed(MyRouters.bottomNavbar);
                                  });
                                }
                              }
                            },
                            title: 'Login'.tr,
                          ),
                          // : CommonButton(
                          //     onPressed: () async {
                          //       if (_formKey.currentState!.validate()) {
                          //         checkPhoneNumberInFirestore();
                          //       }
                          //     },
                          //     title: 'Login',
                          //   ),
                          const SizedBox(
                            height: 20,
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
