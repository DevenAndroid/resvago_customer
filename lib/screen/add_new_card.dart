import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widget/addsize.dart';
import '../widget/appassets.dart';
import '../widget/apptheme.dart';
import '../widget/common_text_field.dart';

class AddNewCardScreen extends StatefulWidget {
  const AddNewCardScreen({Key? key}) : super(key: key);
  static var addNewCardPage = "/addNewCardPage";

  @override
  State<AddNewCardScreen> createState() => _AddNewCardScreenState();
}

class _AddNewCardScreenState extends State<AddNewCardScreen> {
  bool showValidation = false;

  bool value = false;
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color(0xffF9F9F9),
      appBar: backAppBar(
        title: "Add New Card",
        context: context,
      ),
      body: Container(
        margin: EdgeInsets.only(top: 10),
        padding: EdgeInsets.symmetric(horizontal: 10),
        height: height*.48,
        decoration: BoxDecoration(color: Colors.white),
        child: Padding(
          padding: const EdgeInsets.all(9.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: height * .01,
              ),
              Text(
                'Name',
                style: GoogleFonts.poppins(fontSize: AddSize.font16, color: Color(0xff535353), fontWeight: FontWeight.w400),
              ),
              SizedBox(
                height: height * .01,
              ),
              SizedBox(
                height: height * .08,
                child: TextField(
                  maxLines: 3,
                  cursorColor: Color(0xffFFC529),
                  style: GoogleFonts.poppins(fontSize: 17),
                  decoration: InputDecoration(
                    filled: true,

                    border: const OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xffC7C7C7)),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Color(0xffC7C7C7)), borderRadius: BorderRadius.circular(10)),
                    enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xffC7C7C7)),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    fillColor: Colors.white,
                    contentPadding: EdgeInsets.symmetric(horizontal: width * .03, vertical: height * .02),

                    hintStyle: GoogleFonts.ibmPlexSansArabic(
                        fontSize: AddSize.font16, color: Color(0xffACACB7), fontWeight: FontWeight.w700),

                    // prefixIcon: IconButton(
                    //   onPressed: () {
                    //     // Get.to(const SearchScreenData());
                    //
                    //   },
                    //   icon: const Icon(
                    //     Icons.place_rounded,
                    //     color: Color(0xffD3D1D8),
                    //     size: 30,
                    //   ),
                    // ),
                  ),
                ),
              ),
              SizedBox(
                height: height * .01,
              ),
              Text(
                'Card Number',
                style: GoogleFonts.poppins(fontSize: AddSize.font16, color: Color(0xff535353), fontWeight: FontWeight.w400),
              ),
              SizedBox(
                height: height * .01,
              ),
              SizedBox(
                height: height * .08,
                child: TextField(
                  maxLines: 3,
                  cursorColor: Color(0xffFFC529),
                  style: GoogleFonts.poppins(fontSize: 17),
                  // textAlignVertical: TextAlignVertical.center,
                  // textInputAction: TextInputAction.search,
                  keyboardType: TextInputType.number,
                  onSubmitted: (value) => {},
                  decoration: InputDecoration(
                    filled: true,
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xffC7C7C7)),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xffC7C7C7)), borderRadius: BorderRadius.circular(10)),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xffC7C7C7)),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    fillColor: Colors.white,
                    contentPadding: EdgeInsets.symmetric(horizontal: width * .03, vertical: height * .02),
                    suffixIcon: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image(
                        height: 35,
                        width: 35,
                        image: AssetImage(AppAssets.paymentCardIcon),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: height * .01,
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Expires',
                      style: GoogleFonts.poppins(
                          fontSize: AddSize.font16, color: Color(0xff535353), fontWeight: FontWeight.w400),
                    ),
                  ),
                  SizedBox(
                    width: width * .05,
                  ),
                  Expanded(
                    child: Text(
                      'CVV',
                      style: GoogleFonts.poppins(
                          fontSize: AddSize.font16, color: Color(0xff535353), fontWeight: FontWeight.w400),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: height * .08,
                      child: TextField(
                        maxLines: 3,
                        cursorColor: Color(0xffFFC529),
                        style:  GoogleFonts.poppins(fontSize: 17),
                        // textAlignVertical: TextAlignVertical.center,
                        textInputAction: TextInputAction.search,
                        onSubmitted: (value) => {},
                        decoration: InputDecoration(
                          filled: true,
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xffC7C7C7)),
                              borderRadius: BorderRadius.all(Radius.circular(10))),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xffC7C7C7)), borderRadius: BorderRadius.circular(10)),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xffC7C7C7)),
                              borderRadius: BorderRadius.all(Radius.circular(10))),
                          fillColor: Colors.white,
                          contentPadding: EdgeInsets.symmetric(horizontal: width * .03, vertical: height * .02),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: width * .05,
                  ),
                  Expanded(
                    child: SizedBox(
                      height: height * .08,
                      child: TextField(
                        cursorColor: Color(0xffFFC529),
                        maxLines: 3,

                        style: GoogleFonts.poppins(fontSize: 17),
                        // textAlignVertical: TextAlignVertical.center,
                        // textInputAction: TextInputAction.search,
                        keyboardType: TextInputType.number,
                        onSubmitted: (value) => {},
                        decoration: InputDecoration(
                          filled: true,
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xffC7C7C7)),
                              borderRadius: BorderRadius.all(Radius.circular(10))),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xffC7C7C7)), borderRadius: BorderRadius.circular(10)),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xffC7C7C7)),
                              borderRadius: BorderRadius.all(Radius.circular(10))),
                          fillColor: Colors.white,
                          contentPadding: EdgeInsets.symmetric(horizontal: width * .03, vertical: height * .02),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10,),
              Row(
                children: [
                  Transform.scale(
                    scale: 1,
                    child: Theme(
                      data: ThemeData(unselectedWidgetColor: showValidation == false ? AppTheme.primaryColor: Colors.red),
                      child: Checkbox(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          value: value,
                          activeColor:AppTheme.primaryColor,

                          visualDensity: const VisualDensity(vertical: 0, horizontal: 0),
                          onChanged: (newValue) {
                            setState(() {
                              value = newValue!;
                              setState(() {});
                            });
                          }),
                    ),
                  ),
                   Text('Securely save card and details',
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w400, fontSize: 14, color: Color(0xff878787))),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(10),
                backgroundColor: AppTheme.primaryColor,
                minimumSize: const Size(double.maxFinite, 50),
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
            child: Text(
              "Save",
              style: Theme.of(context)
                  .textTheme
                  .headline5!
                  .copyWith(color: AppTheme.backgroundcolor, fontWeight: FontWeight.w500, fontSize: AddSize.font16),
            )),
      ),
    );
  }
}
