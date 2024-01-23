import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:resvago_customer/widget/appassets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../controller/logn_controller.dart';
import '../firebase_service/firebase_service.dart';
import '../model/profile_model.dart';
import '../routers/routers.dart';
import '../widget/addsize.dart';
import '../widget/custom_textfield.dart';
import 'helper.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final loginController = Get.put(LoginController());
  TextEditingController emailController = TextEditingController();
  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  late GeoFlutterFire geo;
  String code = "+353";
  String verificationId = "";
  bool value = false;
  bool passwordSecure = true;
  var confirmPasswordSecure = true;
  var oldPasswordSecure = true;

  ProfileData profileData = ProfileData();

  void fetchdata() {
    FirebaseFirestore.instance.collection("customer_users").doc(FirebaseAuth.instance.currentUser!.uid).get().then((value) {
      if (value.exists) {
        if (value.data() == null) return;
        profileData = ProfileData.fromJson(value.data()!);
        setState(() {});
      }
    });
  }

  void updatePassword({required String newPassword, required String oldPassword, required String confirmPassword}) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var password = pref.getString("password");
    if (password.toString() != oldPasswordController.text.trim()) {
      if (!kIsWeb) {
        Fluttertoast.showToast(msg: 'Old password is incorrect');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Old password is incorrect"),
        ));
      }
      return;
    }
    if (passwordController.text.trim() == oldPasswordController.text.trim()) {
      if (!kIsWeb) {
        Fluttertoast.showToast(msg: 'Old password and new password should be difference');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Old password and new password should be difference"),
        ));
      }
      return;
    }
    OverlayEntry loader = Helper.overlayLoader(context);
    Overlay.of(context).insert(loader);
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: profileData.email,
        password: password.toString(),
      );
      User? user = userCredential.user;
      await user!.updatePassword(newPassword).then((value) {
        FirebaseFirestore.instance.collection('customer_users').doc(FirebaseAuth.instance.currentUser!.uid).update({
          "password": passwordController.text.trim(),
        }).then((value) {
          Helper.hideLoader(loader);
          if (!kIsWeb) {
            Fluttertoast.showToast(msg: 'Password changed successfully');
          } else {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Password changed successfully"),
            ));
          }
          if (!kIsWeb) {
            FirebaseAuth.instance.signOut();
          }
          Get.offAllNamed(MyRouters.loginScreen);
          print('Password changed successfully');
        });
      });
    } catch (e) {
      Helper.hideLoader(loader);
      if (!kIsWeb) {
        Fluttertoast.showToast(msg: e.toString());
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(e.toString()),
        ));
      }
      print('Error changing password: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchdata();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          leadingWidth: AddSize.size22 * 1.6,
          leading: Padding(
            padding: EdgeInsets.only(left: AddSize.padding10),
            child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  Get.back();
                },
                child: SvgPicture.asset(AppAssets.back)),
          ),
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
        ),
        extendBodyBehindAppBar: true,
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
                        'Change Password'.tr,
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
                            'Old Password'.tr,
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
                              obscureText: oldPasswordSecure,
                              controller: oldPasswordController,
                              textInputAction: TextInputAction.next,
                              hint: 'Enter your old password'.tr,
                              keyboardType: TextInputType.text,
                              suffix: GestureDetector(
                                  onTap: () {
                                    oldPasswordSecure = !oldPasswordSecure;
                                    setState(() {});
                                  },
                                  child: Icon(
                                    oldPasswordSecure ? Icons.visibility_off : Icons.visibility,
                                    size: 20,
                                    color: Colors.white,
                                  )),
                              validator: MultiValidator([
                                RequiredValidator(errorText: 'Please enter old your password'),
                                MinLengthValidator(8,
                                    errorText: 'Password must be at least 8 characters, with 1 special character & 1 numerical'),
                                PatternValidator(r"(?=.*\W)(?=.*?[#?!@$%^&*-])(?=.*[0-9])",
                                    errorText: "Password must be at least with 1 special character & 1 numerical"),
                              ])),
                          const SizedBox(
                            height: 15,
                          ),
                          Text(
                            'Password'.tr,
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
                              hint: 'Enter your password'.tr,
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
                            'Confirm Password'.tr,
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
                            hint: 'Enter your confirm password'.tr,
                            keyboardType: TextInputType.text,
                            suffix: GestureDetector(
                                onTap: () {
                                  confirmPasswordSecure = !confirmPasswordSecure;
                                  setState(() {});
                                },
                                child: Icon(
                                  confirmPasswordSecure ? Icons.visibility_off : Icons.visibility,
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
                                FocusManager.instance.primaryFocus!.unfocus();
                                updatePassword(
                                    confirmPassword: confirmController.text.trim(),
                                    newPassword: passwordController.text.trim(),
                                    oldPassword: oldPasswordController.text.trim());
                              }
                            },
                            title: 'Change Password'.tr,
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
