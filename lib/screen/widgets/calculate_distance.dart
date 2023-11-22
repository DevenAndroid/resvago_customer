import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../controller/location_controller.dart';

class CalculateDistanceFromStoreWidget extends StatefulWidget {
  const CalculateDistanceFromStoreWidget({super.key, required this.latLng});

  final LatLng latLng;

  @override
  State<CalculateDistanceFromStoreWidget> createState() => _CalculateDistanceFromStoreWidgetState();
}

class _CalculateDistanceFromStoreWidgetState extends State<CalculateDistanceFromStoreWidget> {
  final locationController = Get.put(LocationController());

  String _calculateDistance({dynamic lat1, dynamic lon1}) {
    if (locationController.currentUserPosition == null) {
      return "Not Available";
    }
    if (lat1 == 0 || lon1 == 0) {
      return "Not Available";
    }

    double distanceInMeters = Geolocator.distanceBetween(
        lat1, lon1, locationController.currentUserPosition!.latitude, locationController.currentUserPosition!.longitude);
    if ((distanceInMeters / 1000) < 1) {
      return "${distanceInMeters.toInt()} Meter away";
    }
    return "${(distanceInMeters / 1000).toStringAsFixed(2)} KM";
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (locationController.refreshInt.value > 0) {}
      return Text(
        _calculateDistance(
          lat1: widget.latLng.latitude,
          lon1: widget.latLng.longitude,
        ),
        style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w400, color: const Color(0xff384953)),
      );
    });
  }
}
