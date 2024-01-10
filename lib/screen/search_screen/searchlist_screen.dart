import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:resvago_customer/screen/helper.dart';
import '../../model/resturant_model.dart';
import '../../widget/addsize.dart';
import '../../widget/appassets.dart';
import '../../widget/apptheme.dart';
import '../../widget/custom_textfield.dart';
import '../delivery_screen/single_store_delivery_screen.dart';
import '../single_store_screens/single_restaurants_screen.dart';

class SerachListScreen extends StatefulWidget {
  const SerachListScreen({super.key});

  @override
  State<SerachListScreen> createState() => _SerachListScreenState();
}

class _SerachListScreenState extends State<SerachListScreen> {
  String searchQuery = '';
  Stream<List<RestaurantModel>> getRestaurantData() {
    return FirebaseFirestore.instance
        .collection("vendor_users")
        .where("deactivate", isEqualTo: false)
        .snapshots()
        .map((querySnapshot) {
      List<RestaurantModel> menuList = [];
      try {
        for (var doc in querySnapshot.docs) {
          var gg = doc.data();
          menuList.add(RestaurantModel.fromJson(gg, doc.id.toString()));
        }
      } catch (e) {
        throw Exception(e.toString());
      }
      return menuList;
    });
  }

  Stream<List<RestaurantModel>> getDeliveryRestaurantData() {
    return FirebaseFirestore.instance
        .collection("vendor_users")
        .where("deactivate", isEqualTo: false)
        .where("setDelivery", isEqualTo: true)
        .snapshots()
        .map((querySnapshot) {
      List<RestaurantModel> menuList = [];
      try {
        for (var doc in querySnapshot.docs) {
          var gg = doc.data();
          menuList.add(RestaurantModel.fromJson(gg, doc.id.toString()));
        }
      } catch (e) {
        throw Exception(e.toString());
      }
      return menuList;
    });
  }

  List<RestaurantModel> filterRestaurant(List<RestaurantModel> menus, String query) {
    if (query.isEmpty) {
      return menus; // Return all users if the search query is empty
    } else {
      return menus.where((menu) {
        if (menu.category is String) {
          return menu.category.toLowerCase().contains(query.toLowerCase()) |
              menu.restaurantName.toLowerCase().contains(query.toLowerCase());
        }
        return false;
      }).toList();
    }
  }

  String searchKeyword = "";
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          surfaceTintColor: Colors.white,
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          title: Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Row(
              children: [
                InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 13.0),
                    child: SvgPicture.asset("assets/images/back.svg"),
                  ),
                ),
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
                        prefix: InkWell(
                          onTap: () {},
                          child: Icon(
                            Icons.search,
                            size: 19,
                            color: const Color(0xFF000000).withOpacity(0.56),
                          ),
                        ),
                        onChanged: (val) {
                          setState(() {
                            searchQuery = val;
                            log("search-----${searchQuery}");
                          });
                        },
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
                          shadowColor: Colors.white,
                          padding: EdgeInsets.zero,
                          icon: const Icon(
                            Icons.filter_list_sharp,
                            color: Colors.black,
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
          ),
          bottom: const TabBar(
            dividerColor: Colors.grey,
            indicatorSize: TabBarIndicatorSize.tab,
            tabs: [
              Tab(
                child: Text("Dine In"),
              ),
              Tab(
                child: Text("Delivery"),
              ),
            ],
          ),
          // title: Text('Tabs Demo'),
        ),
        body: TabBarView(
          children: [
            StreamBuilder<List<RestaurantModel>>(
              stream: getRestaurantData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return LoadingAnimationWidget.fourRotatingDots(
                    color: AppTheme.primaryColor,
                    size: 40,
                  );
                }
                if (snapshot.hasData) {
                  List<RestaurantModel> menu = snapshot.data ?? [];
                  log(menu.toString());
                  final filteredUsers = filterRestaurant(menu, searchQuery); //
                  return filteredUsers.isNotEmpty
                      ? ListView.builder(
                          itemCount: filteredUsers.length,
                          itemBuilder: (BuildContext context, int index) {
                            var menuItem = filteredUsers[index];
                            return InkWell(
                              onTap: () {
                                Get.to(() => SingleRestaurantsScreen(
                                      restaurantItem: menuItem,
                                    ));
                                FocusManager.instance.primaryFocus!.unfocus();
                              },
                              child: Stack(
                                children: [
                                  Padding(
                                      padding: EdgeInsets.symmetric(vertical: AddSize.size10, horizontal: 15),
                                      child: Row(
                                        children: [
                                          Container(
                                            height: AddSize.size50,
                                            width: AddSize.size50,
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(50), border: Border.all(width: 1)),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(50),
                                              child: CachedNetworkImage(
                                                imageUrl: menuItem.image.toString(),
                                                errorWidget: (_, __, ___) => Padding(
                                                  padding: EdgeInsets.all(8.0),
                                                  child: Image.asset(AppAssets.storeIcon),
                                                ),
                                                placeholder: (_, __) => const SizedBox(),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: AddSize.size15,
                                          ),
                                          Expanded(
                                            child: Text(
                                              menuItem.restaurantName ?? "".toString(),
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w500, fontSize: 18, color: AppTheme.blackcolor),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                        ],
                                      )),
                                ],
                              ),
                            );
                          })
                      : Center(
                          child: Text("Restaurant not found".tr),
                        );
                }
                return const SizedBox.shrink();
              },
            ).appPaddingForScreen,
            StreamBuilder<List<RestaurantModel>>(
              stream: getDeliveryRestaurantData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return LoadingAnimationWidget.fourRotatingDots(
                    color: AppTheme.primaryColor,
                    size: 40,
                  );
                }
                if (snapshot.hasData) {
                  List<RestaurantModel> menu = snapshot.data ?? [];
                  log(menu.toString());
                  final filteredUsers = filterRestaurant(menu, searchQuery); //
                  return filteredUsers.isNotEmpty
                      ? ListView.builder(
                          itemCount: filteredUsers.length,
                          itemBuilder: (BuildContext context, int index) {
                            var menuItem = filteredUsers[index];
                            return InkWell(
                              onTap: () {
                                Get.to(() => SingleRestaurantForDeliveryScreen(
                                      restaurantItem: menuItem,
                                    ));
                                FocusManager.instance.primaryFocus!.unfocus();
                              },
                              child: Stack(
                                children: [
                                  Padding(
                                      padding: EdgeInsets.symmetric(vertical: AddSize.size10, horizontal: 15),
                                      child: Row(
                                        children: [
                                          Container(
                                            height: AddSize.size50,
                                            width: AddSize.size50,
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(50), border: Border.all(width: 1)),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(50),
                                              child: CachedNetworkImage(
                                                imageUrl: menuItem.image.toString(),
                                                errorWidget: (_, __, ___) => Padding(
                                                  padding: EdgeInsets.all(8.0),
                                                  child: Image.asset(AppAssets.storeIcon),
                                                ),
                                                placeholder: (_, __) => const SizedBox(),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: AddSize.size15,
                                          ),
                                          Expanded(
                                            child: Text(
                                              menuItem.restaurantName ?? "".toString(),
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w500, fontSize: 18, color: AppTheme.blackcolor),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                        ],
                                      )),
                                ],
                              ),
                            );
                          })
                      : SizedBox.shrink();
                }
                return const SizedBox.shrink();
              },
            ).appPaddingForScreen,
            // StreamBuilder(
            //   stream: FirebaseFirestore.instance
            //       .collection('vendor_users')
            //       .where("deactivate", isEqualTo: false)
            //       .where("setDelivery", isEqualTo: true)
            //       .where('category', isGreaterThanOrEqualTo: searchKeyword)
            //       .where('category', isLessThan: '${searchKeyword}z')
            //       .snapshots(),
            //   builder: (context, snapshot) {
            //     if (snapshot.hasData) {
            //       var products = snapshot.data!.docs;
            //       List<String> kk = products.map((e) => e.data()['category'].toString()).toList().toSet().toList();
            //       List<String> image = products.map((e) => e.data()['image'].toString()).toList().toSet().toList();
            //       print(products);
            //       return ListView.builder(
            //         itemCount: kk.length,
            //         itemBuilder: (context, index) {
            //           var product = kk[index];
            //           return GestureDetector(
            //             onTap: () {
            //               Get.to(SearchRestaurantScreen(
            //                 category: product,
            //               ));
            //             },
            //             child: ListTile(
            //               title: Text(product),
            //               leading: CircleAvatar(
            //                 backgroundImage: NetworkImage(image[index]),
            //               ),
            //             ),
            //           );
            //         },
            //       );
            //     }
            //     return const Center(child: CircularProgressIndicator());
            //   },
            // ).appPaddingForScreen,
            // StreamBuilder(
            //   stream: FirebaseFirestore.instance
            //       .collection('vendor_users')
            //       .where("deactivate", isEqualTo: false)
            //       .where('category', isGreaterThanOrEqualTo: searchKeyword)
            //       .where('category', isLessThan: '${searchKeyword}z')
            //       .snapshots(),
            //   builder: (context, snapshot) {
            //     if (snapshot.hasData) {
            //       var products = snapshot.data!.docs;
            //       List<String> kk = products.map((e) => e.data()['restaurantName'].toString()).toList().toSet().toList();
            //       List<String> image = products.map((e) => e.data()['restaurantImage'].toString()).toList().toSet().toList();
            //       print(products);
            //       return ListView.builder(
            //         itemCount: kk.length,
            //         itemBuilder: (context, index) {
            //           var product = kk[index];
            //           return GestureDetector(
            //             onTap: () {
            //               // Get.to(() => SingleRestaurantsScreen(
            //               //   restaurantItem: restaurantListItem,
            //               // ));
            //             },
            //             child: ListTile(
            //               title: Text(product),
            //               leading: CircleAvatar(
            //                 backgroundImage: NetworkImage(image[index]),
            //               ),
            //             ),
            //           );
            //         },
            //       );
            //     }
            //     return const Center(child: CircularProgressIndicator());
            //   },
            // ).appPaddingForScreen,
            // StreamBuilder(
            //   stream: FirebaseFirestore.instance
            //       .collection('vendor_menu')
            //       .where("bookingForDining" , isEqualTo: true)
            //       .where('category',
            //       isGreaterThanOrEqualTo: searchKeyword)
            //       .where('category', isLessThan: '${searchKeyword}z')
            //       .snapshots(),
            //   builder: (context, snapshot) {
            //     if (snapshot.hasData) {
            //
            //       var products = snapshot.data!.docs;
            //       List<String> kk = products.map((e) => e.data()['category'].toString()).toList().toSet().toList();
            //       List<String> name = products.map((e) => e.data()['name'].toString()).toList().toSet().toList();
            //       List<String> image = products.map((e) => e.data()['image'].toString()).toList().toSet().toList();
            //       print(products);
            //       return ListView.builder(
            //         itemCount: kk.length,
            //         itemBuilder: (context, index) {
            //           var product = kk[index];
            //           return GestureDetector(
            //             onTap: (){
            //               Get.to(SearchRestaurantScreen(
            //                 category: product,
            //
            //               ));
            //             },
            //             child: ListTile(
            //               title: Text(name[index]),
            //               leading: CircleAvatar(
            //                 backgroundImage: NetworkImage(image[index]),
            //               ),
            //             ),
            //           );
            //         },
            //       );
            //     }
            //     return Center(child: const CircularProgressIndicator());
            //   },
            // ),
          ],
        ),
      ),
    );
  }
}
