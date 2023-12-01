import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:resvago_customer/widget/common_text_field.dart';
import '../../model/model_store_timing.dart';
import '../../widget/apptheme.dart';

class RestaurantTimingScreenList extends StatefulWidget {
  const RestaurantTimingScreenList({super.key, required this.docId});
  final String docId;

  @override
  State<RestaurantTimingScreenList> createState() => _RestaurantTimingScreenListState();
}

class _RestaurantTimingScreenListState extends State<RestaurantTimingScreenList> {
  @override
  Widget build(BuildContext context) {
    print(widget.docId);
    return Scaffold(
      appBar: backAppBar(title: "Restaurant Open Time", context: context),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("week_schedules").doc(widget.docId).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.hasData && snapshot.data!.data() != null) {
            ModelStoreTime modelStoreTime = ModelStoreTime.fromJson(snapshot.data!.data()!);
            return Padding(
              padding: const EdgeInsets.all(12),
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                itemCount: modelStoreTime.schedule!.length,
                itemBuilder: (context, index) {
                  var daySchedule = modelStoreTime.schedule![index];
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Container(
                      decoration:
                          BoxDecoration(borderRadius: BorderRadius.circular(10), border: Border.all(color: AppTheme.greycolor)),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Theme(
                            data: ThemeData(
                                checkboxTheme:
                                    CheckboxThemeData(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)))),
                            child: Checkbox(
                              activeColor: AppTheme.primaryColor,
                              checkColor: Colors.white,
                              value: daySchedule.status,
                              onChanged: (value) {
                                daySchedule.status = value;
                                log(daySchedule.status.toString());
                                setState(() {});
                              },
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Text(
                              daySchedule.day.toString(),
                              style: GoogleFonts.poppins(color: Colors.grey.shade900, fontSize: 14, fontWeight: FontWeight.w400),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onTap: () {},
                              child: Row(
                                children: [
                                  Text(
                                    daySchedule.startTime.toString(),
                                    style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w500, fontSize: 15, color: Colors.grey.shade700),
                                  ),
                                  const Icon(Icons.keyboard_arrow_down_rounded)
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              "To",
                              style: GoogleFonts.poppins(color: Colors.grey.shade900, fontSize: 14, fontWeight: FontWeight.w400),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: GestureDetector(
                              onTap: () {},
                              child: Row(
                                children: [
                                  Text(
                                    daySchedule.endTime.toString(),
                                    style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w500, fontSize: 15, color: Colors.grey.shade700),
                                  ),
                                  const Icon(Icons.keyboard_arrow_down_rounded)
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          }
          return Text(
            "Open",
            style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w400, color: const Color(0xff3B5998)),
          );
        },
      ),
    );
  }
}
