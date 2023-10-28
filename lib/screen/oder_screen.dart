import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:resvago_customer/widget/apptheme.dart';

import '../widget/appassets.dart';

class OderScreen extends StatefulWidget {
  const OderScreen({super.key});

  @override
  State<OderScreen> createState() => _OderScreenState();
}

class _OderScreenState extends State<OderScreen> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
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
            "Checkout",
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        body: SingleChildScrollView(
            child: Column(children: [
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: size.width,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF37C666).withOpacity(0.10),
                    offset: const Offset(
                      1,
                      1,
                    ),
                    blurRadius: 20.0,
                    spreadRadius: 1.0,
                  ),
                ]),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Restaurant",
                      style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500, color: const Color(0xFF1E2538)),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      // mainAxisAlignment: MainAxisAlignment.start,
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset(
                          AppAssets.roll,
                          height: 60,
                          width: 80,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "McDonald’s",
                                style: GoogleFonts.poppins(
                                    fontSize: 16, fontWeight: FontWeight.w500, color: const Color(0xFF1E2538)),
                              ),
                              SizedBox(
                                height: 3,
                              ),
                              Text(
                                "145 Adarsh Nagar Raja Park",
                                style: GoogleFonts.poppins(
                                    fontSize: 10, fontWeight: FontWeight.w300, color: const Color(0xFF384953)),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        ),
                        Spacer(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              "assets/icons/edit.png",
                              height: 23,
                            ),
                          ],
                        )
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Divider(
                      color: Color(0xFF698EDE).withOpacity(.1),
                      thickness: 2,
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Reservation",
                          style:
                              GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500, color: const Color(0xFF1E2538)),
                        ),
                        Image.asset(
                          "assets/icons/edit.png",
                          height: 23,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Date:",
                          style:
                              GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500, color: const Color(0xFF1E2538)),
                        ),
                        Text(
                          "04 Oct 2023",
                          style: GoogleFonts.poppins(fontSize: 13, color: const Color(0xFF1E2538)),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    DottedLine(
                      dashColor: Color(0xffBCBCBC),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Dinner:",
                          style:
                              GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500, color: const Color(0xFF1E2538)),
                        ),
                        Text(
                          "02:00",
                          style: GoogleFonts.poppins(fontSize: 13, color: const Color(0xFF1E2538)),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    DottedLine(
                      dashColor: Color(0xffBCBCBC),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Guest:",
                          style:
                              GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500, color: const Color(0xFF1E2538)),
                        ),
                        Text(
                          "6",
                          style: GoogleFonts.poppins(fontSize: 13, color: const Color(0xFF1E2538)),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              )),
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                  width: size.width,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF37C666).withOpacity(0.10),
                      offset: const Offset(
                        1,
                        1,
                      ),
                      blurRadius: 20.0,
                      spreadRadius: 1.0,
                    ),
                  ]),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Selected Items",
                          style:
                              GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500, color: const Color(0xFF1E2538)),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: 4,
                            itemBuilder: (context, index) {
                              return Column(children: [
                                Row(children: [
                                  Image.asset(
                                    AppAssets.roll,
                                    height: 60,
                                    width: 80,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 15),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Salad veggie",
                                          style: GoogleFonts.poppins(
                                              fontSize: 14, fontWeight: FontWeight.w400, color: const Color(0xFF1E2538)),
                                        ),
                                        SizedBox(
                                          height: 3,
                                        ),
                                        Text(
                                          "\$10.00",
                                          style: GoogleFonts.poppins(fontSize: 14, color: const Color(0xFF74848C)),
                                        ),

                                        // DottedLine(
                                        //   dashColor: Colors.black,
                                        // )
                                      ],
                                    ),
                                  ),
                                  Spacer(),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        height: 28,
                                        width: 28,
                                        decoration: BoxDecoration(
                                            border: Border.all(color: Colors.black),
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(20),
                                            )),
                                        child: Icon(Icons.remove),
                                      ),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      Text(
                                        "2",
                                        style: GoogleFonts.alegreyaSans(
                                          fontSize: 16,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      Row(
                                        children: [
                                          Container(
                                            height: 28,
                                            width: 28,
                                            decoration: BoxDecoration(
                                                color: AppTheme.primaryColor,
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(20),
                                                )),
                                            child: Icon(
                                              Icons.add,
                                              color: Colors.white,
                                              size: 18,
                                            ),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ])
                              ]);
                            }),
                      ]))),
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: size.width,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(10), boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF37C666).withOpacity(0.10),
                    offset: const Offset(




                      1,
                      1,
                    ),
                    blurRadius: 20.0,
                    spreadRadius: 1.0,
                  ),
                ]),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Selec",
                        style:
                            GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500, color: const Color(0xFF1E2538)),
                      ),
                      Text(
                        "Selec",
                        style:
                            GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500, color: const Color(0xFF1E2538)),
                      ),
                      Text(
                        "Selec",
                        style:
                            GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500, color: const Color(0xFF1E2538)),
                      ),
                      Text(
                        "Selec",
                        style:
                            GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500, color: const Color(0xFF1E2538)),
                      ),
                      Text(
                        "Selec",
                        style:
                            GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500, color: const Color(0xFF1E2538)),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                    ]),
              )),
              SizedBox(height: 20,)
        ])));
  }
}
