import 'dart:developer';
import 'package:card_swiper/card_swiper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:resvago_customer/model/resturant_model.dart';
import 'package:resvago_customer/routers/routers.dart';
import '../controller/location_controller.dart';
import '../model/category_model.dart';
import '../widget/appassets.dart';
import '../widget/apptheme.dart';
import '../widget/custom_textfield.dart';
import 'package:rxdart/rxdart.dart';
import 'category/resturant_by_category.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  static var homePageScreen = "/homePageScreen";

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final locationController = Get.put(LocationController());
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
  getRestaurantList() {
    FirebaseFirestore.instance.collection("vendor_users").get().then((value) {
      for (var element in value.docs) {
        var gg = element.data();
        restaurantList ??= [];
        restaurantList!.add(RestaurantModel.fromJson(gg));
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
      print(double.tryParse(locationController.lat.toString()));
    }
    if (kDebugMode) {
      print(double.tryParse(locationController.long.toString()));
    }
    if (double.tryParse(lat1) == null ||
        double.tryParse(lon1) == null ||
        double.tryParse(locationController.lat.toString()) == null ||
        double.tryParse(locationController.long.toString()) == null) {
      return "Not Available";
    }

    double distanceInMeters = Geolocator.distanceBetween(double.parse(lat1), double.parse(lon1),
        double.parse(locationController.lat.toString()), double.parse(locationController.long.toString()));
    if((distanceInMeters / 1000) < 1){
      return "${distanceInMeters.toInt()} Meter away";
    }
    return "${(distanceInMeters / 1000).toStringAsFixed(2)} KM";
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
    getSliders();
    getVendorCategories();
    getRestaurantList();
    locationController.getLocation();
    locationController.checkGps(context).then((value) {
    });
  }

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
              onTap: () {
                // profileController.scaffoldKey.currentState!.openDrawer();
              },
              child: Image.asset(
                'assets/images/customerprofile.png',
                height: 40,
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
            GestureDetector(
              onTap: () {},
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  'assets/images/shoppinbag.png',
                  height: 30,
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
      body: SingleChildScrollView(
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
                        padding: const EdgeInsets.only(right: 5.0,left: 5.0),
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
                        onTap: (){
                          Get.to(()=> RestaurantByCategory(categoryName:categoryList![index].name.toString()));
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
                                style:
                                    GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w300, color: const Color(0xff384953)),
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
                  height: 240,
                  child: StreamBuilder<List<DocumentSnapshot>>(
                      stream: stream,
                      builder: (context, snapshot) {
                        return ListView.builder(
                            shrinkWrap: true,
                            itemCount: restaurantList!.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              var restaurantListItem = restaurantList![index];
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: InkWell(
                                  onTap: () {
                                    Get.toNamed(MyRouters.singleProductScreen);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    decoration: BoxDecoration(
                                      color: const Color(0xffFFFFFF),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        ClipRRect(
                                          borderRadius: const BorderRadius.only(
                                            topRight: Radius.circular(10),
                                            topLeft: Radius.circular(10),
                                          ),
                                          child: Stack(children: [
                                            Image.network(
                                              restaurantListItem.image.toString(),
                                              height: 140,
                                              width: 250,
                                              fit: BoxFit.cover,
                                            ),
                                            Positioned(
                                                top: 11,
                                                right: 10,
                                                child: InkWell(
                                                  onTap: () {},
                                                  child: Container(
                                                    height: 25,
                                                    width: 25,
                                                    decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
                                                    child: const Icon(
                                                      Icons.favorite_border,
                                                      color: AppTheme.primaryColor,
                                                      size: 18,
                                                    ),
                                                  ),
                                                )),
                                          ]),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                restaurantListItem.restaurantName.toString(),
                                                style: GoogleFonts.ibmPlexSansArabic(
                                                    fontSize: 15, fontWeight: FontWeight.w400, color: const Color(0xff08141B)),
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Row(children: [
                                                const Icon(
                                                  Icons.star,
                                                  color: Color(0xff2C4D61),
                                                  size: 17,
                                                ),
                                                Text(
                                                  "4.4",
                                                  style: GoogleFonts.ibmPlexSansArabic(
                                                      fontSize: 15, fontWeight: FontWeight.w500, color: const Color(0xff08141B)),
                                                ),
                                              ],)
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
                                              Text(
                                                "25 mins ",
                                                style: GoogleFonts.poppins(
                                                    fontSize: 14, fontWeight: FontWeight.w400, color: const Color(0xff384953)),
                                              ),
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
                                              SvgPicture.asset(
                                                AppAssets.vector,
                                                height: 16,
                                              ),
                                              Text(
                                                "  40% off up to \$100",
                                                style: GoogleFonts.poppins(
                                                    fontSize: 12, fontWeight: FontWeight.w400, color: const Color(0xff3B5998)),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            });
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
              SizedBox(
                height: 170,
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: 7,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: const Color(0xffFFFFFF),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(10),
                                  topLeft: Radius.circular(10),
                                ),
                                child: Center(
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Image.asset(
                                      AppAssets.roll,
                                      width: 140,
                                      // height: 300,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                "Offers New",
                                style: GoogleFonts.poppins(
                                    fontSize: 15, fontWeight: FontWeight.w500, color: const Color(0xff1E2538)),
                              ),
                              const SizedBox(
                                height: 3,
                              ),
                              Text(
                                "Up to 60% off",
                                style: GoogleFonts.poppins(
                                    fontSize: 14, fontWeight: FontWeight.w400, color: const Color(0xffE66353)),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
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
                  height: 240,
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
                              Get.toNamed(MyRouters.singleProductScreen);
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
                                  ClipRRect(
                                    borderRadius: const BorderRadius.only(
                                      topRight: Radius.circular(10),
                                      topLeft: Radius.circular(10),
                                    ),
                                    child: Stack(children: [
                                      Image.network(
                                        restaurantListItem.image.toString(),
                                        height: 150,
                                        width: 250,
                                        fit: BoxFit.cover,
                                      ),
                                      Positioned(
                                          top: 11,
                                          right: 10,
                                          child: InkWell(
                                            onTap: () {},
                                            child: Container(
                                              height: 25,
                                              width: 25,
                                              decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
                                              child: const Icon(
                                                Icons.favorite_border,
                                                color: AppTheme.primaryColor,
                                                size: 18,
                                              ),
                                            ),
                                          )),
                                    ]),
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
                                        const Icon(
                                          Icons.star,
                                          color: Color(0xff2C4D61),
                                          size: 17,
                                        ),
                                        Text(
                                          "4.4",
                                          style: GoogleFonts.ibmPlexSansArabic(
                                              fontSize: 15, fontWeight: FontWeight.w500, color: const Color(0xff08141B)),
                                        ),
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
                                        Text(
                                          "25 mins ",
                                          style: GoogleFonts.poppins(
                                              fontSize: 14, fontWeight: FontWeight.w400, color: const Color(0xff384953)),
                                        ),
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
                                        SvgPicture.asset(
                                          AppAssets.vector,
                                          height: 16,
                                        ),
                                        Text(
                                          "  40% off up to \$100",
                                          style: GoogleFonts.poppins(
                                              fontSize: 12, fontWeight: FontWeight.w400, color: const Color(0xff3B5998)),
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
              const SizedBox(
                height: 90,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
