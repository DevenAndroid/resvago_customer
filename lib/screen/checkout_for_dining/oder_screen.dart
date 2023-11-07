import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:resvago_customer/widget/apptheme.dart';
import '../../firebase_service/firebase_service.dart';
import '../../model/menu_model.dart';
import '../../model/resturant_model.dart';
import '../../routers/routers.dart';
import '../../widget/appassets.dart';
import '../../widget/common_text_field.dart';
import '../helper.dart';

class OderScreen extends StatefulWidget {
  OderScreen({super.key, this.restaurantItem, this.menuList, this.guest, this.slot, required this.date, this.discountValue});
  final RestaurantModel? restaurantItem;
  final List<MenuData>? menuList;
  DateTime date;
  int? guest;
  String? slot;
  dynamic discountValue;
  @override
  State<OderScreen> createState() => _OderScreenState();
}

class _OderScreenState extends State<OderScreen> {
  RestaurantModel? get restaurantData => widget.restaurantItem;
  List<MenuData>? get menuListData => widget.menuList;

  var totalPrice = 0.0;
  getTotalPrice() {
    totalPrice = 0;
    for (int i = 0; i < menuListData!.length; i++) {
      totalPrice = totalPrice + double.parse(menuListData![i].qty.toString()) * double.parse(menuListData![i].price);
      log(totalPrice.toString());
      setState(() {});
    }
  }

  FirebaseService firebaseService = FirebaseService();
  Future<int> order(String vendorId) async {
    String? fcm = await FirebaseMessaging.instance.getToken();
    OverlayEntry loader = Helper.overlayLoader(context);
    Overlay.of(context).insert(loader);
    int gg = DateTime.now().millisecondsSinceEpoch;
    try {
      await firebaseService
          .manageOrderForDining(
        orderId: gg.toString(),
        menuList: menuListData!.where((e) => e.qty > 0).map((e) => e.toMap()).toList(),
        restaurantInfo: restaurantData!.toJson(),
        vendorId: vendorId,
        time: gg,
        fcm: fcm,
        slot: widget.slot,
        guest: widget.guest,
        date: widget.date,
        total: totalPrice
      )
          .then((value) {
        Helper.hideLoader(loader);
        return gg;
      });
      return gg;
    } catch (e) {
      Helper.hideLoader(loader);
      throw Exception(e);
    }
  }

  @override
  void initState() {
    super.initState();
    getTotalPrice();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    log(restaurantData!.toJson().toString());
    log(menuListData!.toString());
    return Scaffold(
        appBar: backAppBar(
          title: "CheckOut",
          context: context,
        ),
        body: restaurantData != null && menuListData != null
            ? SingleChildScrollView(
                child: Column(children: [
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: size.width,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Restaurant",
                            style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500, color: const Color(0xFF1E2538)),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Row(
                            // mainAxisAlignment: MainAxisAlignment.start,
                            // crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  restaurantData!.image ?? "",
                                  height: 60,
                                  width: 80,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 15),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        restaurantData!.restaurantName ?? "",
                                        style: GoogleFonts.poppins(
                                            fontSize: 16, fontWeight: FontWeight.w500, color: const Color(0xFF1E2538)),
                                      ),
                                      const SizedBox(
                                        height: 3,
                                      ),
                                      Text(
                                        restaurantData!.aboutUs ?? "",
                                        maxLines: 3,
                                        style: GoogleFonts.poppins(
                                            fontSize: 10, fontWeight: FontWeight.w300, color: const Color(0xFF384953)),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              // const Spacer(),
                              // Column(
                              //   crossAxisAlignment: CrossAxisAlignment.center,
                              //   mainAxisAlignment: MainAxisAlignment.center,
                              //   children: [
                              //     Image.asset(
                              //       "assets/icons/edit.png",
                              //       height: 23,
                              //     ),
                              //   ],
                              // )
                            ],
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Divider(
                            color: const Color(0xFF698EDE).withOpacity(.1),
                            thickness: 2,
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Reservation",
                                style: GoogleFonts.poppins(
                                    fontSize: 16, fontWeight: FontWeight.w500, color: const Color(0xFF1E2538)),
                              ),
                              // Image.asset(
                              //   "assets/icons/edit.png",
                              //   height: 23,
                              // ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Date:",
                                style: GoogleFonts.poppins(
                                    fontSize: 16, fontWeight: FontWeight.w500, color: const Color(0xFF1E2538)),
                              ),
                              Text(
                                DateFormat("dd-MMM-yyyy").format(DateTime.parse(widget.date.toString())),
                                style: GoogleFonts.poppins(fontSize: 13, color: const Color(0xFF1E2538)),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          const DottedLine(
                            dashColor: Color(0xffBCBCBC),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Dinner:",
                                style: GoogleFonts.poppins(
                                    fontSize: 16, fontWeight: FontWeight.w500, color: const Color(0xFF1E2538)),
                              ),
                              Text(
                                widget.slot.toString(),
                                style: GoogleFonts.poppins(fontSize: 13, color: const Color(0xFF1E2538)),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          const DottedLine(
                            dashColor: Color(0xffBCBCBC),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Guest:",
                                style: GoogleFonts.poppins(
                                    fontSize: 16, fontWeight: FontWeight.w500, color: const Color(0xFF1E2538)),
                              ),
                              Text(
                                widget.guest.toString(),
                                style: GoogleFonts.poppins(fontSize: 13, color: const Color(0xFF1E2538)),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    )),
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                        width: size.width,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF37C666).withOpacity(0.10),
                            offset: const Offset(
                              1,
                              1,
                            ),
                            blurRadius: 20.0,
                            spreadRadius: 1.0,
                          ),
                        ]),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Selected Items",
                                style: GoogleFonts.poppins(
                                    fontSize: 16, fontWeight: FontWeight.w500, color: const Color(0xFF1E2538)),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: menuListData!.length,
                                  itemBuilder: (context, index) {
                                    var menuListItem = menuListData![index];
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 5),
                                      child: Column(children: [
                                        Row(children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(10),
                                            child: Image.network(
                                              menuListItem.image ?? "",
                                              height: 60,
                                              width: 80,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(left: 15),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  menuListItem.dishName ?? "",
                                                  style: GoogleFonts.poppins(
                                                      fontSize: 14, fontWeight: FontWeight.w400, color: const Color(0xFF1E2538)),
                                                ),
                                                const SizedBox(
                                                  height: 3,
                                                ),
                                                Text(
                                                  "\$${menuListItem.price ?? ""}",
                                                  style: GoogleFonts.poppins(fontSize: 14, color: const Color(0xFF74848C)),
                                                ),

                                                // DottedLine(
                                                //   dashColor: Colors.black,
                                                // )
                                              ],
                                            ),
                                          ),
                                          const Spacer(),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                height: 28,
                                                width: 28,
                                                decoration: BoxDecoration(
                                                    border: Border.all(color: Colors.black),
                                                    borderRadius: const BorderRadius.all(
                                                      Radius.circular(20),
                                                    )),
                                                child: InkWell(
                                                    onTap: () {
                                                      if (menuListItem.qty == 1) {
                                                        null;
                                                      } else {
                                                        menuListItem.qty--;
                                                        getTotalPrice();
                                                      }
                                                      setState(() {});
                                                    },
                                                    child: const Icon(
                                                      Icons.remove,
                                                      size: 18,
                                                    )),
                                              ),
                                              const SizedBox(
                                                width: 8,
                                              ),
                                              Text(
                                                menuListItem.qty.toString(),
                                                style: GoogleFonts.alegreyaSans(
                                                  fontSize: 16,
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 8,
                                              ),
                                              Row(
                                                children: [
                                                  Container(
                                                    height: 28,
                                                    width: 28,
                                                    decoration: const BoxDecoration(
                                                        color: AppTheme.primaryColor,
                                                        borderRadius: BorderRadius.all(
                                                          Radius.circular(20),
                                                        )),
                                                    child: InkWell(
                                                      onTap: () {
                                                        menuListItem.qty++;
                                                        getTotalPrice();
                                                        setState(() {});
                                                      },
                                                      child: const Icon(
                                                        Icons.add,
                                                        color: Colors.white,
                                                        size: 18,
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              )
                                            ],
                                          ),
                                        ])
                                      ]),
                                    );
                                  }),
                            ]))),
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: size.width,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF37C666).withOpacity(0.10),
                          offset: const Offset(
                            1,
                            1,
                          ),
                          blurRadius: 20.0,
                          spreadRadius: 1.0,
                        ),
                      ]),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.asset(
                              'assets/icons/discount.png',
                              height: 20,
                            ),
                            const SizedBox(
                              width: 13,
                            ),
                            Text(
                              ' Your Offer',
                              style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500, color: AppTheme.primaryColor),
                            ),
                            const Spacer(),
                            Text(
                              'Applied',
                              style:
                                  GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w500, color: const Color(0xff34AD00)),
                            ),
                          ]),
                    )),
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: size.width,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF37C666).withOpacity(0.10),
                          offset: const Offset(
                            1,
                            1,
                          ),
                          blurRadius: 20.0,
                          spreadRadius: 1.0,
                        ),
                      ]),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Payable Amount",
                              style:
                                  GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500, color: const Color(0xFF1E2538)),
                            ),
                            const SizedBox(
                              height: 18,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Booking  Fee',
                                  style: GoogleFonts.poppins(
                                      fontSize: 14, fontWeight: FontWeight.w400, color: const Color(0xff1E2538)),
                                ),
                                Text(
                                  '\$10.00',
                                  style: GoogleFonts.poppins(fontSize: 14, color: const Color(0xff1E2538)),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Salad Veggie x 2',
                                  style: GoogleFonts.poppins(
                                      fontSize: 14, fontWeight: FontWeight.w400, color: const Color(0xff1E2538)),
                                ),
                                Text(
                                  '\$20.00',
                                  style: GoogleFonts.poppins(fontSize: 14, color: const Color(0xff1E2538)),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Total',
                                  style: GoogleFonts.poppins(
                                      fontSize: 14, fontWeight: FontWeight.w400, color: const Color(0xff1E2538)),
                                ),
                                Text(
                                  '\$$totalPrice',
                                  style: GoogleFonts.poppins(fontSize: 14, color: const Color(0xff1E2538)),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                          ]),
                    )),
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                        width: size.width,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF37C666).withOpacity(0.10),
                            offset: const Offset(
                              1,
                              1,
                            ),
                            blurRadius: 20.0,
                            spreadRadius: 1.0,
                          ),
                        ]),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  "Payment Method",
                                  style: GoogleFonts.poppins(
                                      fontSize: 16, fontWeight: FontWeight.w500, color: const Color(0xFF1E2538)),
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                const SizedBox(
                                  height: 12,
                                ),
                                Container(
                                  height: 23,
                                  width: 23,
                                  decoration: const BoxDecoration(
                                      color: Color(0xffFAAF40),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(20),
                                      )),
                                  child: const Icon(
                                    Icons.add,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 14,
                            ),
                            Container(
                              width: size.width,
                              decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                                  border: Border.all(color: const Color(0xff3B5998).withOpacity(.3))),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                                child: Row(
                                  children: [
                                    Image.asset(
                                      "assets/icons/debvitcard.png",
                                      height: 20,
                                    ),
                                    const SizedBox(
                                      width: 18,
                                    ),
                                    Text(
                                      'Debit/Credit Card',
                                      style: GoogleFonts.poppins(
                                          fontSize: 14, fontWeight: FontWeight.w400, color: const Color(0xFF1E2538)),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            Container(
                              width: size.width,
                              decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                                  border: Border.all(color: const Color(0xff3B5998).withOpacity(.3))),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                                child: Row(
                                  children: [
                                    Image.asset(
                                      "assets/icons/phonepay.png",
                                      height: 20,
                                    ),
                                    const SizedBox(
                                      width: 18,
                                    ),
                                    Text(
                                      'PayPay',
                                      style: GoogleFonts.poppins(
                                          fontSize: 14, fontWeight: FontWeight.w400, color: const Color(0xFF1E2538)),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                          ],
                        ))),
                Container(
                    margin: const EdgeInsets.only(top: 20),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: SizedBox(
                      width: size.width,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          order(restaurantData!.docid).then((value) {
                            FirebaseFirestore.instance
                                .collection("checkOut")
                                .doc(FirebaseAuth.instance.currentUser!.phoneNumber)
                                .delete();
                            Get.offAllNamed(MyRouters.thankYouScreen, arguments: [DateTime.fromMillisecondsSinceEpoch(value)]);
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: const BorderSide(
                              width: 2.0,
                              color: Color(0xFF3B5998),
                            ),
                          ),
                          textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                        child: Text(
                          "Place Order",
                          style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white),
                        ),
                      ),
                    )),
                const SizedBox(
                  height: 100,
                )
              ]))
            : const Center(child: CircularProgressIndicator()));
  }
}
