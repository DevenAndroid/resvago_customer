import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:resvago_customer/widget/common_text_field.dart';
import '../../controller/location_controller.dart';
import '../../model/resturant_model.dart';
import '../../routers/routers.dart';
import '../../widget/appassets.dart';
import '../../widget/apptheme.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:rxdart/rxdart.dart';

import '../../widget/restaurant_timing.dart';
import '../single_store_screens/setting_for_restaurant.dart';
import '../single_store_screens/single_restaurants_screen.dart';

class RestaurantByCategory extends StatefulWidget {
  String categoryName;
  RestaurantByCategory({super.key, required this.categoryName});

  @override
  State<RestaurantByCategory> createState() => _RestaurantByCategoryState();
}

class _RestaurantByCategoryState extends State<RestaurantByCategory> {
  final locationController = Get.put(LocationController());
  final _firestore = FirebaseFirestore.instance;
  List<RestaurantModel>? restaurantList;
  getRestaurantList() {
    FirebaseFirestore.instance
        .collection("vendor_users")
        .where("category", isEqualTo: widget.categoryName)
        .get()
        .then((value) {
      for (var element in value.docs) {
        var gg = element.data();
        restaurantList ??= [];
        restaurantList!.add(RestaurantModel.fromJson(gg, element.id.toString()));
      }
      setState(() {});
    });
  }


  final radius = BehaviorSubject<double>.seeded(1.0);
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
    if ((distanceInMeters / 1000) < 1) {
      return "${distanceInMeters.toInt()} Meter away";
    }
    return "${(distanceInMeters / 1000).toStringAsFixed(2)} KM";
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getRestaurantList();
    locationController.getLocation();
    locationController.checkGps(context).then((value) {
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
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: backAppBar(title: widget.categoryName, context: context),
      body: restaurantList != null
          ? StreamBuilder<List<DocumentSnapshot>>(
              stream: stream,
              builder: (context, snapshot) {
                return ListView.builder(
                    shrinkWrap: true,
                    itemCount: restaurantList!.length,
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
                                ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    topRight: Radius.circular(10),
                                    topLeft: Radius.circular(10),
                                  ),
                                  child: Stack(children: [
                                    Image.network(
                                      restaurantListItem.image.toString(),
                                      height: 150,
                                      width: double.maxFinite,
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
                                      MaxRatingScreen(docId: restaurantListItem.docid,)
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
                                      PreparationTimeScreen(docId: restaurantListItem.docid),
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
                                const SizedBox(
                                  height: 5,
                                ),
                                FittedBox(
                                  child: Row(
                                    children: List.generate(
                                        29,
                                        (index) => Padding(
                                              padding: const EdgeInsets.only(left: 2, right: 2),
                                              child: Container(
                                                color: Colors.grey[200],
                                                height: 2,
                                                width: 10,
                                              ),
                                            )),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                MaxDiscountScreen(docId: restaurantListItem.docid),
                                const SizedBox(height: 5),
                              ],
                            ),
                          ),
                        ),
                      );
                    });
              })
          : const SizedBox.shrink(),
    );
  }
}
