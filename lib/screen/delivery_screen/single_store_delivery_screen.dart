import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:resvago_customer/model/menu_model.dart';
import 'package:resvago_customer/screen/single_store_screens/setting_for_restaurant.dart';
import 'package:resvago_customer/widget/appassets.dart';
import '../../firebase_service/firebase_service.dart';
import '../../model/resturant_model.dart';
import '../../model/review_model.dart';
import '../../widget/apptheme.dart';
import '../../widget/restaurant_timing.dart';
import '../helper.dart';
import '../login_screen.dart';
import '../widgets/calculate_distance.dart';
import 'cart screen.dart';

class SingleRestaurantForDeliveryScreen extends StatefulWidget {
  final RestaurantModel? restaurantItem;
  // String distance;
  SingleRestaurantForDeliveryScreen({super.key, required this.restaurantItem, });

  @override
  State<SingleRestaurantForDeliveryScreen> createState() => _SingleRestaurantForDeliveryScreenState();
}

class _SingleRestaurantForDeliveryScreenState extends State<SingleRestaurantForDeliveryScreen> {
  RestaurantModel? get restaurantData => widget.restaurantItem;
  // String? get distance => widget.distance;
  double fullRating = 0;
  int currentDrawer = 0;
  int currentMenu = 0;
  int currentStep = 0;
  DateTime today = DateTime.now();

  bool value = false;

  List<MenuData>? menuList;
  getMenuList() {
    FirebaseFirestore.instance
        .collection("vendor_menu")
        .where("vendorId", isEqualTo: widget.restaurantItem!.docid)
        .where("bookingForDelivery", isEqualTo: true)
        .get()
        .then((value) {
      for (var element in value.docs) {
        var gg = element.data();
        menuList ??= [];
        menuList!.add(MenuData.fromMap(gg, element.id));
      }
      setState(() {});
    });
  }

  double kk = 0.0;
  List<String> fields = [
    "Date",
    "Time",
    "Guest",
    "Offer",
  ];
  List<Map<String, dynamic>> weekSchedule1 = [];
  Future<List<Map<String, dynamic>>> getWeekSchedule(String userId) async {
    try {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance.collection('week_schedules').doc(userId).get();
      if (documentSnapshot.exists) {
        Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
        List<Map<String, dynamic>> weekSchedule = List.from(data['schedule']);
        weekSchedule1 = weekSchedule;
        log(weekSchedule1.toString());
        return weekSchedule;
      } else {
        return [];
      }
    } catch (error) {
      rethrow;
    }
  }

  List<ReviewModel>? reviewModel;
  getReviewList() {
    FirebaseFirestore.instance
        .collection("Review")
        .where("vendorID", isEqualTo: widget.restaurantItem!.userID)
        .get()
        .then((value) {
      for (var element in value.docs) {
        var gg = element.data();
        reviewModel ??= [];
        reviewModel!.add(ReviewModel.fromJson(gg));
      }
      setState(() {});
    });
  }

  FirebaseService firebaseService = FirebaseService();
  Future<void> manageCheckOut(String vendorId) async {
    OverlayEntry loader = Helper.overlayLoader(context);
    Overlay.of(context).insert(loader);
    try {
      await firebaseService
          .manageCheckOut(
        cartId: FirebaseAuth.instance.currentUser!.uid,
        menuList: menuList!.where((e) => e.qty > 0).map((e) => e.toMap()).toList(),
        restaurantInfo: restaurantData!.toJson(),
        vendorId: vendorId,
        time: DateTime.now().millisecondsSinceEpoch,
      )
          .then((value) {
        Helper.hideLoader(loader);
      });
    } catch (e) {
      Helper.hideLoader(loader);
      throw Exception(e);
    }
  }

  @override
  void initState() {
    super.initState();
    getMenuList();
    getReviewList();
    if (widget.restaurantItem != null) {
      log(widget.restaurantItem!.image.toString());
      // getWeekSchedule(widget.restaurantItem!.userID);
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          surfaceTintColor: Colors.white,
          leading: InkWell(
            onTap: () {
              Get.back();
            },
            child: Padding(
              padding: const EdgeInsets.all(13.0),
              child: SvgPicture.asset("assets/images/back.svg"),
            ),
          ),
          elevation: 1,
          title: Text(
            "Restaurants",
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        body: widget.restaurantItem != null
            ? SingleChildScrollView(
                child: Column(children: [
                SizedBox(
                  height: 390,
                  child: Stack(children: [
                    SizedBox(
                      width: size.width,
                      height: size.height * .20,
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(0),
                          child: CachedNetworkImage(
                            imageUrl: widget.restaurantItem!.image.toString(),
                            fit: BoxFit.cover,
                            errorWidget: (_, __, ___) => Icon(
                              Icons.error,
                              color: Colors.red,
                            ),
                          )),
                    ),
                    Positioned(
                      top: 110,
                      left: 12,
                      right: 12,
                      child: Column(
                        children: [
                          Stack(children: [
                            Container(
                              // height: 267,
                              width: size.width,
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF37C666).withOpacity(0.10),
                                  offset: const Offset(
                                    .1,
                                    .1,
                                  ),
                                  blurRadius: 20.0,
                                  spreadRadius: 1.0,
                                ),
                              ]),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.circle, size: 7, color: Color(0xff3B5998)),
                                      const SizedBox(
                                        width: 6,
                                      ),
                                      RestaurantTimingScreen(
                                        docId: widget.restaurantItem!.docid.toString(),
                                      ),
                                      const Spacer(),
                                      CalculateDistanceFromStoreWidget(
                                        latLng: LatLng(widget.restaurantItem!.storeLat, widget.restaurantItem!.storeLong),
                                      ),
                                      // Text(
                                      //   widget.distance,
                                      //   style: GoogleFonts.poppins(
                                      //       fontSize: 12, fontWeight: FontWeight.w400, color: const Color(0xff606573)),
                                      // ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "Layers of delicious restoring",
                                    style: GoogleFonts.poppins(
                                        fontSize: 16, fontWeight: FontWeight.w500, color: const Color(0xff1E2538)),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      SvgPicture.asset(AppAssets.location),
                                      const SizedBox(
                                        width: 20,
                                      ),
                                      Expanded(
                                        child: Text(
                                          widget.restaurantItem!.address.toString(),
                                          maxLines: 3,
                                          style: GoogleFonts.poppins(
                                              fontSize: 12, fontWeight: FontWeight.w300, color: const Color(0xff384953)),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Row(
                                    children: [
                                      SvgPicture.asset(AppAssets.food),
                                      const SizedBox(
                                        width: 20,
                                      ),
                                      Text(
                                        widget.restaurantItem!.category.toString(),
                                        style: GoogleFonts.poppins(
                                            fontSize: 12, fontWeight: FontWeight.w300, color: const Color(0xff384953)),
                                      ),
                                    ],
                                  ),
                                  // SizedBox(height: 5,),
                                  Row(
                                    // mainAxisAlignment: MainAxisAlignment.start,
                                    // crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SvgPicture.asset(AppAssets.money),
                                      const SizedBox(
                                        width: 20,
                                      ),
                                      SettingDataScreen(
                                        docId: widget.restaurantItem!.docid.toString(),
                                      ),
                                      // Text(
                                      //   "Average price \$20",
                                      //   style: GoogleFonts.poppins(
                                      //       fontSize: 12, fontWeight: FontWeight.w300, color: const Color(0xff384953)),
                                      // ),
                                      const Spacer(),
                                      Column(
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                "4.9",
                                                style: GoogleFonts.poppins(
                                                    fontSize: 22, fontWeight: FontWeight.w300, color: const Color(0xff1E2538)),
                                              ),
                                              Text(
                                                "/5.9",
                                                style: GoogleFonts.poppins(
                                                    fontSize: 11, fontWeight: FontWeight.w300, color: const Color(0xff979798)),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              SvgPicture.asset(AppAssets.chat),
                                              const SizedBox(
                                                width: 3,
                                              ),
                                              Text(
                                                "2584",
                                                style: GoogleFonts.poppins(
                                                    fontSize: 11, fontWeight: FontWeight.w300, color: const Color(0xff1E2538)),
                                              ),
                                            ],
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),

                                  Center(
                                    child: Container(
                                      width: size.width,
                                      height: 60,
                                      decoration: const BoxDecoration(
                                          borderRadius:
                                              BorderRadius.only(topRight: Radius.circular(30), topLeft: Radius.circular(30)),
                                          color: Color(0xFFEBF0FB)),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Up to \$10 Master card Cashback",
                                            style: GoogleFonts.poppins(
                                                fontSize: 15, fontWeight: FontWeight.w400, color: const Color(0xff000000)),
                                          ),
                                          Text(
                                            "Use code Card Above \$120",
                                            style: GoogleFonts.poppins(
                                                fontSize: 10, fontWeight: FontWeight.w300, color: const Color(0xff384953)),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Positioned(
                                top: 120, bottom: 0, left: 0, right: 0, child: Center(child: SvgPicture.asset(AppAssets.code))),
                          ]),
                        ],
                      ),
                    ),
                  ]),
                ),
                Column(children: [
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Container(
                            width: size.width,
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
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        currentMenu = 0;
                                        setState(() {});
                                      },
                                      child: Text(
                                        "About",
                                        style: currentMenu == 0
                                            ? GoogleFonts.poppins(
                                                fontSize: 16, fontWeight: FontWeight.w500, color: const Color(0xFF3B5998))
                                            : GoogleFonts.poppins(
                                                fontSize: 16, fontWeight: FontWeight.w300, color: const Color(0xFF1E2538)),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        currentMenu = 1;
                                        setState(() {});
                                      },
                                      child: Text(
                                        "Menu",
                                        style: currentMenu == 1
                                            ? GoogleFonts.poppins(
                                                fontSize: 16, fontWeight: FontWeight.w500, color: const Color(0xFF3B5998))
                                            : GoogleFonts.poppins(
                                                fontSize: 16, fontWeight: FontWeight.w300, color: const Color(0xFF1E2538)),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        currentMenu = 2;
                                        setState(() {});
                                      },
                                      child: Text(
                                        "Reviews",
                                        style: currentMenu == 2
                                            ? GoogleFonts.poppins(
                                                fontSize: 16, fontWeight: FontWeight.w500, color: const Color(0xFF3B5998))
                                            : GoogleFonts.poppins(
                                                fontSize: 16, fontWeight: FontWeight.w300, color: const Color(0xFF1E2538)),
                                      ),
                                    ),
                                  ],
                                ),
                                Divider(
                                  thickness: 1,
                                  color: Colors.grey.withOpacity(0.3),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                if (currentMenu == 0)
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "About Us",
                                          style: GoogleFonts.poppins(
                                              fontSize: 16, fontWeight: FontWeight.w500, color: const Color(0xFF1E2538)),
                                        ),
                                        const SizedBox(
                                          height: 8,
                                        ),
                                        Text(
                                          (widget.restaurantItem!.aboutUs ?? "").toString(),
                                          style: GoogleFonts.poppins(
                                              fontSize: 12, fontWeight: FontWeight.w300, color: const Color(0xFF1E2538)),
                                        ),
                                        const SizedBox(
                                          height: 18,
                                        ),
                                        if (widget.restaurantItem!.restaurantImage!.isNotEmpty)
                                          SizedBox(
                                            height: 100,
                                            child: ListView.builder(
                                              shrinkWrap: true,
                                              scrollDirection: Axis.horizontal,
                                              itemCount: widget.restaurantItem!.restaurantImage!.length,
                                              itemBuilder: (BuildContext context, int index) {
                                                return Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: 2),
                                                  child: SizedBox(
                                                    width: 100,
                                                    child: ClipRRect(
                                                        borderRadius: BorderRadius.circular(20),
                                                        child: CachedNetworkImage(
                                                          imageUrl: widget.restaurantItem!.restaurantImage![index],
                                                          fit: BoxFit.cover,
                                                          errorWidget: (_, __, ___) => Icon(
                                                            Icons.error,
                                                            color: Colors.red,
                                                          ),
                                                        )),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                if (currentMenu == 1)
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Restaurant Menu",
                                          style: GoogleFonts.poppins(
                                              fontSize: 16, fontWeight: FontWeight.w500, color: const Color(0xFF1E2538)),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        if (widget.restaurantItem!.menuGalleryImages!.isNotEmpty)
                                          SizedBox(
                                            height: 400,
                                            child: PageView.builder(
                                              scrollDirection: Axis.horizontal,
                                              itemCount: widget.restaurantItem!.menuGalleryImages!.length,
                                              itemBuilder: (BuildContext context, int index) {
                                                return Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: 2),
                                                  child: CachedNetworkImage(
                                                    imageUrl: widget.restaurantItem!.menuGalleryImages![index],
                                                    fit: BoxFit.cover,
                                                    errorWidget: (_, __, ___) => Icon(
                                                      Icons.error,
                                                      color: Colors.red,
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        if (menuList != null)
                                          ListView.builder(
                                              shrinkWrap: true,
                                              physics: const NeverScrollableScrollPhysics(),
                                              itemCount: menuList!.length,
                                              itemBuilder: (context, index) {
                                                var menuListData = menuList![index];
                                                return Column(children: [
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      SizedBox(
                                                        height: 60,
                                                        width: 80,
                                                        child: ClipRRect(
                                                          borderRadius: BorderRadius.circular(10),
                                                          child: CachedNetworkImage(
                                                            imageUrl: menuListData.image,
                                                            fit: BoxFit.cover,
                                                            errorWidget: (_, __, ___) => Icon(
                                                              Icons.error,
                                                              color: Colors.red,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      Expanded(
                                                        child: Column(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Text(
                                                              menuListData.dishName.toString(),
                                                              maxLines: 2,
                                                              style: GoogleFonts.poppins(
                                                                  fontSize: 14,
                                                                  fontWeight: FontWeight.w400,
                                                                  color: const Color(0xFF1E2538)),
                                                            ),
                                                            const SizedBox(
                                                              height: 3,
                                                            ),
                                                            Text(
                                                              menuListData.description.toString(),
                                                              maxLines: 2,
                                                              style: GoogleFonts.poppins(
                                                                  fontSize: 10,
                                                                  fontWeight: FontWeight.w300,
                                                                  color: const Color(0xFF74848C)),
                                                            ),
                                                            const SizedBox(
                                                              height: 10,
                                                            ),
                                                            menuListData.qty > 0
                                                                ? Row(
                                                                    mainAxisAlignment: MainAxisAlignment.start,
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
                                                                              menuListData.qty--;
                                                                              log(menuListData.qty.toString());
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
                                                                        menuListData.qty.toString(),
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
                                                                                menuListData.qty++;
                                                                                log(menuListData.qty.toString());
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
                                                                  )
                                                                : SizedBox(
                                                                    // width: size.width,
                                                                    height: 23,

                                                                    child: ElevatedButton(
                                                                      onPressed: () {
                                                                        menuListData.qty++;
                                                                        log(menuListData.qty.toString());
                                                                        setState(() {});
                                                                      },
                                                                      style: ElevatedButton.styleFrom(
                                                                          backgroundColor: const Color(0xFF3B5998),
                                                                          shape: RoundedRectangleBorder(
                                                                              borderRadius: BorderRadius.circular(3),
                                                                              side: const BorderSide(
                                                                                width: 2.0,
                                                                                color: Color(0xFF3B5998),
                                                                              )),
                                                                          textStyle: const TextStyle(
                                                                              fontSize: 18, fontWeight: FontWeight.w500)),
                                                                      child: Text(
                                                                        "ADD TO CART",
                                                                        style: GoogleFonts.poppins(
                                                                          fontSize: 10,
                                                                          fontWeight: FontWeight.w500,
                                                                          color: Colors.white,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                          ],
                                                        ),
                                                      ),
                                                      Column(
                                                        crossAxisAlignment: CrossAxisAlignment.end,
                                                        children: [
                                                          Text(
                                                            "\$${menuListData.price.toString()}",
                                                            style: GoogleFonts.poppins(
                                                                fontSize: 14,
                                                                // fontWeight: FontWeight.w400,
                                                                color: const Color(0xFF1E2538)),
                                                          ),
                                                          const SizedBox(
                                                            height: 5,
                                                          ),
                                                          Text(
                                                            "${menuListData.discount.toString()}% Discount",
                                                            style: GoogleFonts.poppins(
                                                                fontSize: 14,
                                                                // fontWeight: FontWeight.w400,
                                                                color: const Color(0xFF74848C)),
                                                          ),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  index != menuList!.length - 1
                                                      ? const DottedLine(
                                                          dashColor: Color(0xffBCBCBC),
                                                          dashGapLength: 1,
                                                        )
                                                      : const SizedBox(),
                                                ]);
                                              }),
                                      ],
                                    ),
                                  ),
                                if (currentMenu == 2)
                                  if (reviewModel != null)
                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10),
                                      child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Review(${reviewModel!.length})",
                                              style: GoogleFonts.poppins(
                                                  fontSize: 16, fontWeight: FontWeight.w500, color: const Color(0xFF1E2538)),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              "Overall Rating",
                                              style: GoogleFonts.poppins(
                                                  fontSize: 16, fontWeight: FontWeight.w500, color: const Color(0xFF969AA3)),
                                            ),
                                            Padding(
                                                padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10),
                                                child: Column(children: [
                                                  Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                                                    const Text(
                                                      '4.8',
                                                      style: TextStyle(
                                                        color: Color(0xFF1B233A),
                                                        fontSize: 48,
                                                        fontWeight: FontWeight.w600,
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      width: 20,
                                                    ),
                                                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                                      RatingBar.builder(
                                                        initialRating: 4,
                                                        minRating: 1,
                                                        unratedColor: const Color(0xFF698EDE).withOpacity(.2),
                                                        itemCount: 5,
                                                        itemSize: 16.0,
                                                        itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                                                        updateOnDrag: true,
                                                        itemBuilder: (context, index) => Image.asset(
                                                          'assets/icons/star.png',
                                                          color: const Color(0xff3B5998),
                                                        ),
                                                        onRatingUpdate: (ratingvalue) {
                                                          setState(() {
                                                            fullRating = ratingvalue;
                                                          });
                                                        },
                                                      ),
                                                      const SizedBox(
                                                        height: 8,
                                                      ),
                                                      const Padding(
                                                        padding: EdgeInsets.symmetric(horizontal: 4.0),
                                                        child: Text(
                                                          'basad on 23 reviews',
                                                          style: TextStyle(
                                                            color: Color(0xFF969AA3),
                                                            fontSize: 13,
                                                            fontWeight: FontWeight.w400,
                                                          ),
                                                        ),
                                                      ),
                                                    ]),
                                                  ]),
                                                ])),
                                            Column(children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  const Expanded(
                                                    child: Text(
                                                      'Excellent',
                                                      style: TextStyle(
                                                        color: Color(0xFF969AA3),
                                                        fontSize: 12,
                                                        fontWeight: FontWeight.w400,
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 3,
                                                    child: LinearPercentIndicator(
                                                      lineHeight: 6.0,
                                                      barRadius: const Radius.circular(16),
                                                      backgroundColor: const Color(0xFFE6F9ED),
                                                      animation: true,
                                                      progressColor: const Color(0xFF5DAF5E),
                                                      percent: 0.9,
                                                      animationDuration: 1200,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children: [
                                                  const Expanded(
                                                    child: Text(
                                                      'Good',
                                                      style: TextStyle(
                                                        color: Color(0xFF969AA3),
                                                        fontSize: 12,
                                                        fontWeight: FontWeight.w400,
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 3,
                                                    child: LinearPercentIndicator(
                                                      lineHeight: 6.0,
                                                      barRadius: const Radius.circular(16),
                                                      backgroundColor: const Color(0xFFF2FFCF),
                                                      animation: true,
                                                      progressColor: const Color(0xFFA4D131),
                                                      percent: 0.7,
                                                      animationDuration: 1200,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  const Expanded(
                                                    child: Text(
                                                      'Average',
                                                      style: TextStyle(
                                                        color: Color(0xFF969AA3),
                                                        fontSize: 12,
                                                        fontWeight: FontWeight.w400,
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 3,
                                                    child: LinearPercentIndicator(
                                                      lineHeight: 6.0,
                                                      barRadius: const Radius.circular(16),
                                                      backgroundColor: const Color(0xFFF5FFDB),
                                                      animation: true,
                                                      progressColor: const Color(0xFFF7E742),
                                                      percent: 0.6,
                                                      animationDuration: 1200,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  const Expanded(
                                                    child: Text(
                                                      'Below Average',
                                                      style: TextStyle(
                                                        color: Color(0xFF969AA3),
                                                        fontSize: 12,
                                                        fontWeight: FontWeight.w400,
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 3,
                                                    child: LinearPercentIndicator(
                                                      lineHeight: 6.0,
                                                      barRadius: const Radius.circular(16),
                                                      backgroundColor: const Color(0xFFFFF5E5),
                                                      animation: true,
                                                      progressColor: const Color(0xFFF8B859),
                                                      percent: 0.5,
                                                      animationDuration: 1200,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  const Expanded(
                                                    child: Text(
                                                      'Poor',
                                                      style: TextStyle(
                                                        color: Color(0xFF969AA3),
                                                        fontSize: 12,
                                                        fontWeight: FontWeight.w400,
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 3,
                                                    child: LinearPercentIndicator(
                                                      lineHeight: 6.0,
                                                      barRadius: const Radius.circular(16),
                                                      backgroundColor: const Color(0xFFFFE9E4),
                                                      animation: true,
                                                      progressColor: const Color(0xFFEE3D1C),
                                                      percent: 0.3,
                                                      animationDuration: 1200,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                ],
                                              ),
                                            ]),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Divider(
                                              color: const Color(0xFF698EDE).withOpacity(.1),
                                              thickness: 2,
                                            ),
                                            const SizedBox(
                                              height: 8,
                                            ),
                                            ListView.builder(
                                                shrinkWrap: true,
                                                itemCount: reviewModel!.length,
                                                physics: const NeverScrollableScrollPhysics(),
                                                itemBuilder: (context, index) {
                                                  var reviewList = reviewModel![index];
                                                  return Column(
                                                    children: [
                                                      Row(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          ClipRRect(
                                                            borderRadius: BorderRadius.circular(20),
                                                            child: const SizedBox(
                                                              height: 40,
                                                              width: 40,
                                                              child: Icon(Icons.person),
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            width: 20,
                                                          ),
                                                          Expanded(
                                                            child: Column(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                Padding(
                                                                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                                                                  child: Text(
                                                                    reviewList.userName.toString(),
                                                                    style: GoogleFonts.poppins(
                                                                      color: const Color(0xFF1B233A),
                                                                      fontSize: 16,
                                                                      fontWeight: FontWeight.w600,
                                                                    ),
                                                                  ),
                                                                ),
                                                                const SizedBox(
                                                                  height: 6,
                                                                ),
                                                                RatingBar.builder(
                                                                  initialRating: reviewList.fullRating,
                                                                  minRating: 1,
                                                                  unratedColor: const Color(0xff3B5998).withOpacity(.2),
                                                                  itemCount: 5,
                                                                  itemSize: 16.0,
                                                                  itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                                                                  updateOnDrag: true,
                                                                  itemBuilder: (context, index) => Image.asset(
                                                                    'assets/icons/star.png',
                                                                    color: const Color(0xff3B5998),
                                                                  ),
                                                                  onRatingUpdate: (ratingvalue) {
                                                                    null;
                                                                  },
                                                                ),
                                                                const SizedBox(
                                                                  height: 8,
                                                                ),
                                                                Padding(
                                                                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                                                                  child: RichText(
                                                                    text: TextSpan(children: [
                                                                      TextSpan(
                                                                          text: reviewList.about,
                                                                          style: GoogleFonts.poppins(
                                                                            color: const Color(0xFF969AA3),
                                                                            fontSize: 14,
                                                                            fontWeight: FontWeight.w300,
                                                                          )),
                                                                      // TextSpan(
                                                                      //     text: 'read more',
                                                                      //     style: GoogleFonts.poppins(
                                                                      //         fontSize: 14,
                                                                      //         fontWeight: FontWeight.w400,
                                                                      //         color: const Color(0xFF567DF4)))
                                                                    ]),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          // const Spacer(),
                                                          Padding(
                                                            padding: const EdgeInsets.symmetric(vertical: 3.0),
                                                            child: Text(
                                                              DateFormat.yMMMd().format(DateTime.parse(
                                                                  DateTime.fromMillisecondsSinceEpoch(int.parse(reviewList.time))
                                                                      .toString())),
                                                              style: const TextStyle(
                                                                color: Color(0xFF969AA3),
                                                                fontSize: 12,
                                                                fontWeight: FontWeight.w400,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                      index != 2
                                                          ? Divider(
                                                              color: const Color(0xFF698EDE).withOpacity(.1),
                                                              thickness: 2,
                                                            )
                                                          : const SizedBox(),
                                                      const SizedBox(
                                                        height: 12,
                                                      ),
                                                    ],
                                                  );
                                                })
                                          ]),
                                    )
                              ],
                            )),
                      ),
                      if (currentMenu == 1)
                        Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                                width: size.width,
                                padding: const EdgeInsets.all(14),
                                decoration:
                                    BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), boxShadow: [
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
                                        "Buy As a Bundle and save",
                                        style: GoogleFonts.poppins(
                                            fontSize: 16, fontWeight: FontWeight.w500, color: const Color(0xFF1E2538)),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        "20% Discount ",
                                        style: GoogleFonts.poppins(
                                            fontStyle: FontStyle.italic,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            color: const Color(0xFF3B5998)),
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
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Image.asset(
                                              AppAssets.roll,
                                              height: 60,
                                              width: 80,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(left: 15),
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "Salad veggie",
                                                    style: GoogleFonts.poppins(
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.w400,
                                                        color: const Color(0xFF1E2538)),
                                                  ),
                                                  const SizedBox(
                                                    height: 3,
                                                  ),
                                                  Text(
                                                    "Lorem ipsum Dollar",
                                                    style: GoogleFonts.poppins(
                                                        fontSize: 10,
                                                        fontWeight: FontWeight.w300,
                                                        color: const Color(0xFF74848C)),
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  SizedBox(
                                                    // width: size.width,
                                                    height: 23,

                                                    child: ElevatedButton(
                                                      onPressed: () {},
                                                      style: ElevatedButton.styleFrom(
                                                          backgroundColor: const Color(0xFF3B5998),
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.circular(3),
                                                              side: const BorderSide(
                                                                width: 2.0,
                                                                color: Color(0xFF3B5998),
                                                              )),
                                                          textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                                                      child: Text(
                                                        "ADD TO CART",
                                                        style: GoogleFonts.poppins(
                                                          fontSize: 10,
                                                          fontWeight: FontWeight.w500,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const Spacer(),
                                            Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                                              Text(
                                                "\$10.00",
                                                style: GoogleFonts.poppins(
                                                    fontSize: 14,
                                                    // fontWeight: FontWeight.w400,
                                                    color: const Color(0xFF1E2538)),
                                              ),
                                            ])
                                          ])
                                    ]))),
                      if (currentMenu == 1)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    if (menuList!.where((e) => e.qty > 0).map((e) => e.toMap()).toList().isNotEmpty) {
                                      FirebaseAuth _auth = FirebaseAuth.instance;
                                      User? user = _auth.currentUser;
                                      if (user != null) {
                                        manageCheckOut(widget.restaurantItem!.docid).then((value) {
                                          Get.to(() => const CartScreen());
                                        });
                                      } else {
                                        Get.to(() => LoginScreen());
                                      }
                                    } else {
                                      showToast("Please select menu");
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: AppTheme.primaryColor,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8),
                                          side: const BorderSide(
                                            width: 2.0,
                                            color: AppTheme.primaryColor,
                                          )),
                                      textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                                  child: Text(
                                    "Checkout".toUpperCase(),
                                    style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ]),
                const SizedBox(
                  height: 20,
                )
              ]).appPaddingForScreen)
            : const SizedBox.shrink());
  }
}
