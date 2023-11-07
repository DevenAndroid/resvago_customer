import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
class BottomNavBarController extends GetxController{

  final scaffoldKey = GlobalKey<ScaffoldState>();

  RxInt pageIndex = 0.obs;
  updateIndexValue(value) {pageIndex.value = value;
  }


  updateFCMToken() async {
    print("updated............");
    try {
      String? fcm = await FirebaseMessaging.instance.getToken();
      FirebaseDatabase firebaseDatabase = FirebaseDatabase.instance;
      print("updated............     $fcm");
      final ref = firebaseDatabase.ref(
          "users/${FirebaseAuth.instance.currentUser!.phoneNumber.toString()}");
      await ref.update({
        fcm.toString(): fcm.toString()
      }).then((value) {
        print("updated............");
      }).catchError((e){
        print("updated............    $e");
      });
      print("updated............");
    } catch(e){
      print("updated............    $e");
      throw Exception(e);
    }
  }
}