import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:resvago_customer/widget/apptheme.dart';

import 'addsize.dart';

class CommonTextFieldWidget extends StatelessWidget {
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

  const CommonTextFieldWidget({
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
      onTap: onTap,
      onChanged: onChanged,
      readOnly: readOnly!,
      controller: controller,
      obscureText: hint == hint ? obscureText! : false,
      autofillHints: autofillHints,
      validator: validator,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      minLines: minLines,
      maxLines: maxLines,
      cursorColor: Colors.white,
      style: const TextStyle(color: Colors.white),
      inputFormatters: [
        LengthLimitingTextInputFormatter(length),
      ],
      decoration: InputDecoration(
          hintText: hint,
          focusColor: Colors.black,
          hintStyle: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 14,
            // fontFamily: 'poppins',
            fontWeight: FontWeight.w300,
          ),
          filled: true,
          fillColor: Colors.white.withOpacity(.10),
          contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
          // .copyWith(top: maxLines! > 4 ? AddSize.size18 : 0),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white.withOpacity(.35)),
            borderRadius: BorderRadius.circular(10.0),
          ),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white.withOpacity(.35)),
              borderRadius: const BorderRadius.all(Radius.circular(10.0))),
          border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white.withOpacity(.35), width: 3.0),
              borderRadius: BorderRadius.circular(15.0)),
          suffixIcon: suffix,
          prefixIcon: prefix),
    );
  }
}
class CommonTextFiel1dWidget extends StatelessWidget {
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

  const CommonTextFiel1dWidget({
    Key? key,
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
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: onTap,
      onChanged: onChanged,
      readOnly: readOnly!,
      controller: controller,
      obscureText: hint == hint ? obscureText! : false,
      autofillHints: autofillHints,
      validator: validator,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      minLines: minLines,
      maxLines: maxLines,
      cursorColor: Colors.grey,
      style: const TextStyle(color: Colors.grey),
      inputFormatters: [
        LengthLimitingTextInputFormatter(length),
      ],
      decoration: InputDecoration(
          hintText: hint,
          focusColor: Colors.black,
          hintStyle: GoogleFonts.poppins(
            color: Colors.grey,
            fontSize: 14,
            // fontFamily: 'poppins',
            fontWeight: FontWeight.w300,
          ),
          filled: true,
          fillColor: Colors.grey.withOpacity(.10),
          contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
          // .copyWith(top: maxLines! > 4 ? AddSize.size18 : 0),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.circular(10.0),
          ),
          enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          border: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.grey, width: 3.0),
              borderRadius: BorderRadius.circular(15.0)),
          suffixIcon: suffix,
          prefixIcon: prefix),
    );
  }
}

class CommonButton extends StatelessWidget {
  final String title;
  final VoidCallback? onPressed;

  const CommonButton({super.key, required this.title, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: Colors.white),
      child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            minimumSize: Size(AddSize.screenWidth, AddSize.size50 * 1.2),
            backgroundColor: Colors.transparent,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12), // <-- Radius
            ),
            // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: Text(title,
              style: GoogleFonts.poppins(fontWeight: FontWeight.w700, color: AppTheme.primaryColor, fontSize: 20))),
    );
  }
}

class CommonTextFieldWidget1 extends StatelessWidget {
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

  const CommonTextFieldWidget1({
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
      onTap: onTap,
      onChanged: onChanged,
      readOnly: readOnly!,
      controller: controller,
      obscureText: hint == hint ? obscureText! : false,
      autofillHints: autofillHints,
      validator: validator,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      minLines: minLines,
      maxLines: maxLines,
      cursorColor: Colors.black,
      inputFormatters: [
        LengthLimitingTextInputFormatter(length),
      ],
      decoration: InputDecoration(
          hintText: hint,
          focusColor: Colors.black,
          hintStyle: const TextStyle(
            color: Color(0xff9DA4BB),
            fontSize: 14,
            fontFamily: 'poppins',
            fontWeight: FontWeight.w300,
          ),
          filled: true,

          fillColor: Colors.white,
          contentPadding: EdgeInsets.zero,
          // contentPadding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
          // .copyWith(top: maxLines! > 4 ? AddSize.size18 : 0),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(10.0),
          ),
          enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white), borderRadius: BorderRadius.all(Radius.circular(10.0))),
          border: OutlineInputBorder(
              borderSide: const BorderSide(color: Color(0xFFD8DCDD), width: 3.0), borderRadius: BorderRadius.circular(15.0)),
          suffixIcon: suffix,
          prefixIcon: prefix),
    );
  }
}
