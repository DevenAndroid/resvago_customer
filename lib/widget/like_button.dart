import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/wishlist_controller.dart';
import '../model/resturant_model.dart';
import '../screen/login_screen.dart';

class LikeButtonWidget extends StatefulWidget {
   LikeButtonWidget({super.key, required this.restaurantModel,required this.restaurantType});
  String restaurantType;
  final RestaurantModel restaurantModel;

  @override
  State<LikeButtonWidget> createState() => _LikeButtonWidgetState();
}

class _LikeButtonWidgetState extends State<LikeButtonWidget> {
  RestaurantModel get info => widget.restaurantModel;

  final wishListController = Get.put(WishListController());

  bool get isInWishlist => wishListController.wishListRestaurants[info.docid] != null;
  FirebaseAuth _auth = FirebaseAuth.instance;
  User? user;
  @override
  void initState() {
    super.initState();
    user = _auth.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (wishListController.refreshInt.value > 0) {}
      return IconButton(
        onPressed: () {
          if (user != null) {
            if (isInWishlist) {
              wishListController.removeFromWishList(docId: info.docid.toString());
              FirebaseFirestore.instance
                  .collection("wishlist")
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .collection("my_wishlist")
                  .doc(info.docid.toString())
                  .update({"wishlist": ""});
            }
            else {
              wishListController.addToWishList(restaurantInfo: info.toJson(), docId: info.docid.toString());
              FirebaseFirestore.instance
                  .collection("wishlist")
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .collection("my_wishlist")
                  .doc(info.docid.toString())
                  .update({"wishlist": widget.restaurantType});
            }
          } else {
            Get.to(() => LoginScreen());
          }
        },
        icon: Container(
          height: 25,
          width: 25,
          decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
          child: Icon(
            isInWishlist ? Icons.favorite : Icons.favorite_border,
            color: isInWishlist ? Colors.red : Colors.grey.shade800,
            size: 18,
          ),
        ),
      );
    });
  }
}
