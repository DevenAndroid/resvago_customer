import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:resvago_customer/widget/appassets.dart';

import '../widget/apptheme.dart';

class MyOrder extends StatefulWidget {
  const MyOrder({super.key});

  @override
  State<MyOrder> createState() => _MyOrderState();
}

class _MyOrderState extends State<MyOrder> {
  var currentDrawer = 0;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return DefaultTabController(
        length: 3,
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.white,
              leading: InkWell(
                onTap: () {
                  Get.back();
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 13.0),
                  child: SvgPicture.asset("assets/images/back.svg"),
                ),
              ),
              elevation: 1,
              title: Text(
                "My Orders",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 13.0),
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: Colors.white,
                        border: Border.all(
                          color: Color(0xff363539).withOpacity(.1),
                        )),
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
                ),
              ],
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
                      "Active",
                      style: currentDrawer == 0
                          ? GoogleFonts.poppins(color: const Color(0xff1A2E33), fontSize: 16, fontWeight: FontWeight.w500)
                          : GoogleFonts.poppins(color: AppTheme.primaryColor, fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ),
                  Tab(
                    child: Text(
                      "Completed",
                      style: currentDrawer == 1
                          ? GoogleFonts.poppins(color: Colors.cyan, fontSize: 16, fontWeight: FontWeight.w500)
                          : GoogleFonts.poppins(color: Color(0xff1A2E33), fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ),
                  Tab(
                    child: Text(
                      "Cancelled",
                      style: currentDrawer == 1
                          ? GoogleFonts.poppins(color: Colors.cyan, fontSize: 16, fontWeight: FontWeight.w500)
                          : GoogleFonts.poppins(color: Color(0xff1A2E33), fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),

            body: TabBarView(children: [

              Container(
                height: size.height * .6,
                margin: EdgeInsets.only( top: 18, ),
                decoration: BoxDecoration(
                  color: const Color(0xffFFFFFF),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
               Image.asset(AppAssets.orderEmpty),
                    Text('Empty',style: GoogleFonts.poppins(
                      fontSize: 18,fontWeight: FontWeight.w500
                    ),),
                    Text('You do not have an active order of this time',style: GoogleFonts.poppins(
                    fontSize: 15,fontWeight: FontWeight.w400
                    ),),
                  ],
                ),
              ),
            ])));
  }
}
