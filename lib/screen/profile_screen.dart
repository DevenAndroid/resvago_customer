import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:resvago_customer/widget/appassets.dart';

import '../model/profile_model.dart';
import '../widget/apptheme.dart';
import '../widget/common_text_field.dart';
import 'helper.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController mobileController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  ProfileData profileData = ProfileData();
  String code = "+91";
  void fetchdata() {
    FirebaseFirestore.instance
        .collection("customer_users")
        .doc(FirebaseAuth.instance.currentUser!.phoneNumber)
        .get()
        .then((value) {
      if (value.exists) {
        if (value.data() == null) return;
        profileData = ProfileData.fromJson(value.data()!);
        mobileController.text = (profileData.mobileNumber ?? "").toString();
        firstNameController.text = (profileData.userName ?? "").toString();
        lastNameController.text = (profileData.userName ?? "").toString();
        emailController.text = (profileData.email ?? "").toString();
        setState(() {});
      }
    });
  }

  Future<void> updateProfileToFirestore() async {
    OverlayEntry loader = Helper.overlayLoader(context);
    Overlay.of(context).insert(loader);
    try {
      await FirebaseFirestore.instance.collection("customer_users").doc(FirebaseAuth.instance.currentUser!.phoneNumber).update({
        "userName": firstNameController.text.trim(),
        "email": emailController.text.trim(),
        "mobileNumber": code + mobileController.text.trim(),
      }).then((value) => Fluttertoast.showToast(msg: "Profile Updated"));
      Helper.hideLoader(loader);
      fetchdata();
    } catch (e) {
      Helper.hideLoader(loader);
      throw Exception(e);
    } finally {
      Helper.hideLoader(loader);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchdata();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            children: [
              Container(
                // padding: const EdgeInsets.all(15),
                width: size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        Container(
                            padding: const EdgeInsets.only(bottom: 50),
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(border: Border.all(color: Colors.white)),
                            child: Image.asset('assets/images/profilebg.png')),
                        Positioned(
                          top: 90,
                          left: 0,
                          right: 0,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10000),
                                child: Container(
                                    height: 100,
                                    width: 100,
                                    clipBehavior: Clip.antiAlias,
                                    decoration: BoxDecoration(
                                      color: const Color(0xffFAAF40),
                                      border: Border.all(color: const Color(0xff3B5998), width: 6),
                                      borderRadius: BorderRadius.circular(5000),
                                      // color: Colors.brown
                                    ),
                                    child: Image.asset(
                                      'assets/images/man.png',
                                      height: 50,
                                      fit: BoxFit.cover,
                                    )),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: 150,
                          left: 210,
                          right: 122,
                          child: Container(
                            height: 30,
                            width: 30,
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                              color: const Color(0xff04666E),
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: const Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 15,
                            ),
                          ),
                        )
                      ],
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        profileData.userName.toString(),
                        style: GoogleFonts.poppins(color: AppTheme.registortext, fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        profileData.email.toString(),
                        style: GoogleFonts.poppins(color: Colors.grey, fontWeight: FontWeight.normal, fontSize: 12),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'First Name',
                            style: GoogleFonts.poppins(color: AppTheme.registortext, fontWeight: FontWeight.w500, fontSize: 15),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          RegisterTextFieldWidget(
                              controller: firstNameController,
                              validator: RequiredValidator(errorText: 'Please enter your First name').call,
                              hint: "First"),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            "Last name",
                            style: GoogleFonts.poppins(color: AppTheme.registortext, fontWeight: FontWeight.w500, fontSize: 15),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          RegisterTextFieldWidget(
                              controller: lastNameController,
                              validator: RequiredValidator(errorText: 'Please enter your Last name ').call,
                              // keyboardType: TextInputType.number,
                              // textInputAction: TextInputAction.next,
                              hint: "Last name"),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            "Email",
                            style: GoogleFonts.poppins(color: AppTheme.registortext, fontWeight: FontWeight.w500, fontSize: 15),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          RegisterTextFieldWidget(
                            controller: emailController,
                            validator: MultiValidator([
                              RequiredValidator(errorText: 'Please enter your email'),
                              EmailValidator(errorText: 'Enter a valid email address'),
                            ]).call,
                            keyboardType: TextInputType.emailAddress,
                            // textInputAction: TextInputAction.next,
                            hint: "abc@gmail.com",
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            "Mobile Number",
                            style: GoogleFonts.poppins(color: AppTheme.registortext, fontWeight: FontWeight.w500, fontSize: 15),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          IntlPhoneField(
                            cursorColor: Colors.black,
                            dropdownIcon: const Icon(
                              Icons.arrow_drop_down_rounded,
                              color: Colors.black,
                            ),
                            dropdownTextStyle: const TextStyle(color: Colors.black),
                            style: const TextStyle(color: Colors.black),
                            flagsButtonPadding: const EdgeInsets.all(8),
                            dropdownIconPosition: IconPosition.trailing,
                            controller: mobileController,
                            decoration: const InputDecoration(
                                hintStyle: TextStyle(color: Colors.black),
                                labelText: 'Phone Number',
                                labelStyle: TextStyle(color: Colors.black),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(),
                                ),
                                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
                                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black))),
                            initialCountryCode: 'IN',
                            onChanged: (phone) {
                              code = phone.countryCode.toString();
                              setState(() {});
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          CommonButtonBlue(
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                updateProfileToFirestore();
                              }
                            },
                            title: 'Save',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 80,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
