import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:resvago_customer/widget/appassets.dart';
import 'package:table_calendar/table_calendar.dart';

import '../widget/addsize.dart';
import '../widget/apptheme.dart';

class SingleRestaurantsScreen extends StatefulWidget {
  const SingleRestaurantsScreen({super.key});

  @override
  State<SingleRestaurantsScreen> createState() => _SingleRestaurantsScreenState();
}

class _SingleRestaurantsScreenState extends State<SingleRestaurantsScreen> {
  double fullRating = 0;
  int currentDrawer = 0;
  int currentStep = 0;
  DateTime today = DateTime.now();
  void _onDaySelected(DateTime day, DateTime focusedDay){
    setState(() {
      today = day;
    });
  }
  bool value = false;
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
            style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500,),
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
            child: Column(children: [
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
                    Stack(children: [
                      Container(
                        // height: 267,
                        width: size.width,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), boxShadow: [
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
                                      fontSize: 12, fontWeight: FontWeight.w400, color: const Color(0xff3B5998)),
                                ),
                                const Spacer(),
                                Text(
                                  "1.8 Km",
                                  style: GoogleFonts.poppins(
                                      fontSize: 12, fontWeight: FontWeight.w400, color: const Color(0xff606573)),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Layers of delicious restoring",
                              style: GoogleFonts.poppins(
                                  fontSize: 16, fontWeight: FontWeight.w500, color: const Color(0xff1E2538)),
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
                                      fontSize: 12, fontWeight: FontWeight.w300, color: const Color(0xff384953)),
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
                                      fontSize: 12, fontWeight: FontWeight.w300, color: const Color(0xff384953)),
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
                                      fontSize: 12, fontWeight: FontWeight.w300, color: const Color(0xff384953)),
                                ),
                                const Spacer(),
                                Column(
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          "4.9",
                                          style: GoogleFonts.poppins(
                                              fontSize: 22, fontWeight: FontWeight.w300, color: const Color(0xff1E2538)),
                                        ),
                                        Text(
                                          "/5.9",
                                          style: GoogleFonts.poppins(
                                              fontSize: 11, fontWeight: FontWeight.w300, color: const Color(0xff979798)),
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
                                              fontSize: 11, fontWeight: FontWeight.w300, color: const Color(0xff1E2538)),
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
                                decoration: const BoxDecoration(
                                    borderRadius:
                                        BorderRadius.only(topRight: Radius.circular(30), topLeft: Radius.circular(30)),
                                    color: Color(0xFFEBF0FB)),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Up to \$10 Master card Cashback",
                                      style: GoogleFonts.poppins(
                                          fontSize: 15, fontWeight: FontWeight.w400, color: const Color(0xff000000)),
                                    ),
                                    Text(
                                      "Use code Card Above \$120",
                                      style: GoogleFonts.poppins(
                                          fontSize: 10, fontWeight: FontWeight.w300, color: const Color(0xff384953)),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Positioned(top: 120, bottom: 0, left: 93, child: Center(child: SvgPicture.asset(AppAssets.code))),
                    ]),
                  ],
                ),
              ),
            ]),
          ),
          Column(children: [
            Padding(
              padding: const EdgeInsets.only(left: 12.0, right: 12),
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      width: size.width,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          currentDrawer = 0;
                          setState(() {

                        });},
                        style:  currentDrawer == 0?
                        ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF3B5998),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                                side: const BorderSide(
                                  width: 2.0,
                                  color: const Color(0xFF3B5998),
                                )),
                            primary: const Color(0xFF3B5998),
                            textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500)):
                        ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                                side: const BorderSide(
                                  width: 2.0,
                                  color: Color(0xFF3B5998),
                                )),
                            primary: const Color(0xFF3B5998),
                            textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                        child: Text(
                          "Select Date",
                          style: currentDrawer == 0?

                          GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w600, color:

                          Colors.white) :GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w600, color:

                          const Color(0xFF3B5998)),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: SizedBox(
                      width: size.width,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          currentDrawer = 1;
                          setState(() {

                          });
                        },
                        style: currentDrawer == 1?

                        ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF3B5998),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                                side: const BorderSide(
                                  width: 2.0,
                                  color: const Color(0xFF3B5998),
                                )),
                            primary: const Color(0xFF3B5998),
                            textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500)):
                        ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                                side: const BorderSide(
                                  width: 2.0,
                                  color: Color(0xFF3B5998),
                                )),
                            primary: const Color(0xFF3B5998),
                            textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                        child: Text(
                          "Menu List",
                          style:  currentDrawer == 1?
                          GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ): GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color:  const Color(0xFF3B5998),
                          )
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if(currentDrawer ==1 )
         Column(
           children: [
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
                       const SizedBox(
                         height: 10,
                       ),
                       Row(
                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                         children: [
                           Text(
                             "About",
                             style: GoogleFonts.poppins(
                                 fontSize: 16, fontWeight: FontWeight.w500, color: const Color(0xFF3B5998)),
                           ),
                           Text(
                             "Menu",
                             style: GoogleFonts.poppins(
                                 fontSize: 16, fontWeight: FontWeight.w300, color: const Color(0xFF1E2538)),
                           ),
                           Text(
                             "Reviews",
                             style: GoogleFonts.poppins(
                                 fontSize: 16, fontWeight: FontWeight.w300, color: const Color(0xFF1E2538)),
                           ),
                         ],
                       ),
                       Divider(
                         thickness: 1,
                         color: Colors.grey.withOpacity(0.3),
                       ),
                       const SizedBox(
                         height: 8,
                       ),
                       Text(
                         "About Us",
                         style:
                         GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500, color: const Color(0xFF1E2538)),
                       ),
                       const SizedBox(
                         height: 8,
                       ),
                       Text(
                         "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text",
                         style:
                         GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w300, color: const Color(0xFF1E2538)),
                       ),
                       const SizedBox(
                         height: 18,
                       ),
                       Row(
                         children: [
                           Image.asset(AppAssets.about),
                           const SizedBox(
                             width: 10,
                           ),
                           Image.asset(AppAssets.about),
                           const SizedBox(
                             width: 10,
                           ),
                           Image.asset(AppAssets.about),
                         ],
                       )
                     ],
                   )),
             ),
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
                         "Restaurant Menu",
                         style:
                         GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500, color: const Color(0xFF1E2538)),
                       ),
                       const SizedBox(
                         height: 15,
                       ),
                       Image.network(
                           "https://marketplace.canva.com/EAFKfB87pN0/1/0/1131w/canva-brown-and-black-illustration-fast-food-menu-y8NpubROdFc.jpg"),
                       const SizedBox(
                         height: 15,
                       ),
                       SizedBox(
                         // height: 200,
                         child: ListView.builder(
                             shrinkWrap: true,
                             physics: const NeverScrollableScrollPhysics(),
                             itemCount: 5,
                             itemBuilder: (context, index) {
                               return Column(children: [
                                 Row(
                                   mainAxisAlignment: MainAxisAlignment.start,
                                   crossAxisAlignment: CrossAxisAlignment.start,
                                   children: [
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
                                           const SizedBox(
                                             height: 3,
                                           ),
                                           Text(
                                             "Lorem ipsum Dollar",
                                             style: GoogleFonts.poppins(
                                                 fontSize: 10, fontWeight: FontWeight.w300, color: const Color(0xFF74848C)),
                                           ),
                                           const SizedBox(
                                             height: 10,
                                           ),
                                           SizedBox(
                                             // width: size.width,
                                             height: 23,

                                             child: ElevatedButton(
                                               onPressed: () {},
                                               style: ElevatedButton.styleFrom(
                                                   backgroundColor: const Color(0xFF3B5998),
                                                   shape: RoundedRectangleBorder(
                                                       borderRadius: BorderRadius.circular(3),
                                                       side: const BorderSide(
                                                         width: 2.0,
                                                         color: const Color(0xFF3B5998),
                                                       )),
                                                   primary: const Color(0xFF3B5998),
                                                   textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                                               child: Text(
                                                 "ADD TO CART",
                                                 style: GoogleFonts.poppins(
                                                   fontSize: 10,
                                                   fontWeight: FontWeight.w500,
                                                   color: Colors.white,
                                                 ),
                                               ),
                                             ),
                                           ),
                                           const SizedBox(
                                             height: 15,
                                           ),
                                           // DottedLine(
                                           //   dashColor: Colors.black,
                                           // )
                                         ],
                                       ),
                                     ),
                                     const Spacer(),
                                     Column(
                                       crossAxisAlignment: CrossAxisAlignment.end,
                                       children: [
                                         Text(
                                           "\$10.00",
                                           style: GoogleFonts.poppins(
                                               fontSize: 14,
                                               // fontWeight: FontWeight.w400,
                                               color: const Color(0xFF1E2538)),
                                         ),
                                         const SizedBox(
                                           height: 5,
                                         ),
                                         Text(
                                           "10% Discount",
                                           style: GoogleFonts.poppins(
                                               fontSize: 14,
                                               // fontWeight: FontWeight.w400,
                                               color: const Color(0xFF74848C)),
                                         ),
                                       ],
                                     )
                                   ],
                                 ),
                                 index != 4 ?   const DottedLine(
                                   dashColor: Color(0xffBCBCBC),
                                 ):const SizedBox(),
                                 const SizedBox(
                                   height: 15,
                                 ),
                               ]);
                             }),
                       ),
                     ],
                   )),
             ),
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
                             "Buy As a Bundle and save",
                             style: GoogleFonts.poppins(
                                 fontSize: 16, fontWeight: FontWeight.w500, color: const Color(0xFF1E2538)),
                           ),
                           const SizedBox(
                             height: 5,
                           ),
                           Text(
                             "20% Discount ",
                             style: GoogleFonts.poppins(
                                 fontStyle: FontStyle.italic,
                                 fontSize: 16,
                                 fontWeight: FontWeight.w500,
                                 color: const Color(0xFF3B5998)),
                           ),
                           const SizedBox(
                             height: 10,
                           ),
                           const DottedLine(
                             dashColor: Color(0xffBCBCBC),
                           ),
                           const SizedBox(
                             height: 10,
                           ),
                           Row(
                               mainAxisAlignment: MainAxisAlignment.start,
                               crossAxisAlignment: CrossAxisAlignment.start,
                               children: [
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
                                       const SizedBox(
                                         height: 3,
                                       ),
                                       Text(
                                         "Lorem ipsum Dollar",
                                         style: GoogleFonts.poppins(
                                             fontSize: 10, fontWeight: FontWeight.w300, color: const Color(0xFF74848C)),
                                       ),
                                       const SizedBox(
                                         height: 10,
                                       ),
                                       SizedBox(
                                         // width: size.width,
                                         height: 23,

                                         child: ElevatedButton(
                                           onPressed: () {},
                                           style: ElevatedButton.styleFrom(
                                               backgroundColor: const Color(0xFF3B5998),
                                               shape: RoundedRectangleBorder(
                                                   borderRadius: BorderRadius.circular(3),
                                                   side: const BorderSide(
                                                     width: 2.0,
                                                     color: const Color(0xFF3B5998),
                                                   )),
                                               primary: const Color(0xFF3B5998),
                                               textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                                           child: Text(
                                             "ADD TO CART",
                                             style: GoogleFonts.poppins(
                                               fontSize: 10,
                                               fontWeight: FontWeight.w500,
                                               color: Colors.white,
                                             ),
                                           ),
                                         ),
                                       ),
                                     ],
                                   ),
                                 ),
                                 const Spacer(),
                                 Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                                   Text(
                                     "\$10.00",
                                     style: GoogleFonts.poppins(
                                         fontSize: 14,
                                         // fontWeight: FontWeight.w400,
                                         color: const Color(0xFF1E2538)),
                                   ),
                                 ])
                               ])
                         ]))),
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
                             "Review(5)",
                             style: GoogleFonts.poppins(
                                 fontSize: 16, fontWeight: FontWeight.w500, color: const Color(0xFF1E2538)),
                           ),
                           const SizedBox(
                             height: 10,
                           ),
                           Text(
                             "Overall Rating",
                             style: GoogleFonts.poppins(
                                 fontSize: 16, fontWeight: FontWeight.w500, color: const Color(0xFF969AA3)),
                           ),
                           Padding(
                               padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10),
                               child: Column(children: [
                                 Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                                   const Text(
                                     '4.8',
                                     style: TextStyle(
                                       color: Color(0xFF1B233A),
                                       fontSize: 48,
                                       fontWeight: FontWeight.w600,
                                     ),
                                   ),
                                   const SizedBox(
                                     width: 20,
                                   ),
                                   Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                     RatingBar.builder(
                                       initialRating: 4,
                                       minRating: 1,
                                       unratedColor: const Color(0xFF698EDE).withOpacity(.2),
                                       itemCount: 5,
                                       itemSize: 16.0,
                                       itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                                       updateOnDrag: true,
                                       itemBuilder: (context, index) => Image.asset(
                                         'assets/icons/star.png',
                                         color: const Color(0xff3B5998),
                                       ),
                                       onRatingUpdate: (ratingvalue) {
                                         setState(() {
                                           fullRating = ratingvalue;
                                         });
                                       },
                                     ),
                                     const SizedBox(
                                       height: 8,
                                     ),
                                     const Padding(
                                       padding: EdgeInsets.symmetric(horizontal: 4.0),
                                       child: Text(
                                         'basad on 23 reviews',
                                         style: TextStyle(
                                           color: Color(0xFF969AA3),
                                           fontSize: 13,
                                           fontWeight: FontWeight.w400,
                                         ),
                                       ),
                                     ),
                                   ]),
                                 ]),
                               ])),
                           Column(children: [
                             Row(
                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                               children: [
                                 const Expanded(
                                   child: Text(
                                     'Excellent',
                                     style: TextStyle(
                                       color: Color(0xFF969AA3),
                                       fontSize: 12,
                                       fontWeight: FontWeight.w400,
                                     ),
                                   ),
                                 ),
                                 Expanded(
                                   flex: 3,
                                   child: LinearPercentIndicator(
                                     lineHeight: 6.0,
                                     barRadius: const Radius.circular(16),
                                     backgroundColor: const Color(0xFFE6F9ED),
                                     animation: true,
                                     progressColor: const Color(0xFF5DAF5E),
                                     percent: 0.9,
                                     animationDuration: 1200,
                                   ),
                                 ),
                               ],
                             ),
                             const SizedBox(
                               height: 5,
                             ),
                             Row(
                               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                               children: [
                                 const Expanded(
                                   child: Text(
                                     'Good',
                                     style: TextStyle(
                                       color: Color(0xFF969AA3),
                                       fontSize: 12,
                                       fontWeight: FontWeight.w400,
                                     ),
                                   ),
                                 ),
                                 Expanded(
                                   flex: 3,
                                   child: LinearPercentIndicator(
                                     lineHeight: 6.0,
                                     barRadius: const Radius.circular(16),
                                     backgroundColor: const Color(0xFFF2FFCF),
                                     animation: true,
                                     progressColor: const Color(0xFFA4D131),
                                     percent: 0.7,
                                     animationDuration: 1200,
                                   ),
                                 ),
                               ],
                             ),
                             const SizedBox(
                               height: 5,
                             ),
                             Row(
                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                               children: [
                                 const Expanded(
                                   child: Text(
                                     'Average',
                                     style: TextStyle(
                                       color: Color(0xFF969AA3),
                                       fontSize: 12,
                                       fontWeight: FontWeight.w400,
                                     ),
                                   ),
                                 ),
                                 Expanded(
                                   flex: 3,
                                   child: LinearPercentIndicator(
                                     lineHeight: 6.0,
                                     barRadius: const Radius.circular(16),
                                     backgroundColor: const Color(0xFFF5FFDB),
                                     animation: true,
                                     progressColor: const Color(0xFFF7E742),
                                     percent: 0.6,
                                     animationDuration: 1200,
                                   ),
                                 ),
                               ],
                             ),
                             const SizedBox(
                               height: 5,
                             ),
                             Row(
                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                               children: [
                                 const Expanded(
                                   child: Text(
                                     'Below Average',
                                     style: TextStyle(
                                       color: Color(0xFF969AA3),
                                       fontSize: 12,
                                       fontWeight: FontWeight.w400,
                                     ),
                                   ),
                                 ),
                                 Expanded(
                                   flex: 3,
                                   child: LinearPercentIndicator(
                                     lineHeight: 6.0,
                                     barRadius: const Radius.circular(16),
                                     backgroundColor: const Color(0xFFFFF5E5),
                                     animation: true,
                                     progressColor: const Color(0xFFF8B859),
                                     percent: 0.5,
                                     animationDuration: 1200,
                                   ),
                                 ),
                               ],
                             ),
                             const SizedBox(
                               height: 5,
                             ),
                             Row(
                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                               children: [
                                 const Expanded(
                                   child: Text(
                                     'Poor',
                                     style: TextStyle(
                                       color: Color(0xFF969AA3),
                                       fontSize: 12,
                                       fontWeight: FontWeight.w400,
                                     ),
                                   ),
                                 ),
                                 Expanded(
                                   flex: 3,
                                   child: LinearPercentIndicator(
                                     lineHeight: 6.0,
                                     barRadius: const Radius.circular(16),
                                     backgroundColor: const Color(0xFFFFE9E4),
                                     animation: true,
                                     progressColor: const Color(0xFFEE3D1C),
                                     percent: 0.3,
                                     animationDuration: 1200,
                                   ),
                                 ),
                                 const SizedBox(
                                   height: 5,
                                 ),
                               ],
                             ),
                           ]),
                           const SizedBox(
                             height: 5,
                           ),
                           Divider(
                             color: const Color(0xFF698EDE).withOpacity(.1),
                             thickness: 2,
                           ),
                           const SizedBox(
                             height: 8,
                           ),
                           ListView.builder(
                               shrinkWrap: true,
                               itemCount: 3,
                               physics: const NeverScrollableScrollPhysics(),
                               itemBuilder: (context, index) {
                                 return Column(
                                   children: [
                                     Row(
                                       crossAxisAlignment: CrossAxisAlignment.start,
                                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                       children: [
                                         Image.asset(
                                           'assets/images/Ellipse 1563.png',
                                           height: 50,
                                         ),
                                         const SizedBox(
                                           width: 20,
                                         ),
                                         Expanded(
                                           child: Column(
                                             crossAxisAlignment: CrossAxisAlignment.start,
                                             children: [
                                               Padding(
                                                 padding: const EdgeInsets.symmetric(horizontal: 5.0),
                                                 child: Text(
                                                   'Abhishek Jangid',
                                                   style: GoogleFonts.poppins(
                                                     color: const Color(0xFF1B233A),
                                                     fontSize: 16,
                                                     fontWeight: FontWeight.w600,
                                                   ),
                                                 ),
                                               ),
                                               const SizedBox(
                                                 height: 6,
                                               ),
                                               RatingBar.builder(
                                                 initialRating: 4,
                                                 minRating: 1,
                                                 unratedColor: const Color(0xff3B5998).withOpacity(.2),
                                                 itemCount: 5,
                                                 itemSize: 16.0,
                                                 itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                                                 updateOnDrag: true,
                                                 itemBuilder: (context, index) => Image.asset(
                                                   'assets/icons/star.png',
                                                   color: const Color(0xff3B5998),
                                                 ),
                                                 onRatingUpdate: (ratingvalue) {
                                                   setState(() {
                                                     fullRating = ratingvalue;
                                                   });
                                                 },
                                               ),
                                               const SizedBox(
                                                 height: 8,
                                               ),
                                               Padding(
                                                 padding: const EdgeInsets.symmetric(horizontal: 5.0),
                                                 child: RichText(
                                                   text:  TextSpan(children: [
                                                     TextSpan(
                                                         text:
                                                         'It is a long established fact that a reader will be distracted by the readable content of a page when looking...',
                                                         style: GoogleFonts.poppins(
                                                           color: const Color(0xFF969AA3),
                                                           fontSize: 14,
                                                           fontWeight: FontWeight.w300,
                                                         )),
                                                     TextSpan(
                                                         text: 'read more',
                                                         style: GoogleFonts.poppins(
                                                             fontSize: 14,
                                                             fontWeight: FontWeight.w400,
                                                             color: const Color(0xFF567DF4)))
                                                   ]),
                                                 ),
                                               ),
                                             ],
                                           ),
                                         ),
                                         // const Spacer(),
                                         const Padding(
                                           padding: EdgeInsets.symmetric(vertical: 3.0),
                                           child: Text(
                                             'Oct 23, 2022',
                                             style: TextStyle(
                                               color: Color(0xFF969AA3),
                                               fontSize: 12,
                                               fontWeight: FontWeight.w400,
                                             ),
                                           ),
                                         ),
                                       ],
                                     ),
                                     const SizedBox(
                                       height: 10,
                                     ),
                                     index != 2 ?   Divider(
                                       color: const Color(0xFF698EDE).withOpacity(.1),
                                       thickness: 2,
                                     ) : const SizedBox(),
                                     const SizedBox(
                                       height: 12,
                                     ),
                                   ],
                                 );
                               })
                         ])))
           ],
         ),
            if(currentDrawer ==0 )
              SizedBox(
                height: size.height,
                child: Theme(
                  data: Theme.of(context).copyWith(
                      colorScheme: const ColorScheme.light(primary: Color(0xFF3B5998))
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14,vertical: 15),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF5F5F5F).withOpacity(0.4),
                              offset: const Offset(0.0, 0.5),
                              blurRadius: 5,),
                          ]
                      ),
                      child: Stepper(
                        type: StepperType.horizontal,
                        physics: const NeverScrollableScrollPhysics(),
                        steps: getSteps(),
                        currentStep: currentStep,
                        onStepContinue: () {
                          final isLastStep = currentStep == getSteps().length - 1;

                          if (isLastStep) {
                            print('Complete');
                          } else {
                            setState(() {
                              currentStep += 1;
                            });
                          }
                        },
                        onStepCancel: () {
                          currentStep == 0 ? null : setState(() => currentStep -= 1);
                        },
                        elevation: 0,
                        onStepTapped: (step) => setState(() => currentStep = step),
                        controlsBuilder: (context, details) {
                          return Container(
                              margin: const EdgeInsets.only(top: 50),
                              child:
                              (currentStep != 3 && currentStep != 0) ? SizedBox(
                                width: size.width,
                                height: 50,
                                child: ElevatedButton(
                                  onPressed: details.onStepContinue,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppTheme.primaryColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      side: const BorderSide(
                                        width: 2.0,
                                        color: Color(0xFF3B5998),
                                      ),
                                    ),
                                    primary: const Color(0xFF3B5998),
                                    textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                                  ),
                                  child: Text(
                                    "NEXT",
                                    style: GoogleFonts.poppins(
                                        fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white),
                                  ),
                                ),
                              ) : (currentStep == 3) ? SizedBox(
                                width: size.width,
                                height: 50,
                                child: ElevatedButton(
                                  onPressed: () {
                                    // Handle confirm button click logic here
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppTheme.primaryColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      side: const BorderSide(
                                        width: 2.0,
                                        color: Color(0xFF3B5998),
                                      ),
                                    ),
                                    primary: const Color(0xFF3B5998),
                                    textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                                  ),
                                  child: Text(
                                    "Checkout".toUpperCase(),
                                    style: GoogleFonts.poppins(
                                        fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white),
                                  ),
                                ),
                              ) : const SizedBox()

                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
          ])
        ])));
  }
  List<Step> getSteps() => [
    Step(

        title: const Text(''),
        state: currentStep > 0 ? StepState.complete : StepState.indexed,
        isActive: currentStep >= 0,
        label: currentStep > 0 ? const Text('Date',
          style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w300,
              fontSize: 12
          ),): const Text('Date',
          style: TextStyle(
              color: AppTheme.primaryColor,
              fontWeight: FontWeight.w500,
              fontSize: 12
          ),),
        content:  Column(
          children: [
              Container(
                child: TableCalendar(
                  rowHeight: 43,
                    headerStyle: const HeaderStyle(formatButtonVisible: false,titleCentered: true),
                    locale: "en_US",
                    availableGestures: AvailableGestures.all,
                    focusedDay: today,
                    firstDay: DateTime.utc(2010,10,16),
                    lastDay: DateTime.utc(2030,3,14),
                  onDaySelected: _onDaySelected,
                  selectedDayPredicate: (day) => isSameDay(day,today),
                ),
              )
          ],
        )),
    Step(
        isActive: currentStep >= 1,
        state: currentStep > 1 ? StepState.complete : StepState.indexed,
        label:  const Text('Time',style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w300,
            fontSize: 12
        ),),
        title: const Text(''),
        content:  Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Divider(
              color: Colors.grey,
              thickness: 0.5,
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text('Lunch',
                style: GoogleFonts.poppins(
                    color: const Color(0xFF545B61),
                    fontWeight: FontWeight.w500,
                    fontSize: 16
                ),),
            ),
            const SizedBox(
              height: 10,
            ),
            GridView.builder(
              itemCount: 6,
              shrinkWrap: true,
              gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 0,
                  mainAxisExtent: AddSize.screenHeight*.080
              ),
              itemBuilder: (BuildContext context, int index) {
                return Column(
                  children: [
                    Container(
                      height: 48,
                      width: 66,
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey,
                          ),
                          borderRadius: BorderRadius.circular(4)
                      ),
                      child: Center(
                        child: Text(
                          '11:33',
                          style: GoogleFonts.poppins(
                              color: AppTheme.primaryColor
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text('Dinner',
                style: GoogleFonts.poppins(
                    color: const Color(0xFF545B61),
                    fontWeight: FontWeight.w500,
                    fontSize: 16
                ),),
            ),
            const SizedBox(
              height: 10,
            ),
            GridView.builder(
              itemCount: 7,
              shrinkWrap: true,
              gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 0,
                  mainAxisExtent: AddSize.screenHeight*.080
              ),
              itemBuilder: (BuildContext context, int index) {
                return Column(
                  children: [
                    Container(
                      height: 48,
                      width: 66,
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey,
                          ),
                          borderRadius: BorderRadius.circular(4)
                      ),
                      child: Center(
                        child: Text(
                          '19:30',
                          style: GoogleFonts.poppins(
                              color: AppTheme.primaryColor
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        )

    ),
    Step(
        state: currentStep > 2 ? StepState.complete : StepState.indexed,
        isActive: currentStep >= 2,
        label:  const Text('Guest',style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w300,
            fontSize: 12
        ),),
        title: const Text(''),
        content:  Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Divider(
              color: Colors.grey,
              thickness: 0.5,
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text('Number Of Guests',
                style: GoogleFonts.poppins(
                    color: const Color(0xFF545B61),
                    fontWeight: FontWeight.w500,
                    fontSize: 16
                ),),
            ),
            const SizedBox(
              height: 10,
            ),
            GridView.builder(
              itemCount: 15,
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 10,
                mainAxisSpacing: 0,
                mainAxisExtent: AddSize.screenHeight * 0.080,
              ),
              itemBuilder: (BuildContext context, int index) {
                int number = index + 1;
                return Column(
                  children: [
                    Container(
                      height: 48,
                      width: 66,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey,
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Center(
                        child: Text(
                          '$number', // Display the number
                          style: GoogleFonts.poppins(
                            color: AppTheme.primaryColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(
              height: 10,
            ),
            Center(
              child: Text('We have max 100 sitting capacity'.toUpperCase(),
                style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFFFF2D2D)
                ),
              ),
            )
          ],
        )
        ),
    Step(
        state: currentStep > 3 ? StepState.complete : StepState.indexed,
        isActive: currentStep >=3,
        label:  const Text('Offer',style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w300,
            fontSize: 12
        ),),
        title: const Text(''),
        content:  Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                        color: const Color(0xFFC7C7C7),
                        width: 1.0
                    )
                ),
                width: AddSize.screenWidth,
                height: 50,
                child: GestureDetector(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(AppAssets.vector,height: 20),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        "Select Your Offer",
                        style: GoogleFonts.poppins(
                            fontSize: 15, fontWeight: FontWeight.w600, color: const Color(0xFF3B5998)),
                      ),
                    ],
                  ),
                )

            ),
            const SizedBox(
              height: 13,
            ),
            Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                        color: const Color(0xFFC7C7C7),
                        width: 1.0
                    )
                ),
                padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 15),
                width: AddSize.screenWidth,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('20% Off On “A La Carte” Menu',style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 16
                          ),),
                          const SizedBox(
                            height: 5,
                          ),
                          Text('Discount available for the booked timeslot preset menus and drinks not inclused',style: GoogleFonts.poppins(
                              color: const Color(0xFF384953),
                              fontWeight: FontWeight.w300,
                              fontSize: 13
                          ),
                            maxLines: 5,
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Container(
                            width: 90,
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            decoration: BoxDecoration(
                                color: AppTheme.primaryColor,
                                borderRadius: BorderRadius.circular(5)
                            ),
                            child: Center(
                              child: Text('20% off',style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14
                              ),),
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppTheme.primaryColor,
                      ),
                      child: const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 20,
                      ),
                    )
                  ],
                )

            ),
            const SizedBox(
              height: 13,
            ),
            Text('Restaurants Menu Chosen For You',
              style: GoogleFonts.poppins(
                  color: const Color(0xFF1E2538),
                  fontWeight: FontWeight.w500,
                  fontSize: 17
              ),),
            const SizedBox(
              height: 16,
            ),
            ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 4,
                itemBuilder: (context, index) {
                  return Column(children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Transform.scale(
                          scale: 1.1,
                          child: Checkbox(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              value: value,
                              activeColor: AppTheme.primaryColor,
                              visualDensity: const VisualDensity(vertical: 0, horizontal: 0),
                              onChanged: (newValue) {
                                setState(() {
                                  value = newValue!;
                                  setState(() {});
                                });
                              }),
                        ),
                        const SizedBox(
                          width: 7,
                        ),
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
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xFF1E2538)),
                              ),
                              const SizedBox(
                                height: 3,
                              ),
                              Text(
                                "\$10.00",
                                style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w300,
                                    color: const Color(0xFF74848C)),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const DottedLine(
                      dashColor: Color(0xffBCBCBC),
                    ),
                    const SizedBox(
                      height: 7,
                    ),
                  ]);
                }),
          ],
        )
    ),
  ];
}
