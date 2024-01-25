import 'dart:convert';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resvago_customer/model/faq_model.dart';
import '../widget/addsize.dart';
import '../widget/apptheme.dart';
import '../widget/common_text_field.dart';

class FaqScreen extends StatefulWidget {
  const FaqScreen({super.key});

  @override
  State<FaqScreen> createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> {
  List<FAQModel>? faqModel;
  bool isLoading = false;
  getFAQList() {
    FirebaseFirestore.instance.collection("FAQ").get().then((value) {
      isLoading = true;
      for (var element in value.docs) {
        var gg = element.data();
        faqModel ??= [];
        faqModel!.add(FAQModel.fromJson(gg));
      }
      setState(() {});
    });
  }

  RxInt showSubTitle = (0).obs;
  @override
  void initState() {
    super.initState();
    getFAQList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: backAppBar(title: "FAQ", context: context),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AddSize.padding16,
                vertical: AddSize.padding10,
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: AddSize.size12,
                  ),
                  isLoading ?  faqModel !=null && faqModel!.isNotEmpty
                      ? Column(
                          children: List.generate(
                              faqModel!.length,
                              (index) => Padding(
                                    padding: EdgeInsets.symmetric(vertical: AddSize.padding20, horizontal: AddSize.padding10),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: AppTheme.backgroundcolor,
                                          borderRadius: BorderRadius.circular(10),
                                          boxShadow: [
                                            BoxShadow(
                                                color: Colors.grey.shade300,
                                                // offset: Offset(2, 2),
                                                blurRadius: 15)
                                          ]),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: AddSize.padding20,
                                        ),
                                        child: Obx(() {
                                          return Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              ListTile(
                                                onTap: () {
                                                  if (showSubTitle.value == index) {
                                                    showSubTitle.value = -1;
                                                  } else {
                                                    showSubTitle.value = index;
                                                  }
                                                },
                                                minLeadingWidth: 0,
                                                dense: true,
                                                contentPadding: EdgeInsets.zero,
                                                title: Text(
                                                  faqModel![index].question.toString(),
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .headline5!
                                                      .copyWith(fontWeight: FontWeight.w500, fontSize: AddSize.font16),
                                                ),
                                                trailing: Icon(
                                                  showSubTitle.value == index
                                                      ? Icons.keyboard_arrow_up_rounded
                                                      : Icons.keyboard_arrow_down_outlined,
                                                  size: AddSize.size25,
                                                  color: AppTheme.subText,
                                                ),
                                                subtitle: showSubTitle.value == index
                                                    ? Text(
                                                        faqModel![index].answer.toString(),
                                                      )
                                                    : null,
                                              ),
                                              SizedBox(height: AddSize.size10),
                                            ],
                                          );
                                        }),
                                      ),
                                    ),
                                  )))
                      : Padding(
                          padding: EdgeInsets.symmetric(horizontal: AddSize.padding20 * 3, vertical: AddSize.padding20),
                          child: Center(
                            child: Text("Data not Available",
                                style: Theme.of(context).textTheme.headline5!.copyWith(
                                    height: 1.5,
                                    fontWeight: FontWeight.w500,
                                    fontSize: AddSize.font14,
                                    color: AppTheme.blackcolor)),
                          ),
                        ):Center(child: CircularProgressIndicator()),
                ],
              )),
        ));
  }
}
