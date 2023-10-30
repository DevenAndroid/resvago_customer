import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widget/appassets.dart';
import '../widget/apptheme.dart';

class RestaurantCategoryScreen extends StatefulWidget {
  const RestaurantCategoryScreen({super.key});

  @override
  State<RestaurantCategoryScreen> createState() => _RestaurantCategoryScreenState();
}

class _RestaurantCategoryScreenState extends State<RestaurantCategoryScreen> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return  Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            Get.back();
          },
          child: Padding(
            padding: const EdgeInsets.all(13.0),
            child: SvgPicture.asset("assets/images/back.svg"),
          ),
        ),
        elevation: 1,
        title: Text(
          "Category",
          style: GoogleFonts.poppins(
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column
          (children: [
          SizedBox(
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: 4,
                physics: BouncingScrollPhysics(),
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      // Get.toNamed(MyRouters.searchDiningListScreen);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Container(
                        margin: EdgeInsets.only(right: 12, top: 8, left: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xffFFFFFF),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Stack(
                              children: [
                                ClipRRect(
                                    borderRadius: const BorderRadius.only(
                                      topRight: Radius.circular(10),
                                      topLeft: Radius.circular(10),
                                    ),
                                    child: Image.asset(
                                      AppAssets.restaurant,
                                      height: 150,
                                      width: size.width,
                                      fit: BoxFit.cover,
                                    )),
                                Positioned(
                                    top: 11,
                                    right: 10,
                                    child: InkWell(
                                      onTap: () {},
                                      child: Container(
                                        height: 25,
                                        width: 25,
                                        decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
                                        child: const Icon(
                                          Icons.favorite_border,
                                          color: AppTheme.primaryColor,
                                          size: 18,
                                        ),
                                      ),
                                    )),
                              ],
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    // margin: EdgeInsets.all(13),
                                    height: 30,
                                    width: 130,
                                    decoration: BoxDecoration(
                                        color: Color(0xff3B5998).withOpacity(.5),
                                        // border: Border.all(color: ),
                                        borderRadius: BorderRadius.all(Radius.circular(5))),
                                    child: Center(
                                      child: Text(
                                        'Chinese  Food',
                                        style: GoogleFonts.poppins(
                                            fontSize: 12, fontWeight: FontWeight.w500, color: AppTheme.primaryColor),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 13,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "McDonald’s New Restaurant",
                                        style: GoogleFonts.poppins(
                                            fontSize: 15, fontWeight: FontWeight.w400, color: const Color(0xff08141B)),
                                      ),
                                      Spacer(),
                                      const Icon(
                                        Icons.star,
                                        color: Color(0xffFFC529),
                                        size: 17,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        "4.5",
                                        style: GoogleFonts.poppins(
                                            fontSize: 14, fontWeight: FontWeight.w300, color: const Color(0xff08141B)),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        "25 Mins ",
                                        style: GoogleFonts.poppins(
                                            fontSize: 12, fontWeight: FontWeight.w300, color: const Color(0xff384953)),
                                      ),
                                      const SizedBox(
                                        width: 3,
                                      ),
                                      const Icon(Icons.circle, size: 5, color: Color(0xff384953)),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        "1.8 Km",
                                        style: GoogleFonts.poppins(
                                            fontSize: 12, fontWeight: FontWeight.w300, color: const Color(0xff384953)),
                                      ),
                                      const SizedBox(
                                        width: 3,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  DottedLine(
                                    dashColor: Color(0xffBCBCBC),
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  Row(
                                    children: [
                                      SvgPicture.asset(
                                        AppAssets.vector,
                                        height: 16,
                                      ),
                                      Text(
                                        "  40% off up to \$100",
                                        style: GoogleFonts.poppins(
                                            fontSize: 12, fontWeight: FontWeight.w400, color: const Color(0xff3B5998)),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
          ),
        ],),
      ),
    );
  }
}
