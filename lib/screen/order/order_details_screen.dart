import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../model/order_model.dart';
import '../../widget/appassets.dart';
import '../../widget/common_text_field.dart';

class OderDetailsScreen extends StatefulWidget {
  const OderDetailsScreen({super.key, required this.myOrderDetails});
  final MyOrderModel myOrderDetails;

  @override
  State<OderDetailsScreen> createState() => _OderDetailsScreenState();
}

class _OderDetailsScreenState extends State<OderDetailsScreen> {
  MyOrderModel? get orderDetailsData => widget.myOrderDetails;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: backAppBar(title: "Orders Details", context: context),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Image.asset(AppAssets.details,height: 23,),
                    const SizedBox(
                      width: 20,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Order ID: ${orderDetailsData!.orderId.toString()}",
                          style: GoogleFonts.poppins(color: const Color(0xFF423E5E), fontWeight: FontWeight.w600, fontSize: 15),
                        ),
                        Text(
                          "Monday, 2 June, 2021",
                          style: GoogleFonts.poppins(color: const Color(0xFF303C5E), fontWeight: FontWeight.w400, fontSize: 11),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
                      decoration: BoxDecoration(
                        color: const Color(0xFF65CD90),
                        borderRadius: BorderRadius.circular(9),
                      ),
                      child: Text(
                        orderDetailsData!.orderStatus.toString(),
                        style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 11),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Container(
                margin: const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
                width: size.width,
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
                  crossAxisAlignment: CrossAxisAlignment.end,
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
                    Row(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          orderDetailsData!.orderDetails!.restaurantInfo!.image.toString(),
                          height: 70,
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
                                orderDetailsData!.orderDetails!.restaurantInfo!.restaurantName.toString(),
                                style: GoogleFonts.poppins(
                                    fontSize: 16, fontWeight: FontWeight.w500, color: const Color(0xFF1A2E33)),
                              ),
                              const SizedBox(
                                height: 3,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Date",
                                        style: GoogleFonts.poppins(
                                            fontSize: 11, fontWeight: FontWeight.w300, color: const Color(0xFF74848C)),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        "24 Oct 23",
                                        style: GoogleFonts.poppins(
                                            fontSize: 11, fontWeight: FontWeight.w500, color: const Color(0xFF384953)),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width: size.width * .06,
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Time",
                                        style: GoogleFonts.poppins(
                                            fontSize: 11, fontWeight: FontWeight.w300, color: const Color(0xFF74848C)),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        "6:30PM",
                                        style: GoogleFonts.poppins(
                                            fontSize: 11, fontWeight: FontWeight.w500, color: const Color(0xFF384953)),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width: size.width * .06,
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Guest",
                                        style: GoogleFonts.poppins(
                                            fontSize: 11, fontWeight: FontWeight.w300, color: const Color(0xFF74848C)),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        "12",
                                        style: GoogleFonts.poppins(
                                            fontSize: 11, fontWeight: FontWeight.w500, color: const Color(0xFF384953)),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width: size.width * .06,
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        "offer",
                                        style: GoogleFonts.poppins(
                                            fontSize: 11, fontWeight: FontWeight.w300, color: const Color(0xFF74848C)),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
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
                      )
                    ]),
                    const SizedBox(
                      height: 10,
                    )
                  ],
                )),
            Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Selected Items",
                                style:
                                    GoogleFonts.poppins(color: const Color(0xFF1A2E33), fontWeight: FontWeight.w600, fontSize: 16),
                              ),
                              const SizedBox(
                                height: 11,
                              ),
                              ListView.builder(
                                shrinkWrap: true,
                                itemCount: orderDetailsData!.orderDetails!.menuList!.length,
                                itemBuilder: (BuildContext context, int index) {
                                  var menuData = orderDetailsData!.orderDetails!.menuList![index];
                                  return Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(10),
                                            child: Image.network(
                                              menuData.image.toString(),
                                              height: 70,
                                              width: 80,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 15,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(top: 8.0),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Salad veggie",
                                                  style: GoogleFonts.poppins(
                                                      color: const Color(0xFF1A2E33), fontWeight: FontWeight.w600, fontSize: 15),
                                                ),
                                                const SizedBox(
                                                  height: 6,
                                                ),
                                                Text(
                                                  "\$10.00",
                                                  style: GoogleFonts.poppins(
                                                      color: const Color(0xFF384953), fontWeight: FontWeight.w300, fontSize: 15),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                    ],
                                  );
                                },
                              )
                            ],
                          ),
                        ),
                        // Padding(
                        //   padding: const EdgeInsets.only(top: 98.0),
                        //   child: Image.asset(AppAssets.qr,height: 80,),
                        // )
                      ],
                    ))),
            Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Customer Details",
                          style: GoogleFonts.poppins(color: const Color(0xFF1A2E33), fontWeight: FontWeight.w500, fontSize: 16),
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                        Divider(
                          thickness: 1,
                          color: Colors.grey.withOpacity(.3),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0, right: 8),
                          child: Row(
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Customer Name",
                                    style: GoogleFonts.poppins(
                                        color: const Color(0xFF486769), fontWeight: FontWeight.w300, fontSize: 14),
                                  ),
                                  Text(
                                    "McDonald’s",
                                    style: GoogleFonts.poppins(
                                        color: const Color(0xFF21283D), fontWeight: FontWeight.w500, fontSize: 16),
                                  ),
                                ],
                              ),
                              const Spacer(),
                              // SvgPicture.asset(AppAssets.contact)
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Divider(
                          thickness: 1,
                          color: Colors.grey.withOpacity(.3),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0, right: 8),
                          child: Row(
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Customer Number",
                                    style: GoogleFonts.poppins(
                                        color: const Color(0xFF486769), fontWeight: FontWeight.w300, fontSize: 14),
                                  ),
                                  Text(
                                    "+91 9876454321",
                                    style: GoogleFonts.poppins(
                                        color: const Color(0xFF21283D), fontWeight: FontWeight.w500, fontSize: 16),
                                  ),
                                ],
                              ),
                              const Spacer(),
                              // Image.asset(AppAssets.call,height: 40,)
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Divider(
                          thickness: 1,
                          color: Colors.grey.withOpacity(.3),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0, right: 8),
                          child: Row(
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Customer Address",
                                    style: GoogleFonts.poppins(
                                        color: const Color(0xFF486769), fontWeight: FontWeight.w300, fontSize: 14),
                                  ),
                                  Text(
                                    "Douglas, Cork, T16 XN73, uk",
                                    style: GoogleFonts.poppins(
                                        color: const Color(0xFF21283D), fontWeight: FontWeight.w500, fontSize: 16),
                                  ),
                                ],
                              ),
                              const Spacer(),
                              // Image.asset(AppAssets.customerLocation,height: 40,)
                            ],
                          ),
                        ),
                      ],
                    ))),
            Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Subtotal",
                              style:
                                  GoogleFonts.poppins(color: const Color(0xFF1E2538), fontWeight: FontWeight.w300, fontSize: 14),
                            ),
                            Text(
                              "\$12.99",
                              style:
                                  GoogleFonts.poppins(color: const Color(0xFF3A3A3A), fontWeight: FontWeight.w500, fontSize: 16),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Service Fees",
                              style:
                                  GoogleFonts.poppins(color: const Color(0xFF1E2538), fontWeight: FontWeight.w300, fontSize: 14),
                            ),
                            Text(
                              "\$5.00",
                              style:
                                  GoogleFonts.poppins(color: const Color(0xFF3A3A3A), fontWeight: FontWeight.w500, fontSize: 16),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Meat Pasta",
                              style:
                                  GoogleFonts.poppins(color: const Color(0xFF1E2538), fontWeight: FontWeight.w300, fontSize: 14),
                            ),
                            Text(
                              "\$3.00",
                              style:
                                  GoogleFonts.poppins(color: const Color(0xFF3A3A3A), fontWeight: FontWeight.w500, fontSize: 16),
                            ),
                          ],
                        ),
                        Divider(
                          thickness: 1,
                          color: Colors.grey.withOpacity(.3),
                        ),
                        const SizedBox(
                          height: 3,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Total",
                              style:
                                  GoogleFonts.poppins(color: const Color(0xFF3A3A3A), fontWeight: FontWeight.w500, fontSize: 16),
                            ),
                            Text(
                              "\$26.00",
                              style:
                                  GoogleFonts.poppins(color: const Color(0xFF3A3A3A), fontWeight: FontWeight.w500, fontSize: 16),
                            ),
                          ],
                        ),
                      ],
                    ))),
            const SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }
}
