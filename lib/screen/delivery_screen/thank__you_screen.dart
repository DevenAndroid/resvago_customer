import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:resvago_customer/model/order_model.dart';
import 'package:resvago_customer/screen/helper.dart';
import 'package:resvago_customer/screen/order/myorder_screen.dart';
import '../../widget/apptheme.dart';
import '../order/order_details_screen.dart';

class ThankuScreen extends StatefulWidget {
  ThankuScreen({super.key, this.date, this.orderType, this.guestNo, this.orderId});
  String? date;
  String? orderType;
  int? guestNo;
  String? orderId;

  @override
  State<ThankuScreen> createState() => _ThankuScreenState();
}

class _ThankuScreenState extends State<ThankuScreen> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    log(widget.date.toString());
    return Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            Container(
              width: size.width,
              height: size.height,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage(
                        "assets/images/Thank you.png",
                      ))),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Image.asset(
                      'assets/images/thnaku.png',
                      height: 130,
                    ),
                    const SizedBox(
                      height: 13,
                    ),
                    Text(
                      'Thank you '.toUpperCase(),
                      style: GoogleFonts.poppins(fontSize: 40, fontWeight: FontWeight.w600, color: Colors.white),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      'Your reservation is confirmed',
                      style: GoogleFonts.poppins(fontSize: 16, color: Colors.white),
                    ),
                    const SizedBox(
                      height: 18,
                    ),
                    Container(
                      width: kIsWeb ? 800 : size.width * .85,
                      height: 43,
                      decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(Radius.circular(20)),
                          color: const Color(0xffFAAF40).withOpacity(.3),
                          border: Border.all(color: const Color(0xffFAAF40))
                          // color: Color()
                          ),
                      child: Center(
                        child: widget.orderType == "Dining"
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "${widget.guestNo.toString()} Guest, ",
                                    style: GoogleFonts.poppins(
                                        color: const Color(
                                          0xffFAAF40,
                                        ),
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Text(
                                    DateFormat("MMM-dd-yyyy").format(DateTime.parse(widget.date.toString())),
                                    style: GoogleFonts.poppins(
                                        color: const Color(
                                          0xffFAAF40,
                                        ),
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              )
                            : Text(
                                "Your OrderId: #${widget.orderId.toString()}",
                                style: GoogleFonts.poppins(
                                    color: const Color(
                                      0xffFAAF40,
                                    ),
                                    fontWeight: FontWeight.w500),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ).appPaddingForScreen,
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: SizedBox(
                width: size.width,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    log(widget.orderId.toString());
                    Get.offAll(() => OderDetailsScreen(
                          orderId: widget.orderId.toString(),
                          orderType: widget.orderType,
                          data: 'Data',
                        ));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    surfaceTintColor: Colors.white,
                    shape: const RoundedRectangleBorder(
                      side: BorderSide(
                        color: Color(0xFF3B5998),
                      ),
                    ),
                    textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  child: Text(
                    "Check Order Details".toUpperCase(),
                    style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w600, color: AppTheme.primaryColor),
                  ),
                ),
              ).appPaddingForScreen,
            )
          ],
        ));
  }
}
