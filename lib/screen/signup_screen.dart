import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';
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
  TextEditingController passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  late GeoFlutterFire geo;
  String code = "+353";
  String verificationId = "";
  bool value = false;
  bool passwordSecure = false;
  bool showValidation = false;
  FirebaseService firebaseService = FirebaseService();
  Future<void> addUserToFirestore() async {
    OverlayEntry loader = Helper.overlayLoader(context);
    Overlay.of(context).insert(loader);
    await FirebaseAuth.instance.createUserWithEmailAndPassword(email: emailController.text.trim(), password: passwordController.text.trim());
    if (FirebaseAuth.instance.currentUser != null) {
      await firebaseService
          .manageRegisterUsers(
              userName: userNameController.text.trim(),
              email: emailController.text.trim(),
              password: passwordController.text.trim())
          .then((value) async {
        Helper.hideLoader(loader);
        if (!kIsWeb) {
          Fluttertoast.showToast(msg: 'User created successfully');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("User created successfully"),
          ));
        }
        Get.toNamed(MyRouters.loginScreen);
      });
    }
  }

  void checkEmailInFirestore() async {
    final QuerySnapshot result =
        await FirebaseFirestore.instance.collection('customer_users').where('email', isEqualTo: emailController.text).get();
    if (result.docs.isNotEmpty) {
      Fluttertoast.showToast(msg: 'Email already exits');
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
                      fit: BoxFit.cover,
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
                            ]).call,
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
                              validator: MultiValidator([
                                EmailValidator(errorText: "Valid Email is required"),
                                RequiredValidator(errorText: "Email is required")
                              ]).call),
                          const SizedBox(
                            height: 15,
                          ),
                          Text(
                            'Enter Password',
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
                                    passwordSecure ? Icons.visibility : Icons.visibility_off,
                                    size: 20,
                                    color: Colors.white,
                                  )),
                              validator: MultiValidator([
                                RequiredValidator(
                                    errorText: 'Please enter your password'),
                                MinLengthValidator(8,
                                    errorText: 'Password must be at least 8 characters, with 1 special character & 1 numerical'),
                                PatternValidator(r"(?=.*\W)(?=.*?[#?!@$%^&*-])(?=.*[0-9])",
                                    errorText: "Password must be at least with 1 special character & 1 numerical"),
                              ])
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          // Text(
                          //   'Enter Mobile number',
                          //   style: GoogleFonts.poppins(
                          //     color: Colors.white,
                          //     fontWeight: FontWeight.w400,
                          //     fontSize: 14,
                          //   ),
                          // ),
                          // const SizedBox(
                          //   height: 15,
                          // ),
                          // IntlPhoneField(
                          //   flagsButtonPadding: const EdgeInsets.all(8),
                          //   dropdownIconPosition: IconPosition.trailing,
                          //   cursorColor: Colors.white,
                          //   dropdownIcon: const Icon(
                          //     Icons.arrow_drop_down_rounded,
                          //     color: Colors.white,
                          //   ),
                          //   dropdownTextStyle: const TextStyle(color: Colors.white),
                          //   style: const TextStyle(color: Colors.white),
                          //   controller: phoneNumberController,
                          //   decoration: const InputDecoration(
                          //       hintStyle: TextStyle(color: Colors.white),
                          //       labelText: 'Phone Number',
                          //       labelStyle: TextStyle(color: Colors.white),
                          //       border: OutlineInputBorder(
                          //         borderSide: BorderSide(),
                          //       ),
                          //       enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                          //       focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white))),
                          //   initialCountryCode: 'IE',
                          //   onCountryChanged: (phone) {
                          //     setState(() {
                          //       code = "+${phone.dialCode}";
                          //       log(code.toString());
                          //     });
                          //   },
                          //   onChanged: (phone) {
                          //     code = phone.countryCode.toString();
                          //   },
                          // ),
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
                              GestureDetector(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      // Return the dialog box widget
                                      return const AlertDialog(
                                        title: Text('Terms And Conditions'),
                                        content: Text(
                                            'Terms and conditions are part of a contract that ensure parties understand their contractual rights and obligations. Parties draft them into a legal contract, also called a legal agreement, in accordance with local, state, and federal contract laws. They set important boundaries that all contract principals must uphold.'
                                            'Several contract types utilize terms and conditions. When there is a formal agreement to create with another individual or entity, consider how you would like to structure your deal and negotiate the terms and conditions with the other side before finalizing anything. This strategy will help foster a sense of importance and inclusion on all sides.'),
                                        actions: <Widget>[],
                                      );
                                    },
                                  );
                                },
                                child: const Text('Are you agree terms and conditions?',
                                    style: TextStyle(fontWeight: FontWeight.w300, fontSize: 13, color: Colors.white)),
                              ),
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
                                  showToast("Please accept term and conditions");
                                }
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
              )).appPadding,
        ));
  }
}
