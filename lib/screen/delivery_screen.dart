import 'package:flutter/material.dart';
import 'package:get/get.dart';
class DeliveryScreen extends StatefulWidget {
  const DeliveryScreen({super.key});

  @override
  State<DeliveryScreen> createState() => _DeliveryScreenState();
}

class _DeliveryScreenState extends State<DeliveryScreen> {
  @override
  Widget build(BuildContext context) {
    return   Scaffold(
      body: Center(
        child: Text(
            "Delivery".tr
        ),
      ),
    );
  }
}
