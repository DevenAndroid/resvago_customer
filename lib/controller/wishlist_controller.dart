import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../model/resturant_model.dart';

class WishListController extends GetxController{
  
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? streamSubscription;
  
  Map<String, RestaurantModel> wishListRestaurants = {};
  RxInt refreshInt = 0.obs;
  
  startListener(){
    streamSubscription ??= FirebaseFirestore.instance
        .collection("wishlist")
        .doc(FirebaseAuth.instance.currentUser!.phoneNumber)
        .collection("my_wishlist").snapshots().listen(updateChanges);
  }
  
  updateChanges(QuerySnapshot<Map<String, dynamic>> event){
    wishListRestaurants.clear();
    for (var element in event.docs) {
      wishListRestaurants[element.id] ??= RestaurantModel.fromJson(element.data(), element.id.toString());
    }
    refreshInt.value = DateTime.now().millisecondsSinceEpoch;
  }

  disposeStream(){
    if(streamSubscription != null){
      streamSubscription!.cancel();
      streamSubscription = null;
    }
  }

  Future addToWishList({required Map<String, dynamic> restaurantInfo, required String docId}) async {
    await FirebaseFirestore.instance
        .collection("wishlist")
        .doc(FirebaseAuth.instance.currentUser!.phoneNumber)
        .collection("my_wishlist")
        .doc(docId)
        .set(restaurantInfo);
  }

  Future removeFromWishList({required String docId}) async {
    await FirebaseFirestore.instance
        .collection("wishlist")
        .doc(FirebaseAuth.instance.currentUser!.phoneNumber)
        .collection("my_wishlist")
        .doc(docId).delete();
  }

  @override
  void onInit() {
    super.onInit();
    startListener();
  }
}