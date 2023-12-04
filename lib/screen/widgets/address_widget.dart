import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:resvago_customer/controller/location_controller.dart';
import '../../model/add_address_modal.dart';
import '../login_screen.dart';
import '../myAddressList.dart';

class AddressWidget extends StatefulWidget {
  const AddressWidget({super.key, required this.addressId});
  final String addressId;

  @override
  State<AddressWidget> createState() => _AddressWidgetState();
}

class _AddressWidgetState extends State<AddressWidget> {

  final locationController = Get.put(LocationController());
  @override
  void initState() {
    super.initState();
    locationController.checkGps(context);
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FirebaseAuth _auth = FirebaseAuth.instance;
        User? user = _auth.currentUser;
        if (user != null) {
          Get.to(() => MyAddressList(
                addressChanged: (AddressModel address) {},
              ));
        } else {
          Get.to(() => LoginScreen());
        }
      },
      behavior: HitTestBehavior.translucent,
      child: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Address')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection('TotalAddress')
            .doc(widget.addressId)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.hasData && snapshot.data!.exists) {
            AddressModel addressModel = AddressModel.fromMap(snapshot.data!.data()!, "menuId");
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Image.asset(
                      'assets/icons/location.png',
                      height: 15,
                    ),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        addressModel.AddressType,
                        style: GoogleFonts.poppins(fontWeight: FontWeight.w500, fontSize: 15),
                      ),
                    ),
                    const SizedBox(width: 5),
                    Image.asset(
                      'assets/icons/dropdown.png',
                      height: 8,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 6,
                ),
                Text(addressModel.streetAddress.toString(),
                    style: GoogleFonts.poppins(
                      color: const Color(0xFF1E2538),
                      fontSize: 12,
                      fontWeight: FontWeight.w300,
                    ))
              ],
            );
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                  onTap: () {
                    FirebaseAuth _auth = FirebaseAuth.instance;
                    User? user = _auth.currentUser;
                    if (user != null) {
                      Get.to(() => MyAddressList(
                        addressChanged: (AddressModel address) {},
                      ));
                    } else {
                      Get.to(() => LoginScreen());
                    }
                  },
                  behavior: HitTestBehavior.translucent,
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/icons/location.png',
                        height: 15,
                      ),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          'Home'.tr,
                          style: GoogleFonts.poppins(fontWeight: FontWeight.w500, fontSize: 15),
                        ),
                      ),
                      const SizedBox(width: 5),
                      Image.asset(
                        'assets/icons/dropdown.png',
                        height: 8,
                      ),
                    ],
                  )),
              const SizedBox(
                height: 6,
              ),
              Text(
                locationController.locality.value.toString(),
                style: GoogleFonts.poppins(
                  color: const Color(0xFF1E2538),
                  fontSize: 12,
                  fontWeight: FontWeight.w300,
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
