import 'dart:convert';
import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:resvago_customer/controller/location_controller.dart';
import 'package:resvago_customer/screen/helper.dart';
import 'package:resvago_customer/screen/single_store_screens/setting_for_restaurant.dart';
import 'package:resvago_customer/screen/single_store_screens/single_restaurants_screen.dart';
import 'package:resvago_customer/screen/widgets/calculate_distance.dart';
import 'package:resvago_customer/widget/common_text_field.dart';
import '../controller/wishlist_controller.dart';
import '../model/resturant_model.dart';
import '../widget/like_button.dart';
import '../widget/restaurant_timing.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});
  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  final wishListController = Get.put(WishListController());
  final locationController = Get.put(LocationController());

  @override
  void initState() {
    super.initState();
    wishListController.startListener();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: backAppBar(title: "My Wishlist", context: context),
        body: Obx(() {
          if (wishListController.refreshInt.value > 0) {}
          List<RestaurantModel> restaurantModel = wishListController.wishListRestaurants.entries.map((e) => e.value).toList();
          log(restaurantModel.length.toString());
          log(jsonEncode(restaurantModel));
          return restaurantModel.isNotEmpty
              ? ListView.builder(
                  shrinkWrap: true,
                  itemCount: restaurantModel.length,
                  itemBuilder: (context, index) {
                    var restaurantListItem = restaurantModel[index];
                    log("fgsdfhjgjhds" + restaurantListItem.email);
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
                                  SizedBox(
                                    height: 150,
                                    width: double.maxFinite,
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
                                  Positioned(
                                      top: 0,
                                      right: 0,
                                      child: LikeButtonWidget(
                                        restaurantModel: restaurantListItem,
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
                                        latLng: LatLng(restaurantListItem.storeLat, restaurantListItem.storeLong)),
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
                                padding: const EdgeInsets.only(left: 8.0),
                                child: MaxDiscountScreen(docId: restaurantListItem.docid),
                              ),
                              const SizedBox(height: 5),
                            ],
                          ),
                        ).appPaddingForScreen,
                      ),
                    );
                  })
              : Center(
                  child: Text("Wishlist is Empty"),
                );
        }));

    //   Obx(() {
    //   if (wishListController.refreshInt.value > 0) {}
    //   return IconButton(
    //     onPressed: () {
    //       if (isInWishlist) {
    //         wishListController.removeFromWishList(docId: info.userID.toString());
    //       } else {
    //         wishListController.addToWishList(restaurantInfo: info.toJson(), docId: info.userID.toString());
    //       }
    //     },
    //     icon: Container(
    //       height: 25,
    //       width: 25,
    //       decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
    //       child: Icon(
    //         isInWishlist ? Icons.favorite : Icons.favorite_border,
    //         color: isInWishlist ? Colors.red : Colors.grey.shade800,
    //         size: 18,
    //       ),
    //     ),
    //   );
    // });
  }
}
