import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:resvago_customer/model/resturant_model.dart';
import 'package:resvago_customer/model/wishListModel.dart';
import 'package:resvago_customer/routers/routers.dart';
import 'package:resvago_customer/screen/helper.dart';
import 'package:resvago_customer/screen/search_screen/searchlist_screen.dart';
import 'package:resvago_customer/screen/single_store_screens/setting_for_restaurant.dart';
import 'package:resvago_customer/screen/single_store_screens/single_restaurants_screen.dart';
import 'package:resvago_customer/screen/widgets/address_widget.dart';
import 'package:resvago_customer/screen/widgets/calculate_distance.dart';
import 'package:resvago_customer/widget/like_button.dart';
import '../controller/bottomnavbar_controller.dart';
import '../controller/location_controller.dart';
import '../controller/profile_controller.dart';
import '../controller/wishlist_controller.dart';
import '../firebase_service/firebase_service.dart';
import '../model/add_address_modal.dart';
import '../model/category_model.dart';
import '../model/checkout_model.dart';
import '../widget/apptheme.dart';
import '../widget/custom_textfield.dart';
import 'package:rxdart/rxdart.dart';
import '../widget/restaurant_timing.dart';
import 'allcategory_screen.dart';
import 'category/resturant_by_category.dart';
import 'login_screen.dart';
import 'myAddressList.dart';
import 'package:carousel_slider/carousel_slider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  static var homePageScreen = "/homePageScreen";

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final locationController = Get.put(LocationController());
  final wishListController = Get.put(WishListController());
  final bottomController = Get.put(BottomNavBarController());
  bool isDescendingOrder = false;
  List<String>? sliderList;

  getSliders() {
    FirebaseFirestore.instance.collection("slider").orderBy('timestamp', descending: isDescendingOrder).get().then((value) {
      for (var element in value.docs) {
        var gg = element.data();
        print(gg.toString());
        sliderList ??= [];
        sliderList!.add(gg["imageUrl"]);
        print("dfasghdfhg$sliderList");
      }
      setState(() {});
    });
  }

  List<CategoryData>? categoryList;

  getVendorCategories() {
    FirebaseFirestore.instance.collection("resturent").where("deactivate", isEqualTo: false).get().then((value) {
      for (var element in value.docs) {
        var gg = element.data();
        categoryList ??= [];
        categoryList!.add(CategoryData.fromMap(gg));
      }
      setState(() {});
    });
  }

  List<RestaurantModel>? restaurantList;
  Future getRestaurantList() async {
    restaurantList ??= [];
    restaurantList!.clear();
    await FirebaseFirestore.instance
        .collection("vendor_users")
        .where("deactivate", isEqualTo: false)
        .orderBy("order_count", descending: true)
        .limit(10)
        .get()
        .then((value) {
      for (var element in value.docs) {
        var gg = element.data();
        restaurantList!.add(RestaurantModel.fromJson(gg, element.id.toString()));
      }
      setState(() {});
    });
  }

  final radius = BehaviorSubject<double>.seeded(1.0);
  final _firestore = FirebaseFirestore.instance;
  Stream<List<DocumentSnapshot>>? stream;
  GeoFlutterFire? geo;

  Future<bool> addToWishlist(
    String userId,
    String vendorId,
  ) async {
    try {
      await FirebaseFirestore.instance
          .collection('wishlist')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("wishlist_list")
          .doc()
          .set({
        'userId': userId,
        'vendorId': vendorId,
        'timestamp': DateTime.now().microsecondsSinceEpoch,
      });
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('Error adding to wishlist: $e');
      }
      return false;
    }
  }

  FirebaseService firebaseService = FirebaseService();

  Future<bool> addWishlistToFirestore(vendorId) async {
    OverlayEntry loader = Helper.overlayLoader(context);
    Overlay.of(context).insert(loader);
    try {
      await firebaseService
          .manageWishlist(
              time: DateTime.now().millisecondsSinceEpoch,
              wishlistId: DateTime.now().microsecondsSinceEpoch.toString(),
              userId: FirebaseAuth.instance.currentUser!.uid,
              vendorId: vendorId)
          .then((value) {
        Get.back();
        Helper.hideLoader(loader);
      });
    } catch (e) {
      Helper.hideLoader(loader);
      showToast(e.toString());
      throw Exception(e.toString());
    }
    return true;
  }

  bool? addedToWishlist;

  addWishlist(
    String vendorId,
  ) async {
    addedToWishlist = await addWishlistToFirestore(vendorId);
    if (addedToWishlist!) {
      showToast("Item was added to the wishlist successfully");
      getWishList();
    } else {}
  }

  List<WishListModel>? wishList;

  Future getWishList() async {
    await FirebaseFirestore.instance
        .collection('wishlist')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("wishlist_list")
        .get()
        .then((value) {
      for (var element in value.docs) {
        var gg = element.data();
        wishList ??= [];
        wishList!.add(WishListModel.fromMap(gg, element.id));
        print("wishList$wishList");
      }
      setState(() {});
    });
  }

  final profileController = Get.put(ProfileController());
  FirebaseAuth _auth = FirebaseAuth.instance;
  User? user;
  @override
  void initState() {
    super.initState();
    locationController.checkGps(context).then((value) {});
    locationController.getLocation();
    user = _auth.currentUser;
    if (user != null) {
      wishListController.startListener();
      profileController.getProfileData();
    }
    geo = GeoFlutterFire();
    GeoFirePoint center = geo!.point(
        latitude: double.parse(locationController.lat.toString()), longitude: double.parse(locationController.long.toString()));
    stream = radius.switchMap((rad) {
      final collectionReference = _firestore.collection('vendor_users');
      return geo!
          .collection(collectionRef: collectionReference)
          .within(center: center, radius: rad, field: 'restaurant_position', strictMode: true);
    });
    getSliders();
    getVendorCategories();
    getRestaurantList();
  }

  int currentDrawer = 0;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color(0xffF6F6F6),
      appBar: AppBar(
        surfaceTintColor: AppTheme.backgroundcolor,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  bottomController.scaffoldKey.currentState!.openDrawer();
                },
                child: Icon(Icons.menu)),
            const SizedBox(width: 10),
            Expanded(
              child: Obx(() {
                if (profileController.refreshInt.value > 0) {}
                return profileController.profileData != null && profileController.profileData!.selected_address != null
                    ? AddressWidget(addressId: profileController.profileData!.selected_address)
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                              onTap: () {
                                FirebaseAuth _auth = FirebaseAuth.instance;
                                User? user = _auth.currentUser;
                                if (user != null) {
                                  Get.to(() => MyAddressList(
                                        addressChanged: (AddressModel address) {},
                                      ));
                                } else {
                                  Get.to(() => LoginScreen());
                                }
                              },
                              behavior: HitTestBehavior.translucent,
                              child: Row(
                                children: [
                                  Image.asset(
                                    'assets/icons/location.png',
                                    height: 15,
                                  ),
                                  const SizedBox(width: 4),
                                  Flexible(
                                    child: Text(
                                      'Home',
                                      style: GoogleFonts.poppins(fontWeight: FontWeight.w500, fontSize: 15),
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  Image.asset(
                                    'assets/icons/dropdown.png',
                                    height: 8,
                                  ),
                                ],
                              )),
                          const SizedBox(
                            height: 6,
                          ),
                          Text(
                            locationController.locality.value.toString(),
                            style: GoogleFonts.poppins(
                              color: const Color(0xFF1E2538),
                              fontSize: 12,
                              fontWeight: FontWeight.w300,
                            ),
                          )
                        ],
                      );
              }),
            ),
            // GestureDetector(
            //   onTap: () {
            //     FirebaseAuth _auth = FirebaseAuth.instance;
            //     User? user = _auth.currentUser;
            //     if (user != null) {
            //       Get.toNamed(MyRouters.cartScreen);
            //     } else {
            //       Get.to(() => LoginScreen());
            //     }
            //   },
            //   child: Padding(
            //     padding: const EdgeInsets.all(8.0),
            //     child: Image.asset(
            //       'assets/images/shoppinbag.png',
            //       height: 30,
            //     ),
            //   ),
            // ),
            user != null ?
            Badge(
              label: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('checkOut')
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .snapshots(),
                builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: Text(" 0 "));
                  }

                  if (snapshot.hasError) {
                    return const Center(child: Text(" 0 "));
                  }

                  if (!snapshot.hasData || !snapshot.data!.exists) {
                    return const Center(child: Text(" 0 "));
                  }

                  // Access the menuList from the document snapshot
                  List<dynamic> menuList = snapshot.data!['menuList'];

                  // Now you can use the menuList as needed

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3.0),
                    child: Text("${menuList.length.toString()}"),
                  );
                },
              ),
              backgroundColor: Colors.black,
              padding: EdgeInsets.zero,
              child: GestureDetector(
                onTap: () {
                  FirebaseAuth _auth = FirebaseAuth.instance;
                  User? user = _auth.currentUser;
                  if (user != null) {
                    Get.toNamed(MyRouters.cartScreen);
                  } else {
                    Get.to(() => LoginScreen());
                  }
                  // Get.toNamed(MyRouters.cartScreen);
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(
                    'assets/images/shoppinbag.png',
                    height: 30,
                  ),
                ),
              ),
            ):
            GestureDetector(
              onTap: () {
                FirebaseAuth _auth = FirebaseAuth.instance;
                User? user = _auth.currentUser;
                if (user != null) {
                  Get.toNamed(MyRouters.cartScreen);
                } else {
                  Get.to(() => LoginScreen());
                }
                // Get.toNamed(MyRouters.cartScreen);
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  'assets/images/shoppinbag.png',
                  height: 30,
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                FirebaseAuth _auth = FirebaseAuth.instance;
                User? user = _auth.currentUser;
                if (user != null) {
                  bottomController.updateIndexValue(3);
                  Get.back();
                } else {
                  Get.to(() => LoginScreen());
                }
              },
              child: SizedBox(
                height: 40,
                width: 40,
                child: Container(
                  decoration: BoxDecoration(border: Border.all(color: Colors.white, width: 2), shape: BoxShape.circle),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Obx(() {
                      if (profileController.refreshInt.value > 0) {}
                      return CachedNetworkImage(
                        fit: BoxFit.cover,
                        imageUrl:
                            profileController.profileData != null ? profileController.profileData!.profile_image.toString() : "",
                        errorWidget: (_, __, ___) => const Icon(Icons.person),
                        placeholder: (_, __) => const SizedBox(),
                      );
                    }),
                  ),
                ),
              ),
            ),
          ],
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        //toolbarHeight: 70,
        //toolbarHeight: 70,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await getRestaurantList();
          await getWishList();
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: Row(
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
                              onTap: () {
                                Get.to(const SerachListScreen());
                              },
                              readOnly: true,
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
                const SizedBox(
                  height: 10,
                ),
                if (sliderList != null)
                  CarouselSlider(
                    options: CarouselOptions(height: size.height * 0.20, autoPlay: true, viewportFraction: 1),
                    items: sliderList!.map((i) {
                      return Container(
                        width: double.maxFinite,
                        padding: const EdgeInsets.only(right: 5.0, left: 5.0),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: CachedNetworkImage(
                              imageUrl: i,
                              fit: BoxFit.cover,
                              errorWidget: (_, __, ___) => Icon(
                                Icons.error,
                                color: Colors.red,
                              ),
                            )),
                      );
                    }).toList(),
                  ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          Get.to(() => AllCategoryScreen(restaurantType: ""));
                        },
                        child: Text(
                          "View All",
                          style: TextStyle(color: AppTheme.primaryColor),
                        ))
                  ],
                ),
                SizedBox(height: 10),
                if (categoryList != null)
                  SizedBox(
                    height: 80,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: min(6, categoryList!.length),
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () {
                            Get.to(() =>
                                RestaurantByCategory(categoryName: categoryList![index].name.toString(), restaurantType: ""));
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: SizedBox(
                              width: 60,
                              child: Column(
                                children: [
                                  Expanded(
                                    child: ClipRRect(
                                        borderRadius: BorderRadius.circular(100),
                                        child: CachedNetworkImage(
                                          imageUrl: categoryList![index].image.toString(),
                                          fit: BoxFit.cover,
                                          errorWidget: (_, __, ___) => Icon(
                                            Icons.error,
                                            color: Colors.red,
                                          ),
                                        )),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    categoryList![index].name ?? "",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.poppins(
                                        fontSize: 12, fontWeight: FontWeight.w300, color: const Color(0xff384953)),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  '  Restaurants chosen for you',
                  style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500, color: const Color(0xff1E2538)),
                ),
                const SizedBox(
                  height: 10,
                ),
                if (restaurantList!.isNotEmpty && restaurantList != null)
                  SizedBox(
                    height: 260,
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: restaurantList!.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          var restaurantListItem = restaurantList![index];
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                              onTap: () {
                                Get.to(() => SingleRestaurantsScreen(
                                      restaurantItem: restaurantListItem,
                                    ));
                              },
                              child: Container(
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
                                        SizedBox(
                                          height: 150,
                                          width: 250,
                                          child: Hero(
                                            tag: restaurantListItem.image,
                                            child: ClipRRect(
                                                borderRadius: const BorderRadius.only(
                                                  topRight: Radius.circular(10),
                                                  topLeft: Radius.circular(10),
                                                ),
                                                child: CachedNetworkImage(
                                                  imageUrl: restaurantListItem.image.toString(),
                                                  fit: BoxFit.cover,
                                                  errorWidget: (_, __, ___) => Icon(
                                                    Icons.error,
                                                    color: Colors.red,
                                                  ),
                                                )),
                                          ),
                                        ),
                                        Positioned(
                                            top: 0,
                                            right: 0,
                                            child: LikeButtonWidget(
                                              restaurantModel: restaurantListItem,
                                            )),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            restaurantListItem.restaurantName.toString(),
                                            style: GoogleFonts.ibmPlexSansArabic(
                                                fontSize: 15, fontWeight: FontWeight.w400, color: const Color(0xff08141B)),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          MaxRatingScreen(
                                            docId: restaurantListItem.docid.toString(),
                                          )
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 3,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                      child: Row(
                                        children: [
                                          PreparationTimeScreen(docId: restaurantListItem.userID.toString()),
                                          const SizedBox(
                                            width: 3,
                                          ),
                                          const Icon(Icons.circle, size: 5, color: Color(0xff384953)),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          CalculateDistanceFromStoreWidget(
                                            latLng: LatLng(restaurantListItem.storeLat, restaurantListItem.storeLong),
                                          ),
                                          // Text(
                                          //   _calculateDistance(
                                          //     lat1: restaurantListItem.latitude.toString(),
                                          //     lon1: restaurantListItem.longitude.toString(),
                                          //   ),
                                          //   style: GoogleFonts.poppins(
                                          //       fontSize: 14, fontWeight: FontWeight.w400, color: const Color(0xff384953)),
                                          // ),
                                          const SizedBox(
                                            width: 3,
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: 250,
                                      child: FittedBox(
                                        child: Row(
                                          children: List.generate(
                                              30,
                                              (index) => Padding(
                                                    padding: const EdgeInsets.only(left: 2, right: 2),
                                                    child: Container(
                                                      color: Colors.grey[300],
                                                      height: 2,
                                                      width: 10,
                                                    ),
                                                  )),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Row(
                                        children: [
                                          MaxDiscountScreen(docId: restaurantListItem.docid.toString())
                                          // Text(
                                          //   "  40% off up to \$100",
                                          //   style: GoogleFonts.poppins(
                                          //       fontSize: 12, fontWeight: FontWeight.w400, color: const Color(0xff3B5998)),
                                          // ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                                .animate(
                                  key: ValueKey(DateTime.now().millisecondsSinceEpoch + index),
                                )
                                .slideX(
                                    duration: Duration(milliseconds: 600),
                                    delay: Duration(milliseconds: (index + 1) * 100),
                                    end: 0,
                                    begin: 2)
                                .fade(
                                  duration: Duration(milliseconds: 800),
                                  delay: Duration(milliseconds: (index + 1) * 100),
                                ),
                          );
                        }),
                  ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  '  Explore Now',
                  style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500, color: const Color(0xff1E2538)),
                ),
                const SizedBox(
                  height: 10,
                ),
                if (categoryList != null)
                  SizedBox(
                    height: 80,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: min(6, categoryList!.length),
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () {
                            Get.to(() => RestaurantByCategory(
                                categoryName: categoryList![index].name.toString(), restaurantType: "Delivery"));
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: SizedBox(
                              width: 60,
                              child: Column(
                                children: [
                                  Expanded(
                                    child: ClipRRect(
                                        borderRadius: BorderRadius.circular(100),
                                        child: CachedNetworkImage(
                                          imageUrl: categoryList![index].image.toString(),
                                          fit: BoxFit.cover,
                                          errorWidget: (_, __, ___) => Icon(
                                            Icons.error,
                                            color: Colors.red,
                                          ),
                                        )),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    categoryList![index].name ?? "",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.poppins(
                                        fontSize: 12, fontWeight: FontWeight.w300, color: const Color(0xff384953)),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  '  Popular restaurants',
                  style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500, color: const Color(0xff1E2538)),
                ),
                const SizedBox(
                  height: 10,
                ),
                if (restaurantList!.isNotEmpty && restaurantList != null)
                  SizedBox(
                    height: 260,
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: restaurantList!.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          var restaurantListItem = restaurantList![index];
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                              onTap: () {
                                Get.to(() => SingleRestaurantsScreen(
                                      restaurantItem: restaurantListItem,
                                    ));
                              },
                              child: Container(
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
                                        SizedBox(
                                          height: 150,
                                          width: 250,
                                          child: ClipRRect(
                                              borderRadius: const BorderRadius.only(
                                                topRight: Radius.circular(10),
                                                topLeft: Radius.circular(10),
                                              ),
                                              child: Hero(
                                                tag: "Image",
                                                child: CachedNetworkImage(
                                                  imageUrl: restaurantListItem.image.toString(),
                                                  fit: BoxFit.cover,
                                                  errorWidget: (_, __, ___) => Icon(
                                                    Icons.error,
                                                    color: Colors.red,
                                                  ),
                                                ),
                                              )),
                                        ),
                                        // ClipRRect(
                                        //     borderRadius: const BorderRadius.only(
                                        //       topRight: Radius.circular(10),
                                        //       topLeft: Radius.circular(10),
                                        //     ),
                                        //     child: Image.network(
                                        //       restaurantListItem.image.toString(),
                                        //       height: 150,
                                        //       width: 250,
                                        //       fit: BoxFit.cover,
                                        //       errorBuilder: (_, __, ___) => SizedBox(
                                        //           height: 150,
                                        //           width: 250,
                                        //           child: Icon(
                                        //             Icons.error,
                                        //             color: Colors.red,
                                        //           )),
                                        //     )),
                                        Positioned(
                                            top: 0,
                                            right: 0,
                                            child: LikeButtonWidget(
                                              restaurantModel: restaurantListItem,
                                            )),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            restaurantListItem.restaurantName.toString(),
                                            style: GoogleFonts.ibmPlexSansArabic(
                                                fontSize: 15, fontWeight: FontWeight.w400, color: const Color(0xff08141B)),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          MaxRatingScreen(
                                            docId: restaurantListItem.docid,
                                          )
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 3,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                      child: Row(
                                        children: [
                                          PreparationTimeScreen(docId: restaurantListItem.userID.toString()),
                                          const SizedBox(
                                            width: 3,
                                          ),
                                          const Icon(Icons.circle, size: 5, color: Color(0xff384953)),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          CalculateDistanceFromStoreWidget(
                                              latLng: LatLng(restaurantListItem.storeLat, restaurantListItem.storeLong)),
                                          const SizedBox(
                                            width: 3,
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: 250,
                                      child: FittedBox(
                                        child: Row(
                                          children: List.generate(
                                              30,
                                              (index) => Padding(
                                                    padding: const EdgeInsets.only(left: 2, right: 2),
                                                    child: Container(
                                                      color: Colors.grey[300],
                                                      height: 2,
                                                      width: 10,
                                                    ),
                                                  )),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Row(
                                        children: [
                                          MaxDiscountScreen(docId: restaurantListItem.docid.toString())
                                          // Text(
                                          //   "  40% off up to \$100",
                                          //   style: GoogleFonts.poppins(
                                          //       fontSize: 12, fontWeight: FontWeight.w400, color: const Color(0xff3B5998)),
                                          // ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                                .animate(
                                  key: ValueKey(DateTime.now().millisecondsSinceEpoch + index),
                                )
                                .slideX(
                                    duration: Duration(milliseconds: 600),
                                    delay: Duration(milliseconds: (index + 1) * 100),
                                    end: 0,
                                    begin: 2)
                                .fade(
                                  duration: Duration(milliseconds: 800),
                                  delay: Duration(milliseconds: (index + 1) * 100),
                                ),
                          );
                        }),
                  ),
                const SizedBox(
                  height: 90,
                ),
              ].animate(interval: Duration(milliseconds: 200)).fade(
                    duration: Duration(milliseconds: 600),
                  ),
            ).appPaddingForScreen,
          ),
        ),
      ),
    );
  }
}

Widget drawerTile({required bool active, required String title, required ImageIcon icon, required VoidCallback onTap}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8.0),
    child: ListTile(
      selectedTileColor: AppTheme.primaryColor,
      leading: icon,
      minLeadingWidth: 25,
      title: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 14,
          color: AppTheme.drawerColor,
          fontWeight: FontWeight.w400,
        ),
      ),
      onTap: active ? onTap : null,
    ),
  );
}
