import 'dart:async';
import 'dart:developer';
import 'dart:ui' as ui;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:resvago_customer/screen/myAddressList.dart';
import 'package:resvago_customer/widget/custom_textfield.dart';

import '../widget/addsize.dart';
import '../widget/appassets.dart';
import '../widget/apptheme.dart';
import '../widget/common_text_field.dart';

class ChooseAddress extends StatefulWidget {
  String? streetAddress;
  String? name;
  String? flatAddress;
  String? docID;
  String? selectedChip;
  final bool isEditMode;

  ChooseAddress(
      {super.key, required this.isEditMode, this.streetAddress, this.selectedChip, this.name, this.flatAddress, this.docID});
  static var chooseAddressScreen = "/chooseAddressScreen";

  @override
  State<ChooseAddress> createState() => _ChooseAddressState();
}

class _ChooseAddressState extends State<ChooseAddress> {
  final _formKey = GlobalKey<FormState>();
  final List<String> choiceAddress = ["Home", "Office", "Hotel", "Other"];
  final RxBool _isValue = false.obs;
  RxBool customTip = false.obs;
  RxString selectedChip = "Home".obs;
  final TextEditingController searchController = TextEditingController();
  final TextEditingController otherController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController streetAddressController = TextEditingController();
  final TextEditingController flatAddressController = TextEditingController();

  final Completer<GoogleMapController> googleMapController = Completer();
  GoogleMapController? mapController;

  String? _address = "";
  Position? _currentPosition;

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();

    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high).then((Position position) {
      setState(() => _currentPosition = position);
      _getAddressFromLatLng(_currentPosition!);
      mapController!.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(_currentPosition!.latitude, _currentPosition!.longitude), zoom: 15)));
      // _onAddMarkerButtonPressed(LatLng(_currentPosition!.latitude, _currentPosition!.longitude), "current location");
      setState(() {});
      // location = _currentAddress!;
    }).catchError((e) {
      debugPrint(e);
    });
  }

  Future<void> _getAddressFromLatLng(Position position) async {
    await placemarkFromCoordinates(_currentPosition!.latitude, _currentPosition!.longitude).then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      setState(() {
        _address = '${place.subLocality}, ${place.subAdministrativeArea}, ${place.postalCode}';
      });
    }).catchError((e) {
      debugPrint(e.toString());
    });
  }

  showChangeAddressSheet() {
    print(selectedChip.value);
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        enableDrag: false,
        isDismissible: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        builder: (context) {
          return WillPopScope(
            onWillPop: () async {
              return false;
            },
            child: Obx(() {
              return Padding(
                  padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () {
                              setState(() {
                                _isValue.value = !_isValue.value;
                              });
                              Get.back();
                              setState(() {});
                            },
                            child: Container(
                              height: 50,
                              width: 50,
                              decoration: const ShapeDecoration(color: AppTheme.blackcolor, shape: CircleBorder()),
                              child: Center(
                                  child: Icon(
                                Icons.clear,
                                color: AppTheme.backgroundcolor,
                                size: AddSize.size30,
                              )),
                            ),
                          ),
                          SizedBox(
                            height: AddSize.size20,
                          ),
                          Container(
                            width: double.maxFinite,
                            decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20))),
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: AddSize.padding16, vertical: AddSize.padding16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Enter complete address",
                                    style: TextStyle(color: AppTheme.blackcolor, fontWeight: FontWeight.w600, fontSize: 17),
                                  ),
                                  SizedBox(
                                    height: AddSize.size12,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: List.generate(
                                      choiceAddress.length,
                                      (index) => chipList(choiceAddress[index]),
                                    ),
                                  ),
                                  SizedBox(
                                    height: AddSize.size20,
                                  ),
                                  if (customTip.value)
                                    const CommonTextFiel1dWidget(
                                      hint: "Other",
                                    ),
                                  SizedBox(
                                    height: AddSize.size20,
                                  ),
                                  CommonTextFiel1dWidget(
                                    controller: streetAddressController,
                                    hint: "Flat, House no, Floor, Tower,Street",
                                    validator: MultiValidator([
                                      RequiredValidator(errorText: 'Flat, House no, Floor, Tower,Street'),
                                    ]).call,
                                  ),
                                  SizedBox(
                                    height: AddSize.size20,
                                  ),
                                  CommonTextFiel1dWidget(
                                    controller: flatAddressController,
                                    hint: "Street, Society, Landmark",
                                    validator: MultiValidator([
                                      RequiredValidator(errorText: 'Select city'),
                                    ]).call,
                                  ),
                                  SizedBox(
                                    height: AddSize.size20,
                                  ),
                                  CommonTextFiel1dWidget(
                                    hint: "Recipient’s name",
                                    controller: nameController,
                                    validator: MultiValidator([
                                      RequiredValidator(errorText: 'Recipient’s name'),
                                    ]).call,
                                  ),
                                  SizedBox(
                                    height: AddSize.size20,
                                  ),
                                  CommonButtonBlue(
                                    title: 'save address'.toUpperCase(),
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        AddAddresstofirebase();
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // Obx(() {
                          //   return SizedBox(
                          //     height: sizeBoxHeight.value,
                          //   );
                          // })
                        ],
                      ),
                    ),
                  ));
            }),
          );
        });
  }

  AddAddresstofirebase() {
    if (widget.isEditMode == false) {
      FirebaseFirestore.instance
          .collection('Address')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('TotalAddress')
          .add({
        "name": nameController.text,
        "streetAddress": streetAddressController.text,
        "flatAddress": flatAddressController.text,
        "AddressType": selectedChip.value,
        "time": DateTime.now(),
        "userID": FirebaseAuth.instance.currentUser!.uid,
      }).then((value) {
        Get.back();
        Get.back();
        Fluttertoast.showToast(msg: 'Address Added');
      });
    } else {
      FirebaseFirestore.instance
          .collection('Address')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('TotalAddress')
          .doc(widget.docID)
          .update({
        "name": nameController.text,
        "streetAddress": streetAddressController.text,
        "flatAddress": flatAddressController.text,
        "AddressType": selectedChip.value,
        "time": DateTime.now(),
        "userID": FirebaseAuth.instance.currentUser!.uid,
      }).then((value) {
        Get.back();
        Get.back();
        Fluttertoast.showToast(msg: 'Address Updated');
      });
    }
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _getCurrentPosition();
    });
    nameController.text = widget.name ?? "";
    streetAddressController.text = widget.streetAddress ?? "";
    flatAddressController.text = widget.flatAddress ?? "";
    selectedChip.value = widget.selectedChip ?? "Home";
  }

  String googleApikey = "AIzaSyDDl-_JOy_bj4MyQhYbKbGkZ0sfpbTZDNU";
  GoogleMapController? mapController1; //contrller for Google map
  CameraPosition? cameraPosition;
  String location = "Search Location";
  final Set<Marker> markers = {};
  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
  }

  // Future<void> _onAddMarkerButtonPressed(LatLng lastMapPosition, markerTitle, {allowZoomIn = true}) async {
  //   final Uint8List markerIcon = await getBytesFromAsset(location, 100);
  //   markers.clear();
  //   markers.add(Marker(
  //       markerId: MarkerId(lastMapPosition.toString()),
  //       position: lastMapPosition,
  //       infoWindow: const InfoWindow(
  //         title: "",
  //       ),
  //       icon: BitmapDescriptor.fromBytes(markerIcon)));
  //   // BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan,)));
  //   if (googleMapController.isCompleted) {
  //     mapController!
  //         .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: lastMapPosition, zoom: allowZoomIn ? 14 : 11)));
  //   }
  //   setState(() {});
  // }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        mapController!.dispose();
        return true;
      },
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          FocusManager.instance.primaryFocus!.unfocus();
        },
        child: Scaffold(
            appBar: backAppBar(
                title: _isValue.value == true ? "Complete Address" : "Choose Address",
                context: context,
                dispose: "dispose",
                disposeController: () {
                  mapController!.dispose();
                }),
            body: Stack(
              children: [
                GoogleMap(
                  zoomGesturesEnabled: true,
                  initialCameraPosition: const CameraPosition(
                    target: LatLng(0, 0),
                    zoom: 14.0, //initial zoom level
                  ),
                  mapType: MapType.normal,
                  onMapCreated: (controller) {
                    mapController = controller;
                    setState(() async {
                    });
                  },
                  markers: markers,

                  // myLocationEnabled: true,
                  // myLocationButtonEnabled: true,
                  // compassEnabled: true,
                  // markers: Set<Marker>.of(_markers),
                  onCameraMove: (CameraPosition cameraPositions) {
                    cameraPosition = cameraPositions;
                  },
                  onCameraIdle: () async {},
                ),
                Positioned(
                    bottom: 0,
                    child: Container(
                      height: AddSize.size200,
                      width: MediaQuery.of(context).size.width,
                      decoration: const BoxDecoration(
                          color: AppTheme.backgroundcolor,
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: AddSize.padding16,
                          vertical: AddSize.padding10,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.location_on,
                                        color: AppTheme.primaryColor,
                                        size: AddSize.size25,
                                      ),
                                      SizedBox(
                                        width: AddSize.size12,
                                      ),
                                      Expanded(
                                        child: Text(
                                          _address.toString(),
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineSmall!
                                              .copyWith(fontWeight: FontWeight.w500, fontSize: AddSize.font16),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: AddSize.size30,
                            ),
                            CommonButtonBlue(
                              title: "Enter complete address",
                              onPressed: () {
                                setState(() {
                                  _isValue.value = !_isValue.value;
                                });
                                // FocusManager.instance.primaryFocus!.unfocus();
                                showChangeAddressSheet();
                                // Get.toNamed(MyRouter.chooseAddressScreen);
                              },
                            ),
                          ],
                        ),
                      ),
                    ))
              ],
            )),
      ),
    );
  }

  chipList(
    title,
  ) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Obx(() {
      return Column(
        children: [
          ChoiceChip(
            padding: EdgeInsets.symmetric(horizontal: width * .01, vertical: height * .01),
            backgroundColor: AppTheme.backgroundcolor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(color: title != selectedChip.value ? Colors.grey.shade300 : const Color(0xff7ED957))),
            label: Text("$title",
                style: TextStyle(
                    color: title != selectedChip.value ? Colors.grey.shade600 : const Color(0xff7ED957),
                    fontSize: AddSize.font14,
                    fontWeight: FontWeight.w500)),
            selected: title == selectedChip.value,
            selectedColor: const Color(0xff7ED957).withOpacity(.13),
            onSelected: (value) {
              selectedChip.value = title;
              if (title == "Other") {
                customTip.value = true;
                otherController.text = "";
              } else {
                customTip.value = false;
                otherController.text = title;
              }
              setState(() {});
            },
          )
        ],
      );
    });
  }
}
