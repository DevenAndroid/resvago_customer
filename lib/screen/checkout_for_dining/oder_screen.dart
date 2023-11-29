import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paypal/flutter_paypal.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:resvago_customer/screen/delivery_screen/thank__you_screen.dart';
import 'package:resvago_customer/widget/apptheme.dart';
import '../../firebase_service/firebase_service.dart';
import '../../model/coupon_modal.dart';
import '../../model/menu_model.dart';
import '../../model/profile_model.dart';
import '../../model/resturant_model.dart';
import '../../widget/common_text_field.dart';
import '../coupon_list_screen.dart';
import '../helper.dart';
import 'dart:math' as math;

class OderScreen extends StatefulWidget {
  OderScreen(
      {super.key,
      this.restaurantItem,
      this.menuList,
      this.guest,
      this.slot,
      required this.date,
      this.discountValue,
      required this.lunchSelected});
  final RestaurantModel? restaurantItem;
  final List<MenuData>? menuList;
  DateTime date;
  int? guest;
  String? slot;
  final bool lunchSelected;
  dynamic discountValue;
  @override
  State<OderScreen> createState() => _OderScreenState();
}

class _OderScreenState extends State<OderScreen> {
  RestaurantModel? get restaurantData => widget.restaurantItem;
  List<MenuData>? get menuListData => widget.menuList;
  CouponData? couponData;
  var totalPrice = 0.0;
  double getTotalPrice() {
    totalPrice = 0;
    for (int i = 0; i < menuListData!.length; i++) {
      totalPrice = totalPrice + double.parse(menuListData![i].qty.toString()) * double.parse(menuListData![i].price);
      log(totalPrice.toString());
    }
    return totalPrice;
  }

  FirebaseService firebaseService = FirebaseService();
  ProfileData? profileData;
  void fetchdata() {
    FirebaseFirestore.instance.collection("customer_users").doc(FirebaseAuth.instance.currentUser!.uid).get().then((value) {
      if (value.exists) {
        if (value.data() == null) return;
        profileData = ProfileData.fromJson(value.data()!);
        setState(() {});
      }
    });
  }

  List<Map<String, dynamic>> extractedData = [];
  getCheckOutData() {
    extractedData.clear();
    log("rydhfdgh" + menuListData!.where((e) => e.qty > 0).map((e) => e.toMap()).toList().toString());
    extractedData = menuListData!.where((e) => e.qty > 0).map((e) => e.toMap()).toList().map((item) {
      return {
        "name": item["dishName"],
        "quantity": item["qty"],
        "price": double.parse(item["price"]).toStringAsFixed(2).toString(),
        "currency": "USD"
      };
    }).toList();
    if (couponData != null) {
      extractedData.add({
        "name": "discount",
        "quantity": "1",
        "price": (-math.min(discountAmount, couponData!.maximumDiscountAmount)).toStringAsFixed(2),
        "currency": "USD"
      });
    }
    // extractedData = menuListData!.where((e) => e.qty > 0).map((e) => e.toMap()).toList().map((item) {
    //   return {"name": item["dishName"], "quantity": item["qty"], "price": double.parse(item["price"]).toStringAsFixed(2), "currency": "USD"};
    // }).toList();
    log("dhfgdhgfh" + extractedData.toString());
    setState(() {});
  }

  Future<int> order(String vendorId) async {
    OverlayEntry loader = Helper.overlayLoader(context);
    Overlay.of(context).insert(loader);
    // String? fcm = await FirebaseMessaging.instance.getToken();
    int gg = DateTime.now().millisecondsSinceEpoch;
    try {
      await firebaseService
          .manageOrderForDining(
              orderId: gg.toString(),
              lunchSelected: widget.lunchSelected,
              menuList: menuListData!.where((e) => e.qty > 0).map((e) => e.toMap()).toList(),
              restaurantInfo: restaurantData!.toJson(),
              profileData: profileData!.toJson(),
              vendorId: vendorId,
              time: gg,
              fcm: "fcm",
              slot: widget.slot,
              guest: widget.guest,
              date: widget.date,
              total: calculateTotalPrice.toString())
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

  double get discountAmount => totalPrice * couponData!.maximumDiscount;

  double get calculateTotalPrice => getTotalPrice() > 0
      ? (getTotalPrice() - (couponData == null ? 0 : math.min(discountAmount, couponData!.maximumDiscountAmount)))
      : 0;

  double get couponDiscount => (couponData == null ? 0 : math.min(discountAmount, couponData!.maximumDiscountAmount));
  @override
  void initState() {
    super.initState();
    getTotalPrice();
    fetchdata();
    getCheckOutData();
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
                              SizedBox(
                                height: 60,
                                width: 80,
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: CachedNetworkImage(
                                      imageUrl: restaurantData!.image,
                                      fit: BoxFit.cover,
                                      errorWidget: (_, __, ___) => Icon(
                                        Icons.error,
                                        color: Colors.red,
                                      ),
                                    )),
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
                                "Slot Time",
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
                                                  "\$${menuListItem.price}",
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
                                                        getCheckOutData();
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
                                                        getCheckOutData();
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
                // Padding(
                //     padding: const EdgeInsets.all(8.0),
                //     child: Container(
                //       width: size.width,
                //       padding: const EdgeInsets.all(14),
                //       decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), boxShadow: [
                //         BoxShadow(
                //           color: const Color(0xFF37C666).withOpacity(0.10),
                //           offset: const Offset(
                //             1,
                //             1,
                //           ),
                //           blurRadius: 20.0,
                //           spreadRadius: 1.0,
                //         ),
                //       ]),
                //       child: Row(
                //           mainAxisAlignment: MainAxisAlignment.start,
                //           crossAxisAlignment: CrossAxisAlignment.start,
                //           children: [
                //             Image.asset(
                //               'assets/icons/discount.png',
                //               height: 20,
                //             ),
                //             const SizedBox(
                //               width: 13,
                //             ),
                //             Text(
                //               ' Your Offer',
                //               style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500, color: AppTheme.primaryColor),
                //             ),
                //             const Spacer(),
                //             Text(
                //               'Applied',
                //               style:
                //                   GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w500, color: const Color(0xff34AD00)),
                //             ),
                //           ]),
                //     )),

                InkWell(
                  onTap: () {
                    Get.to(() => PromoCodeList(
                          id: restaurantData!.userID,
                          couponData: (CouponData coupon) {
                            couponData = coupon;
                            setState(() {});
                          },
                        ));
                  },
                  child: Container(
                    width: size.width,
                    margin: const EdgeInsets.all(8),
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
                        Row(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Image.asset(
                            'assets/icons/coupon.png',
                            height: 20,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            'Use Coupons',
                            style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w500, color: const Color(0xff293044)),
                          ),
                        ]),
                        if (couponData != null)
                          Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.asset(
                                  'assets/icons/verified.png',
                                  height: 20,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${couponData!.code} Applied Successfully',
                                      style: GoogleFonts.poppins(fontSize: 14, color: const Color(0xff1E2538).withOpacity(.8)),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      'You saved \$${couponDiscount.toStringAsFixed(2)}',
                                      style: GoogleFonts.poppins(fontSize: 12, color: AppTheme.primaryColor),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    )
                                  ],
                                ),
                              ]),
                      ],
                    ),
                  ),
                ),
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
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  ' Subtotal',
                                  style: GoogleFonts.poppins(
                                      fontSize: 14, fontWeight: FontWeight.w400, color: const Color(0xff1E2538)),
                                ),
                                Text(
                                  '\$${totalPrice.toStringAsFixed(2)}',
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
                                  'Save Coupon',
                                  style: GoogleFonts.poppins(
                                      fontSize: 14, fontWeight: FontWeight.w400, color: const Color(0xff1E2538)),
                                ),
                                Text(
                                  "\$${couponDiscount.toStringAsFixed(2)}",
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
                                  '\$${calculateTotalPrice.toStringAsFixed(2)}',
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
                          print([
                            {
                              "amount": {
                                "total": calculateTotalPrice.toStringAsFixed(2).toString(),
                                "currency": "USD",
                                "details": {
                                  "subtotal": calculateTotalPrice.toStringAsFixed(2).toString(),
                                  "shipping": '0',
                                  "shipping_discount": 0
                                }
                              },
                              "description": "The payment transaction description.",
                              // "payment_options": {
                              //   "allowed_payment_method":
                              //       "INSTANT_FUNDING_SOURCE"
                              // },
                              "item_list": {
                                "items": extractedData,
                              },
                              // shipping address is not required though
                              // "shipping_address": {
                              //   "recipient_name": "Jane Foster",
                              //   "line1": "Travis County",
                              //   "line2": "",
                              //   "city": "Austin",
                              //   "country_code": "US",
                              //   "phone": "+00000000",
                              //   "state": "Texas"
                              // },
                            }
                          ]);
                          // return;
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (BuildContext context) => UsePaypal(
                                  sandboxMode: true,
                                  clientId: "AXzzNizO268LtEWEhlORqtjSut6XpJerxfosziugQke9gzo9P8HJSajCF9e2r7Xp1WZ68Ab68TkMmuxF",
                                  secretKey: "EOM7dx9y1e-EbyVNxKaEEAgHMTZJ-GUpO9e4CzfrfI0zu-emIZdszR-8hX22H-gt8FPzV7nc5yzX3BT5",
                                  returnURL: "https://samplesite.com/return",
                                  cancelURL: "https://samplesite.com/cancel",
                                  transactions: [
                                    {
                                      "amount": {
                                        "total": calculateTotalPrice.toString(),
                                        "currency": "USD",
                                        "details": {
                                          "subtotal": calculateTotalPrice.toString(),
                                          "shipping": '0',
                                          "shipping_discount": 0
                                        }
                                      },
                                      "description": "The payment transaction description.",
                                      // "payment_options": {
                                      //   "allowed_payment_method":
                                      //       "INSTANT_FUNDING_SOURCE"
                                      // },
                                      "item_list": {
                                        "items": extractedData,
                                      },
                                      // shipping address is not required though
                                      // "shipping_address": {
                                      //   "recipient_name": "Jane Foster",
                                      //   "line1": "Travis County",
                                      //   "line2": "",
                                      //   "city": "Austin",
                                      //   "country_code": "US",
                                      //   "phone": "+00000000",
                                      //   "state": "Texas"
                                      // },
                                    }
                                  ],
                                  note: "Contact us for any questions on your order.",
                                  onSuccess: (Map params) async {
                                    print("onSuccess: ${params}");
                                    order(restaurantData!.docid).then((value) {
                                      FirebaseFirestore.instance
                                          .collection("checkOut")
                                          .doc(FirebaseAuth.instance.currentUser!.uid)
                                          .delete();
                                      Get.offAll(ThankuScreen(
                                        date: widget.date.toString(),
                                        guestNo: widget.guest,
                                        orderType: "Dining",
                                        orderId: value.toString(),
                                      ));
                                    });
                                  },
                                  onError: (error) {
                                    print("onError: $error");
                                  },
                                  onCancel: (params) {
                                    print('cancelled: $params');
                                  }),
                            ),
                          );
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
              ]).appPaddingForScreen)
            : const Center(child: CircularProgressIndicator()));
  }
}
