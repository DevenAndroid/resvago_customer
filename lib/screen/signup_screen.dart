import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controller/logn_controller.dart';
import '../firebase_service/firebase_service.dart';
import '../routers/routers.dart';
import '../widget/custom_textfield.dart';
import 'helper.dart';
import 'otpscreen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);
  static var signupScreen = "/signupScreen";

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final loginController = Get.put(LoginController());
  TextEditingController userNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  late Geoflutterfire geo;

  String verificationId = "";
  bool value = false;
  bool showValidation = false;
  FirebaseService firebaseService = FirebaseService();

  Future<void> addUserToFirestore() async {
    OverlayEntry loader = Helper.overlayLoader(context);
    Overlay.of(context).insert(loader);
    await firebaseService
        .manageRegisterUsers(
      userName: userNameController.text.trim(),
      email: emailController.text.trim(),
      mobileNumber: phoneNumberController.text.trim(),
    ).then((value) {
      Helper.hideLoader(loader);
      Get.toNamed(MyRouters.loginScreen);
    });
  }


  void checkEmailInFirestore() async {
    final QuerySnapshot result =
    await FirebaseFirestore.instance.collection('customer_users').where('email', isEqualTo: emailController.text).get();

    if (result.docs.isNotEmpty) {
      Fluttertoast.showToast(msg: 'Email already exits');
      return;
    }
    final QuerySnapshot phoneResult = await FirebaseFirestore.instance
        .collection('customer_users')
        .where('mobileNumber', isEqualTo: phoneNumberController.text.trim())
        .get();

    if (phoneResult.docs.isNotEmpty) {
      Fluttertoast.showToast(msg: 'Mobile Number already exits');
      return;
    }
    addUserToFirestore();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Container(
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.fill,
                      image: AssetImage(
                        "assets/images/login.png",
                      ))),
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
                        'Create Account',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 26,
                          // fontFamily: 'poppins',
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Enter Your Name',
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
                            controller: userNameController,
                            textInputAction: TextInputAction.next,
                            hint: 'Enter Your Name',
                            validator: MultiValidator([
                              RequiredValidator(errorText: 'Please enter your name'),
                            ]),
                            keyboardType: TextInputType.text,
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Text(
                            'Enter Email',
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
                            controller: emailController,
                            textInputAction: TextInputAction.next,
                            hint: 'Enter your Email',
                            keyboardType: TextInputType.text,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Email required";
                              } else {
                                return null;
                              }
                            },
                          ),
                          const SizedBox(
                            height: 15,
                          ),
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

                            hint: 'Enter your Mobile number',
                            // length: 10,
                            validator: MultiValidator([
                              RequiredValidator(errorText: 'Please enter your phone number'),
                              MinLengthValidator(10, errorText: 'Please enter valid phone number'),
                            ]),
                            keyboardType: TextInputType.number,
                          ),
                          Row(
                            children: [
                              Transform.scale(
                                scale: 1.1,
                                child: Theme(
                                  data: ThemeData(unselectedWidgetColor: showValidation == false ? Colors.white : Colors.red),
                                  child: Checkbox(
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                      value: value,
                                      activeColor: Colors.orange,
                                      visualDensity: const VisualDensity(vertical: 0, horizontal: 0),
                                      onChanged: (newValue) {
                                        setState(() {
                                          value = newValue!;
                                          setState(() {});
                                        });
                                      }),
                                ),
                              ),
                              const Text('Are you agree terms and conditions?',
                                  style: TextStyle(fontWeight: FontWeight.w300, fontSize: 13, color: Colors.white)),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          CommonButton(
                            onPressed: () {
                              if(_formKey.currentState!.validate()){
                                checkEmailInFirestore();
                              }
                            },
                            title: 'Create Account',
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
                              Container(
                                width: 152,
                                height: 55,
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
                                      style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white),
                                    )
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: () {},
                                child: Container(
                                  width: 152,
                                  height: 55,
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Already Have an Account?",
                                style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 15),
                              ),
                              InkWell(
                                onTap: () {
                                  Get.toNamed(MyRouters.loginScreen);
                                },
                                child: Text(
                                  '  Login',
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
