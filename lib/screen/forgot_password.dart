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
import 'package:resvago_customer/screen/login_screen.dart';
import '../controller/logn_controller.dart';
import '../firebase_service/firebase_service.dart';
import '../model/profile_model.dart';
import '../routers/routers.dart';
import '../widget/custom_textfield.dart';
import 'helper.dart';

class ForgotPassword extends StatefulWidget {
   ForgotPassword({super.key,});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final loginController = Get.put(LoginController());
  TextEditingController emailController = TextEditingController();
  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  late GeoFlutterFire geo;
  bool value = false;
  bool passwordSecure = false;
  var confirmPasswordSecure = false;
  var oldPasswordSecure = false;

  ProfileData profileData = ProfileData();
  FirebaseService firebaseService = FirebaseService();

  void updatePassword({required String newPassword, required String confirmPassword}) async {
    OverlayEntry loader = Helper.overlayLoader(context);
    Overlay.of(context).insert(loader);
    final QuerySnapshot result =
    await FirebaseFirestore.instance.collection('customer_users').where('email', isEqualTo: emailController.text).get();
    if (result.docs.isNotEmpty) {
      Map kk = result.docs.first.data() as Map;
      if (kk["deactivate"] == false) {
        UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: kk["email"],
          password: kk["password"],
        );
        User? user = userCredential.user;
        await user!.updatePassword(newPassword).then((value) {
          FirebaseFirestore.instance.collection('customer_users').doc(FirebaseAuth.instance.currentUser!.uid).update({
            "password": passwordController.text.trim(),
          }).then((value) {
            Helper.hideLoader(loader);
            if (!kIsWeb) {
              Fluttertoast.showToast(msg: 'Reset your password successfully');
            } else {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text("Reset your password successfully"),
              ));
            }
            if (!kIsWeb) {
              FirebaseAuth.instance.signOut();
            }
            Get.offAllNamed(MyRouters.loginScreen);
            print('Password changed successfully');
          });
        });
      }
    }
  }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            child: Container(
                height: Get.height,
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
                      SizedBox(
                        height: 200,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          'Forgot Password',
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
                              'Email',
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
                              hint: 'Enter your email',
                              keyboardType: TextInputType.emailAddress,
                              validator: MultiValidator([
                                RequiredValidator(errorText: 'Please enter your email'),
                                EmailValidator(errorText: 'Enter a valid email address'),
                              ]).call,
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Text(
                              'Password',
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
                                  RequiredValidator(errorText: 'Please enter your password'),
                                  MinLengthValidator(8,
                                      errorText: 'Password must be at least 8 characters, with 1 special character & 1 numerical'),
                                  PatternValidator(r"(?=.*\W)(?=.*?[#?!@$%^&*-])(?=.*[0-9])",
                                      errorText: "Password must be at least with 1 special character & 1 numerical"),
                                ])),
                            const SizedBox(
                              height: 15,
                            ),
                            Text(
                              'Confirm Password',
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
                              obscureText: confirmPasswordSecure,
                              controller: confirmController,
                              textInputAction: TextInputAction.next,
                              hint: 'Enter your confirm password',
                              keyboardType: TextInputType.text,
                              suffix: GestureDetector(
                                  onTap: () {
                                    confirmPasswordSecure = !confirmPasswordSecure;
                                    setState(() {});
                                  },
                                  child: Icon(
                                    confirmPasswordSecure ? Icons.visibility : Icons.visibility_off,
                                    size: 20,
                                    color: Colors.white,
                                  )),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter your confirm password';
                                }
                                if (value.toString() == passwordController.text) {
                                  return null;
                                }
                                return "Confirm password not matching with password";
                              },
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            CommonButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  updatePassword(newPassword: passwordController.text.trim(),
                                      confirmPassword: confirmController.text.trim());
                                }
                              },
                              title: 'Forgot Password',
                            ),
                            const SizedBox(
                              height: 30,
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

