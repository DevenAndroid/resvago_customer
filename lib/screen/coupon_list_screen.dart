import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../model/coupon_modal.dart';
import '../widget/addsize.dart';
import '../widget/common_text_field.dart';

class PromoCodeList extends StatefulWidget {
  const PromoCodeList({super.key, required this.id, required this.couponData});
  final String id;
  final Function(CouponData couponData) couponData;
  @override
  State<PromoCodeList> createState() => _PromoCodeListState();
}

class _PromoCodeListState extends State<PromoCodeList> {
  var selectedItem = '';
  String searchQuery = '';
  String get id => widget.id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: backAppBar(
          title: "Promo code List".tr,
          context: context,
        ),
        body: SingleChildScrollView(
            child: Column(children: [
          const SizedBox(
            height: 10,
          ),
          StreamBuilder<List<CouponData>>(
            stream: getCouponStream(widget.id),
            builder: (BuildContext context, AsyncSnapshot<List<CouponData>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text("Error: ${snapshot.error}"));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return  Center(child: Text("No Coupon Found".tr));
              } else {
                List<CouponData>? users = snapshot.data;
                final filteredUsers = filterUsers(users!, searchQuery);
                return filteredUsers.isNotEmpty
                    ? ListView.builder(
                        padding: EdgeInsets.zero,
                        scrollDirection: Axis.vertical,
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: filteredUsers.length,
                        itemBuilder: (context, int index) {
                          final item = filteredUsers[index];
                          return GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () {
                              widget.couponData(item);
                              Get.back();
                            },
                            child: Stack(children: [
                              Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Container(
                                      width: AddSize.screenWidth,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.shade200,
                                            blurRadius: 10,
                                          ),
                                        ],
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 28, top: 7),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const SizedBox(
                                              height: 12,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(right: 8.0),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  RichText(
                                                    overflow: TextOverflow.clip,
                                                    textAlign: TextAlign.end,
                                                    textDirection: TextDirection.rtl,
                                                    softWrap: true,
                                                    maxLines: 1,
                                                    textScaleFactor: 1,
                                                    text: TextSpan(
                                                      text: item.promoCodeName.toString(),
                                                      style: DefaultTextStyle.of(context).style,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            // const SizedBox(height: 0,),
                                            Text(
                                              item.code.toString(),
                                              style: GoogleFonts.poppins(
                                                  color: const Color(0xFFFAAF40), fontWeight: FontWeight.w300, fontSize: 14),
                                            ),
                                            const SizedBox(
                                              height: 30,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(left: 2.0, right: 25),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(
                                                    "Discount".tr,
                                                    style: GoogleFonts.poppins(
                                                        color: const Color(0xFF304048),
                                                        fontWeight: FontWeight.w400,
                                                        fontSize: 16),
                                                  ),
                                                  Text(
                                                    "\$${item.discount.toString()}",
                                                    style: GoogleFonts.poppins(
                                                        color: Colors.grey, fontWeight: FontWeight.w300, fontSize: 14),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 6,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(left: 2.0, right: 25),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(
                                                    item.startDate.toString(),
                                                    style: GoogleFonts.poppins(
                                                        color: Colors.grey, fontWeight: FontWeight.w400, fontSize: 16),
                                                  ),
                                                  Text(
                                                    "To".tr,
                                                    style: GoogleFonts.poppins(
                                                        color: Colors.grey, fontWeight: FontWeight.w400, fontSize: 16),
                                                  ),
                                                  Text(
                                                    item.endDate.toString(),
                                                    style: GoogleFonts.poppins(
                                                        color: Colors.grey, fontWeight: FontWeight.w300, fontSize: 14),
                                                  ),
                                                ],
                                              ),
                                            ),

                                            const SizedBox(
                                              height: 20,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Positioned(
                                  top: 70,
                                  left: -10,
                                  right: -10,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      CircleAvatar(
                                        radius: 15,
                                        backgroundColor: Colors.grey[100],
                                      ),
                                      //Image.asset('assets/images/abc.png',height: 30,width: 30,),
                                      Expanded(
                                        child: FittedBox(
                                          child: Row(
                                            children: List.generate(
                                                25,
                                                (index) => Padding(
                                                      padding: const EdgeInsets.only(left: 2, right: 2),
                                                      child: Container(
                                                        color: Colors.grey[200],
                                                        height: 2,
                                                        width: 10,
                                                      ),
                                                    )),
                                          ),
                                        ),
                                      ),
                                      CircleAvatar(
                                        radius: 15,
                                        backgroundColor: Colors.grey[100],
                                      ),
                                    ],
                                  )),
                            ]),
                          );
                        })
                    :  Center(
                        child: Text("No Coupon Found".tr),
                      );
              }
            },
          )
        ])));
  }

  List<CouponData> filterUsers(List<CouponData> users, String query) {
    if (query.isEmpty) {
      return users; // Return all users if the search query is empty
    } else {
      // Filter the users based on the search query
      return users.where((user) {
        if (user.promoCodeName is String) {
          return user.promoCodeName.toLowerCase().contains(query.toLowerCase());
        }
        return false;
      }).toList();
    }
  }

  Stream<List<CouponData>> getCouponStream(id) {
    return FirebaseFirestore.instance
        .collection('Coupon_data')
        .where("deactivate", isEqualTo: false)
        .where("userID", isEqualTo: id)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => CouponData(
                  code: doc.data()['code'],
                  discount: doc.data()['discount'],
                  docid: doc.id,
                  deactivate: doc.data()['deactivate'],
                  promoCodeName: doc.data()['promoCodeName'],
                  startDate: doc.data()['startDate'],
                  maxDiscount: doc.data()['maxDiscount'],
                  endDate: doc.data()['endDate'],
                ))
            .toList());
  }
}
