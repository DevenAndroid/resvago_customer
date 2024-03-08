import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:resvago_customer/screen/bottomnav_bar.dart';
import 'package:resvago_customer/screen/homepage.dart';
import 'addsize.dart';
import 'appassets.dart';
import 'apptheme.dart';

class RegisterTextFieldWidget extends StatelessWidget {
  final IconData? suffixIcon;
  final IconData? prefixIcon;
  final Widget? suffix;
  final Widget? prefix;
  final Color? bgColor;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final String? hint;
  final Iterable<String>? autofillHints;
  final ValueChanged<String>? onChanged;
  final TextEditingController? controller;
  final bool? readOnly;
  final dynamic value = 0;
  final dynamic minLines;
  final dynamic maxLines;
  final bool? obscureText;
  final VoidCallback? onTap;
  final length;

  const RegisterTextFieldWidget({
    super.key,
    this.suffixIcon,
    this.prefixIcon,
    this.onChanged,
    this.hint,
    this.keyboardType,
    this.textInputAction,
    this.controller,
    this.bgColor,
    this.validator,
    this.suffix,
    this.autofillHints,
    this.prefix,
    this.minLines = 1,
    this.maxLines = 1,
    this.obscureText = false,
    this.readOnly = false,
    this.onTap,
    this.length,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: const TextStyle(color: Color(0xFF384953)),
      onTap: onTap,
      onChanged: onChanged,
      readOnly: readOnly!,
      controller: controller,
      obscureText: hint == hint ? obscureText! : false,
      autofillHints: autofillHints,
      validator: validator,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      minLines: minLines,
      maxLines: maxLines,
      cursorColor: AppTheme.primaryColor,
      inputFormatters: [
        LengthLimitingTextInputFormatter(length),
      ],
      decoration: InputDecoration(

          hintText: hint,
          focusColor: const Color(0xFF384953),
          hintStyle: GoogleFonts.poppins(
            color: const Color(0xFF384953),
            textStyle: GoogleFonts.poppins(
              color: const Color(0xFF384953),
              fontSize: 14,
              fontWeight: FontWeight.w300,
            ),
            fontSize: 14,
            // fontFamily: 'poppins',
            fontWeight: FontWeight.w300,
          ),
          filled: true,
          fillColor: Colors.white.withOpacity(.10),
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 15, vertical: 16),
          // .copyWith(top: maxLines! > 4 ? AddSize.size18 : 0),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: const Color(0xFF384953).withOpacity(.24)),
            borderRadius: BorderRadius.circular(6.0),
          ),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: const Color(0xFF384953).withOpacity(.24)),
              borderRadius: const BorderRadius.all(Radius.circular(6.0))),
          border: OutlineInputBorder(
              borderSide:
              BorderSide(color:const Color(0xFF384953).withOpacity(.24), width: 3.0),
              borderRadius: BorderRadius.circular(6.0)),
          suffixIcon: suffix,
          prefixIcon: prefix),
    );
  }
}
class CommonButtonBlue extends StatelessWidget {
  final String title;
  final VoidCallback? onPressed;

  const CommonButtonBlue({Key? key, required this.title, this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6), color: AppTheme.primaryColor),
      child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            minimumSize: Size(AddSize.screenWidth, AddSize.size50 * 1.2),
            backgroundColor: AppTheme.primaryColor,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8), // <-- Radius
            ),
            // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: Text(title,
              style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  letterSpacing: .5,
                  fontSize: 20))),
    );
  }
}

AppBar backAppBar(
    {required title,
      required BuildContext context,
      String dispose = "",
      Color? backgroundColor = AppTheme.backgroundcolor,
      Color? textColor = Colors.black,
      Widget? icon,
      Widget? icon2,
      disposeController}) {
  return AppBar(
    toolbarHeight: 60,
    elevation: 0,
    leadingWidth: AddSize.size22 * 1.6,
    backgroundColor: backgroundColor,
    surfaceTintColor: AppTheme.backgroundcolor,
    title: Text(
      title,
      style: GoogleFonts.poppins(color: const Color(0xFF423E5E), fontWeight: FontWeight.w600, fontSize: 17),
    ),
    actions: [
      icon2 ?? const SizedBox.shrink()
    ],
    leading: Padding(
      padding: EdgeInsets.only(left: AddSize.padding10),
      child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            if(dispose == 'Data'){
              Get.offAll(const BottomNavbar());
            }
            if(dispose == 'orderScreen'){
              Get.offAll(const BottomNavbar());
            }
            Get.back();
          },
          child: icon ??
              SvgPicture.asset(AppAssets.back)),
    ),
  );
}