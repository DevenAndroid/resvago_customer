import 'package:get/get.dart';
class BottomNavBarController extends GetxController{
  RxInt pageIndex = 0.obs;
  updateIndexValue(value) {pageIndex.value = value;
  }
}