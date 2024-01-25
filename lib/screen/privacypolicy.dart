import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:resvago_customer/screen/helper.dart';

import '../model/page_model.dart';
import '../widget/common_text_field.dart';

class PrivacyPolicy extends StatefulWidget {
  const PrivacyPolicy({super.key});

  @override
  State<PrivacyPolicy> createState() => _PrivacyPolicyState();
}

class _PrivacyPolicyState extends State<PrivacyPolicy> {
  @override
  void initState() {
    super.initState();
    getPageData();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: backAppBar(
          title: "Privacy Policy".tr,
          context: context,
        ),
        body: pageModel != null
            ? SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  child: Container(
                      decoration: const BoxDecoration(
                        color: Color(0xffFFFFFF),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [Text(pageModel!.longdescription.toString())]),
                      )).appPaddingForScreen,
                ),
              )
            : Center(
                child: Text("Data Not Available"),
              ));
  }

  PagesData? pageModel;
  void getPageData() {
    FirebaseFirestore.instance.collection("Pages").get().then((value) {
      pageModel = PagesData.fromMap(value.docs.first.data());
      // log(jsonEncode(value.docs.first.data()).toString());
      setState(() {});
    });
  }
}
