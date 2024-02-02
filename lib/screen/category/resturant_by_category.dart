import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:resvago_customer/screen/helper.dart';
import 'package:resvago_customer/screen/widgets/calculate_distance.dart';
import 'package:resvago_customer/widget/common_text_field.dart';
import '../../controller/location_controller.dart';
import '../../model/resturant_model.dart';
import '../../routers/routers.dart';
import '../../widget/appassets.dart';
import '../../widget/apptheme.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:rxdart/rxdart.dart';
import '../../widget/like_button.dart';
import '../../widget/restaurant_timing.dart';
import '../delivery_screen/single_store_delivery_screen.dart';
import '../single_store_screens/setting_for_restaurant.dart';
import '../single_store_screens/single_restaurants_screen.dart';

class RestaurantByCategory extends StatefulWidget {
  String categoryName;
  String restaurantType;
  RestaurantByCategory({super.key, required this.categoryName, required this.restaurantType});

  @override
  State<RestaurantByCategory> createState() => _RestaurantByCategoryState();
}

class _RestaurantByCategoryState extends State<RestaurantByCategory> {
  final locationController = Get.put(LocationController());
  final _firestore = FirebaseFirestore.instance;
  List<RestaurantModel>? restaurantList;
  getRestaurantList() {
    if (widget.restaurantType == "Delivery") {
      FirebaseFirestore.instance
          .collection("vendor_users")
          .where("deactivate", isEqualTo: false)
          .where("setDelivery", isEqualTo: true)
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
    } else {
      FirebaseFirestore.instance
          .collection("vendor_users")
          .where("deactivate", isEqualTo: false)
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
  }

  final radius = BehaviorSubject<double>.seeded(1.0);
  Stream<List<DocumentSnapshot>>? stream;
  GeoFlutterFire? geo;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getRestaurantList();
    locationController.getLocation();
    locationController.checkGps(context).then((value) {
      geo = GeoFlutterFire();
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
                          child: GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () {
                              if (widget.restaurantType == "Delivery") {
                                Get.to(() => SingleRestaurantForDeliveryScreen(
                                      restaurantItem: restaurantListItem,
                                    ));
                              } else {
                                Get.to(() => SingleRestaurantsScreen(
                                      restaurantItem: restaurantListItem,
                                    ));
                              }
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
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
                                        errorBuilder: (BuildContext, Object, StackTrace) {
                                          return SizedBox(
                                            height: 150,
                                            width: double.maxFinite,
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Image.asset(AppAssets.storeIcon),
                                            ),
                                          );
                                        },
                                      ),
                                      Positioned(
                                          top: 0,
                                          right: 0,
                                          child: widget.restaurantType == "Delivery"
                                              ? LikeButtonWidget(
                                                  restaurantModel: restaurantListItem,
                                                  restaurantType: 'Delivery',
                                                )
                                              : LikeButtonWidget(
                                                  restaurantModel: restaurantListItem,
                                                  restaurantType: 'Dining',
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
                                        PreparationTimeScreen(docId: restaurantListItem.docid),
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
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  FittedBox(
                                    child: Row(
                                      children: List.generate(
                                          kIsWeb ? 100 : 40,
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
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10.0),
                                    child: MaxDiscountScreen(docId: restaurantListItem.docid),
                                  ),
                                  const SizedBox(height: 5),
                                ],
                              ),
                            ).appPaddingForScreen,
                          )
                              .animate(
                                key: ValueKey(DateTime.now().millisecondsSinceEpoch + index),
                              )
                              .slideY(
                                  duration: Duration(milliseconds: 600),
                                  delay: Duration(milliseconds: (index + 1) * 100),
                                  end: 0,
                                  begin: .50)
                              .fade(
                                duration: Duration(milliseconds: 800),
                                delay: Duration(milliseconds: (index + 1) * 100),
                              ));
                    });
              })
          : const SizedBox.shrink(),
    );
  }
}
