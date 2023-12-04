import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:resvago_customer/controller/location_controller.dart';
import 'package:resvago_customer/model/resturant_model.dart';
import 'package:resvago_customer/screen/single_store_screens/setting_for_restaurant.dart';
import 'package:resvago_customer/screen/single_store_screens/single_restaurants_screen.dart';
import '../../widget/apptheme.dart';
import '../../widget/custom_textfield.dart';
import '../widget/like_button.dart';
import '../widget/restaurant_timing.dart';

class SearchRestaurantScreen extends StatefulWidget {
  final String? category;
  final String? image;
  const SearchRestaurantScreen({super.key, this.category, this.image});

  @override
  State<SearchRestaurantScreen> createState() => _SearchRestaurantScreenState();
}

class _SearchRestaurantScreenState extends State<SearchRestaurantScreen> {
  int currentDrawer = 0;
  List<RestaurantModel> categoryList = [];

  getRestaurantCategories() {
    FirebaseFirestore.instance.collection("vendor_users").where("category", isEqualTo: widget.category).get().then((value) {
      for (var element in value.docs) {
        var gg = element.data();
        log(categoryList.toString());
        categoryList.add(RestaurantModel.fromJson(gg, element.id.toString()));
      }
      setState(() {});
    });
  }

  final locationController = Get.put(LocationController());
  String _calculateDistance({dynamic lat1, dynamic lon1}) {
    if (double.tryParse(lat1) == null ||
        double.tryParse(lon1) == null ||
        double.tryParse(locationController.lat.toString()) == null ||
        double.tryParse(locationController.long.toString()) == null) {
      return "Not Available";
    }

    double distanceInMeters = Geolocator.distanceBetween(double.parse(lat1), double.parse(lon1),
        double.parse(locationController.lat.toString()), double.parse(locationController.long.toString()));
    if ((distanceInMeters / 1000) < 1) {
      return "${distanceInMeters.toInt()} Meter away";
    }
    return "${(distanceInMeters / 1000).toStringAsFixed(2)} KM";
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getRestaurantCategories();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 80,
          automaticallyImplyLeading: false,
          title: Row(
            children: [
              Expanded(
                child: Container(
                    height: 42,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF37C666).withOpacity(0.10),
                            offset: const Offset(
                              .1,
                              .1,
                            ),
                            blurRadius: 20.0,
                            spreadRadius: 1.0,
                          ),
                        ],
                        color: Colors.white),
                    child: CommonTextFieldWidget1(
                      hint: 'Find for food or restaurant...'.tr,
                      // controller: filterDataController.storeSearchController,
                      prefix: InkWell(
                        onTap: () {},
                        child: Icon(
                          Icons.search,
                          size: 19,
                          color: const Color(0xFF000000).withOpacity(0.56),
                        ),
                      ),
                      onChanged: (val) {},
                    )),
              ),
              const SizedBox(
                width: 10,
              ),
              Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: Colors.white,
                ),
                child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: PopupMenuButton<int>(
                        padding: EdgeInsets.zero,
                        icon: const Icon(
                          Icons.filter_list_sharp,
                          color: AppTheme.primaryColor,
                        ),
                        color: Colors.white,
                        surfaceTintColor: Colors.white,
                        itemBuilder: (context) {
                          return [
                            PopupMenuItem(
                              value: 1,
                              onTap: () {},
                              child:  Column(
                                children: [Text("Near By".tr), Divider()],
                              ),
                            ),
                            PopupMenuItem(
                              value: 1,
                              onTap: () {},
                              child:  Column(
                                children: [Text("Rating".tr), Divider()],
                              ),
                            ),
                            PopupMenuItem(
                              value: 1,
                              onTap: () {},
                              child:  Column(
                                children: [Text("Offers".tr), Divider()],
                              ),
                            ),
                            PopupMenuItem(
                              value: 1,
                              onTap: () {},
                              child:  Column(
                                children: [
                                  Text("Popular".tr),
                                  Divider(
                                    color: Colors.white,
                                  )
                                ],
                              ),
                            ),
                          ];
                        })),
              ),
            ],
          ),
          bottom: TabBar(
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorColor: AppTheme.primaryColor,
            indicatorPadding: const EdgeInsets.symmetric(horizontal: 15),
            // automaticIndicatorColorAdjustment: true,
            onTap: (value) {
              currentDrawer = 0;
              setState(() {});
            },
            tabs: [
              Tab(
                child: Text(
                  "Restaurants".tr,
                  style: currentDrawer == 0
                      ? GoogleFonts.poppins(color: const Color(0xff1A2E33), fontSize: 16, fontWeight: FontWeight.w500)
                      : GoogleFonts.poppins(color: AppTheme.primaryColor, fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ),
              Tab(
                child: Text(
                  "Dishes".tr,
                  style: currentDrawer == 1
                      ? GoogleFonts.poppins(color: Colors.cyan, fontSize: 16, fontWeight: FontWeight.w500)
                      : GoogleFonts.poppins(color: const Color(0xff1A2E33), fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            SizedBox(
              height: 260,
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: categoryList.length,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Get.to(() => SingleRestaurantsScreen(
                              restaurantItem: categoryList[index],
                            ));
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Container(
                          margin: const EdgeInsets.only(right: 12, left: 12),
                          decoration: BoxDecoration(
                            color: const Color(0xffFFFFFF),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Stack(
                                children: [
                                  ClipRRect(
                                      borderRadius: const BorderRadius.only(
                                        topRight: Radius.circular(10),
                                        topLeft: Radius.circular(10),
                                      ),
                                      child: Image.network(
                                        categoryList[index].image.toString(),
                                        height: 150,
                                        width: size.width,
                                        fit: BoxFit.cover,
                                      )),
                                  Positioned(
                                      top: 0,
                                      right: 0,
                                      child: LikeButtonWidget(
                                        restaurantModel: categoryList[index],
                                      )),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 15),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: 30,
                                      // width: 130,
                                      decoration: BoxDecoration(
                                          color: const Color(0xff8facea).withOpacity(.2),
                                          borderRadius: const BorderRadius.all(Radius.circular(5))),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                        child: Text(
                                          categoryList[index].category ?? "",
                                          style: GoogleFonts.poppins(
                                              fontSize: 12, fontWeight: FontWeight.w500, color: AppTheme.primaryColor),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          categoryList[index].restaurantName ?? "",
                                          style: GoogleFonts.poppins(
                                              fontSize: 15, fontWeight: FontWeight.w400, color: const Color(0xff08141B)),
                                        ),
                                        const Spacer(),
                                        MaxRatingScreen(docId: categoryList[index].docid)
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      children: [
                                        PreparationTimeScreen(docId: categoryList[index].docid),
                                        const SizedBox(
                                          width: 3,
                                        ),
                                        const Icon(Icons.circle, size: 5, color: Color(0xff384953)),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          _calculateDistance(
                                            lat1: categoryList[index].latitude.toString(),
                                            lon1: categoryList[index].longitude.toString(),
                                          ),
                                          style: GoogleFonts.poppins(
                                              fontSize: 14, fontWeight: FontWeight.w400, color: const Color(0xff384953)),
                                        ),
                                        const SizedBox(
                                          width: 3,
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
                                      children: [MaxDiscountScreen(docId: categoryList[index].docid)],
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
            ),
             Text('djn'.tr),
            // Icon(Icons.directions_transit, size: 350),
          ],
        ),
      ),
    );
  }
}
