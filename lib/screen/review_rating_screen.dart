import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:resvago_customer/screen/homepage.dart';
import 'package:resvago_customer/widget/apptheme.dart';
import '../widget/addsize.dart';
import '../widget/common_text_field.dart';
import '../widget/custom_textfield.dart';

class ReviewAndRatingScreen extends StatefulWidget {
  ReviewAndRatingScreen({super.key, required this.orderId, required this.vendorId});
  String? orderId;
  String? vendorId;
  @override
  State<ReviewAndRatingScreen> createState() => _ReviewAndRatingScreenState();
}

class _ReviewAndRatingScreenState extends State<ReviewAndRatingScreen> {
  double fullRating = 0;
  bool foodQualityValue = false;
  bool foodQuantityValue = false;
  bool communicationValue = false;
  bool hygieneValue = false;
  TextEditingController aboutController = TextEditingController();
  String userName = '';
  String profileImage = '';

  void checkFirstore() async {
    final result =
    await  FirebaseFirestore.instance
        .collection('Review').where('userID', isEqualTo: FirebaseAuth.instance.currentUser!.phoneNumber).get();

    if (result.docs.isNotEmpty) {
      Fluttertoast.showToast(msg: 'Review already added');
      return;
    }
    Addreviewdatatofirebase();
  }

  Addreviewdatatofirebase() {
    FirebaseFirestore.instance
        .collection('Review')
        .doc(FirebaseAuth.instance.currentUser!.phoneNumber)
        .set({
      "fullRating": fullRating,
      "foodQualityValue": foodQualityValue,
      "foodQuantityValue": foodQuantityValue,
      "communicationValue": communicationValue,
      "hygieneValue": hygieneValue,
      "about": aboutController.text,
      "time": DateTime.now().millisecondsSinceEpoch.toString(),
      "userName": userName,
      "userID": FirebaseAuth.instance.currentUser!.phoneNumber,
      "vendorID": widget.vendorId,
      "orderID": widget.orderId,
    }).then((value) {
      Get.back();
      Fluttertoast.showToast(msg: 'Review Added Successfully');
    });
  }

  Future<String> getUserName() async {
    try {
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('customer_users').doc(FirebaseAuth.instance.currentUser!.phoneNumber).get();
      if (userDoc.exists) {
        userName = userDoc.get('userName');
        userName = userDoc.get('userName');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching user data: $e');
      }
    }
    return userName;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserName();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: backAppBar(title: "Review", context: context),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                height: 240,
                width: Get.width,
                decoration: const BoxDecoration(color: Colors.white),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'How did we do?',
                      style: TextStyle(color: Color(0xff1A2E33), fontSize: 18),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    RatingBar.builder(
                      initialRating: 0,
                      minRating: 1,
                      unratedColor: const Color(0xFF698EDE).withOpacity(.2),
                      itemCount: 5,
                      itemSize: 30.0,
                      itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                      updateOnDrag: true,
                      itemBuilder: (context, index) => Image.asset(
                        'assets/icons/star.png',
                        color: const Color(0xffFFC94D),
                      ),
                      onRatingUpdate: (ratingvalue) {
                        setState(() {
                          fullRating = ratingvalue;
                        });
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Checkbox(
                                  activeColor: AppTheme.primaryColor,
                                  value: foodQualityValue,
                                  onChanged: (value) {
                                    setState(() {
                                      foodQualityValue = value!;
                                    });
                                  }),
                              const Text(
                                'food quality',
                                style: TextStyle(color: Colors.black, fontSize: 20),
                              ),
                              const SizedBox(width: 20), // Add some space between checkboxes
                              Checkbox(
                                  activeColor: AppTheme.primaryColor,
                                  value: foodQuantityValue,
                                  onChanged: (value) {
                                    setState(() {
                                      foodQuantityValue = value!;
                                    });
                                  }),
                              const Text(
                                'food quantity',
                                style: TextStyle(color: Colors.black, fontSize: 20),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Checkbox(
                                  activeColor: AppTheme.primaryColor,
                                  value: communicationValue,
                                  onChanged: (value) {
                                    setState(() {
                                      communicationValue = value!;
                                    });
                                  }),
                              const Text(
                                'communication',
                                style: TextStyle(color: Colors.black, fontSize: 20),
                              ),
                              const SizedBox(width: 20), // Add some space between checkboxes
                              Checkbox(
                                  activeColor: AppTheme.primaryColor,
                                  value: hygieneValue,
                                  onChanged: (value) {
                                    setState(() {
                                      hygieneValue = value!;
                                    });
                                  }),
                              const Text(
                                'hygiene',
                                style: TextStyle(color: Colors.black, fontSize: 20),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                height: 300,
                width: Get.width,
                decoration: const BoxDecoration(color: Colors.white),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'How did we do?',
                      style: TextStyle(color: Color(0xff1A2E33), fontSize: 18),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: aboutController,
                      textInputAction: TextInputAction.next,
                      minLines: 7,
                      maxLines: 7,
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "About required";
                        } else {
                          return null;
                        }
                      },
                      decoration: InputDecoration(
                        focusColor: Colors.black,
                        hintStyle: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 14,
                          // fontFamily: 'poppins',
                          fontWeight: FontWeight.w300,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
                        // .copyWith(top: maxLines! > 4 ? AddSize.size18 : 0),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey.withOpacity(.35)),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey.withOpacity(.35)),
                            borderRadius: const BorderRadius.all(Radius.circular(10.0))),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey.withOpacity(.35), width: 3.0),
                            borderRadius: BorderRadius.circular(15.0)),
                      ),
                    ),
                  ],
                ),
              ),
              CommonButtonBlue(
                onPressed: () {
                  checkFirstore();
                },
                title: 'FeedBack',
              ),
              const SizedBox(
                height: 15,
              ),
              ElevatedButton(
                onPressed: () {
                  Get.back();
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    minimumSize: Size(AddSize.screenWidth, AddSize.size50),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(3),
                        side: const BorderSide(
                          color: Color(0xFF3B5998),
                        )),
                    textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                child: Text(
                  "Leave a review",
                  style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w500, color: AppTheme.primaryColor),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
