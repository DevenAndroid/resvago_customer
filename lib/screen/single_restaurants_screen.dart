import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:resvago_customer/routers/routers.dart';
import 'package:resvago_customer/widget/appassets.dart';


class SingleRestaurantsScreen extends StatefulWidget {
  const  SingleRestaurantsScreen({super.key});

  @override
  State<SingleRestaurantsScreen> createState() =>
      _SingleRestaurantsScreenState();
}

class _SingleRestaurantsScreenState extends State<SingleRestaurantsScreen> {


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
          "Restaurants",
          style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: const Color(0xff1E2538)),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: GestureDetector(
              onTap: () {},
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  'assets/images/shoppinbag.png',
                  height: 30,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 400,
              child: Stack(children: [
                Image.asset(
                  AppAssets.burger,
                  width: size.width,
                  fit: BoxFit.fill,
                ),
                Positioned(
                  top: 110,
                  left: 12,
                  right: 12,
                  child: Column(
                    children: [
                      Stack(
                        children:[ Container(
                          height: 267,
                          width: size.width,
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF37C666).withOpacity(0.10),
                                  offset: const Offset(
                                    .1,
                                    .1,
                                  ),
                                  blurRadius: 20.0,
                                  spreadRadius: 1.0,
                                ),
                              ]),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.circle, size: 7, color: Color(0xff3B5998)),
                                  const SizedBox(
                                    width: 6,
                                  ),
                                  Text(
                                    "Open (8 AM to 9 PM )",
                                    style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                        color: const Color(0xff3B5998)),
                                  ),
                                  const Spacer(),
                                  Text(
                                    "1.8 Km",
                                    style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                        color: const Color(0xff606573)),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                "Layers of delicious restoring",
                                style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xff1E2538)),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  SvgPicture.asset(AppAssets.location),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Text(
                                    "145 Adarsh Nagar Raja Park",
                                    style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w300,
                                        color: const Color(0xff384953)),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Row(
                                children: [
                                  SvgPicture.asset(AppAssets.food),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Text(
                                    "Pizzeria",
                                    style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w300,
                                        color: const Color(0xff384953)),
                                  ),
                                ],
                              ),
                              // SizedBox(height: 5,),
                              Row(
                                // mainAxisAlignment: MainAxisAlignment.start,
                                // crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SvgPicture.asset(AppAssets.money),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Text(
                                    "Average price \$20",
                                    style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w300,
                                        color: const Color(0xff384953)),
                                  ),
                                  const Spacer(),
                                  Column(
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            "4.9",
                                            style: GoogleFonts.poppins(
                                                fontSize: 22,
                                                fontWeight: FontWeight.w300,
                                                color: const Color(0xff1E2538)),
                                          ),
                                          Text(
                                            "/5.9",
                                            style: GoogleFonts.poppins(
                                                fontSize: 11,
                                                fontWeight: FontWeight.w300,
                                                color: const Color(0xff979798)),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          SvgPicture.asset(AppAssets.chat),
                                          const SizedBox(
                                            width: 3,
                                          ),
                                          Text(
                                            "2584",
                                            style: GoogleFonts.poppins(
                                                fontSize: 11,
                                                fontWeight: FontWeight.w300,
                                                color: const Color(0xff1E2538)),
                                          ),
                                        ],
                                      ),
                                    ],
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 15,
                              ),

                              Center(
                                child: Container(
                                width: size.width,
                                height: 60,
                                decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.only(
                                        topRight: Radius.circular(30),
                                        topLeft: Radius.circular(30)),
                                    color: const Color(0xFFEBF0FB)),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [

                                    Text(
                                      "Up to \$10 Master card Cashback",
                                      style: GoogleFonts.poppins(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w400,
                                          color: const Color(0xff000000)),
                                    ),
                                    Text(
                                      "Use code Card Above \$120",
                                      style: GoogleFonts.poppins(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w300,
                                          color: const Color(0xff384953)),
                                    ),
                                  ],
                                ),
                                  ),
                              )
                            ],
                          ),
                        ),
                          Positioned(
                              top: 120,
                              bottom: 0,
                              left: 93,

                              child: Center(child: SvgPicture.asset(AppAssets.code))),
                      ]),

                    ],
                  ),
                ),
              ]),
            ),
             Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 12.0,right: 12),
                  child: Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          width: size.width,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {
                                Get.toNamed(MyRouters.restaurantsStepperScreen);
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    side: const BorderSide(
                                      width: 2.0,
                                      color: const Color(0xFF3B5998),
                                    )),
                                primary: const Color(0xFF3B5998),
                                textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                            child: Text(
                              "Select Date",
                              style: GoogleFonts.poppins(
                                  fontSize: 15, fontWeight: FontWeight.w600, color: const Color(0xFF3B5998)),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 20,),
             Expanded(
               child: SizedBox(
                   width: size.width,
                   height: 50,
                   child: ElevatedButton(
                   onPressed: () {
      },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF3B5998),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8), side: const BorderSide(
                    width: 2.0,
                    color:const Color(0xFF3B5998),
            )),

            primary: const Color(0xFF3B5998),
            textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
        child:  Text(
          "Menu List",
          style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,),
        ),),
               ),
             ),
                    ],
                  ),
                )

              ],
            )
          ],
        ),
      ),
    );
  }
}
