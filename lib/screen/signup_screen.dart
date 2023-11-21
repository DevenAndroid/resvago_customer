import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import '../controller/logn_controller.dart';
import '../firebase_service/firebase_service.dart';
import '../routers/routers.dart';
import '../widget/appStrings.dart';
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
  late GeoFlutterFire geo;
  String code = "+91";
  String verificationId = "";
  bool value = false;
  bool showValidation = false;
  FirebaseService firebaseService = FirebaseService();

  Future<void> addUserToFirestore() async {
    OverlayEntry loader = Helper.overlayLoader(context);
    Overlay.of(context).insert(loader);
    await FirebaseAuth.instance.createUserWithEmailAndPassword(email: emailController.text.trim(), password: "123456");
    if (FirebaseAuth.instance.currentUser != null) {
      await firebaseService
          .manageRegisterUsers(
              userName: userNameController.text.trim(),
              email: emailController.text.trim(),
              mobileNumber: code + phoneNumberController.text.trim(),
              password: "123456")
          .then((value) {
        Helper.hideLoader(loader);
        Get.toNamed(MyRouters.loginScreen);
      });
    }
  }

  void checkEmailInFirestore() async {
    final QuerySnapshot result =
        await FirebaseFirestore.instance.collection('customer_users').where('email', isEqualTo: emailController.text).get();

    if (result.docs.isNotEmpty) {
      Fluttertoast.showToast(msg: AppStrings.emailAlreadyEx.tr);
      return;
    }
    final QuerySnapshot phoneResult = await FirebaseFirestore.instance
        .collection('customer_users')
        .where('mobileNumber', isEqualTo: code + phoneNumberController.text.trim())
        .get();

    if (phoneResult.docs.isNotEmpty) {
      Fluttertoast.showToast(msg: AppStrings.mobileAlreadyEx.tr);
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
                      height: 230,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        AppStrings.createAcc.tr,
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
                            AppStrings.enterYourName.tr,
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
                            hint: AppStrings.enterYourName.tr,
                            validator: MultiValidator([
                              RequiredValidator(errorText: AppStrings.pleaseEnterYourName.tr),
                            ]).call,
                            keyboardType: TextInputType.text,
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Text(
                            AppStrings.enterEmail.tr,
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
                              hint:  AppStrings.enterYourEmail.tr,
                              keyboardType: TextInputType.text,
                              validator: MultiValidator([
                                EmailValidator(errorText:  AppStrings.validEmailIsReq.tr),
                                RequiredValidator(errorText: AppStrings.emailIsReq.tr)
                              ]).call),
                          const SizedBox(
                            height: 15,
                          ),
                          Text(
                            AppStrings.enterMobileNumber.tr,
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
                            flagsButtonPadding: const EdgeInsets.all(8),
                            dropdownIconPosition: IconPosition.trailing,
                            cursorColor: Colors.white,
                            dropdownIcon: const Icon(
                              Icons.arrow_drop_down_rounded,
                              color: Colors.white,
                            ),
                            dropdownTextStyle: const TextStyle(color: Colors.white),
                            style: const TextStyle(color: Colors.white),
                            controller: phoneNumberController,
                            decoration:  InputDecoration(
                                hintStyle: TextStyle(color: Colors.white),
                                labelText: AppStrings.phoneNumber.tr,
                                labelStyle: TextStyle(color: Colors.white),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(),
                                ),
                                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white))),
                            initialCountryCode: 'IN',
                            onChanged: (phone) {
                              code = phone.countryCode.toString();
                            },
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
                               Text(
                                   AppStrings.areYouAgree.tr,
                                  style: TextStyle(fontWeight: FontWeight.w300, fontSize: 13, color: Colors.white)),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          CommonButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                if (value == true) {
                                  checkEmailInFirestore();
                                } else {
                                  showToast(AppStrings.pleaseAccTerm.tr);
                                }
                              }
                            },
                            title: AppStrings.createAcc.tr,
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
                              Text(AppStrings.orLoginWith.tr,
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
                                      AppStrings.facebook.tr,
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
                                        AppStrings.google.tr,
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
                                AppStrings.alreadyHaveAnAcc.tr,
                                style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 15),
                              ),
                              InkWell(
                                onTap: () {
                                  Get.toNamed(MyRouters.loginScreen);
                                },
                                child: Text(
                                    " ${AppStrings.login.tr}",
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
