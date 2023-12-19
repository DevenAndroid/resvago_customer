import 'dart:convert';
import 'dart:developer';
import 'dart:math' as math;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paypal/flutter_paypal.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:resvago_customer/model/profile_model.dart';
import 'package:resvago_customer/screen/delivery_screen/thank__you_screen.dart';
import 'package:resvago_customer/screen/myAddressList.dart';
import 'package:uni_links/uni_links.dart';
import 'package:url_launcher/url_launcher.dart';
// import 'package:youcanpay_sdk/youcanpay_sdk.dart';
import '../../controller/bottomnavbar_controller.dart';
import '../../firebase_service/firebase_service.dart';
import '../../model/add_address_modal.dart';
import '../../model/checkout_model.dart';
import '../../model/coupon_modal.dart';
import '../../model/resturant_model.dart';
import '../../widget/apptheme.dart';
import '../../widget/common_text_field.dart';
import '../bottomnav_bar.dart';
import '../coupon_list_screen.dart';
import '../helper.dart';
import '../paypal_services/payment.dart';
import '../paypal_services/paypal.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final bottomController = Get.put(BottomNavBarController());
  String token = "token";
  String publicKey = "pubKey";
  // late YCPay ycPay;
  // late CardInformation cardInformation;
  CheckOutModel cartModel = CheckOutModel();
  List<Map<String, dynamic>> extractedData = [];

  final PayPalService payPalService = PayPalService(
    clientId: "Ab5v6E4R-gNbD13BbcdgpzK0G66oJ8ij1Va8i85qzGTtgA4TXkmt2h4oRpCXGRTBQs8Fn1SMqgyVkQ19",
    secret: "ELCzlUANZYqBS27CGrYqP3RNyoob11TbOj_J4kYp6QULFkDWh9veSi_zkpQoe8nu-VS3FN8XJf-o5WJx",
    // clientId: "AYBmWmZ1iXnGwAqSsmGdqTZFeJ6RYu-rBjGWFLnuX-kDfvLqa8qp75RPCzhaetorPoFrxqZJu0cPccd_",
    // secret: "EJIKzLSexzl_2VKzn9aoNa_J6tpdDFzz4zgm2xAPxw3WWZvkInjPW8wGVlRk-zvz5QhFiCbPrJrtBy8H",
  );

  getCheckOutData() {
    extractedData.clear();
    FirebaseFirestore.instance.collection("checkOut").doc(FirebaseAuth.instance.currentUser!.uid).get().then((value) {
      log("checkOut${jsonEncode(value.data())}");
      cartModel = CheckOutModel.fromJson(value.data() ?? {});
      log("checkOut${cartModel.toJson()}");
      log(cartModel.menuList!.map((e) => e.toJson()).toList().toString());
      extractedData = cartModel.menuList!.map((e) => e.toJson()).toList().map((item) {
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
      log(extractedData.toString());
      setState(() {});
    });
  }

  Future updateFirebaseValues() async {
    await FirebaseFirestore.instance
        .collection("checkOut")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({"menuList": cartModel.menuList!.map((e) => e.toJson()).toList()});
  }

  Future updateVendor(int count, vendorId) async {
    await FirebaseFirestore.instance.collection("vendor_users").doc(vendorId).update({"order_count": ++count});
  }

  var totalPrice = 0.0;
  double getTotalPrice() {
    if (cartModel.menuList == null) return 0;
    totalPrice = 0;
    for (int i = 0; i < cartModel.menuList!.length; i++) {
      totalPrice = totalPrice + double.parse(cartModel.menuList![i].qty.toString()) * double.parse(cartModel.menuList![i].price);
      log(totalPrice.toString());
    }
    return totalPrice;
  }

  double get discountAmount => totalPrice * couponData!.maximumDiscount;

  double get calculateTotalPrice => getTotalPrice() > 0
      ? (getTotalPrice() - (couponData == null ? 0 : math.min(discountAmount, couponData!.maximumDiscountAmount)))
      : 0;

  double get couponDiscount => (couponData == null ? 0 : math.min(discountAmount, couponData!.maximumDiscountAmount));

  @override
  void initState() {
    super.initState();
    getCheckOutData();
    getTotalPrice();
    fetchdata();
    // initYCPay();
    // initCardInformation();
  }

  CouponData? couponData;
  AddressModel? addressData;
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

  FirebaseService firebaseService = FirebaseService();
  Future<int> order(String vendorId) async {
    OverlayEntry loader = Helper.overlayLoader(context);
    Overlay.of(context).insert(loader);
    // String? fcm = await FirebaseMessaging.instance.getToken();
    int gg = DateTime.now().millisecondsSinceEpoch;
    try {
      await firebaseService
          .manageOrder(
              profileData: profileData!.toJson(),
              orderId: gg.toString(),
              restaurantInfo: cartModel.toJson(),
              vendorId: vendorId,
              time: gg,
              address: addressData!.flatAddress + ", " + addressData!.streetAddress ?? "",
              couponDiscount: couponDiscount,
              fcm: "fcm",
              total: totalPrice)
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

  Future<void> _launchUrl(url) async {
    final Uri _url = Uri.parse(url);
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: backAppBar(
          title: "CheckOut",
          context: context,
        ),
        body: cartModel.menuList != null && cartModel.menuList!.isNotEmpty
            ? SingleChildScrollView(
                child: Column(children: [
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
                              if (cartModel.menuList != null)
                                ListView.builder(
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemCount: cartModel.menuList!.length,
                                    itemBuilder: (context, index) {
                                      var item = cartModel.menuList![index];
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 5),
                                        child: Column(children: [
                                          Row(children: [
                                            SizedBox(
                                              height: 60,
                                              width: 80,
                                              child: ClipRRect(
                                                  borderRadius: BorderRadius.circular(10),
                                                  child: CachedNetworkImage(
                                                    imageUrl: item.image,
                                                    fit: BoxFit.cover,
                                                    errorWidget: (_, __, ___) => Icon(
                                                      Icons.error,
                                                      color: Colors.red,
                                                    ),
                                                  )),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(left: 15),
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    item.dishName ?? "",
                                                    style: GoogleFonts.poppins(
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.w400,
                                                        color: const Color(0xFF1E2538)),
                                                  ),
                                                  const SizedBox(
                                                    height: 3,
                                                  ),
                                                  Text(
                                                    "\$${item.price}",
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
                                                      onTap: () async {
                                                        if (item.qty < 1) return;
                                                        item.qty--;
                                                        if (item.qty == 0) {
                                                          cartModel.menuList!.removeAt(index);
                                                        }
                                                        await updateFirebaseValues();
                                                        getTotalPrice();
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
                                                  item.qty.toString(),
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
                                                        onTap: () async {
                                                          item.qty++;
                                                          await updateFirebaseValues();
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
                InkWell(
                  onTap: () {
                    Get.to(() => MyAddressList(
                          addressChanged: (AddressModel address) {
                            addressData = address;
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
                      child: Column(children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Deliver To',
                                style: GoogleFonts.poppins(
                                    fontSize: 15, fontWeight: FontWeight.w500, color: const Color(0xff293044)),
                              ),
                              InkWell(
                                onTap: () {
                                  Get.to(() => const MyAddressList());
                                },
                                child: const Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  color: Color(0xff04666E),
                                  size: 20,
                                ),
                              )
                            ]),
                        if (addressData != null)
                          ListTile(
                            horizontalTitleGap: -0,
                            contentPadding: EdgeInsets.zero,
                            visualDensity: VisualDensity.comfortable,
                            title: Transform.translate(
                              offset: const Offset(-16, 0),
                              child: Text(
                                addressData!.AddressType ?? "Home",
                                style: const TextStyle(color: Color(0xff384953), fontWeight: FontWeight.bold),
                              ),
                            ),
                            leading: Transform.translate(
                              offset: const Offset(-16, 0),
                              child: const CircleAvatar(
                                maxRadius: 40,
                                minRadius: 40,
                                backgroundColor: Color(0x1a3b5998),
                                child: CircleAvatar(
                                  maxRadius: 20,
                                  minRadius: 20,
                                  backgroundColor: Color(0xff3B5998),
                                  child: Icon(
                                    Icons.location_on,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            subtitle: Transform.translate(
                              offset: const Offset(-16, 0),
                              child: Text(
                                addressData!.flatAddress + ", " + addressData!.streetAddress ?? "",
                                style: const TextStyle(fontSize: 15),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          )
                        else
                          const Center(
                            child: Text(
                              "Please choose address",
                              style: TextStyle(fontSize: 16),
                            ),
                          )
                      ])),
                ),
                InkWell(
                  onTap: () {
                    Get.to(() => PromoCodeList(
                          id: cartModel.vendorId,
                          couponData: (CouponData coupon) {
                            couponData = coupon;
                            getCheckOutData();
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
                Container(
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
                  child:
                      Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Subtotal',
                          style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w400, color: const Color(0xff1E2538)),
                        ),
                        Text(
                          '\$$totalPrice',
                          style: GoogleFonts.poppins(fontSize: 14, color: const Color(0xffBCBCBC)),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const DottedLine(
                      dashColor: Color(0xffBCBCBC),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Tax And Fees',
                          style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w400, color: const Color(0xff1E2538)),
                        ),
                        Text(
                          '\$0.00',
                          style: GoogleFonts.poppins(fontSize: 14, color: const Color(0xffBCBCBC)),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const DottedLine(
                      dashColor: Color(0xffBCBCBC),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Delivery',
                          style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w400, color: const Color(0xff1E2538)),
                        ),
                        Text(
                          "\$0.00",
                          style: GoogleFonts.poppins(fontSize: 14, color: const Color(0xffBCBCBC)),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const DottedLine(
                      dashColor: Color(0xffBCBCBC),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Save Coupon',
                          style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w400, color: const Color(0xff1E2538)),
                        ),
                        Text(
                          "\$${couponDiscount.toStringAsFixed(2)}",
                          style: GoogleFonts.poppins(fontSize: 14, color: const Color(0xffBCBCBC)),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const DottedLine(
                      dashColor: Color(0xffBCBCBC),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total',
                          style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w400, color: const Color(0xff1E2538)),
                        ),
                        const Spacer(),
                        if (cartModel.menuList != null)
                          Text(
                            "(${cartModel.menuList!.length} Items)",
                            style: GoogleFonts.poppins(fontSize: 10, color: const Color(0xff3B5998), fontStyle: FontStyle.italic),
                          ),
                        const SizedBox(
                          width: 15,
                        ),
                        Text(
                          "\$$calculateTotalPrice",
                          style: GoogleFonts.poppins(fontSize: 14, color: const Color(0xffBCBCBC)),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ]),
                ),
                Container(
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
                        Row(
                          children: [
                            Text(
                              "Payment Method",
                              style:
                                  GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500, color: const Color(0xFF1E2538)),
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
                                  'PayPal',
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
                    )),
                Container(
                    margin: const EdgeInsets.only(top: 20),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: SizedBox(
                      width: size.width,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (addressData == null) {
                            showToast("Please choose address");
                          } else {
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
                                  // shipping address is not required though
                                  // "shipping_address": {
                                  //   "recipient_name": "Jane Foster",
                                  //   "line1": "Travis County",
                                  //   "line2": "",
                                  //   "city": "Austin",
                                  //   "country_code": "US",sqxc3v4bgy5un6mi7,o8.p[/j vm],nl̥ō'{}|9+
                                  //   "phone": "+00000000",
                                  //   "state": "Texas"
                                  // },
                                }
                              }
                            ]);
                            // return;

                            if (kIsWeb) {
                              order(cartModel.vendorId).then((value2) {
                                FirebaseFirestore.instance
                                    .collection("checkOut")
                                    .doc(FirebaseAuth.instance.currentUser!.uid)
                                    .delete();
                                Get.offAll(ThankuScreen(orderType: "Delivery", orderId: value2.toString()));
                              });
                            } else {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (BuildContext context) => UsePaypal(
                                      sandboxMode: true,
                                      // clientId: "AXzzNizO268LtEWEhlORqtjSut6XpJerxfosziugQke9gzo9P8HJSajCF9e2r7Xp1WZ68Ab68TkMmuxF",
                                      // secretKey: "EOM7dx9y1e-EbyVNxKaEEAgHMTZJ-GUpO9e4CzfrfI0zu-emIZdszR-8hX22H-gt8FPzV7nc5yzX3BT5",
                                      clientId: "Ab5v6E4R-gNbD13BbcdgpzK0G66oJ8ij1Va8i85qzGTtgA4TXkmt2h4oRpCXGRTBQs8Fn1SMqgyVkQ19",
                                      secretKey: "ELCzlUANZYqBS27CGrYqP3RNyoob11TbOj_J4kYp6QULFkDWh9veSi_zkpQoe8nu-VS3FN8XJf-o5WJx",
                                      returnURL: "https://samplesite.com/return",
                                      cancelURL: "https://samplesite.com/cancel",
                                      transactions: [
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
                                            // shipping address is not required though
                                            "shipping_address": {
                                              "recipient_name": "Jane Foster",
                                              "line1": "aaa",
                                              "line2": "aaa",
                                              "city": addressData!.streetAddress.toString(),
                                              "country_code": "IN",
                                              "phone": "+91",
                                              "state": addressData!.streetAddress.toString(),
                                            },
                                          }
                                        }
                                      ],
                                      note: "Contact us for any questions on your order.",
                                      onSuccess: (Map params) async {
                                        print("onSuccess: ${params}");
                                        order(cartModel.vendorId).then((value) {
                                          FirebaseFirestore.instance
                                              .collection("checkOut")
                                              .doc(FirebaseAuth.instance.currentUser!.uid)
                                              .delete();
                                          Get.offAll(ThankuScreen(orderType: "Delivery", orderId: value.toString()));
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
                            }
                          }
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
                // payWithCardButton(),
                // const SizedBox(height: 20),
                // payWithCashPlusButton(),
                const SizedBox(
                  height: 100,
                )
              ]).appPaddingForScreen)
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text("Cart is empty"),
                    Container(
                        margin: const EdgeInsets.only(top: 20),
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: SizedBox(
                          width: size.width * .40,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {
                              Get.offAll(const BottomNavbar());
                              bottomController.updateIndexValue(1);
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
                              "Browse",
                              style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white),
                            ),
                          ),
                        )),
                  ],
                ),
              ));
  }

  String? initialLink;
  Future<void> initUniLinks() async {
    try {
      initialLink = await getInitialLink();
      handleDeepLink(Uri.parse(initialLink.toString()));
    } on Exception catch (e) {
      // Handle error
      print('Error initializing deep links: $e');
    }
    uriLinkStream.listen((Uri? uri) {
      handleDeepLink(uri);
    });
  }

  void handleDeepLink(Uri? uri) {
    if (uri != null) {
      print('Received deep link: $uri');
      if (uri.path == '/payment-success') {
        order(cartModel.vendorId).then((value2) {
          FirebaseFirestore.instance.collection("checkOut").doc(FirebaseAuth.instance.currentUser!.uid).delete();
          Get.offAll(ThankuScreen(orderType: "Delivery", orderId: value2.toString()));
        });
      } else if (uri.path == '/payment-cancel') {}
    }
  }

  // Widget payWithCardButton() {
  //   return ElevatedButton(
  //       onPressed: () => payWithCard(),
  //       child: SizedBox(
  //           height: 50,
  //           width: MediaQuery.of(context).size.width,
  //           child: const Center(
  //               child: Text(
  //             "Pay with card",
  //             style: TextStyle(fontSize: 20),
  //           ))));
  // }
  //
  // Widget payWithCashPlusButton() {
  //   return ElevatedButton(
  //       style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
  //       onPressed: () => payWithCashPlus(),
  //       child: SizedBox(
  //           height: 50,
  //           width: MediaQuery.of(context).size.width,
  //           child: const Center(
  //               child: Text(
  //             "Pay with CashPlus",
  //             style: TextStyle(fontSize: 20),
  //           ))));
  // }
  //
  // void payWithCashPlus() {
  //   ycPay.payWithCashPlus(
  //       token: token,
  //       onSuccessfulPayment: (transactionId, cashPlusToken) {
  //         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //           content: Text('pay success cashPlus token: $transactionId'),
  //           backgroundColor: Colors.green,
  //         ));
  //       },
  //       onFailedPayment: (message) {
  //         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //           content: Text('pay failed $message'),
  //           backgroundColor: Colors.red,
  //         ));
  //       });
  // }
  //
  // void payWithCard() {
  //   ycPay.payWithCard(
  //       token: token,
  //       cardInformation: cardInformation,
  //       onSuccessfulPayment: (transactionId) {
  //         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //           content: Text('pay success $transactionId'),
  //           backgroundColor: Colors.green,
  //         ));
  //       },
  //       onFailedPayment: (message) {
  //         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //           content: Text('pay failed $message'),
  //           backgroundColor: Colors.red,
  //         ));
  //       });
  // }
}
