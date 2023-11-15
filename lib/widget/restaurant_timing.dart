import 'dart:convert';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../model/coupon_modal.dart';
import '../model/model_store_timing.dart';
import '../model/review_model.dart';
import '../screen/single_store_screens/timimg_list.dart';
import 'appassets.dart';

class RestaurantTimingScreen extends StatefulWidget {
  const RestaurantTimingScreen({super.key, required this.docId});
  final String docId;

  @override
  State<RestaurantTimingScreen> createState() => _RestaurantTimingScreenState();
}

class _RestaurantTimingScreenState extends State<RestaurantTimingScreen> {
  @override
  Widget build(BuildContext context) {
    log(widget.docId);
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection("week_schedules").doc(widget.docId).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
        if (snapshot.hasData && snapshot.data!.data() != null) {
          ModelStoreTime modelStoreTime = ModelStoreTime.fromJson(snapshot.data!.data()!);
          Schedule? schedule;
          int index = modelStoreTime.schedule!
              .indexWhere((element) => element.day.toString() == DateFormat("EEE").format(DateTime.now()));
          if (index != -1) {
            schedule = modelStoreTime.schedule![index];
            return InkWell(
              onTap: () {
                Get.to(() => RestaurantTimingScreenList(docId: widget.docId));
              },
              child: Text(
                schedule.status == true ? "Open (${schedule.startTime} to ${schedule.endTime})" : "Closed",
                style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w400, color: const Color(0xff3B5998)),
              ),
            );
          }
        }
        return Text(
          "Open",
          style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w400, color: const Color(0xff3B5998)),
        );
      },
    );
  }
}

class MaxDiscountScreen extends StatefulWidget {
  const MaxDiscountScreen({super.key, required this.docId});
  final String docId;

  @override
  State<MaxDiscountScreen> createState() => _MaxDiscountScreenState();
}

class _MaxDiscountScreenState extends State<MaxDiscountScreen> {
  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print(widget.docId);
    }
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("Coupon_data")
          .where("userID", isEqualTo: widget.docId)
          .orderBy("maxDiscount", descending: true)
          .limit(1)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data == null) {
            return const SizedBox();
          }
          log(snapshot.data!.docs.map((e) => e.data()).toList().toString());
          if (snapshot.data!.docs.isEmpty) {
            return const SizedBox.shrink();
          }
          CouponData couponData = CouponData.fromMap(snapshot.data!.docs.first.data());
          return Row(
            children: [
              const SizedBox(width: 5),
              SvgPicture.asset(
                AppAssets.vector,
                height: 16,
              ),
              Text(
                "${couponData.discount}% Off",
                // schedule.status == true ? "Open (${schedule.startTime} to ${schedule.endTime})" : "Closed",
                style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w400, color: const Color(0xff3B5998)),
              ),
              const SizedBox(width: 5),
              Text(
                "Up To \$${couponData.maxDiscount}",
                // schedule.status == true ? "Open (${schedule.startTime} to ${schedule.endTime})" : "Closed",
                style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w400, color: const Color(0xff3B5998)),
              ),
            ],
          );
        }
        return const SizedBox();
      },
    );
  }
}

class MaxRatingScreen extends StatefulWidget {
  const MaxRatingScreen({super.key, required this.docId});
  final String docId;

  @override
  State<MaxRatingScreen> createState() => _MaxRatingScreenState();
}

class _MaxRatingScreenState extends State<MaxRatingScreen> {
  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print("ffgghdfh${widget.docId}");
    }
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("Review")
          .where("vendorID", isEqualTo: widget.docId)
          // .orderBy("fullRating", descending: true)
          .limit(1)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data == null) {
            return const SizedBox();
          }
          if (snapshot.data!.docs.isNotEmpty) {
            ReviewModel reviewData = ReviewModel.fromJson(snapshot.data!.docs.first.data());
            log(snapshot.data!.docs.first.data().toString());
            return Row(
              children: [
                const SizedBox(width: 5),
                const Icon(Icons.star_rounded, color: Colors.amber, size: 20),
                const SizedBox(width: 2),
                Text(
                  "${reviewData.fullRating}",
                  style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w400, color: const Color(0xff3B5998)),
                ),
              ],
            );
          } else {
            return Row(
              children: [
                const Icon(
                  Icons.star_rounded,
                  color: Colors.amber,
                  size: 20,
                ),
                Text(
                  "0.0",
                  style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w400, color: const Color(0xff3B5998)),
                ),
              ],
            );
          }
        }
        return Row(
          children: [
            const Icon(
              Icons.star_rounded,
              color: Colors.amber,
              size: 20,
            ),
            Text(
              "0.0",
              style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w400, color: const Color(0xff3B5998)),
            ),
          ],
        );
      },
    );
  }
}
