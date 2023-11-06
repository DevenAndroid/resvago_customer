import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:resvago_customer/widget/appassets.dart';

import '../widget/apptheme.dart';

class CustomDrawer extends StatefulWidget {
  // final void Function(int index) onItemTapped;

  const CustomDrawer({
    Key? key,
  }) : super(key: key);

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  final RxBool _isValue = false.obs;
  final RxBool _isValue1 = false.obs;
  var vendor = [
    'Dashboard'.tr,
    'Order'.tr,
    'Products'.tr,
    'Store open time'.tr,
    'Vendor Information'.tr,
    'Bank Details'.tr,
    'Withdraw'.tr
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Drawer(
        child: Obx(() {
          return Container(
            color: AppTheme.backgroundcolor,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: <Widget>[
                  Container(
                    height: screenSize.height * 0.30,
                    width: screenSize.width,
                    color: AppTheme.primaryColor.withOpacity(.80),
                    child: Column(
                      children: [
                        SizedBox(
                          height: screenSize.height * 0.05,
                        ),
                        GestureDetector(
                          onTap: () {
                            // Get.to(navigationPage.elementAt(_currentPage))
                            // Get.to(MyProfile());
                          },
                          child: Card(
                              elevation: 3,
                              shape: const CircleBorder(),
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              child: Container(
                                  margin: const EdgeInsets.all(4),
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  decoration: const ShapeDecoration(
                                    shape: CircleBorder(),
                                    color: Colors.white,
                                  ),
                                  child: Image.asset(AppAssets.pasta)
                                  //         CachedNetworkImage(
                                  //     imageUrl:
                                  //     profileController.isDataLoading.value
                                  //     ? (profileController.model.value.data!
                                  //         .profileImage ??
                                  //         "")
                                  //         .toString()
                                  //       : "",
                                  //   height: screenSize.height * 0.12,
                                  //   width: screenSize.height * 0.12,
                                  //   errorWidget: (_, __, ___) => const SizedBox(),
                                  //   placeholder: (_, __) => const SizedBox(),
                                  //   fit: BoxFit.cover,
                                  // )
                                  )),
                        ),
                        SizedBox(
                          height: screenSize.height * 0.02,
                        ),
                        const Text("",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.w500)),
                        const Text('',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.w400)),
                        const SizedBox(
                            // height: SizeConfig.heightMultiplier! * 1.8,
                            ),
                      ],
                    ),
                  ),
                  const SizedBox(
                      // height: SizeConfig.heightMultiplier! * .5,
                      ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      children: [
                        _drawerTile(
                            active: true,
                            title: "My Orders".tr,
                            icon: const ImageIcon(
                              AssetImage(AppAssets.pasta),
                              size: 22,
                              color: AppTheme.primaryColor,
                            ),
                            onTap: () {}),
                        const Divider(
                          height: 1,
                        ),
                        _drawerTile(
                            active: true,
                            title: "My Profile".tr,
                            icon: const ImageIcon(
                              AssetImage(AppAssets.pasta),
                              size: 22,
                              color: AppTheme.primaryColor,
                            ),
                            onTap: () async {
                              // Get.toNamed(MyProfileScreen.myProfileScreen);
                            }),
                        const Divider(
                          height: 1,
                        ),
                        _drawerTile(
                            active: true,
                            title: "Notification".tr,
                            icon: const ImageIcon(
                              AssetImage(AppAssets.pasta),
                              size: 22,
                              color: AppTheme.primaryColor,
                            ),
                            onTap: () {
                              // SharedPreferences pref =
                              //     await SharedPreferences.getInstance();
                              // if (pref.getString('user') != null) {
                              //   Get.back();
                              //   // Get.toNamed(MyRouter.addressScreen);
                              // } else {
                              //   Get.back();
                              // Get.toNamed(NotificationScreen.notificationScreen);
                              // }
                            }),
                        const Divider(
                          height: 1,
                        ),
                        _drawerTile(
                            active: true,
                            title: "My Address".tr,
                            icon: const ImageIcon(
                              AssetImage(AppAssets.pasta),
                              size: 22,
                              color: AppTheme.primaryColor,
                            ),
                            onTap: () {
                              // Get.toNamed(MyAddress.myAddressScreen);
                              // Get.back();
                              // widget.onItemTapped(1);
                            }),
                        const Divider(
                          height: 1,
                        ),
                        // _drawerTile(
                        //     active: true,
                        //     title: "Wishlist",
                        //     icon:  ImageIcon(
                        //       Icon(Icons.favorite_border),
                        //       size: 22,
                        //       // color: AppTheme.primaryColor,
                        //     ),
                        //     onTap: () async {
                        //       // SharedPreferences pref =
                        //       //     await SharedPreferences.getInstance();
                        //       // if (pref.getString('user') != null) {
                        //       //   Get.back();
                        //       //   // Get.toNamed(MyRouter.notificationScreen,
                        //       //   //     arguments: [savedLanguage.toString()]);
                        //       // } else {
                        //       //   Get.back();
                        //       Get.toNamed(ReferAndEarn.referAndEarnScreen);
                        //       // }
                        //     }),
                        Padding(
                          padding: const EdgeInsets.only(right: 15, top: 15, bottom: 12, left: 15),
                          child: InkWell(
                            onTap: () {
                              // Get.toNamed(WishListScreen.wishListScreen);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                // SizedBox(height: 10,),
                                const Icon(
                                  Icons.favorite_border,
                                  color: AppTheme.primaryColor,
                                ),
                                const SizedBox(
                                  width: 25,
                                ),
                                Text(
                                  "Wishlist".tr,
                                  style: GoogleFonts.ibmPlexSansArabic(color: AppTheme.primaryColor, fontSize: 15),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const Divider(
                          height: 1,
                        ),

                        _drawerTile(
                            active: true,
                            title: "Privacy Policy".tr,
                            icon: const ImageIcon(
                              AssetImage(AppAssets.pasta),
                              size: 22,
                              color: AppTheme.primaryColor,
                            ),
                            onTap: () async {
                              // Get.toNamed(PrivacyPolicy.privacyPolicyScreen);
                              // }
                            }),
                        const Divider(
                          height: 1,
                        ),
                        _drawerTile(
                            active: true,
                            title: "Help Center".tr,
                            icon: const ImageIcon(
                              AssetImage(AppAssets.pasta),
                              size: 22,
                              color: AppTheme.primaryColor,
                            ),
                            onTap: () async {
                              // Get.toNamed(HelpCenter.helpCenterScreen);
                              // }
                            }),
                        const Divider(
                          height: 1,
                        ),
                        _drawerTile(
                            active: true,
                            title: "Logout".tr,
                            icon: const ImageIcon(
                              AssetImage(AppAssets.pasta),
                              size: 22,
                              color: AppTheme.primaryColor,
                            ),
                            onTap: () {}),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _drawerTile({required bool active, required String title, required ImageIcon icon, required VoidCallback onTap}) {
    return ListTile(
      selectedTileColor: AppTheme.primaryColor,
      leading: icon,
      minLeadingWidth: 30,
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          color: AppTheme.primaryColor,
          fontWeight: FontWeight.w400,
        ),
      ),
      onTap: active ? onTap : null,
    );
  }
}
