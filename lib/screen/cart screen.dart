import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:resvago_customer/routers/routers.dart';
import 'package:resvago_customer/widget/appassets.dart';

import '../widget/apptheme.dart';
import '../widget/common_text_field.dart';
import 'addAddress.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: backAppBar(
          title: "CheckOut",
          context: context,
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
                        ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: 2,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 5),
                                child: Column(children: [
                                  Row(children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.asset(
                                        AppAssets.about,
                                        height: 60,
                                        width: 80,
                                        fit: BoxFit.cover,
                                      ),
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
                                            "\$10.00",
                                            style: GoogleFonts.poppins(fontSize: 14, color: const Color(0xFF74848C)),
                                          ),

                                          // DottedLine(
                                          //   dashColor: Colors.black,
                                          // )
                                        ],
                                      ),
                                    ),
                                    const Spacer(),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          height: 28,
                                          width: 28,
                                          decoration: BoxDecoration(
                                              border: Border.all(color: Colors.black),
                                              borderRadius: const BorderRadius.all(
                                                Radius.circular(20),
                                              )),
                                          child: InkWell(
                                              onTap: () {},
                                              child: const Icon(
                                                Icons.remove,
                                                size: 18,
                                              )),
                                        ),
                                        const SizedBox(
                                          width: 8,
                                        ),
                                        Text(
                                          "2",
                                          style: GoogleFonts.alegreyaSans(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 16,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 8,
                                        ),
                                        Row(
                                          children: [
                                            Container(
                                              height: 28,
                                              width: 28,
                                              decoration: const BoxDecoration(
                                                  color: AppTheme.primaryColor,
                                                  borderRadius: BorderRadius.all(
                                                    Radius.circular(20),
                                                  )),
                                              child: InkWell(
                                                onTap: () {},
                                                child: const Icon(
                                                  Icons.add,
                                                  color: Colors.white,
                                                  size: 18,
                                                ),
                                              ),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ])
                                ]),
                              );
                            }),
                      ]))),
          Container(
              width: size.width,
              margin: const EdgeInsets.all(8),
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
              child: Column(children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Deliver To',
                        style: GoogleFonts.poppins(
                            fontSize: 15, fontWeight: FontWeight.w500, color: const Color(0xff293044)),
                      ),
                      const Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: Color(0xff04666E),
                      )
                    ]),
                 ListTile(
                   horizontalTitleGap: -0,
                  contentPadding: EdgeInsets.zero,

                   visualDensity: VisualDensity.comfortable,

                  title: Transform.translate(
                    offset: Offset(-16, 0),
                    child: Text(
                      "Home",
                      style: TextStyle(color: Color(0xff384953), fontWeight: FontWeight.bold),
                    ),
                  ),
                  leading: Transform.translate(
                    offset: Offset(-16, 0),
                    child: CircleAvatar(
                      maxRadius: 40,
                      minRadius: 40,
                      backgroundColor: Color(0x1a3b5998),
                      child: CircleAvatar(
                        maxRadius: 20,
                        minRadius: 20,
                        backgroundColor: Color(0xff3B5998),
                        child: Icon(
                          Icons.location_on,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  subtitle: Transform.translate(
                    offset: Offset(-16, 0),
                    child: Text(
                      "4295 Shinn Avenue, Indiana, States",
                      style: TextStyle(fontSize: 15),
                      overflow: TextOverflow.ellipsis,

                    ),
                  ),
                )
              ])),
          Container(
            width: size.width,
            margin: EdgeInsets.all(8),
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
              children: [
                Row(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Image.asset(
                    'assets/icons/coupon.png',
                    height: 20,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    'Use Coupons',
                    style:
                        GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w500, color: const Color(0xff293044)),
                  ),
                ]),
                const SizedBox(
                  height: 10,
                ),
                Row(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Image.asset(
                    'assets/icons/verified.png',
                    height: 20,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'WELCOME50 Applied Successfully',
                        style: GoogleFonts.poppins(fontSize: 14, color: const Color(0xff1E2538).withOpacity(.8)),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        'You saved \$5',
                        style: GoogleFonts.poppins(fontSize: 12, color: AppTheme.primaryColor),
                      ),
                      const SizedBox(
                        height: 5,
                      )
                    ],
                  ),
                ]),
              ],
            ),
          ),
          Container(
            width: size.width,
            margin: EdgeInsets.all(8),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Subtotal',
                        style: GoogleFonts.poppins(
                            fontSize: 14, fontWeight: FontWeight.w400, color: const Color(0xff1E2538)),
                      ),
                      Text(
                        '\$10.00',
                        style: GoogleFonts.poppins(fontSize: 14, color: const Color(0xffBCBCBC)),
                      ),
                    ],
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Tax And Fees',
                        style: GoogleFonts.poppins(
                            fontSize: 14, fontWeight: FontWeight.w400, color: const Color(0xff1E2538)),
                      ),
                      Text(
                        '\$20.00',
                        style: GoogleFonts.poppins(fontSize: 14, color: const Color(0xffBCBCBC)),
                      ),
                    ],
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Delivery',
                        style: GoogleFonts.poppins(
                            fontSize: 14, fontWeight: FontWeight.w400, color: const Color(0xff1E2538)),
                      ),
                      Text(
                        "\$20.00",
                        style: GoogleFonts.poppins(fontSize: 14, color: const Color(0xffBCBCBC)),
                      ),
                    ],
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Save Coupon Code',
                        style: GoogleFonts.poppins(
                            fontSize: 14, fontWeight: FontWeight.w400, color: const Color(0xff1E2538)),
                      ),
                      Text(
                        "-\$20.00",
                        style: GoogleFonts.poppins(fontSize: 14, color: const Color(0xffBCBCBC)),
                      ),
                    ],
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total',
                        style: GoogleFonts.poppins(
                            fontSize: 14, fontWeight: FontWeight.w400, color: const Color(0xff1E2538)),
                      ),
                      const Spacer(),
                      Text(
                        "(3 Items)",
                        style: GoogleFonts.poppins(
                            fontSize: 10, color: const Color(0xff3B5998), fontStyle: FontStyle.italic),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Text(
                        "\$20.00",
                        style: GoogleFonts.poppins(fontSize: 14, color: const Color(0xffBCBCBC)),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ]),
          ),
          Container(
              width: size.width,
              margin: EdgeInsets.all(8),
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
                children: [
                  Row(
                    children: [
                      Text(
                        "Payment Method",
                        style: GoogleFonts.poppins(
                            fontSize: 16, fontWeight: FontWeight.w500, color: const Color(0xFF1E2538)),
                      ),
                      const SizedBox(
                        width: 8,
                      ),

                      GestureDetector(onTap: (){
                        Get.toNamed(MyRouters.addNewCard);
                      },
                        child: Container(
                          height: 23,
                          width: 23,
                          decoration: const BoxDecoration(
                              color: Color(0xffFAAF40),
                              borderRadius: BorderRadius.all(
                                Radius.circular(20),
                              )),
                          child: const Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 14,
                  ),
                  Container(
                    width: size.width,
                    decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(Radius.circular(8)),
                        border: Border.all(color: const Color(0xff3B5998).withOpacity(.3))),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                      child: Row(
                        children: [
                          Image.asset(
                            "assets/icons/debvitcard.png",
                            height: 20,
                          ),
                          const SizedBox(
                            width: 18,
                          ),
                          Text(
                            'Debit/Credit Card',
                            style: GoogleFonts.poppins(
                                fontSize: 14, fontWeight: FontWeight.w400, color: const Color(0xFF1E2538)),
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Container(
                    width: size.width,
                    decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(Radius.circular(8)),
                        border: Border.all(color: const Color(0xff3B5998).withOpacity(.3))),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                      child: Row(
                        children: [
                          Image.asset(
                            "assets/icons/phonepay.png",
                            height: 20,
                          ),
                          const SizedBox(
                            width: 18,
                          ),
                          Text(
                            'PayPay',
                            style: GoogleFonts.poppins(
                                fontSize: 14, fontWeight: FontWeight.w400, color: const Color(0xFF1E2538)),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              )),
          Container(
              margin: const EdgeInsets.only(top: 20),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: SizedBox(
                width: size.width,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Get.toNamed(MyRouters.thankuScreen);
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
                    textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  child: Text(
                    "Place Order",
                    style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white),
                  ),
                ),
              )),
          const SizedBox(
            height: 100,
          )
        ])));
  }
}
