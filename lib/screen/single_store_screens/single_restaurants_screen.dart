import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:resvago_customer/model/menu_model.dart';
import 'package:resvago_customer/screen/single_store_screens/setting_for_restaurant.dart';
import 'package:resvago_customer/widget/appassets.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../model/resturant_model.dart';
import '../../widget/addsize.dart';
import '../../widget/apptheme.dart';
import '../../widget/restaurant_timing.dart';
import 'select_date_flow.dart';

class SingleRestaurantsScreen extends StatefulWidget {
  final RestaurantModel? restaurantItem;
  String distance;
  SingleRestaurantsScreen({super.key, required this.restaurantItem, required this.distance});

  @override
  State<SingleRestaurantsScreen> createState() => _SingleRestaurantsScreenState();
}

class _SingleRestaurantsScreenState extends State<SingleRestaurantsScreen> {
  RestaurantModel? get restaurantData => widget.restaurantItem;
  String? get distance => widget.distance;
  double fullRating = 0;
  int currentDrawer = 0;
  int currentMenu = 0;
  int currentStep = 0;
  DateTime today = DateTime.now();

  void _onDaySelected(DateTime day, DateTime focusedDay) {
    setState(() {
      today = day;
    });
  }

  bool value = false;

  final _firestore = FirebaseFirestore.instance;
  List<MenuData>? menuList;
  getMenuList() {
    FirebaseFirestore.instance
        .collection("vendor_menu")
        .where("vendorId", isEqualTo: widget.restaurantItem!.userID)
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

  @override
  void initState() {
    super.initState();
    getMenuList();
    if (widget.restaurantItem != null) {
      log(widget.restaurantItem!.image.toString());
      // getWeekSchedule(widget.restaurantItem!.userID);
    }
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
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: GestureDetector(
                onTap: () {},
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(
                    'assets/images/shoppinbag.png',
                    height: 30,
                  ),
                ),
              ),
            ),
          ],
        ),
        body: widget.restaurantItem != null
            ? SingleChildScrollView(
                child: Column(children: [
                SizedBox(
                  height: 390,
                  child: Stack(children: [
                    Image.network(
                      widget.restaurantItem!.image.toString(),
                      width: size.width,
                      height: size.height * .20,
                      fit: BoxFit.cover,
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
                                      Text(
                                        widget.distance,
                                        style: GoogleFonts.poppins(
                                            fontSize: 12, fontWeight: FontWeight.w400, color: const Color(0xff606573)),
                                      ),
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
                            Positioned(top: 120, bottom: 0, left: 93, child: Center(child: SvgPicture.asset(AppAssets.code))),
                          ]),
                        ],
                      ),
                    ),
                  ]),
                ),
                Column(children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0, right: 12),
                    child: Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            width: size.width,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () {
                                currentDrawer = 0;
                                setState(() {});
                              },
                              style: currentDrawer == 0
                                  ? ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF3B5998),
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8),
                                          side: const BorderSide(
                                            width: 2.0,
                                            color: Color(0xFF3B5998),
                                          )),
                                      primary: const Color(0xFF3B5998),
                                      textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500))
                                  : ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8),
                                          side: const BorderSide(
                                            width: 2.0,
                                            color: Color(0xFF3B5998),
                                          )),
                                      primary: const Color(0xFF3B5998),
                                      textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                              child: Text(
                                "Select Date",
                                style: currentDrawer == 0
                                    ? GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white)
                                    : GoogleFonts.poppins(
                                        fontSize: 15, fontWeight: FontWeight.w600, color: const Color(0xFF3B5998)),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: SizedBox(
                            width: size.width,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () {
                                currentDrawer = 1;
                                setState(() {});
                              },
                              style: currentDrawer == 1
                                  ? ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF3B5998),
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8),
                                          side: const BorderSide(
                                            width: 2.0,
                                            color: Color(0xFF3B5998),
                                          )),
                                      primary: const Color(0xFF3B5998),
                                      textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500))
                                  : ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8),
                                          side: const BorderSide(
                                            width: 2.0,
                                            color: Color(0xFF3B5998),
                                          )),
                                      primary: const Color(0xFF3B5998),
                                      textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                              child: Text("Menu List",
                                  style: currentDrawer == 1
                                      ? GoogleFonts.poppins(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        )
                                      : GoogleFonts.poppins(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          color: const Color(0xFF3B5998),
                                        )),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (currentDrawer == 1)
                    Column(
                      children: [
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
                                    Column(
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
                                                    child: ClipRRect(
                                                      borderRadius: BorderRadius.circular(20),
                                                      child: Image.network(
                                                        widget.restaurantItem!.restaurantImage![index],
                                                        fit: BoxFit.cover,
                                                        width: 100,
                                                        errorBuilder: (context, error, stackTrace) {
                                                          return const SizedBox(
                                                              width: 100,
                                                              child: Icon(
                                                                Icons.error,
                                                                color: Colors.red,
                                                              ));
                                                        },
                                                      ),
                                                    ));
                                              },
                                            ),
                                          ),
                                      ],
                                    ),
                                  if (currentMenu == 1)
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Restaurant Menu",
                                          style: GoogleFonts.poppins(
                                              fontSize: 16, fontWeight: FontWeight.w500, color: const Color(0xFF1E2538)),
                                        ),
                                        const SizedBox(
                                          height: 15,
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
                                                    child: Image.network(
                                                      widget.restaurantItem!.menuGalleryImages![index],
                                                      fit: BoxFit.contain,
                                                    ));
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
                                                              menuListData.dishName.toString(),
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
                                                                    primary: const Color(0xFF3B5998),
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
                                                            const SizedBox(
                                                              height: 15,
                                                            ),
                                                            // DottedLine(
                                                            //   dashColor: Colors.black,
                                                            // )
                                                          ],
                                                        ),
                                                      ),
                                                      const Spacer(),
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
                                                  index != 4
                                                      ? const DottedLine(
                                                          dashColor: Color(0xffBCBCBC),
                                                        )
                                                      : const SizedBox(),
                                                  const SizedBox(
                                                    height: 15,
                                                  ),
                                                ]);
                                              }),
                                      ],
                                    ),
                                  if (currentMenu == 2)
                                    Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Review(5)",
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
                                              itemCount: 3,
                                              physics: const NeverScrollableScrollPhysics(),
                                              itemBuilder: (context, index) {
                                                return Column(
                                                  children: [
                                                    Row(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Image.asset(
                                                          'assets/images/Ellipse 1563.png',
                                                          height: 50,
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
                                                                  'Abhishek Jangid',
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
                                                                initialRating: 4,
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
                                                                  setState(() {
                                                                    fullRating = ratingvalue;
                                                                  });
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
                                                                        text:
                                                                            'It is a long established fact that a reader will be distracted by the readable content of a page when looking...',
                                                                        style: GoogleFonts.poppins(
                                                                          color: const Color(0xFF969AA3),
                                                                          fontSize: 14,
                                                                          fontWeight: FontWeight.w300,
                                                                        )),
                                                                    TextSpan(
                                                                        text: 'read more',
                                                                        style: GoogleFonts.poppins(
                                                                            fontSize: 14,
                                                                            fontWeight: FontWeight.w400,
                                                                            color: const Color(0xFF567DF4)))
                                                                  ]),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        // const Spacer(),
                                                        const Padding(
                                                          padding: EdgeInsets.symmetric(vertical: 3.0),
                                                          child: Text(
                                                            'Oct 23, 2022',
                                                            style: TextStyle(
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
                                        ])
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
                                                            primary: const Color(0xFF3B5998),
                                                            textStyle:
                                                                const TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
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
                      ],
                    ),
                  if (currentDrawer == 0)
                    SelectDateFlowScreen(userId: restaurantData!.docid.toString(),),
                ]),
                const SizedBox(
                  height: 20,
                )
              ]))
            : const SizedBox.shrink());
  }
}
