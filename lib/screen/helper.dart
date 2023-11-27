import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../widget/apptheme.dart';

class Helper {
  static Future addImagePicker({ImageSource imageSource = ImageSource.gallery, int imageQuality = 100}) async {
    try {
      final item = await ImagePicker().pickImage(source: imageSource, imageQuality: imageQuality);
      if (item == null) {
        return null;
      } else {
        return File(item.path);
      }
    } on PlatformException catch (e) {
      throw Exception(e);
    }
  }


  static OverlayEntry overlayLoader(context) {
    OverlayEntry loader = OverlayEntry(builder: (context) {
      final size = MediaQuery.of(context).size;
      return Positioned(
        height: size.height,
        width: size.width,
        top: 0,
        left: 0,
        child: Material(
            color: Colors.white10,
            child: SizedBox(
                height: 35,
                width: 45,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    LoadingAnimationWidget.fourRotatingDots(
                      size: 30,
                      color: AppTheme.primaryColor,
                    )
                  ],
                ))),
      );
    });
    return loader;
  }

  static hideLoader(OverlayEntry loader) {
    Timer(const Duration(milliseconds: 250), () {
      try {
        loader.remove();
        // ignore: empty_catches
      } catch (e) {}
    });
  }
}

showToast(message) {
  Fluttertoast.cancel();
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.white,
      textColor: AppTheme.primaryColor,
      fontSize: 14);
}

loading() {
  return Center(
      child: LoadingAnimationWidget.fourRotatingDots(
    color: AppTheme.primaryColor,
    size: 40,
  ));
}


extension CheckDesktop on BuildContext{

  bool get isWebApp{
    return MediaQuery.of(this).size.width > 450;
  }


  double get paddingWidth{
    return (MediaQuery.of(this).size.width-700 )/ 2;

  }

}

extension AddPaddingtoAll on Widget{

  Widget get appPadding{
    if(kIsWeb){
      return Center(
        child: SizedBox(
          width: 700,
          child: this,
        ),
      );
    }
    return this;
  }

  Widget get appPaddingForScreen{
    if(kIsWeb){
      return Center(
        child: SizedBox(
          width: 1200,
          child: this,
        ),
      );
    }
    return this;
  }

  Widget addPadding(EdgeInsetsGeometry padding){
    return Padding(padding: padding,child: this,);
  }

}

extension AddPaddingTextField on Widget{

  Widget get appPaddingTextField{
    if(kIsWeb){
      return Center(


        child: SizedBox(
          width:  560,
          child: this,
        ),
      );
    }
    return this;
  }

}



extension DateOnlyCompare on DateTime {
  bool isSmallerThen(DateTime other) {
    return (year == other.year && month == other.month && day < other.day) ||
        (year == other.year && month < other.month) ||
        (year < other.year);
  }

  bool get isPreviousDay {
    DateTime now = DateTime.now();
    return DateTime(year, month, day).difference(DateTime(now.year, now.month, now.day)).inDays == -1;
  }

  bool isSameDate(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }
}
