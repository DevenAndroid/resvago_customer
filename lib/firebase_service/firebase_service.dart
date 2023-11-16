import 'dart:convert';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../model/checkout_model.dart';
import '../model/menu_model.dart';
import '../model/model_store_slots.dart';
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
      var DocumentReference = collection.doc(mobileNumber);

      DocumentReference.set({
        "userName": userName,
        "email": email,
        "docid": docid,
        "mobileNumber": mobileNumber,
        "userID": mobileNumber,
        "profile_image":"",
        "password": "123456",
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
      showToast("Added To Cart Successfully");
    } catch (e) {
      throw Exception(e);
    }
  }

  Future manageOrder(
      {required String orderId,
        dynamic vendorId,
        dynamic fcm,
        dynamic address,
        dynamic date,
        dynamic slot,
        dynamic guest,
        dynamic offer,
        dynamic couponDiscount,
        dynamic total,
        required Map<String, dynamic> restaurantInfo,
        required Map<String, dynamic> profileData,
        dynamic time}) async {
    try {
      await FirebaseFirestore.instance.collection('order').add({
        "orderId": orderId,
        "userId": FirebaseAuth.instance.currentUser!.phoneNumber,
        "vendorId": vendorId,
        "order_details": restaurantInfo,
        "user_data": profileData,
        "address":address,
        "couponDiscount":couponDiscount,
        "time": time,
        "order_type":"COD",
        "order_status":"Place Order",
        "fcm_token":fcm,
        "total":total
      });
      showToast("Order Placed Successfully");
    } catch (e) {
      throw Exception(e);
    }
  }


  Future manageOrderForDining(
      {required String orderId,
        dynamic vendorId,
        dynamic fcm,
        dynamic address,
        dynamic date,
        required bool lunchSelected,
        dynamic slot,
        dynamic guest,
        dynamic offer,
        dynamic total,
        dynamic couponDiscount,
        required Map<String, dynamic> restaurantInfo,
        required Map<String, dynamic> profileData,
        required List<dynamic> menuList,
        dynamic time}) async {
    try {
      final slotDocument = firestore.collection("vendor_slot").doc(vendorId.toString()).collection("slot").doc(date.toString());
      await firestore.runTransaction((transaction) {
      return transaction.get(slotDocument).then((transactionDoc) {
        log("transaction data.......        ${transactionDoc.data()}");
        CreateSlotData createSlotData = CreateSlotData.fromMap(transactionDoc.data() ?? {});
        createSlotData.morningSlots = createSlotData.morningSlots ?? {};
        createSlotData.eveningSlots = createSlotData.eveningSlots ?? {};
        log("transaction data.......        ${createSlotData.toMap()}");
        // log("transaction data.......        $slot");

        int? availableSeats = lunchSelected ?
        createSlotData.morningSlots![slot.toString()] :
        createSlotData.eveningSlots![slot.toString()];
        log("transaction data.......        ${slot}    ${guest}    $lunchSelected     $availableSeats   ");

        if(availableSeats != null){
          if(availableSeats < int.parse("$guest")){
            showToast("Some seats are booked\nPlease select seats again");
            throw Exception();
          } else {
            if(lunchSelected){
              createSlotData.morningSlots![slot.toString()] = availableSeats - int.parse("$guest");
            } else {
              createSlotData.eveningSlots![slot.toString()] = availableSeats - int.parse("$guest");
            }
          }
        } else {
          showToast("Seats not available");
          throw Exception();
        }

        log("transaction data.......        ${createSlotData.toMap()}");
        // throw Exception();
        transaction.update(slotDocument, createSlotData.toMap());
      });
    }).then((newPopulation) => print("Population increased to $newPopulation"),
      onError: (e) {
      throw Exception(e);
      },
    );
      await firestore.collection('dining_order').add({
        "orderId": orderId,
        "userId": FirebaseAuth.instance.currentUser!.phoneNumber,
        "vendorId": vendorId,
        "restaurantInfo": restaurantInfo,
        "user_data": profileData,
        "menuList": menuList,
        "time": time,
        "date":date.toString(),
        "slot":slot,
        "guest":guest,
        "offer":"20%",
        "order_type":"COD",
        "order_status":"Place Order",
        "fcm_token":fcm,
        "total":total
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
