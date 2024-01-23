import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../firebase_service/firebase_service.dart';
import '../model/profile_model.dart';
import '../widget/common_text_field.dart';
import 'helper.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  FirebaseService firebaseService = FirebaseService();
  String code = '';
  bool twoStepVerification = false;
  ProfileData profileData = ProfileData();
  void fetchData() {
    FirebaseFirestore.instance.collection("customer_users").doc(FirebaseAuth.instance.currentUser!.uid).get().then((value) {
      if (value.exists) {
        if (value.data() == null) return;
        profileData = ProfileData.fromJson(value.data()!);
        twoStepVerification = profileData.twoStepVerification ?? false;
        setState(() {});
      }
    });
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: backAppBar(title: "Setting".tr, context: context),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Row(
                    children: [
                      Text(
                        "Enable 2 step Verification".tr,
                        style: GoogleFonts.poppins(color: const Color(0xFF292F45), fontSize: 15, fontWeight: FontWeight.w400),
                      ),
                      const Spacer(),
                      CupertinoSwitch(
                        value: twoStepVerification,
                        activeColor: const Color(0xffFAAF40),
                        onChanged: (value) {
                          twoStepVerification = value;
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 50),
              CommonButtonBlue(
                title: "Submit".tr,
                onPressed: () {
                  FirebaseFirestore.instance.collection('customer_users').doc(FirebaseAuth.instance.currentUser!.uid).update({
                    "twoStepVerification": twoStepVerification,
                  }).then((value){
                    showToast("Setting updated successfully");
                  });
                },
              ),
            ],
          ).appPaddingForScreen,
        ),
      ),
    );
  }
}
