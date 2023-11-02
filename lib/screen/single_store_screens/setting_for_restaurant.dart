import 'dart:convert';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:resvago_customer/screen/single_store_screens/timimg_list.dart';
import '../../model/model_store_timing.dart';
import '../../model/setting_model.dart';


class SettingDataScreen extends StatefulWidget {
  const SettingDataScreen({super.key, required this.docId});
  final String docId;

  @override
  State<SettingDataScreen> createState() => _SettingDataScreenState();
}
class _SettingDataScreenState extends State<SettingDataScreen> {

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection("Vendor_Setting").doc(widget.docId).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
        if(snapshot.hasData && snapshot.data!.data() != null){
          SettingModel settingData = SettingModel.fromJson(snapshot.data!.data()!);
            return InkWell(
              onTap: (){
                Get.to(()=>RestaurantTimingScreenList(docId: widget.docId));
              },
              child: Text(
              "Average Price \$${settingData.averageMealForMember.toString()}",
                style: GoogleFonts.poppins(
                    fontSize: 12, fontWeight: FontWeight.w300, color: const Color(0xff384953)),
              ),
            );
          }
        return Text(
          "Average Price",
          style: GoogleFonts.poppins(
              fontSize: 12, fontWeight: FontWeight.w300, color: const Color(0xff384953)),
        );
      },
    );
  }
}
