import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:resvago_customer/model/resturant_model.dart';

import '../../widget/appassets.dart';
import '../../widget/apptheme.dart';
import '../../widget/custom_textfield.dart';

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
    FirebaseFirestore.instance
        .collection("vendor_users")
        .where("category", isEqualTo: widget.category)
        .get()
        .then((value) {
      for (var element in value.docs) {
        var gg = element.data();
        categoryList ??= [];
        log(categoryList.toString());
        categoryList!.add(RestaurantModel.fromJson(gg,element.id.toString()));
      }
      setState(() {});
    });
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
                      hint: 'Find for food or restaurant...',
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
                              child: const Column(
                                children: [Text("Near By"), Divider()],
                              ),
                            ),
                            PopupMenuItem(
                              value: 1,
                              onTap: () {},
                              child: const Column(
                                children: [Text("Rating"), Divider()],
                              ),
                            ),
                            PopupMenuItem(
                              value: 1,
                              onTap: () {},
                              child: const Column(
                                children: [Text("Offers"), Divider()],
                              ),
                            ),
                            PopupMenuItem(
                              value: 1,
                              onTap: () {},
                              child: const Column(
                                children: [
                                  Text("Popular"),
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
            indicatorPadding: EdgeInsets.symmetric(horizontal: 15),
            // automaticIndicatorColorAdjustment: true,
            onTap: (value) {
              currentDrawer = 0;
              setState(() {});
            },
            tabs: [
              Tab(
                child: Text(
                  "Restaurants",
                  style: currentDrawer == 0
                      ? GoogleFonts.poppins(
                          color: const Color(0xff1A2E33),
                          fontSize: 16,
                          fontWeight: FontWeight.w500)
                      : GoogleFonts.poppins(
                          color: AppTheme.primaryColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w500),
                ),
              ),
              Tab(
                child: Text(
                  "Dishes",
                  style: currentDrawer == 1
                      ? GoogleFonts.poppins(
                          color: Colors.cyan,
                          fontSize: 16,
                          fontWeight: FontWeight.w500)
                      : GoogleFonts.poppins(
                          color: Color(0xff1A2E33),
                          fontSize: 16,
                          fontWeight: FontWeight.w500),
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
                        // Get.toNamed(MyRouters.singleProductScreen);
                      },
                      child: Container(
                        margin: EdgeInsets.only(right: 12, top: 18, left: 12),
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
                                    child: Image.asset(
                                      AppAssets.burger,
                                      height: 150,
                                      width: size.width,
                                      fit: BoxFit.cover,
                                    )),
                                Positioned(
                                    top: 11,
                                    right: 10,
                                    child: InkWell(
                                      onTap: () {},
                                      child: Container(
                                        height: 25,
                                        width: 25,
                                        decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.white),
                                        child: const Icon(
                                          Icons.favorite_border,
                                          color: AppTheme.primaryColor,
                                          size: 18,
                                        ),
                                      ),
                                    )),
                              ],
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    // margin: EdgeInsets.all(13),
                                    height: 30,
                                    width: 130,
                                    decoration: BoxDecoration(
                                        color:
                                            Color(0xff3B5998).withOpacity(.3),
                                        // border: Border.all(color: ),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5))),
                                    child: Center(
                                      child: Text(
                                        'South Indian Food',
                                        style: GoogleFonts.poppins(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                            color: AppTheme.primaryColor),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 13,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        categoryList![index].restaurantName,
                                        style: GoogleFonts.poppins(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w400,
                                            color: const Color(0xff08141B)),
                                      ),
                                      Spacer(),
                                      const Icon(
                                        Icons.star,
                                        color: Color(0xffFFC529),
                                        size: 17,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        "4.5",
                                        style: GoogleFonts.poppins(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w300,
                                            color: const Color(0xff08141B)),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        "25 Mins ",
                                        style: GoogleFonts.poppins(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w300,
                                            color: const Color(0xff384953)),
                                      ),
                                      const SizedBox(
                                        width: 3,
                                      ),
                                      const Icon(Icons.circle,
                                          size: 5, color: Color(0xff384953)),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        "1.8 Km",
                                        style: GoogleFonts.poppins(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w300,
                                            color: const Color(0xff384953)),
                                      ),
                                      const SizedBox(
                                        width: 3,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  DottedLine(
                                    dashColor: Color(0xffBCBCBC),
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  Row(
                                    children: [
                                      SvgPicture.asset(
                                        AppAssets.vector,
                                        height: 16,
                                      ),
                                      Text(
                                        "  40% off up to \$100",
                                        style: GoogleFonts.poppins(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                            color: const Color(0xff3B5998)),
                                      ),
                                    ],
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
                    );
                  }),
            ),
            Text('djn'),
            // Icon(Icons.directions_transit, size: 350),
          ],
        ),
      ),
    );
  }
}
