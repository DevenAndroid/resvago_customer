import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_otp/email_otp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pin_code_fields/flutter_pin_code_fields.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../controller/logn_controller.dart';
import '../model/admin_model.dart';
import '../model/menu_model.dart';
import '../model/resturant_model.dart';
import '../routers/routers.dart';
import '../widget/custom_textfield.dart';
import 'checkout_for_dining/oder_screen.dart';
import 'helper.dart';
import 'dart:math';

enum OtpVerify { Mobile, EmailPassword }

class OtpVerifyScreen extends StatefulWidget {
  OtpVerifyScreen({super.key, required this.email, required this.otp, required this.pass});
  String email;
  String otp;
  String pass;
  @override
  State<OtpVerifyScreen> createState() => _OtpVerifyScreenState();
}

class _OtpVerifyScreenState extends State<OtpVerifyScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool showOtpField = false;
  EmailOTP myauth = EmailOTP();
  String verificationId = "";
  String code = "+353";
  OtpVerify loginOption = OtpVerify.Mobile;
  TextEditingController otpController = TextEditingController();
  final loginController = Get.put(LoginController());
  List<TextEditingController> otpControllers = List.generate(6, (index) => TextEditingController());
  AdminModel? adminModel;
  void getAdminData() {
    FirebaseFirestore.instance.collection("admin_login").get().then((value) {
      adminModel = AdminModel.fromJson(value.docs.first.data());
    });
  }
  String discountValueKey = 'discount_value';
  String lunchSelectedKey = 'lunch_selected';
  String slotKey = 'slot';
  String guestKey = 'guest';
  String dateKey = 'date';
  String restaurantItemKey = 'restaurant_item';
  String menuListKey = 'selected_menu_list';
  getDataWithoutLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    double discountValue = prefs.getDouble(discountValueKey) ?? 0.0;
    bool lunchSelected = prefs.getBool(lunchSelectedKey) ?? false;
    String slot = prefs.getString(slotKey) ?? '';
    String docId = prefs.getString("docId") ?? '';
    int guest = prefs.getInt(guestKey) ?? 0;
    String date = prefs.getString(dateKey) ?? '';
    String restaurantItemJson = prefs.getString(restaurantItemKey) ?? '{}';
    RestaurantModel? restaurantItem = RestaurantModel.fromJson(jsonDecode(restaurantItemJson),docId);
    String menuListJson = prefs.getString(menuListKey) ?? '[]';
    List<MenuData>? selectedMenuList = [];
    if (menuListJson.isNotEmpty) {
      selectedMenuList = (jsonDecode(menuListJson) as List<dynamic>).map((e) => MenuData.fromJson(e)).toList();
    }
    Get.to(()=>OderScreen(
        checkScreen:"orderScreen",
        discountValue: discountValue,
        lunchSelected: lunchSelected,
        slot: slot,
        guest: guest,
        date: DateTime.parse(date),
        restaurantItem: restaurantItem,
        menuList: selectedMenuList));
    setState(() {

    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseAuth.instance.signOut();
    getAdminData();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Colors.white,
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
                                height: size.height * 0.28,
                              ),
                              Align(
                                alignment: Alignment.center,
                                child: Text(
                                  'Enter OTP  to verify your email',
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
                              if (kIsWeb)
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: otpControllers
                                      .asMap()
                                      .entries
                                      .map((e) => Flexible(
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 15),
                                              child: Container(
                                                constraints: const BoxConstraints(maxWidth: 50),
                                                child: CommonTextFieldWidget(
                                                  controller: e.value,
                                                  textAlign: TextAlign.center,
                                                  textAlignVertical: TextAlignVertical.center,
                                                  textInputAction: TextInputAction.next,
                                                  hint: '*',
                                                  maxLength: 1,
                                                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                                  onChanged: (v) {
                                                    if (v.isNotEmpty) {
                                                      FocusManager.instance.primaryFocus!.nextFocus();
                                                    } else {
                                                      FocusManager.instance.primaryFocus!.previousFocus();
                                                    }
                                                    if (otpControllers.map((e) => e.text.trim()).join("").length == 6) {
                                                      if (widget.otp != otpControllers.map((e) => e.text.trim()).join("")) {
                                                        if (!kIsWeb) {
                                                          Fluttertoast.showToast(msg: 'Invalid otp');
                                                        } else {
                                                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                                            content: Text("Invalid otp"),
                                                          ));
                                                        }
                                                      }
                                                      else {
                                                        FirebaseAuth.instance
                                                            .signInWithEmailAndPassword(
                                                          email: widget.email,
                                                          password: widget.pass,
                                                        )
                                                            .then((value) async {
                                                          await FirebaseFirestore.instance
                                                              .collection("customer_users")
                                                              .doc(FirebaseAuth.instance.currentUser!.uid)
                                                              .update({"verified": true});
                                                          FirebaseFirestore.instance.collection("send_mail").add({
                                                            "to": widget.email,
                                                            "message": {
                                                              "subject": "This is a email",
                                                              "html": "Your account has been created",
                                                              "text": "asdfgwefddfgwefwn",
                                                            }
                                                          });
                                                          FirebaseFirestore.instance.collection("send_mail").add({
                                                            "to": adminModel!.email,
                                                            "message": {
                                                              "subject": "This is a otp email",
                                                              "html": "Your account has been created",
                                                              "text": "asdfgwefddfgwefwn",
                                                            }
                                                          });
                                                          if (!kIsWeb) {
                                                            Fluttertoast.showToast(msg: 'Verify otp successfully');
                                                          } else {
                                                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                                              content: Text("Verify otp successfully"),
                                                            ));
                                                          }
                                                          SharedPreferences prefs = await SharedPreferences.getInstance();
                                                          var loginValue = prefs.getString("login_response",);
                                                          if(loginValue !=null || loginValue == "checkOut"){
                                                            getDataWithoutLogin();
                                                            prefs.clear();
                                                          }
                                                          else{
                                                            Get.offAllNamed(MyRouters.bottomNavbar);
                                                          }
                                                        });
                                                      }
                                                    }
                                                  },
                                                  validator: MultiValidator([
                                                    RequiredValidator(errorText: 'Please enter your otp'),
                                                  ]).call,
                                                  keyboardType: TextInputType.text,
                                                ),
                                              ),
                                            ),
                                          ))
                                      .toList(),
                                )
                              else
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
                                      if (widget.otp != otpController.text) {
                                        if (!kIsWeb) {
                                          Fluttertoast.showToast(msg: 'Invalid otp');
                                        } else {
                                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                            content: Text("Invalid otp"),
                                          ));
                                        }
                                      }
                                      else {
                                        FirebaseAuth.instance
                                            .signInWithEmailAndPassword(
                                          email: widget.email,
                                          password: widget.pass,
                                        )
                                            .then((value) async {
                                          await FirebaseFirestore.instance
                                              .collection("customer_users")
                                              .doc(FirebaseAuth.instance.currentUser!.uid)
                                              .update({"verified": true});
                                          FirebaseFirestore.instance.collection("send_mail").add({
                                            "to": widget.email,
                                            "message": {
                                              "subject": "This is a email",
                                              "html": "Your account has been created",
                                              "text": "asdfgwefddfgwefwn",
                                            }
                                          });
                                          FirebaseFirestore.instance.collection("send_mail").add({
                                            "to": adminModel!.email,
                                            "message": {
                                              "subject": "This is a otp email",
                                              "html": "Your account has been created",
                                              "text": "asdfgwefddfgwefwn",
                                            }
                                          });
                                          if (!kIsWeb) {
                                            Fluttertoast.showToast(msg: 'Verify otp successfully');
                                          } else {
                                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                              content: Text("Verify otp successfully"),
                                            ));
                                          }
                                          SharedPreferences prefs = await SharedPreferences.getInstance();
                                          var loginValue = prefs.getString("login_response",);
                                          if(loginValue !=null || loginValue == "checkOut"){
                                            getDataWithoutLogin();
                                            prefs.clear();
                                          }
                                          else{
                                            Get.offAllNamed(MyRouters.bottomNavbar);
                                          }
                                        });
                                      }
                                    }),
                              const SizedBox(
                                height: 20,
                              ),
                            ])))).appPaddingForScreen));
  }
}