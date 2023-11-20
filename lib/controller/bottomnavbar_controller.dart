import 'package:flutter/material.dart';
import 'package:get/get.dart';
class BottomNavBarController extends GetxController{
  RxInt pageIndex = 0.obs;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  updateIndexValue(value) {pageIndex.value = value;
  }
}