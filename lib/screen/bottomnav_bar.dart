import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:resvago_customer/screen/delivery_screen.dart';
import 'package:resvago_customer/screen/homepage.dart';
import 'package:resvago_customer/screen/oder_screen.dart';
import 'package:resvago_customer/screen/profile_screen.dart';

import '../controller/bottomnavbar_controller.dart';

import '../widget/appassets.dart';
import '../widget/apptheme.dart';

class BottomNavbar extends StatefulWidget {
  const BottomNavbar({Key? key}) : super(key: key);

  @override
  State<BottomNavbar> createState() => _BottomNavbarState();
}

class _BottomNavbarState extends State<BottomNavbar> {
  final bottomController = Get.put(BottomNavBarController());

  final pages = [
    const HomePage(),
    const DeliveryScreen(),
    const OderScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        body: pages.elementAt(bottomController.pageIndex.value),
        extendBody: true,
        backgroundColor: Colors.white,
        bottomNavigationBar: buildMyNavBar(context),
      );
    });
  }

  buildMyNavBar(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: double.maxFinite,
          decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                offset: Offset(0.0, 1.0), //(x,y)
                blurRadius: 6.0,
              ),
            ],
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(0),
              topRight: Radius.circular(0),
            ),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: MaterialButton(
                      padding: const EdgeInsets.only(bottom: 10),
                      onPressed: () {
                        bottomController.updateIndexValue(0);
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 8,
                          ),
                          bottomController.pageIndex.value == 0
                              ? SvgPicture.asset(
                                  AppAssets.dining,
                                  color: Color(0xFFFAAF40),
                                )
                              : SvgPicture.asset(AppAssets.dining),
                          const SizedBox(
                            height: 5,
                          ),
                          bottomController.pageIndex.value == 0
                              ? const Text(
                                  "Dining",
                                  style: TextStyle(color: Color(0xFFFAAF40), fontSize: 15, fontWeight: FontWeight.w400),
                                )
                              : const Text(
                                  "Dining",
                                  style: TextStyle(color: Color(0xFF4E5B5F), fontSize: 15, fontWeight: FontWeight.w400),
                                )
                        ],
                      ),
                    ),
                  ),
                  Flexible(
                    child: MaterialButton(
                      padding: const EdgeInsets.only(bottom: 10),
                      onPressed: () {
                        bottomController.updateIndexValue(1);
                      },
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 8,
                          ),
                          bottomController.pageIndex.value == 1
                              ? SvgPicture.asset(AppAssets.delivery, color: Color(0xFFFAAF40))
                              : SvgPicture.asset(
                                  AppAssets.delivery,
                                  color: Colors.black,
                                ),
                          const SizedBox(
                            height: 5,
                          ),
                          bottomController.pageIndex.value == 1
                              ? const Text(
                                  "Delivery",
                                  style: TextStyle(color: Color(0xFFFAAF40), fontSize: 15, fontWeight: FontWeight.w400),
                                )
                              : const Text(
                                  "Delivery",
                                  style: TextStyle(color: Color(0xFF4E5B5F), fontSize: 15, fontWeight: FontWeight.w400),
                                )
                        ],
                      ),
                    ),
                  ),
                  Flexible(
                    child: MaterialButton(
                      padding: const EdgeInsets.only(bottom: 10),
                      onPressed: () {
                        bottomController.updateIndexValue(2);
                      },
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 8,
                          ),
                          bottomController.pageIndex.value == 2
                              ? SvgPicture.asset(AppAssets.oder, color: Color(0xFFFAAF40))
                              : SvgPicture.asset(AppAssets.oder),
                          const SizedBox(
                            height: 5,
                          ),
                          bottomController.pageIndex.value == 2
                              ? const Text(
                                  "Oders",
                                  style: TextStyle(color: Color(0xFFFAAF40), fontSize: 15, fontWeight: FontWeight.w400),
                                )
                              : const Text(
                                  "Oders",
                                  style: TextStyle(color: Color(0xFF4E5B5F), fontSize: 15, fontWeight: FontWeight.w400),
                                )
                        ],
                      ),
                    ),
                  ),
                  Flexible(
                    child: MaterialButton(
                      padding: const EdgeInsets.only(bottom: 10),
                      onPressed: () {
                        bottomController.updateIndexValue(3);
                      },
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 8,
                          ),
                          bottomController.pageIndex.value == 3
                              ? SvgPicture.asset(AppAssets.profile, color: Color(0xFFFAAF40))
                              : SvgPicture.asset(AppAssets.profile),
                          const SizedBox(
                            height: 5,
                          ),
                          bottomController.pageIndex.value == 3
                              ? const Text(
                                  "Profile",
                                  style: TextStyle(color: Color(0xFFFAAF40), fontSize: 15, fontWeight: FontWeight.w400),
                                )
                              : const Text(
                                  "Profile",
                                  style: TextStyle(color: Color(0xFF4E5B5F), fontSize: 15, fontWeight: FontWeight.w400),
                                )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
