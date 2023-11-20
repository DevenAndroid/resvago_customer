import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/wishlist_controller.dart';
import '../model/resturant_model.dart';

class LikeButtonWidget extends StatefulWidget {
  const LikeButtonWidget({super.key, required this.restaurantModel});

  final RestaurantModel restaurantModel;

  @override
  State<LikeButtonWidget> createState() => _LikeButtonWidgetState();
}

class _LikeButtonWidgetState extends State<LikeButtonWidget> {
  RestaurantModel get info => widget.restaurantModel;

  final wishListController = Get.put(WishListController());

  bool get isInWishlist => wishListController.wishListRestaurants[info.userID] != null;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if(wishListController.refreshInt.value > 0){}
      return IconButton(
        onPressed: () {
          if(isInWishlist) {
            wishListController.removeFromWishList(docId: info.userID.toString());
          } else {
            wishListController.addToWishList(restaurantInfo: info.toJson(), docId: info.userID.toString());
          }
        },
        icon: Container(
          height: 25,
          width: 25,
          decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
          child: Icon(
            isInWishlist ? Icons.favorite
                : Icons.favorite_border,
            color: isInWishlist ? Colors.red : Colors.grey.shade800,
            size: 18,
          ),
        ),
      );
    });
  }
}
