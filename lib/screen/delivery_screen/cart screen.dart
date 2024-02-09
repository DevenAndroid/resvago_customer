import 'dart:convert';
import 'dart:developer';
import 'dart:math' as math;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paypal/flutter_paypal.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:resvago_customer/controller/local_controller.dart';
import 'package:resvago_customer/model/admin_model.dart';
import 'package:resvago_customer/model/profile_model.dart';
import 'package:resvago_customer/screen/delivery_screen/thank__you_screen.dart';
import 'package:resvago_customer/screen/myAddressList.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uni_links/uni_links.dart';
import 'package:url_launcher/url_launcher.dart';
// import 'package:youcanpay_sdk/youcanpay_sdk.dart';
import '../../controller/bottomnavbar_controller.dart';
import '../../firebase_service/firebase_service.dart';
import '../../firebase_service/notification.dart';
import '../../model/add_address_modal.dart';
import '../../model/checkout_model.dart';
import '../../model/coupon_modal.dart';
import '../../model/menu_model.dart';
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

  getCheckOutData() async {
    extractedData.clear();
    if (FirebaseAuth.instance.currentUser != null) {
      FirebaseFirestore.instance.collection("checkOut").doc(FirebaseAuth.instance.currentUser!.uid).get().then((value) {
        log("checkOut${jsonEncode(value.data())}");
        cartModel = CheckOutModel.fromJson(value.data() ?? {});
        log("checkOut${cartModel.toJson()}");
        log(cartModel.menuList!.map((e) => e.toJson()).toList().toString());
        extractedData = cartModel.menuList!.map((e) => e.toJson()).toList().map((item) {
          return {
            "name": item["dishName"],
            "quantity": item["qty"],
            "price": double.parse(item["sellingPrice"].toString()).toStringAsFixed(2).toString(),
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
    } else {
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      if (sharedPreferences.getString("checkout") != null) {
        cartModel = CheckOutModel.fromJson(jsonDecode(sharedPreferences.getString("checkout")!));
      }
    }
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
  double result = 0.0;

  double getTotalPrice() {
    if (cartModel.menuList == null) return 0;
    totalPrice = 0;
    for (int i = 0; i < cartModel.menuList!.length; i++) {
      totalPrice = totalPrice +
          double.parse(cartModel.menuList![i].qty.toString()) * double.parse(cartModel.menuList![i].sellingPrice.toString());
      if (adminModel != null) {
        result = (totalPrice * double.parse(adminModel!.adminCommission ?? "0")) / 100;
        log("sadsfgdg" + result.toString());
      }
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
    getAdminData();
    getCheckOutData();
    getTotalPrice();
    fetchdata();
  }

  CouponData? couponData;
  AddressModel? addressData;
  ProfileData? profileData;

  void fetchdata() {
    if (FirebaseAuth.instance.currentUser == null) return;
    FirebaseFirestore.instance.collection("customer_users").doc(FirebaseAuth.instance.currentUser!.uid).get().then((value) {
      if (value.exists) {
        if (value.data() == null) return;
        profileData = ProfileData.fromJson(value.data()!);
        setState(() {});
      }
    });
  }

  AdminModel? adminModel;
  void getAdminData() {
    FirebaseFirestore.instance.collection("admin_login").get().then((value) {
      adminModel = AdminModel.fromJson(value.docs.first.data());
      log(jsonEncode(value.docs.first.data()).toString());
      setState(() {});
    });
  }

  FirebaseService firebaseService = FirebaseService();
  Future<int> order(String vendorId) async {
    OverlayEntry loader = Helper.overlayLoader(context);
    Overlay.of(context).insert(loader);
    String? fcm = "fcm";
    if (!kIsWeb) {
      fcm = await FirebaseMessaging.instance.getToken();
    }
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
              fcm: fcm,
              total: calculateTotalPrice,
              admin_commission: result)
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
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: backAppBar(
          title: "CheckOut".tr,
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
                                      double? priceValue = double.tryParse(item.price);
                                      double? discountValue = double.tryParse(item.discount);
                                      result = priceValue! - (priceValue * (discountValue ?? 0)) / 100;
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
                                                    errorWidget: (_, __, ___) => const Icon(
                                                      Icons.error,
                                                      color: Colors.red,
                                                    ),
                                                  )),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Expanded(
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    item.dishName ?? "",
                                                    maxLines: 2,
                                                    style: GoogleFonts.poppins(
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.w400,
                                                        color: const Color(0xFF1E2538)),
                                                  ),
                                                  const SizedBox(
                                                    height: 3,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        "\$${(item.price).toString()} ",
                                                        style: const TextStyle(
                                                          fontSize: 14,
                                                          decoration: TextDecoration.lineThrough,
                                                          color: Color(0xFF8E9196),
                                                        ),
                                                      ),
                                                      Text(
                                                        "\$${result.toString()}",
                                                        style: GoogleFonts.poppins(
                                                            fontSize: 14,
                                                            // fontWeight: FontWeight.w400,
                                                            color: const Color(0xFF1E2538)),
                                                      ),
                                                    ],
                                                  ),

                                                  // DottedLine(
                                                  //   dashColor: Colors.black,
                                                  // )
                                                ],
                                              ),
                                            ),
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
                                                        if (FirebaseAuth.instance.currentUser != null) {
                                                          await updateFirebaseValues();
                                                          getCheckOutData();
                                                          getTotalPrice();
                                                        } else {
                                                          SharedPreferences sharedPreferences =
                                                          await SharedPreferences.getInstance();
                                                          sharedPreferences.setString("checkout", jsonEncode(cartModel.toJson()));
                                                          final local = Get.put(LocalController(),permanent: true);
                                                          local.refreshInt.value = DateTime.now().millisecondsSinceEpoch;
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
                                                          if (FirebaseAuth.instance.currentUser != null) {
                                                            await updateFirebaseValues();
                                                            getCheckOutData();
                                                            getTotalPrice();
                                                          } else {
                                                            SharedPreferences sharedPreferences =
                                                                await SharedPreferences.getInstance();
                                                            sharedPreferences.setString("checkout", jsonEncode(cartModel.toJson()));
                                                            final local = Get.put(LocalController(),permanent: true);
                                                            local.refreshInt.value = DateTime.now().millisecondsSinceEpoch;
                                                          }
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
                                'Deliver To'.tr,
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
                          Center(
                            child: Text(
                              "Please choose address".tr,
                              style: const TextStyle(fontSize: 16),
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
                            'Use Coupons'.tr,
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
                          'Subtotal'.tr,
                          style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w400, color: const Color(0xff1E2538)),
                        ),
                        Text(
                          '\$$calculateTotalPrice',
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
                          'Tax And Fees'.tr,
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
                          'Delivery'.tr,
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
                          'Save Coupon'.tr,
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
                          'Total'.tr,
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
                              "Payment Method".tr,
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
                                  'Debit/Credit Card'.tr,
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
                                  'PayPal'.tr,
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
                              order(cartModel.vendorId).then((value) {
                                FirebaseFirestore.instance
                                    .collection("checkOut")
                                    .doc(FirebaseAuth.instance.currentUser!.uid)
                                    .delete();
                                FirebaseFirestore.instance.collection("send_mail").add({
                                  "to": "${profileData!.email}",
                                  "message": {
                                    "subject": "This is a basic email",
                                    "html": getOrderConfirmationHtml(
                                        orderId: value.toString(),
                                        date: DateTime.now().toString(),
                                        total: calculateTotalPrice.toString(),
                                        address: profileData!.selected_address,
                                        orderItems: cartModel,
                                        orderType: "COD"),
                                    "text": "asdfgwefddfgwefwn",
                                  }
                                });
                                FirebaseFirestore.instance.collection("send_mail").add({
                                  "to": "${cartModel.restaurantInfo!.email}",
                                  "message": {
                                    "subject": "This is a basic email",
                                    "html": getOrderConfirmationHtml(
                                        orderId: value.toString(),
                                        date: DateTime.now().toString(),
                                        total: calculateTotalPrice.toString(),
                                        address: profileData!.selected_address,
                                        orderItems: cartModel,
                                        orderType: "COD"),
                                    "text": "asdfgwefddfgwefwn",
                                  }
                                });
                                FirebaseFirestore.instance.collection("send_mail").add({
                                  "to": "${adminModel!.email}",
                                  "message": {
                                    "subject": "This is a basic email",
                                    "html": getOrderConfirmationHtml(
                                        orderId: value.toString(),
                                        date: DateTime.now().toString(),
                                        total: calculateTotalPrice.toString(),
                                        address: profileData!.selected_address,
                                        orderItems: cartModel,
                                        orderType: "COD"),
                                    "text": "asdfgwefddfgwefwn",
                                  }
                                });
                                FirebaseFirestore.instance.collection('notification').add({
                                  'title': "Your Order has been created with Order ID ${value.toString()}",
                                  'body': "Your Order has been created with Order ID ${value.toString()}",
                                  'date': DateTime.now(),
                                  'userId': FirebaseAuth.instance.currentUser!.uid
                                });
                                Get.offAll(ThankuScreen(orderType: "Delivery", orderId: value.toString()));
                              });
                              // try {
                              //   await payPalService.createOrder().then((value) async {
                              //     print("fsdgdfghh" + value.toString());
                              //     await payPalService.capturePayment(value).then((value1) {
                              //       order(cartModel.vendorId).then((value2) {
                              //         FirebaseFirestore.instance
                              //             .collection("checkOut")
                              //             .doc(FirebaseAuth.instance.currentUser!.uid)
                              //             .delete();
                              //         Get.offAll(ThankuScreen(orderType: "Delivery", orderId: value2.toString()));
                              //       });
                              //     });
                              //   });
                              // } catch (e) {
                              //   print('Error: $e');
                              // }
                              // ;
                            } else {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (BuildContext context) => UsePaypal(
                                      sandboxMode: true,
                                      // clientId: "AXzzNizO268LtEWEhlORqtjSut6XpJerxfosziugQke9gzo9P8HJSajCF9e2r7Xp1WZ68Ab68TkMmuxF",
                                      // secretKey: "EOM7dx9y1e-EbyVNxKaEEAgHMTZJ-GUpO9e4CzfrfI0zu-emIZdszR-8hX22H-gt8FPzV7nc5yzX3BT5",
                                      clientId:
                                          "Ab5v6E4R-gNbD13BbcdgpzK0G66oJ8ij1Va8i85qzGTtgA4TXkmt2h4oRpCXGRTBQs8Fn1SMqgyVkQ19",
                                      secretKey:
                                          "ELCzlUANZYqBS27CGrYqP3RNyoob11TbOj_J4kYp6QULFkDWh9veSi_zkpQoe8nu-VS3FN8XJf-o5WJx",
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
                                          FirebaseFirestore.instance.collection("send_mail").add({
                                            "to": "${profileData!.email}",
                                            "message": {
                                              "subject": "This is a basic email",
                                              "html": getOrderConfirmationHtml(
                                                  orderId: value.toString(),
                                                  date: DateTime.now().toString(),
                                                  total: calculateTotalPrice.toString(),
                                                  address: profileData!.selected_address,
                                                  orderItems: cartModel,
                                                  orderType: "Online"),
                                              "text": "asdfgwefddfgwefwn",
                                            }
                                          });
                                          FirebaseFirestore.instance.collection("send_mail").add({
                                            "to": "${cartModel.restaurantInfo!.email}",
                                            "message": {
                                              "subject": "This is a basic email",
                                              "html": getOrderConfirmationHtml(
                                                  orderId: value.toString(),
                                                  date: DateTime.now().toString(),
                                                  total: calculateTotalPrice.toString(),
                                                  address: profileData!.selected_address,
                                                  orderItems: cartModel,
                                                  orderType: "Online"),
                                              "text": "asdfgwefddfgwefwn",
                                            }
                                          });
                                          FirebaseFirestore.instance.collection("send_mail").add({
                                            "to": "${adminModel!.email}",
                                            "message": {
                                              "subject": "This is a basic email",
                                              "html": getOrderConfirmationHtml(
                                                  orderId: value.toString(),
                                                  date: DateTime.now().toString(),
                                                  total: calculateTotalPrice.toString(),
                                                  address: profileData!.selected_address,
                                                  orderItems: cartModel,
                                                  orderType: "Online"),
                                              "text": "asdfgwefddfgwefwn",
                                            }
                                          });
                                          FirebaseFirestore.instance.collection('notification').add({
                                            'title': "Your Order has been created with Order ID ${value.toString()}",
                                            'body': "Your Order has been created with Order ID ${value.toString()}",
                                            'date': DateTime.now(),
                                            'userId': FirebaseAuth.instance.currentUser!.uid
                                          });
                                          Get.offAll(ThankuScreen(orderType: "Delivery", orderId: value.toString()));
                                          sendPushNotification(
                                              body: "Order received",
                                              deviceToken: cartModel.restaurantInfo!.fcm,
                                              image:
                                                  "https://www.funfoodfrolic.com/wp-content/uploads/2021/08/Macaroni-Thumbnail-Blog.jpg",
                                              title: "You have received a new order for Delivery",
                                              orderID: "");
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
                          "Place Order".tr,
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

  String getOrderConfirmationHtml(
      {String? orderId,
      String? date,
      String? address,
      String? total,
      String? adminCommission = "0.0",
      String? orderType,
      CheckOutModel? orderItems}) {
    String orderItemsHtml = '';
    for (var item in orderItems!.menuList!) {
      orderItemsHtml += '''
        <li>
          <img src="${item.image}" alt="${item.dishName}" style="width: 50px; height: 50px;">
          <strong>${item.dishName}</strong> - ${item.discount * item.qty}
        </li>
      ''';
    }

    // HTML template for the email
    String emailHtml = '''
      <!DOCTYPE html>
      <html>
        <head>
          <style>
            body {
              font-family: 'Arial', sans-serif;
              margin: 20px;
            }
            h1 {
              color: #333;
            }
            p {
              margin-bottom: 10px;
            }
            ul {
              list-style-type: none;
              padding: 0;
            }
            li {
              margin-bottom: 5px;
            }
            strong {
              color: #555;
            }
          </style>
        </head>
        <body>
          <h1>Order Confirmation</h1>
          <p><strong>Order ID:</strong> $orderId</p>
          <p><strong>Date:</strong> $date</p>
          <p><strong>Address:</strong> $address</p>
          <p><strong>Total:</strong> $total</p>
          <p><strong>Admin Commission:</strong> $adminCommission</p>
          <p><strong>Order Type:</strong> $orderType</p>
          <p><strong>Order Items:</strong></p>
          <ul>
            $orderItemsHtml
          </ul>
          <p>Your order has been placed successfully. Thank you for choosing our services!</p>
        </body>
      </html>
    ''';

    return emailHtml;
  }
}
