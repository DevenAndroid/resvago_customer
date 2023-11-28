import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:resvago_customer/screen/delivery_screen.dart';
import 'package:resvago_customer/screen/helper.dart';
import 'package:resvago_customer/screen/homepage.dart';
import 'package:resvago_customer/screen/profile_screen.dart';
import 'package:resvago_customer/screen/wishlist_screen.dart';

import '../controller/bottomnavbar_controller.dart';

import '../controller/profile_controller.dart';
import '../model/profile_model.dart';
import '../model/resturant_model.dart';
import '../routers/routers.dart';
import '../widget/appassets.dart';
import '../widget/apptheme.dart';
import 'delivery_screen/delivery_restaurnt_screen.dart';
import 'login_screen.dart';
import 'myAddressList.dart';
import 'order/myorder_screen.dart';

class BottomNavbar extends StatefulWidget {
  const BottomNavbar({Key? key}) : super(key: key);

  @override
  State<BottomNavbar> createState() => _BottomNavbarState();
}

class _BottomNavbarState extends State<BottomNavbar> {
  final bottomController = Get.put(BottomNavBarController());
  final profileController = Get.put(ProfileController());
  final pages = [
    const HomePage(),
    const DeliveryPage(),
    const MyOrder(),
    const ProfileScreen(),
  ];

  updateFCMToken() async {
    print("updated............");
    try {
      String? fcm = await FirebaseMessaging.instance.getToken();
      FirebaseDatabase firebaseDatabase = FirebaseDatabase.instance;
      print("updated............     $fcm");
      final ref = firebaseDatabase.ref("users/${FirebaseAuth.instance.currentUser!.uid.toString()}");
      await ref.update({fcm.toString(): fcm.toString()}).then((value) {
        print("updated............");
      }).catchError((e) {
        print("updated............    $e");
      });
      print("updated............");
    } catch (e) {
      print("updated............    $e");
      throw Exception(e);
    }
  }

  ProfileData profileData = ProfileData();
  void getProfileData() {
    FirebaseAuth _auth = FirebaseAuth.instance;
    User? user = _auth.currentUser;
    if (user != null) {
      FirebaseFirestore.instance.collection("customer_users").doc(FirebaseAuth.instance.currentUser!.uid).get().then((value) {
        if (value.exists) {
          if (value.data() == null) return;
          profileData = ProfileData.fromJson(value.data()!);
          setState(() {});
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    // updateFCMToken();
    FirebaseAuth _auth = FirebaseAuth.instance;
    User? user = _auth.currentUser;
    if (user != null) {
      getProfileData();
      profileController.getProfileData();
    }
  }
   RestaurantModel? restaurantModel;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Obx(() {
      return Scaffold(
        key: bottomController.scaffoldKey,
        drawer: SizedBox(
          width: kIsWeb ? 300 : MediaQuery.of(context).size.width * 0.7,
          child: Drawer(
              child: Container(
            // width: MediaQuery.of(context).size.width * 0.8,
            color: AppTheme.backgroundcolor,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: <Widget>[
                  Container(
                    height: size.height * 0.30,
                    width: size.width,
                    color: AppTheme.primaryColor,
                    child: Column(
                      children: [
                        SizedBox(
                          height: size.height * 0.05,
                        ),
                        GestureDetector(
                          onTap: () {
                            // Get.to(navigationPage.elementAt(_currentPage))
                            // Get.to(MyProfile());
                          },
                          child: Card(
                            elevation: 1,
                            shape: const CircleBorder(),
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            child: SizedBox(
                              height: 100,
                              width: 100,
                              child: Container(
                                decoration:
                                    BoxDecoration(border: Border.all(color: Colors.white, width: 2), shape: BoxShape.circle),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: Obx(() {
                                    if (profileController.refreshInt.value > 0) {}
                                    return CachedNetworkImage(
                                      fit: BoxFit.cover,
                                      imageUrl: profileController.profileData != null ? profileController.profileData!.profile_image.toString() : "",
                                      errorWidget: (_, __, ___) => const Icon(Icons.person),
                                      placeholder: (_, __) => const SizedBox(),
                                    );
                                  }),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: size.height * 0.01,
                        ),
                        Text(profileData.userName ?? "",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(fontSize: 18, color: Colors.white, fontWeight: FontWeight.w600)),
                        Text(profileData.email ?? "",
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.w400)),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Column(
                    children: [
                      drawerTile(
                          active: true,
                          title: "My Orders".tr,
                          icon: const ImageIcon(
                            AssetImage(AppAssets.order),
                            size: 22,
                            color: AppTheme.drawerColor,
                          ),
                          onTap: () {
                            FirebaseAuth _auth = FirebaseAuth.instance;
                            User? user = _auth.currentUser;
                            if (user != null) {
                              bottomController.updateIndexValue(2);
                              Get.back();
                            } else {
                              Get.to(() => LoginScreen());
                            }
                          }),
                      const Divider(
                        height: 5,
                        color: Color(0xffF2F2F2),
                      ),
                      drawerTile(
                          active: true,
                          title: "My Profile".tr,
                          icon: const ImageIcon(
                            AssetImage(AppAssets.profilee),
                            size: 22,
                            color: AppTheme.drawerColor,
                          ),
                          onTap: () async {
                            FirebaseAuth _auth = FirebaseAuth.instance;
                            User? user = _auth.currentUser;
                            if (user != null) {
                              bottomController.updateIndexValue(3);
                              Get.back();
                            } else {
                              Get.to(() => LoginScreen());
                            }
                          }),
                      const Divider(
                        height: 5,
                        color: Color(0xffF2F2F2),
                      ),
                      drawerTile(
                          active: true,
                          title: "Notification".tr,
                          icon: const ImageIcon(
                            AssetImage(AppAssets.notification),
                            size: 22,
                            color: AppTheme.drawerColor,
                          ),
                          onTap: () {
                            Get.toNamed(MyRouters.notification);
                          }),
                      const Divider(
                        height: 5,
                        color: Color(0xffF2F2F2),
                      ),
                      drawerTile(
                          active: true,
                          title: "My Address".tr,
                          icon: const ImageIcon(
                            AssetImage(AppAssets.myAddress),
                            size: 22,
                            color: AppTheme.drawerColor,
                          ),
                          onTap: () {
                            FirebaseAuth _auth = FirebaseAuth.instance;
                            User? user = _auth.currentUser;
                            if (user != null) {
                              Get.to(() => MyAddressList());
                            } else {
                              Get.to(() => LoginScreen());
                            }
                            // Get.back();
                            // widget.onItemTapped(1);
                          }),
                      const Divider(
                        height: 5,
                        color: Color(0xffF2F2F2),
                      ),
                      drawerTile(
                          active: true,
                          title: "My Wishlist".tr,
                          icon: const ImageIcon(
                            AssetImage(AppAssets.myAddress),
                            size: 22,
                            color: AppTheme.drawerColor,
                          ),
                          onTap: () {
                            FirebaseAuth _auth = FirebaseAuth.instance;
                            User? user = _auth.currentUser;
                            if (user != null) {
                              Get.to(() => WishlistScreen());
                            } else {
                              Get.to(() => LoginScreen());
                            }
                            // Get.back();
                            // widget.onItemTapped(1);
                          }),
                      const Divider(
                        height: 5,
                        color: Color(0xffF2F2F2),
                      ),
                      drawerTile(
                          active: true,
                          title: "Privacy Policy".tr,
                          icon: const ImageIcon(
                            AssetImage(AppAssets.privacyPolicy),
                            size: 22,
                            color: AppTheme.drawerColor,
                          ),
                          onTap: () async {
                            Get.toNamed(MyRouters.privacyPolicyScreen);

                            // }
                          }),
                      const Divider(
                        height: 5,
                        color: Color(0xffF2F2F2),
                      ),
                      drawerTile(
                          active: true,
                          title: "Help Center".tr,
                          icon: const ImageIcon(
                            AssetImage(AppAssets.helpCenter),
                            size: 22,
                            color: AppTheme.drawerColor,
                          ),
                          onTap: () async {
                            Get.toNamed(MyRouters.helpCenterScreen);
                            // }
                          }),
                      const Divider(
                        height: 5,
                        color: Color(0xffF2F2F2),
                      ),
                      drawerTile(
                          active: true,
                          title: "Logout".tr,
                          icon: const ImageIcon(
                            AssetImage(AppAssets.logOut),
                            size: 22,
                            color: AppTheme.drawerColor,
                          ),
                          onTap: () async {
                            await FirebaseAuth.instance.signOut();
                            Get.offAll(const LoginScreen());
                          }),
                    ],
                  ),
                  // SizedBox(height:20,)
                ],
              ),
            ),
          )),
        ),
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
                          const SizedBox(
                            height: 8,
                          ),
                          bottomController.pageIndex.value == 0
                              ? SvgPicture.asset(
                                  AppAssets.dining,
                                  color: const Color(0xFFFAAF40),
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
                              ? SvgPicture.asset(AppAssets.delivery, color: const Color(0xFFFAAF40))
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
                        FirebaseAuth _auth = FirebaseAuth.instance;
                        User? user = _auth.currentUser;
                        if (user != null) {
                          bottomController.updateIndexValue(2);
                        } else {
                          Get.to(() => LoginScreen());
                        }
                      },
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 8,
                          ),
                          bottomController.pageIndex.value == 2
                              ? SvgPicture.asset(AppAssets.oder, color: const Color(0xFFFAAF40))
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
                        FirebaseAuth _auth = FirebaseAuth.instance;
                        User? user = _auth.currentUser;
                        if (user != null) {
                          bottomController.updateIndexValue(3);
                        } else {
                          Get.to(() => LoginScreen());
                        }
                      },
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 8,
                          ),
                          bottomController.pageIndex.value == 3
                              ? SvgPicture.asset(AppAssets.profile, color: const Color(0xFFFAAF40))
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
              ).appPaddingForScreen,
            ],
          ),
        ),
      ],
    );
  }
}
