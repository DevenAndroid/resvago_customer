import 'dart:convert';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../model/checkout_model.dart';
import '../model/menu_model.dart';
import '../model/registerData.dart';
import '../screen/helper.dart';

class FirebaseService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future manageRegisterUsers({
    dynamic userName,
    dynamic email,
    dynamic docid,
    dynamic mobileNumber,
    dynamic userID,
  }) async {
    try {
      CollectionReference collection = FirebaseFirestore.instance.collection('customer_users');
      var DocumentReference = collection.doc("+91$mobileNumber");

      DocumentReference.set({
        "userName": userName,
        "email": email,
        "docid": docid,
        "mobileNumber": mobileNumber,
        "userID": "+91$mobileNumber",
      }).then((value) {});
    } catch (e) {
      throw Exception(e);
    }
  }

  Future manageWishlist({
    required String wishlistId,
    dynamic userId,
    dynamic vendorId,
    dynamic time,
  }) async {
    try {
      await FirebaseFirestore.instance
          .collection('wishlist')
          .doc(FirebaseAuth.instance.currentUser!.phoneNumber)
          .collection("wishlist_list")
          .doc(wishlistId)
          .set({"wishlistId": wishlistId, "userId": userId, "vendorId": vendorId, "time": time});
    } catch (e) {
      throw Exception(e);
    }
  }

 Future manageCheckOut(
      {required String cartId,
      dynamic vendorId,
      required Map<String, dynamic> restaurantInfo,
      required List<dynamic> menuList,
      dynamic time}) async {
    try {
      await FirebaseFirestore.instance.collection('checkOut').doc(FirebaseAuth.instance.currentUser!.phoneNumber).set({
        "cartId": cartId,
        "userId": FirebaseAuth.instance.currentUser!.phoneNumber,
        "vendorId": vendorId,
        "restaurantInfo": restaurantInfo,
        "menuList": menuList,
        "time": time
      });
      showToast("Checkout Successfully");
    } catch (e) {
      throw Exception(e);
    }
  }

  Future manageOrder(
      {required String orderId,
        dynamic vendorId,
        dynamic address,
        dynamic couponDiscount,
        required Map<String, dynamic> restaurantInfo,
        // required List<MenuList> menuList,
        dynamic time}) async {
    try {
      await FirebaseFirestore.instance.collection('order').doc(FirebaseAuth.instance.currentUser!.phoneNumber).set({
        "orderId": orderId,
        "userId": FirebaseAuth.instance.currentUser!.phoneNumber,
        "vendorId": vendorId,
        "restaurantInfo": restaurantInfo,
        // "menuList": menuList,
        "address":address,
        "couponDiscount":couponDiscount,
        "time": time,
        "order_type":"COD",
        "order_status":"Place Order"
      });
      showToast("Order Placed Successfully");
    } catch (e) {
      throw Exception(e);
    }
  }




  Future<RegisterData?> getUserInfo({required String uid}) async {
    RegisterData? vendorModel;
    DocumentSnapshot docSnap = await firestore.collection("customer_users").doc(uid.trim()).get();
    if (kDebugMode) {
      if (kDebugMode) print(docSnap.exists);
    }
    if (docSnap.data() != null) {
      vendorModel = RegisterData.fromMap(docSnap.data() as Map<String, dynamic>);
      log(jsonEncode(docSnap.data()));
    }
    return vendorModel;
  }
}
