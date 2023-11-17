import 'dart:convert';
import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:resvago_customer/model/resturant_model.dart';
import 'package:resvago_customer/model/wishListModel.dart';
import 'package:resvago_customer/routers/routers.dart';
import 'package:resvago_customer/screen/helper.dart';
import 'package:resvago_customer/screen/addAddress.dart';
import 'package:resvago_customer/screen/review_rating_screen.dart';
import 'package:resvago_customer/screen/search_screen/searchlist_screen.dart';
import 'package:resvago_customer/screen/search_screen/search_singlerestaurant_screen.dart';
import 'package:resvago_customer/screen/single_store_screens/setting_for_restaurant.dart';
import 'package:resvago_customer/screen/single_store_screens/single_restaurants_screen.dart';
import 'package:resvago_customer/widget/like_button.dart';
import '../controller/location_controller.dart';
import '../controller/wishlist_controller.dart';
import '../firebase_service/firebase_service.dart';
import '../model/category_model.dart';
import '../model/checkout_model.dart';
import '../model/profile_model.dart';
import '../widget/appassets.dart';
import '../widget/apptheme.dart';
import '../widget/custom_textfield.dart';
import 'package:rxdart/rxdart.dart';
import '../widget/restaurant_timing.dart';
import 'category/resturant_by_category.dart';
import 'coupon_list_screen.dart';
import 'login_screen.dart';
import 'myAddressList.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  static var homePageScreen = "/homePageScreen";

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final locationController = Get.put(LocationController());
  final wishListController = Get.put(WishListController());
  bool isDescendingOrder = false;
  List<String>? sliderList;
  getSliders() {
    FirebaseFirestore.instance.collection("slider").orderBy('timestamp', descending: isDescendingOrder).get().then((value) {
      for (var element in value.docs) {
        var gg = element.data();
        log(gg.toString());
        sliderList ??= [];
        sliderList!.add(gg["imageUrl"]);
        log("dfasghdfhg$sliderList");
      }
      setState(() {});
    });
  }

  List<CategoryData>? categoryList;
  getVendorCategories() {
    FirebaseFirestore.instance.collection("resturent").where("deactivate", isNotEqualTo: true).get().then((value) {
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
    await FirebaseFirestore.instance.collection("vendor_users").get().then((value) {
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
  Geoflutterfire? geo;

  String _calculateDistance({dynamic lat1, dynamic lon1}) {
    if (kDebugMode) {
      print("fsdfsdf${double.tryParse(locationController.lat.toString())}");
    }
    if (kDebugMode) {
      print("fsdfsdf${double.tryParse(locationController.long.toString())}");
    }
    if (double.tryParse(lat1) == null || double.tryParse(lon1) == null || double.tryParse(locationController.lat.toString()) == null ||
        double.tryParse(locationController.long.toString()) == null) {
      return "Not Available";
    }
    double distanceInMeters = Geolocator.distanceBetween(double.parse(lat1), double.parse(lon1),
        double.parse(locationController.lat.toString()), double.parse(locationController.long.toString()));
    if ((distanceInMeters / 1000) < 1) {
      return "${distanceInMeters.toInt()} Meter";
    }
    return "${(distanceInMeters / 1000).toStringAsFixed(2)} KM";
  }

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
        log("wishList$wishList");
      }
      setState(() {});
    });
  }

  ProfileData profileData = ProfileData();
  void getProfileData() {
    FirebaseFirestore.instance.collection("customer_users").doc(FirebaseAuth.instance.currentUser!.uid).get().then((value) {
      if (value.exists) {
        if (value.data() == null) return;
        profileData = ProfileData.fromJson(value.data()!);
        setState(() {});
      }
    });
  }

  @override
  void initState() {
    super.initState();
    locationController.checkGps(context).then((value) {});
    locationController.getLocation();
    wishListController.startListener();
    geo = Geoflutterfire();
    GeoFirePoint center = geo!.point(
        latitude: double.parse(locationController.lat.toString()), longitude: double.parse(locationController.long.toString()));
    stream = radius.switchMap((rad) {
      final collectionReference = _firestore.collection('vendor_users');
      // return collectionReference;
      return geo!
          .collection(collectionRef: collectionReference)
          .within(center: center, radius: rad, field: 'restaurant_position', strictMode: true);
    });
    getProfileData();
    getSliders();
    getVendorCategories();
    getRestaurantList();
  }

  int currentDrawer = 0;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      drawer: SizedBox(
        width: MediaQuery.of(context).size.width * 0.7,
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
                                child: CachedNetworkImage(
                                  fit: BoxFit.cover,
                                  imageUrl: profileData.profile_image.toString(),
                                  errorWidget: (_, __, ___) => const Icon(Icons.person),
                                  placeholder: (_, __) => const SizedBox(),
                                ),
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
                    _drawerTile(
                        active: true,
                        title: "My Orders".tr,
                        icon: const ImageIcon(
                          AssetImage(AppAssets.order),
                          size: 22,
                          color: AppTheme.drawerColor,
                        ),
                        onTap: () {
                          Get.toNamed(MyRouters.myOrder);
                        }),
                    const Divider(
                      height: 5,
                      color: Color(0xffF2F2F2),
                    ),
                    _drawerTile(
                        active: true,
                        title: "My Profile".tr,
                        icon: const ImageIcon(
                          AssetImage(AppAssets.profilee),
                          size: 22,
                          color: AppTheme.drawerColor,
                        ),
                        onTap: () async {
                          Get.toNamed(MyRouters.profileScreen);
                        }),
                    const Divider(
                      height: 5,
                      color: Color(0xffF2F2F2),
                    ),
                    _drawerTile(
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
                    _drawerTile(
                        active: true,
                        title: "My Address".tr,
                        icon: const ImageIcon(
                          AssetImage(AppAssets.myAddress),
                          size: 22,
                          color: AppTheme.drawerColor,
                        ),
                        onTap: () {
                          Get.to(() => MyAddressList());
                          // Get.back();
                          // widget.onItemTapped(1);
                        }),
                    const Divider(
                      height: 5,
                      color: Color(0xffF2F2F2),
                    ),
                    _drawerTile(
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
                    _drawerTile(
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
                    _drawerTile(
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
      backgroundColor: const Color(0xffF6F6F6),
      appBar: AppBar(
        surfaceTintColor: AppTheme.backgroundcolor,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                // profileController.scaffoldKey.currentState!.openDrawer();
              },
              child: SizedBox(
                height: 40,
                width: 40,
                child: Container(
                  decoration: BoxDecoration(border: Border.all(color: Colors.white, width: 2), shape: BoxShape.circle),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: CachedNetworkImage(
                      fit: BoxFit.cover,
                      imageUrl: profileData.profile_image.toString(),
                      errorWidget: (_, __, ___) => const Icon(Icons.person),
                      placeholder: (_, __) => const SizedBox(),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {},
                    child: Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                    ),
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  Obx(() {
                    return Text(
                      locationController.locality.value.toString(),
                      style: GoogleFonts.poppins(
                        color: const Color(0xFF1E2538),
                        fontSize: 12,
                        fontWeight: FontWeight.w300,
                      ),
                    );
                  })
                ],
              ),
            ),
            Badge(
              label: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('vendor_menu')
                    .where('userID', isLessThan: FirebaseAuth.instance.currentUser!.uid)
                    .snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data == null) {
                      return const Text(" 0 ");
                    }
                    if (snapshot.data!.docs.isEmpty) {
                      return const Text(" 0 ");
                    }
                    CheckOutModel cartData = CheckOutModel.fromJson(snapshot.data!.docs.first.data());
                    return Text(" ${cartData.menuList!.length}");
                  }
                  return const Center(child: Text(" 0 "));
                },
              ),
              backgroundColor: Colors.black,
              padding: EdgeInsets.zero,
              child: GestureDetector(
                onTap: () {
                  Get.toNamed(MyRouters.cartScreen);
                },
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
                  SizedBox(
                    height: size.height * 0.20,
                    child: Swiper(
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 5.0, left: 5.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.network(
                              sliderList![index],
                              fit: BoxFit.cover,
                              height: 80,
                            ),
                          ),
                        );
                      },
                      outer: false,
                      itemCount: sliderList!.length,
                      autoplayDelay: 1,
                      autoplayDisableOnInteraction: false,
                      scrollDirection: Axis.horizontal,
                      // pagination: const SwiperPagination(),
                      // control: const SwiperControl(size: 6),
                    ),
                  ),
                const SizedBox(
                  height: 10,
                ),
                if (categoryList != null)
                  SizedBox(
                    height: 100,
                    // width: size.width,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: categoryList!.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            Get.to(() => RestaurantByCategory(categoryName: categoryList![index].name.toString()));
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Column(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: Image.network(
                                    categoryList![index].image,
                                    fit: BoxFit.cover,
                                    height: 70,
                                    width: 70,
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  categoryList![index].name ?? "",
                                  style: GoogleFonts.poppins(
                                      fontSize: 12, fontWeight: FontWeight.w300, color: const Color(0xff384953)),
                                )
                              ],
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
                if (restaurantList != null)
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
                                      distance: _calculateDistance(
                                        lat1: restaurantListItem.latitude.toString(),
                                        lon1: restaurantListItem.longitude.toString(),
                                      ),
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
                                        ClipRRect(
                                            borderRadius: const BorderRadius.only(
                                              topRight: Radius.circular(10),
                                              topLeft: Radius.circular(10),
                                            ),
                                            child: Image.network(
                                              restaurantListItem.image.toString(),
                                              height: 150,
                                              width: 250,
                                              fit: BoxFit.cover,
                                            )),
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
                                            docId: restaurantListItem.userID,
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
                                          PreparationTimeScreen(docId: restaurantListItem.userID),
                                          const SizedBox(
                                            width: 3,
                                          ),
                                          const Icon(Icons.circle, size: 5, color: Color(0xff384953)),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            _calculateDistance(
                                              lat1: restaurantListItem.latitude.toString(),
                                              lon1: restaurantListItem.longitude.toString(),
                                            ),
                                            style: GoogleFonts.poppins(
                                                fontSize: 14, fontWeight: FontWeight.w400, color: const Color(0xff384953)),
                                          ),
                                          const SizedBox(
                                            width: 3,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Row(
                                      children: List.generate(
                                          17,
                                          (index) => Padding(
                                                padding: const EdgeInsets.only(left: 2, right: 2),
                                                child: Container(
                                                  color: Colors.grey[200],
                                                  height: 2,
                                                  width: 10,
                                                ),
                                              )),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Row(
                                        children: [
                                          MaxDiscountScreen(docId: restaurantListItem.userID)
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
                    height: 100,
                    // width: size.width,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: categoryList!.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            Get.to(() => RestaurantByCategory(categoryName: categoryList![index].name.toString()));
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Column(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: Image.network(
                                    categoryList![index].image,
                                    fit: BoxFit.cover,
                                    height: 70,
                                    width: 70,
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  categoryList![index].name ?? "",
                                  style: GoogleFonts.poppins(
                                      fontSize: 12, fontWeight: FontWeight.w300, color: const Color(0xff384953)),
                                )
                              ],
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
                  '  Popular restaurants in Madrid',
                  style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500, color: const Color(0xff1E2538)),
                ),
                const SizedBox(
                  height: 10,
                ),
                if (restaurantList != null)
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
                                      distance: _calculateDistance(
                                        lat1: restaurantListItem.latitude.toString(),
                                        lon1: restaurantListItem.longitude.toString(),
                                      ),
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
                                        ClipRRect(
                                            borderRadius: const BorderRadius.only(
                                              topRight: Radius.circular(10),
                                              topLeft: Radius.circular(10),
                                            ),
                                            child: Image.network(
                                              restaurantListItem.image.toString(),
                                              height: 150,
                                              width: 250,
                                              fit: BoxFit.cover,
                                            )),
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
                                            docId: restaurantListItem.userID,
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
                                          PreparationTimeScreen(docId: restaurantListItem.userID),
                                          const SizedBox(
                                            width: 3,
                                          ),
                                          const Icon(Icons.circle, size: 5, color: Color(0xff384953)),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            _calculateDistance(
                                              lat1: restaurantListItem.latitude.toString(),
                                              lon1: restaurantListItem.longitude.toString(),
                                            ),
                                            style: GoogleFonts.poppins(
                                                fontSize: 14, fontWeight: FontWeight.w400, color: const Color(0xff384953)),
                                          ),
                                          const SizedBox(
                                            width: 3,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Row(
                                      children: List.generate(
                                          17,
                                          (index) => Padding(
                                                padding: const EdgeInsets.only(left: 2, right: 2),
                                                child: Container(
                                                  color: Colors.grey[200],
                                                  height: 2,
                                                  width: 10,
                                                ),
                                              )),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Row(
                                        children: [
                                          MaxDiscountScreen(docId: restaurantListItem.userID)
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
                const SizedBox(
                  height: 90,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _drawerTile({required bool active, required String title, required ImageIcon icon, required VoidCallback onTap}) {
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
}
