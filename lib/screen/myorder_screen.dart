import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:resvago_customer/widget/appassets.dart';
import '../widget/apptheme.dart';

class MyOrder extends StatefulWidget {
  const MyOrder({super.key});

  @override
  State<MyOrder> createState() => _MyOrderState();
}

class _MyOrderState extends State<MyOrder> {
  var currentDrawer = 0;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return DefaultTabController(
        length: 3,
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.white,
              leading: InkWell(
                onTap: () {
                  Get.back();
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 13.0),
                  child: SvgPicture.asset("assets/images/back.svg"),
                ),
              ),
              elevation: 1,
              title: Text(
                "My Orders",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 13.0),
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: Colors.white,
                        border: Border.all(
                          color: const Color(0xff363539).withOpacity(.1),
                        )),
                    child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: PopupMenuButton<int>(
                            padding: EdgeInsets.zero,
                            icon: const Icon(
                              Icons.filter_list_sharp,
                              color: AppTheme.primaryColor,
                            ),
                            color: Colors.white,
                            surfaceTintColor: Colors.white,
                            itemBuilder: (context) {
                              return [
                                PopupMenuItem(
                                  value: 1,
                                  onTap: () {},
                                  child: const Column(
                                    children: [Text("Near By"), Divider()],
                                  ),
                                ),
                                PopupMenuItem(
                                  value: 1,
                                  onTap: () {},
                                  child: const Column(
                                    children: [Text("Rating"), Divider()],
                                  ),
                                ),
                                PopupMenuItem(
                                  value: 1,
                                  onTap: () {},
                                  child: const Column(
                                    children: [Text("Offers"), Divider()],
                                  ),
                                ),
                                PopupMenuItem(
                                  value: 1,
                                  onTap: () {},
                                  child: const Column(
                                    children: [
                                      Text("Popular"),
                                      Divider(
                                        color: Colors.white,
                                      )
                                    ],
                                  ),
                                ),
                              ];
                            })),
                  ),
                ),
              ],
              bottom: TabBar(
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorColor: AppTheme.primaryColor,
                indicatorPadding: const EdgeInsets.symmetric(horizontal: 15),
                // automaticIndicatorColorAdjustment: true,
                onTap: (value) {
                  currentDrawer = 0;
                  setState(() {});
                },
                tabs: [
                  Tab(
                    child: Text(
                      "Active",
                      style: currentDrawer == 0
                          ? GoogleFonts.poppins(color: const Color(0xff1A2E33), fontSize: 16, fontWeight: FontWeight.w500)
                          : GoogleFonts.poppins(color: AppTheme.primaryColor, fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ),
                  Tab(
                    child: Text(
                      "Completed",
                      style: currentDrawer == 1
                          ? GoogleFonts.poppins(color: Colors.cyan, fontSize: 16, fontWeight: FontWeight.w500)
                          : GoogleFonts.poppins(color: const Color(0xff1A2E33), fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ),
                  Tab(
                    child: Text(
                      "Cancelled",
                      style: currentDrawer == 1
                          ? GoogleFonts.poppins(color: Colors.cyan, fontSize: 16, fontWeight: FontWeight.w500)
                          : GoogleFonts.poppins(color: const Color(0xff1A2E33), fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),
            body: TabBarView(children: [
              Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(
                      top: 18,
                    ),
                    decoration: const BoxDecoration(
                      color: Color(0xffFFFFFF),
                    ),
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.start,
                      // crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(AppAssets.orderEmpty),
                        Text(
                          'Empty',
                          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Text(
                          'You do not have an active order of this time',
                          style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w400, color: const Color(0xff747474)),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return Column(

                        children: [

                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 13,vertical: 7),
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
                        child:
                          Column(crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(

                                height: 25,
                                width: 25,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Colors.white,
                                    border: Border.all(
                                      color: const Color(0xff363539).withOpacity(.1),
                                    )),
                                child: Padding(
                                  padding: const EdgeInsets.all(2),
                                  child: Image.asset('assets/images/route-square.png'),
                                ),
                              ),



                              Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Image.asset(
                                 'assets/images/bowl pasta.png',
                                      height: 70,
                                      width: 70,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 15),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Golden Kitchen",
                                            style: GoogleFonts.poppins(
                                                fontSize: 16, fontWeight: FontWeight.w500, color: const Color(0xFF1A2E33)),
                                          ),
                                          const SizedBox(
                                            height: 3,
                                          ),
                                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                            children: [
                                              Column(crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "Date",
                                                    style: GoogleFonts.poppins(
                                                        fontSize: 11, fontWeight: FontWeight.w300, color: const Color(0xFF74848C)),
                                                  ),
                                                  const SizedBox(height: 5,),
                                                  Text(
                                                    "24 Oct 23",
                                                    style: GoogleFonts.poppins(
                                                        fontSize: 11, fontWeight: FontWeight.w500, color: const Color(0xFF384953)),
                                                  ),

                                                ],
                                              ),
                                              SizedBox(width: size.width*.06,),
                                              Column(crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "Time",
                                                    style: GoogleFonts.poppins(
                                                        fontSize: 11, fontWeight: FontWeight.w300, color: const Color(0xFF74848C)),
                                                  ),
                                                  const SizedBox(height: 5,),
                                                  Text(
                                                    "6:30PM",
                                                    style: GoogleFonts.poppins(
                                                        fontSize: 11, fontWeight: FontWeight.w500, color: const Color(0xFF384953)),
                                                  ),

                                                ],
                                              ),
                                              SizedBox(width: size.width*.06,),
                                              Column(crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "Guest",
                                                    style: GoogleFonts.poppins(
                                                        fontSize: 11, fontWeight: FontWeight.w300, color: const Color(0xFF74848C)),
                                                  ),
                                                  const SizedBox(height: 5,),
                                                  Text(
                                                    "12",
                                                    style: GoogleFonts.poppins(
                                                        fontSize: 11, fontWeight: FontWeight.w500, color: const Color(0xFF384953)),
                                                  ),

                                                ],
                                              ),
                                              SizedBox(width: size.width*.06,),
                                              Column(
                                                children: [
                                                  Text(
                                                    "offer",
                                                    style: GoogleFonts.poppins(
                                                        fontSize: 11, fontWeight: FontWeight.w300, color: const Color(0xFF74848C)),
                                                  ),
                                                  const SizedBox(height: 5,),
                                                  Text(
                                                    "-20%",
                                                    style: GoogleFonts.poppins(
                                                        fontSize: 11, fontWeight: FontWeight.w500, color: const Color(0xFF384953)),
                                                  ),

                                                ],
                                              ),

                                        ],
                                      ),
                                  ]),
                              ) ]),
                              const Divider(

                                height: 40,
                                color: Color(0xffE8E8E8),
                                thickness: 1,
                              ),


                              Row(
                                children: [
                                  SizedBox(
                                    // width: size.width,
                                    height: 28,

                                    child: ElevatedButton(
                                      onPressed: () {},
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor:  Colors.white,
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(3),
                                              side: const BorderSide(

                                                color: const Color(0xFF3B5998),
                                              )),

                                          textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                                      child: Text(
                                        "Leave a review",
                                        style: GoogleFonts.poppins(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: AppTheme.primaryColor
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 20,),
                                  SizedBox(
                                    // width: size.width,
                                    height: 28,

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
                                        "Order Again",
                                        style: GoogleFonts.poppins(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )


                          )
                          ]);
                  }),
              ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return Column(

                        children: [

                          Container(
                              margin: const EdgeInsets.symmetric(horizontal: 13,vertical: 7),
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
                              child:
                              Column(crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Container(

                                    height: 25,
                                    width: 25,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: Colors.white,
                                        border: Border.all(
                                          color: const Color(0xff363539).withOpacity(.1),
                                        )),
                                    child: Padding(
                                      padding: const EdgeInsets.all(2),
                                      child: Image.asset('assets/images/route-square.png'),
                                    ),
                                  ),



                                  Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Image.asset(
                                          'assets/images/bowl pasta.png',
                                          height: 70,
                                          width: 70,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 15),
                                          child: Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Golden Kitchen",
                                                  style: GoogleFonts.poppins(
                                                      fontSize: 16, fontWeight: FontWeight.w500, color: const Color(0xFF1A2E33)),
                                                ),
                                                const SizedBox(
                                                  height: 3,
                                                ),
                                                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                                  children: [
                                                    Column(crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          "Date",
                                                          style: GoogleFonts.poppins(
                                                              fontSize: 11, fontWeight: FontWeight.w300, color: const Color(0xFF74848C)),
                                                        ),
                                                        const SizedBox(height: 5,),
                                                        Text(
                                                          "24 Oct 23",
                                                          style: GoogleFonts.poppins(
                                                              fontSize: 11, fontWeight: FontWeight.w500, color: const Color(0xFF384953)),
                                                        ),

                                                      ],
                                                    ),
                                                    SizedBox(width: size.width*.06,),
                                                    Column(crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          "Time",
                                                          style: GoogleFonts.poppins(
                                                              fontSize: 11, fontWeight: FontWeight.w300, color: const Color(0xFF74848C)),
                                                        ),
                                                        const SizedBox(height: 5,),
                                                        Text(
                                                          "6:30PM",
                                                          style: GoogleFonts.poppins(
                                                              fontSize: 11, fontWeight: FontWeight.w500, color: const Color(0xFF384953)),
                                                        ),

                                                      ],
                                                    ),
                                                    SizedBox(width: size.width*.06,),
                                                    Column(crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          "Guest",
                                                          style: GoogleFonts.poppins(
                                                              fontSize: 11, fontWeight: FontWeight.w300, color: const Color(0xFF74848C)),
                                                        ),
                                                        const SizedBox(height: 5,),
                                                        Text(
                                                          "12",
                                                          style: GoogleFonts.poppins(
                                                              fontSize: 11, fontWeight: FontWeight.w500, color: const Color(0xFF384953)),
                                                        ),

                                                      ],
                                                    ),
                                                    SizedBox(width: size.width*.06,),
                                                    Column(
                                                      children: [
                                                        Text(
                                                          "offer",
                                                          style: GoogleFonts.poppins(
                                                              fontSize: 11, fontWeight: FontWeight.w300, color: const Color(0xFF74848C)),
                                                        ),
                                                        const SizedBox(height: 5,),
                                                        Text(
                                                          "-20%",
                                                          style: GoogleFonts.poppins(
                                                              fontSize: 11, fontWeight: FontWeight.w500, color: const Color(0xFF384953)),
                                                        ),

                                                      ],
                                                    ),

                                                  ],
                                                ),
                                              ]),
                                        ) ]),

                                ],
                              )


                          )
                        ]);
                  })
            ])));
  }
}
