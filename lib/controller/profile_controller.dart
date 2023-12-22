import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../model/profile_model.dart';

class ProfileController extends GetxController {
  ProfileData? profileData;
  RxInt refreshInt = 0.obs;

  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? profileStream;

  cancelStream() {
    if (profileStream != null) {
      profileStream!.cancel();
      profileStream = null;
    }
  }

  updateProfile(DocumentSnapshot<Map<String, dynamic>> event) {
    if (event.exists) {
      if (event.data() == null) return;
      log("profile updated....     ${event.data()}");
      profileData = ProfileData.fromJson(event.data()!);
      refreshInt.value = DateTime.now().millisecondsSinceEpoch;
    }
  }

  void getProfileData() {
    if (FirebaseAuth.instance.currentUser == null) {
      cancelStream();
    }
    profileStream = FirebaseFirestore.instance
        .collection("customer_users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .snapshots()
        .listen(updateProfile);
  }

  Future updateAddress(String addressId) async {
    await FirebaseFirestore.instance
        .collection("customer_users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({"selected_address": addressId});
  }

  @override
  void dispose() {
    super.dispose();
    cancelStream();
  }
}
