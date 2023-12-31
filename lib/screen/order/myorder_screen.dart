import 'dart:convert';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:resvago_customer/model/dinig_order.dart';
import 'package:resvago_customer/model/order_model.dart';
import 'package:resvago_customer/screen/delivery_screen/cart%20screen.dart';
import 'package:resvago_customer/screen/review_rating_screen.dart';
import 'package:resvago_customer/widget/appassets.dart';
import '../../firebase_service/firebase_service.dart';
import '../../widget/apptheme.dart';
import 'order_details_screen.dart';

class MyOrder extends StatefulWidget {
  const MyOrder({super.key});

  @override
  State<MyOrder> createState() => _MyOrderState();
}

class _MyOrderState extends State<MyOrder> {
  var currentDrawer = 0;
  var orderType = "Dining";
  List<MyOrderModel>? myOrder;
  getOrderList() {
    FirebaseFirestore.instance
        .collection("order")
        .where("userId", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      for (var element in value.docs) {
        var gg = element.data();
        myOrder ??= [];
        myOrder!.add(MyOrderModel.fromJson(gg));
      }
    });
    setState(() {});
  }

  List<MyDiningOrderModel>? myDiningOrder;
  getDiningOrderList() {
    FirebaseFirestore.instance
        .collection("dining_order")
        .where("userId", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      log(jsonEncode(value.docs.first.data()));
    });
    setState(() {});
  }

  Stream<List<MyOrderModel>> getActiveOrder() {
    return FirebaseFirestore.instance
        .collection("order")
        .where("userId", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .where('order_status', isEqualTo: "Place Order")
        .snapshots()
        .map((querySnapshot) {
      List<MyOrderModel> menuList = [];
      try {
        for (var doc in querySnapshot.docs) {
          var gg = doc.data();
          menuList.add(MyOrderModel.fromJson(gg));
        }
      } catch (e) {
        throw Exception(e.toString());
      }
      return menuList;
    });
  }

  Stream<List<MyOrderModel>> getCompletedOrder() {
    return FirebaseFirestore.instance
        .collection("order")
        .where("userId", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .where('order_status', isEqualTo: "Order Completed")
        .snapshots()
        .map((querySnapshot) {
      List<MyOrderModel> menuList = [];

      try {
        for (var doc in querySnapshot.docs) {
          var gg = doc.data();
          menuList.add(MyOrderModel.fromJson(gg));
        }
      } catch (e) {
        throw Exception(e.toString());
      }
      return menuList;
    });
  }

  Stream<List<MyOrderModel>> getCancelledOrder() {
    return FirebaseFirestore.instance
        .collection("order")
        .where("userId", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .where('order_status', isEqualTo: "Order Rejected")
        .snapshots()
        .map((querySnapshot) {
      List<MyOrderModel> menuList = [];
      try {
        for (var doc in querySnapshot.docs) {
          var gg = doc.data();
          menuList.add(MyOrderModel.fromJson(gg));
        }
      } catch (e) {
        throw Exception(e.toString());
      }
      return menuList;
    });
  }

  Stream<List<MyDiningOrderModel>> getActiveDiningOrder() {
    return FirebaseFirestore.instance
        .collection("dining_order")
        .where("userId", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .where('order_status', isEqualTo: "Place Order")
        .snapshots()
        .map((querySnapshot) {
      List<MyDiningOrderModel> menuList = [];
      try {
        for (var doc in querySnapshot.docs) {
          var gg = doc.data();
          menuList.add(MyDiningOrderModel.fromJson(gg));
        }
      } catch (e) {
        throw Exception(e.toString());
      }
      return menuList;
    });
  }

  Stream<List<MyDiningOrderModel>> getCompletedDiningOrder() {
    return FirebaseFirestore.instance
        .collection("dining_order")
        .where("userId", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .where('order_status', isEqualTo: "Order Completed")
        .snapshots()
        .map((querySnapshot) {
      List<MyDiningOrderModel> menuList = [];
      try {
        for (var doc in querySnapshot.docs) {
          var gg = doc.data();
          menuList.add(MyDiningOrderModel.fromJson(gg));
        }
      } catch (e) {
        throw Exception(e.toString());
      }
      return menuList;
    });
  }

  Stream<List<MyDiningOrderModel>> getCancelledDiningOrder() {
    return FirebaseFirestore.instance
        .collection("dining_order")
        .where("userId", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .where('order_status', isEqualTo: "Order Rejected")
        .snapshots()
        .map((querySnapshot) {
      List<MyDiningOrderModel> menuList = [];
      try {
        for (var doc in querySnapshot.docs) {
          var gg = doc.data();
          menuList.add(MyDiningOrderModel.fromJson(gg));
        }
      } catch (e) {
        throw Exception(e.toString());
      }
      return menuList;
    });
  }

  FirebaseService firebaseService = FirebaseService();
  @override
  void initState() {
    super.initState();
    getOrderList();
    getDiningOrderList();
    // getOrderList();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    log("sdsadfsf${FirebaseAuth.instance.currentUser!.uid}");
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
                                  onTap: () {
                                    orderType = "Dining";
                                    log(orderType.toString());
                                    setState(() {});
                                  },
                                  child: const Column(
                                    children: [Text("Dining Orders"), Divider()],
                                  ),
                                ),
                                PopupMenuItem(
                                  value: 1,
                                  onTap: () {
                                    orderType = "Delivery";
                                    log(orderType.toString());
                                    setState(() {});
                                  },
                                  child: const Column(
                                    children: [
                                      Text("Delivery Orders"),
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
                          ? GoogleFonts.poppins(color: AppTheme.primaryColor, fontSize: 16, fontWeight: FontWeight.w500)
                          : GoogleFonts.poppins(color: const Color(0xff9B9B9B), fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ),
                  Tab(
                    child: Text(
                      "Completed",
                      style: currentDrawer == 1
                          ? GoogleFonts.poppins(color: AppTheme.primaryColor, fontSize: 16, fontWeight: FontWeight.w500)
                          : GoogleFonts.poppins(color: const Color(0xff9B9B9B), fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ),
                  Tab(
                    child: Text(
                      "Cancelled",
                      style: currentDrawer == 1
                          ? GoogleFonts.poppins(color: AppTheme.primaryColor, fontSize: 16, fontWeight: FontWeight.w500)
                          : GoogleFonts.poppins(color: const Color(0xff9B9B9B), fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),
            body: orderType == "Delivery"
                ? TabBarView(children: [
                    StreamBuilder<List<MyOrderModel>>(
                      stream: getActiveOrder(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return LoadingAnimationWidget.fourRotatingDots(
                            color: AppTheme.primaryColor,
                            size: 40,
                          );
                        }
                        if (snapshot.hasData) {
                          List<MyOrderModel> myOrder = snapshot.data ?? [];
                          log(myOrder.toString()); //
                          return myOrder.isNotEmpty
                              ? ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: myOrder.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    var orderItem = myOrder[index];
                                    return GestureDetector(
                                      onTap: () {
                                        Get.to(() => OderDetailsScreen(
                                              orderType: 'Delivery',
                                              orderId: orderItem.orderId,
                                              data: '',
                                            ));
                                      },
                                      child: Container(
                                          margin: const EdgeInsets.symmetric(horizontal: 13, vertical: 5),
                                          width: size.width,
                                          padding: const EdgeInsets.all(14),
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(10),
                                              boxShadow: [
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
                                              Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    ClipRRect(
                                                      borderRadius: BorderRadius.circular(20),
                                                      child: Image.network(
                                                        orderItem.orderDetails!.restaurantInfo!.image,
                                                        height: 70,
                                                        width: 70,
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
                                                              orderItem.orderDetails!.restaurantInfo!.restaurantName.toString(),
                                                              style: GoogleFonts.poppins(
                                                                  fontSize: 16,
                                                                  fontWeight: FontWeight.w500,
                                                                  color: const Color(0xFF1A2E33)),
                                                            ),
                                                            const SizedBox(
                                                              height: 3,
                                                            ),
                                                            IntrinsicHeight(
                                                              child: Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                children: [
                                                                  Text(
                                                                    "${orderItem.orderDetails!.menuList!.length} Items",
                                                                    style: GoogleFonts.poppins(
                                                                        fontSize: 12,
                                                                        fontWeight: FontWeight.w300,
                                                                        color: const Color(0xFF74848C)),
                                                                  ),
                                                                  const SizedBox(
                                                                    height: 5,
                                                                  ),
                                                                  const VerticalDivider(),
                                                                  Text(
                                                                    orderItem.orderType,
                                                                    style: GoogleFonts.poppins(
                                                                        fontSize: 12,
                                                                        fontWeight: FontWeight.w300,
                                                                        color: const Color(0xFF74848C)),
                                                                  ),
                                                                  SizedBox(
                                                                    width: size.width * .06,
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              height: 5,
                                                            ),
                                                            Text(
                                                              "\$${orderItem.total}",
                                                              style: GoogleFonts.poppins(
                                                                  fontSize: 12,
                                                                  fontWeight: FontWeight.w300,
                                                                  color: const Color(0xFF3B5998)),
                                                            ),
                                                          ]),
                                                    )
                                                  ]),
                                              const Divider(
                                                height: 20,
                                                color: Color(0xffE8E8E8),
                                                thickness: 1,
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  SizedBox(
                                                    height: 28,
                                                    child: ElevatedButton(
                                                      onPressed: () {},
                                                      style: ElevatedButton.styleFrom(
                                                          backgroundColor: Colors.white,
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.circular(20),
                                                              side: const BorderSide(
                                                                color: Colors.red,
                                                              )),
                                                          textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                                                      child: Text(
                                                        "Cancel Order",
                                                        style: GoogleFonts.poppins(
                                                            fontSize: 12, fontWeight: FontWeight.w500, color: Colors.red),
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 20,
                                                  ),
                                                  SizedBox(
                                                    height: 28,
                                                    child: ElevatedButton(
                                                      onPressed: () {
                                                        Get.to(() => OderDetailsScreen(
                                                              orderType: 'Delivery',
                                                              orderId: '',
                                                              data: '',
                                                            ));
                                                      },
                                                      style: ElevatedButton.styleFrom(
                                                          backgroundColor: AppTheme.primaryColor,
                                                          shape: RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(20),
                                                          ),
                                                          textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                                                      child: Text(
                                                        "See Details",
                                                        style: GoogleFonts.poppins(
                                                            fontSize: 12, fontWeight: FontWeight.w500, color: Colors.white),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          )),
                                    );
                                  })
                              : Column(
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
                                            style: GoogleFonts.poppins(
                                                fontSize: 15, fontWeight: FontWeight.w400, color: const Color(0xff747474)),
                                          ),
                                          const SizedBox(
                                            height: 40,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                    StreamBuilder<List<MyOrderModel>>(
                      stream: getCompletedOrder(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return LoadingAnimationWidget.fourRotatingDots(
                            color: AppTheme.primaryColor,
                            size: 40,
                          );
                        }
                        if (snapshot.hasData) {
                          List<MyOrderModel> myOrder = snapshot.data ?? [];
                          log(myOrder.toString()); //
                          return myOrder.isNotEmpty
                              ? ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: myOrder.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    var orderItem = myOrder[index];
                                    return GestureDetector(
                                      onTap: () {
                                        Get.to(() => OderDetailsScreen(
                                              orderType: 'Delivery',
                                              orderId: orderItem.orderId,
                                              data: '',
                                            ));
                                      },
                                      child: Container(
                                          margin: const EdgeInsets.symmetric(horizontal: 13, vertical: 5),
                                          width: size.width,
                                          padding: const EdgeInsets.all(14),
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(10),
                                              boxShadow: [
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
                                              Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    ClipRRect(
                                                      borderRadius: BorderRadius.circular(20),
                                                      child: Image.network(
                                                        orderItem.orderDetails!.restaurantInfo!.image,
                                                        height: 70,
                                                        width: 70,
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
                                                              orderItem.orderDetails!.restaurantInfo!.restaurantName.toString(),
                                                              style: GoogleFonts.poppins(
                                                                  fontSize: 16,
                                                                  fontWeight: FontWeight.w500,
                                                                  color: const Color(0xFF1A2E33)),
                                                            ),
                                                            const SizedBox(
                                                              height: 3,
                                                            ),
                                                            IntrinsicHeight(
                                                              child: Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                children: [
                                                                  Text(
                                                                    "${orderItem.orderDetails!.menuList!.length} Items",
                                                                    style: GoogleFonts.poppins(
                                                                        fontSize: 12,
                                                                        fontWeight: FontWeight.w300,
                                                                        color: const Color(0xFF74848C)),
                                                                  ),
                                                                  const SizedBox(
                                                                    height: 5,
                                                                  ),
                                                                  const VerticalDivider(),
                                                                  Text(
                                                                    orderItem.orderType,
                                                                    style: GoogleFonts.poppins(
                                                                        fontSize: 12,
                                                                        fontWeight: FontWeight.w300,
                                                                        color: const Color(0xFF74848C)),
                                                                  ),
                                                                  SizedBox(
                                                                    width: size.width * .06,
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              height: 5,
                                                            ),
                                                            Row(
                                                              children: [
                                                                Text(
                                                                  "\$${orderItem.total}",
                                                                  style: GoogleFonts.poppins(
                                                                      fontSize: 12,
                                                                      fontWeight: FontWeight.w300,
                                                                      color: const Color(0xFF3B5998)),
                                                                ),
                                                                const SizedBox(
                                                                  width: 10,
                                                                ),
                                                                SizedBox(
                                                                  height: 28,
                                                                  child: ElevatedButton(
                                                                    onPressed: () {},
                                                                    style: ElevatedButton.styleFrom(
                                                                        backgroundColor: const Color(0xff65CD90),
                                                                        shape: RoundedRectangleBorder(
                                                                          borderRadius: BorderRadius.circular(20),
                                                                        ),
                                                                        textStyle: const TextStyle(
                                                                            fontSize: 18, fontWeight: FontWeight.w500)),
                                                                    child: Text(
                                                                      orderItem.orderStatus.toString(),
                                                                      style: GoogleFonts.poppins(
                                                                          fontSize: 12,
                                                                          fontWeight: FontWeight.w500,
                                                                          color: Colors.white),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ]),
                                                    )
                                                  ]),
                                              const Divider(
                                                height: 20,
                                                color: Color(0xffE8E8E8),
                                                thickness: 1,
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  SizedBox(
                                                    height: 28,
                                                    child: ElevatedButton(
                                                      onPressed: () {
                                                        Get.to(() => ReviewAndRatingScreen(
                                                              orderId: orderItem.orderId,
                                                              vendorId: orderItem.vendorId,
                                                            ));
                                                      },
                                                      style: ElevatedButton.styleFrom(
                                                          backgroundColor: Colors.white,
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.circular(20),
                                                              side: const BorderSide(
                                                                color: Color(0xffFAAF40),
                                                              )),
                                                          textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                                                      child: Text(
                                                        "Leave Review",
                                                        style: GoogleFonts.poppins(
                                                            fontSize: 12,
                                                            fontWeight: FontWeight.w500,
                                                            color: const Color(0xffFAAF40)),
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 20,
                                                  ),
                                                  SizedBox(
                                                    height: 28,
                                                    child: ElevatedButton(
                                                      onPressed: () async {
                                                        log(myOrder[index]
                                                            .orderDetails!
                                                            .menuList!
                                                            .where((e) => e.qty > 0)
                                                            .toList()
                                                            .toString());
                                                        try {
                                                          await firebaseService
                                                              .manageCheckOut(
                                                            cartId: FirebaseAuth.instance.currentUser!.uid,
                                                            menuList: myOrder[index]
                                                                .orderDetails!
                                                                .menuList!
                                                                .where((e) => e.qty > 0)
                                                                .map((e) => e.toJson())
                                                                .toList(),
                                                            restaurantInfo: myOrder[index].orderDetails!.restaurantInfo!.toJson(),
                                                            vendorId: myOrder[index].orderDetails!.restaurantInfo!.userID,
                                                            time: DateTime.now().millisecondsSinceEpoch,
                                                          )
                                                              .then((value) {
                                                            Get.to(() => const CartScreen());
                                                          });
                                                        } catch (e) {
                                                          throw Exception(e);
                                                        }
                                                      },
                                                      style: ElevatedButton.styleFrom(
                                                          backgroundColor: AppTheme.primaryColor,
                                                          shape: RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(20),
                                                          ),
                                                          textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                                                      child: Text(
                                                        "Order Again",
                                                        style: GoogleFonts.poppins(
                                                            fontSize: 12, fontWeight: FontWeight.w500, color: Colors.white),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          )),
                                    );
                                  })
                              : Column(
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
                                            style: GoogleFonts.poppins(
                                                fontSize: 15, fontWeight: FontWeight.w400, color: const Color(0xff747474)),
                                          ),
                                          const SizedBox(
                                            height: 40,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                    StreamBuilder<List<MyOrderModel>>(
                      stream: getCancelledOrder(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return LoadingAnimationWidget.fourRotatingDots(
                            color: AppTheme.primaryColor,
                            size: 40,
                          );
                        }
                        if (snapshot.hasData) {
                          List<MyOrderModel> myOrder = snapshot.data ?? [];
                          log(myOrder.toString()); //
                          return myOrder.isNotEmpty
                              ? ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: myOrder.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    var orderItem = myOrder[index];
                                    return GestureDetector(
                                      onTap: () {
                                        Get.to(() => OderDetailsScreen(
                                              orderType: 'Delivery',
                                              orderId: orderItem.orderId,
                                              data: '',
                                            ));
                                      },
                                      child: Container(
                                          margin: const EdgeInsets.symmetric(horizontal: 13, vertical: 5),
                                          width: size.width,
                                          padding: const EdgeInsets.all(14),
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(10),
                                              boxShadow: [
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
                                              Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    ClipRRect(
                                                      borderRadius: BorderRadius.circular(20),
                                                      child: Image.network(
                                                        orderItem.orderDetails!.restaurantInfo!.image,
                                                        height: 70,
                                                        width: 70,
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
                                                              orderItem.orderDetails!.restaurantInfo!.restaurantName.toString(),
                                                              style: GoogleFonts.poppins(
                                                                  fontSize: 16,
                                                                  fontWeight: FontWeight.w500,
                                                                  color: const Color(0xFF1A2E33)),
                                                            ),
                                                            const SizedBox(
                                                              height: 3,
                                                            ),
                                                            IntrinsicHeight(
                                                              child: Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                children: [
                                                                  Text(
                                                                    "${orderItem.orderDetails!.menuList!.length} Items",
                                                                    style: GoogleFonts.poppins(
                                                                        fontSize: 12,
                                                                        fontWeight: FontWeight.w300,
                                                                        color: const Color(0xFF74848C)),
                                                                  ),
                                                                  const SizedBox(
                                                                    height: 5,
                                                                  ),
                                                                  const VerticalDivider(),
                                                                  Text(
                                                                    orderItem.orderType,
                                                                    style: GoogleFonts.poppins(
                                                                        fontSize: 12,
                                                                        fontWeight: FontWeight.w300,
                                                                        color: const Color(0xFF74848C)),
                                                                  ),
                                                                  SizedBox(
                                                                    width: size.width * .06,
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              height: 5,
                                                            ),
                                                            Row(
                                                              children: [
                                                                Text(
                                                                  "\$${orderItem.total}",
                                                                  style: GoogleFonts.poppins(
                                                                      fontSize: 12,
                                                                      fontWeight: FontWeight.w300,
                                                                      color: const Color(0xFF3B5998)),
                                                                ),
                                                                const SizedBox(
                                                                  width: 10,
                                                                ),
                                                                SizedBox(
                                                                  height: 28,
                                                                  child: ElevatedButton(
                                                                    onPressed: () {},
                                                                    style: ElevatedButton.styleFrom(
                                                                        shape: RoundedRectangleBorder(
                                                                            borderRadius: BorderRadius.circular(20),
                                                                            side: const BorderSide(
                                                                              color: Colors.red,
                                                                            )),
                                                                        textStyle: const TextStyle(
                                                                            fontSize: 18, fontWeight: FontWeight.w500)),
                                                                    child: Text(
                                                                      "Cancelled",
                                                                      style: GoogleFonts.poppins(
                                                                          fontSize: 12,
                                                                          fontWeight: FontWeight.w500,
                                                                          color: Colors.red),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ]),
                                                    )
                                                  ]),
                                            ],
                                          )),
                                    );
                                  })
                              : Column(
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
                                            style: GoogleFonts.poppins(
                                                fontSize: 15, fontWeight: FontWeight.w400, color: const Color(0xff747474)),
                                          ),
                                          const SizedBox(
                                            height: 40,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ])
                : TabBarView(children: [
                    StreamBuilder<List<MyDiningOrderModel>>(
                      stream: getActiveDiningOrder(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return LoadingAnimationWidget.fourRotatingDots(
                            color: AppTheme.primaryColor,
                            size: 40,
                          );
                        }
                        if (snapshot.hasData) {
                          List<MyDiningOrderModel> myOrder = snapshot.data ?? [];
                          log(myOrder.toString()); //
                          return myOrder.isNotEmpty
                              ? ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: myOrder.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    var orderItem = myOrder[index];
                                    return GestureDetector(
                                      onTap: () {
                                        Get.to(() => OderDetailsScreen(
                                              orderType: 'Dining',
                                              orderId: orderItem.orderId,
                                              data: '',
                                            ));
                                      },
                                      child: Container(
                                          margin: const EdgeInsets.symmetric(horizontal: 13, vertical: 5),
                                          width: size.width,
                                          padding: const EdgeInsets.all(14),
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(10),
                                              boxShadow: [
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
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            children: [
                                              Container(
                                                height: 25,
                                                width: 25,
                                                margin: EdgeInsets.zero,
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
                                                    ClipRRect(
                                                      borderRadius: BorderRadius.circular(20),
                                                      child: Image.network(
                                                        orderItem.restaurantInfo!.image,
                                                        height: 70,
                                                        width: 70,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Padding(
                                                        padding: const EdgeInsets.only(left: 10),
                                                        child: Column(
                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Text(
                                                                orderItem.restaurantInfo!.restaurantName.toString(),
                                                                style: GoogleFonts.poppins(
                                                                    fontSize: 16,
                                                                    fontWeight: FontWeight.w500,
                                                                    color: const Color(0xFF1A2E33)),
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
                                                                            fontSize: 11,
                                                                            fontWeight: FontWeight.w300,
                                                                            color: const Color(0xFF74848C)),
                                                                      ),
                                                                      const SizedBox(
                                                                        height: 5,
                                                                      ),
                                                                      Text(
                                                                        DateFormat("dd-MMM-yyyy")
                                                                            .format(DateTime.parse(orderItem.date.toString())),
                                                                        style: GoogleFonts.poppins(
                                                                            fontSize: 11,
                                                                            fontWeight: FontWeight.w500,
                                                                            color: const Color(0xFF384953)),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  SizedBox(
                                                                    width: size.width * .04,
                                                                  ),
                                                                  Expanded(
                                                                    child: Column(
                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                      children: [
                                                                        Text(
                                                                          "Time",
                                                                          style: GoogleFonts.poppins(
                                                                              fontSize: 11,
                                                                              fontWeight: FontWeight.w300,
                                                                              color: const Color(0xFF74848C)),
                                                                        ),
                                                                        const SizedBox(
                                                                          height: 5,
                                                                        ),
                                                                        Text(
                                                                          orderItem.slot,
                                                                          style: GoogleFonts.poppins(
                                                                              fontSize: 11,
                                                                              fontWeight: FontWeight.w500,
                                                                              color: const Color(0xFF384953)),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    width: size.width * .02,
                                                                  ),
                                                                  Column(
                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                    children: [
                                                                      Text(
                                                                        "Guest",
                                                                        style: GoogleFonts.poppins(
                                                                            fontSize: 11,
                                                                            fontWeight: FontWeight.w300,
                                                                            color: const Color(0xFF74848C)),
                                                                      ),
                                                                      const SizedBox(
                                                                        height: 5,
                                                                      ),
                                                                      Text(
                                                                        orderItem.guest.toString(),
                                                                        style: GoogleFonts.poppins(
                                                                            fontSize: 11,
                                                                            fontWeight: FontWeight.w500,
                                                                            color: const Color(0xFF384953)),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  SizedBox(
                                                                    width: size.width * .02,
                                                                  ),
                                                                  Column(
                                                                    children: [
                                                                      Text(
                                                                        "offer",
                                                                        style: GoogleFonts.poppins(
                                                                            fontSize: 11,
                                                                            fontWeight: FontWeight.w300,
                                                                            color: const Color(0xFF74848C)),
                                                                      ),
                                                                      const SizedBox(
                                                                        height: 5,
                                                                      ),
                                                                      Text(
                                                                        orderItem.offer,
                                                                        style: GoogleFonts.poppins(
                                                                            fontSize: 11,
                                                                            fontWeight: FontWeight.w500,
                                                                            color: const Color(0xFF384953)),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                            ]),
                                                      ),
                                                    )
                                                  ]),
                                              const Divider(
                                                height: 20,
                                                color: Color(0xffE8E8E8),
                                                thickness: 1,
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  SizedBox(
                                                    height: 28,
                                                    child: ElevatedButton(
                                                      onPressed: () {},
                                                      style: ElevatedButton.styleFrom(
                                                          backgroundColor: Colors.white,
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.circular(3),
                                                              side: const BorderSide(
                                                                color: Color(0xFF3B5998),
                                                              )),
                                                          textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                                                      child: Text(
                                                        "Cancel Order",
                                                        style: GoogleFonts.poppins(
                                                            fontSize: 12,
                                                            fontWeight: FontWeight.w500,
                                                            color: AppTheme.primaryColor),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          )),
                                    );
                                  })
                              : Column(
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
                                            style: GoogleFonts.poppins(
                                                fontSize: 15, fontWeight: FontWeight.w400, color: const Color(0xff747474)),
                                          ),
                                          const SizedBox(
                                            height: 40,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                    StreamBuilder<List<MyDiningOrderModel>>(
                      stream: getCompletedDiningOrder(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return LoadingAnimationWidget.fourRotatingDots(
                            color: AppTheme.primaryColor,
                            size: 40,
                          );
                        }
                        if (snapshot.hasData) {
                          List<MyDiningOrderModel> myOrder = snapshot.data ?? [];
                          log(myOrder.toString()); //
                          return myOrder.isNotEmpty
                              ? ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: myOrder.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    var orderItem = myOrder[index];
                                    return Column(children: [
                                      Container(
                                          margin: const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
                                          width: size.width,
                                          padding: const EdgeInsets.all(14),
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(10),
                                              boxShadow: [
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
                                              Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    ClipRRect(
                                                      borderRadius: BorderRadius.circular(20),
                                                      child: Image.network(
                                                        orderItem.restaurantInfo!.image,
                                                        height: 70,
                                                        width: 70,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Padding(
                                                        padding: const EdgeInsets.only(left: 10),
                                                        child: Column(
                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Text(
                                                                orderItem.restaurantInfo!.restaurantName.toString(),
                                                                style: GoogleFonts.poppins(
                                                                    fontSize: 16,
                                                                    fontWeight: FontWeight.w500,
                                                                    color: const Color(0xFF1A2E33)),
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
                                                                            fontSize: 11,
                                                                            fontWeight: FontWeight.w300,
                                                                            color: const Color(0xFF74848C)),
                                                                      ),
                                                                      const SizedBox(
                                                                        height: 5,
                                                                      ),
                                                                      Text(
                                                                        DateFormat("dd-MMM-yyyy")
                                                                            .format(DateTime.parse(orderItem.date.toString())),
                                                                        style: GoogleFonts.poppins(
                                                                            fontSize: 11,
                                                                            fontWeight: FontWeight.w500,
                                                                            color: const Color(0xFF384953)),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  SizedBox(
                                                                    width: size.width * .04,
                                                                  ),
                                                                  Expanded(
                                                                    child: Column(
                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                      children: [
                                                                        Text(
                                                                          "Time",
                                                                          style: GoogleFonts.poppins(
                                                                              fontSize: 11,
                                                                              fontWeight: FontWeight.w300,
                                                                              color: const Color(0xFF74848C)),
                                                                        ),
                                                                        const SizedBox(
                                                                          height: 5,
                                                                        ),
                                                                        Text(
                                                                          orderItem.slot,
                                                                          style: GoogleFonts.poppins(
                                                                              fontSize: 11,
                                                                              fontWeight: FontWeight.w500,
                                                                              color: const Color(0xFF384953)),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    width: size.width * .02,
                                                                  ),
                                                                  Column(
                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                    children: [
                                                                      Text(
                                                                        "Guest",
                                                                        style: GoogleFonts.poppins(
                                                                            fontSize: 11,
                                                                            fontWeight: FontWeight.w300,
                                                                            color: const Color(0xFF74848C)),
                                                                      ),
                                                                      const SizedBox(
                                                                        height: 5,
                                                                      ),
                                                                      Text(
                                                                        orderItem.guest.toString(),
                                                                        style: GoogleFonts.poppins(
                                                                            fontSize: 11,
                                                                            fontWeight: FontWeight.w500,
                                                                            color: const Color(0xFF384953)),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  SizedBox(
                                                                    width: size.width * .02,
                                                                  ),
                                                                  Column(
                                                                    children: [
                                                                      Text(
                                                                        "offer",
                                                                        style: GoogleFonts.poppins(
                                                                            fontSize: 11,
                                                                            fontWeight: FontWeight.w300,
                                                                            color: const Color(0xFF74848C)),
                                                                      ),
                                                                      const SizedBox(
                                                                        height: 5,
                                                                      ),
                                                                      Text(
                                                                        orderItem.offer,
                                                                        style: GoogleFonts.poppins(
                                                                            fontSize: 11,
                                                                            fontWeight: FontWeight.w500,
                                                                            color: const Color(0xFF384953)),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                            ]),
                                                      ),
                                                    )
                                                  ]),
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
                                                      onPressed: () {
                                                        Get.to(() => ReviewAndRatingScreen(
                                                              orderId: orderItem.orderId,
                                                              vendorId: orderItem.vendorId,
                                                            ));
                                                      },
                                                      style: ElevatedButton.styleFrom(
                                                          backgroundColor: Colors.white,
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.circular(3),
                                                              side: const BorderSide(
                                                                color: Color(0xFF3B5998),
                                                              )),
                                                          textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                                                      child: Text(
                                                        "Leave a review",
                                                        style: GoogleFonts.poppins(
                                                            fontSize: 12,
                                                            fontWeight: FontWeight.w500,
                                                            color: AppTheme.primaryColor),
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 20,
                                                  ),
                                                  SizedBox(
                                                    // width: size.width,
                                                    height: 28,

                                                    child: ElevatedButton(
                                                      onPressed: () async {
                                                        // int gg = DateTime.now().millisecondsSinceEpoch;
                                                        // String? fcm = await FirebaseMessaging.instance.getToken();
                                                        // try {
                                                        //   await firebaseService
                                                        //       .manageOrderForDining(
                                                        //       orderId: gg.toString(),
                                                        //       menuList: myDiningOrder![index].menuList!.where((e) => e.qty > 0).map((e) => e.toJson()).toList(),
                                                        //       restaurantInfo:  myDiningOrder![index].restaurantInfo!.toJson(),
                                                        //       profileData:  myDiningOrder![index].customerData!.toJson(),
                                                        //       vendorId: myDiningOrder![index].restaurantInfo!.userID,
                                                        //       time: gg,
                                                        //       fcm: fcm,
                                                        //       slot: myDiningOrder![index].slot,
                                                        //       guest: myDiningOrder![index].guest,
                                                        //       date: myDiningOrder![index].date,
                                                        //       total: myDiningOrder![index].total,
                                                        //       lunchSelected: true)
                                                        //       .then((value) {
                                                        //     return gg;
                                                        //   });
                                                        // } catch (e) {
                                                        //   throw Exception(e);
                                                        // }
                                                      },
                                                      style: ElevatedButton.styleFrom(
                                                          backgroundColor: const Color(0xFF3B5998),
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.circular(3),
                                                              side: const BorderSide(
                                                                width: 2.0,
                                                                color: Color(0xFF3B5998),
                                                              )),
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
                                          ))
                                    ]);
                                  })
                              : Column(
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
                                            style: GoogleFonts.poppins(
                                                fontSize: 15, fontWeight: FontWeight.w400, color: const Color(0xff747474)),
                                          ),
                                          const SizedBox(
                                            height: 40,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                    StreamBuilder<List<MyDiningOrderModel>>(
                      stream: getCancelledDiningOrder(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return LoadingAnimationWidget.fourRotatingDots(
                            color: AppTheme.primaryColor,
                            size: 40,
                          );
                        }
                        if (snapshot.hasData) {
                          List<MyDiningOrderModel> myOrder = snapshot.data ?? [];
                          log(myOrder.toString()); //
                          return myOrder.isNotEmpty
                              ? ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: myOrder.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    var orderItem = myOrder[index];
                                    return GestureDetector(
                                      onTap: () {
                                        Get.to(() => OderDetailsScreen(
                                              orderType: 'Dining',
                                              orderId: orderItem.orderId,
                                              data: '',
                                            ));
                                      },
                                      child: Container(
                                          margin: const EdgeInsets.symmetric(horizontal: 13, vertical: 5),
                                          width: size.width,
                                          padding: const EdgeInsets.all(14),
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(10),
                                              boxShadow: [
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
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            children: [
                                              Container(
                                                height: 25,
                                                width: 25,
                                                margin: EdgeInsets.zero,
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
                                                    ClipRRect(
                                                      borderRadius: BorderRadius.circular(20),
                                                      child: Image.network(
                                                        orderItem.restaurantInfo!.image,
                                                        height: 70,
                                                        width: 70,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Padding(
                                                        padding: const EdgeInsets.only(left: 10),
                                                        child: Column(
                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Text(
                                                                orderItem.restaurantInfo!.restaurantName.toString(),
                                                                style: GoogleFonts.poppins(
                                                                    fontSize: 16,
                                                                    fontWeight: FontWeight.w500,
                                                                    color: const Color(0xFF1A2E33)),
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
                                                                            fontSize: 11,
                                                                            fontWeight: FontWeight.w300,
                                                                            color: const Color(0xFF74848C)),
                                                                      ),
                                                                      const SizedBox(
                                                                        height: 5,
                                                                      ),
                                                                      Text(
                                                                        DateFormat("dd-MMM-yyyy")
                                                                            .format(DateTime.parse(orderItem.date.toString())),
                                                                        style: GoogleFonts.poppins(
                                                                            fontSize: 11,
                                                                            fontWeight: FontWeight.w500,
                                                                            color: const Color(0xFF384953)),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  SizedBox(
                                                                    width: size.width * .04,
                                                                  ),
                                                                  Expanded(
                                                                    child: Column(
                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                      children: [
                                                                        Text(
                                                                          "Time",
                                                                          style: GoogleFonts.poppins(
                                                                              fontSize: 11,
                                                                              fontWeight: FontWeight.w300,
                                                                              color: const Color(0xFF74848C)),
                                                                        ),
                                                                        const SizedBox(
                                                                          height: 5,
                                                                        ),
                                                                        Text(
                                                                          orderItem.slot,
                                                                          style: GoogleFonts.poppins(
                                                                              fontSize: 11,
                                                                              fontWeight: FontWeight.w500,
                                                                              color: const Color(0xFF384953)),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    width: size.width * .02,
                                                                  ),
                                                                  Column(
                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                    children: [
                                                                      Text(
                                                                        "Guest",
                                                                        style: GoogleFonts.poppins(
                                                                            fontSize: 11,
                                                                            fontWeight: FontWeight.w300,
                                                                            color: const Color(0xFF74848C)),
                                                                      ),
                                                                      const SizedBox(
                                                                        height: 5,
                                                                      ),
                                                                      Text(
                                                                        orderItem.guest.toString(),
                                                                        style: GoogleFonts.poppins(
                                                                            fontSize: 11,
                                                                            fontWeight: FontWeight.w500,
                                                                            color: const Color(0xFF384953)),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  SizedBox(
                                                                    width: size.width * .02,
                                                                  ),
                                                                  Column(
                                                                    children: [
                                                                      Text(
                                                                        "offer",
                                                                        style: GoogleFonts.poppins(
                                                                            fontSize: 11,
                                                                            fontWeight: FontWeight.w300,
                                                                            color: const Color(0xFF74848C)),
                                                                      ),
                                                                      const SizedBox(
                                                                        height: 5,
                                                                      ),
                                                                      Text(
                                                                        orderItem.offer,
                                                                        style: GoogleFonts.poppins(
                                                                            fontSize: 11,
                                                                            fontWeight: FontWeight.w500,
                                                                            color: const Color(0xFF384953)),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                            ]),
                                                      ),
                                                    )
                                                  ]),
                                            ],
                                          )),
                                    );
                                  })
                              : Column(
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
                                            style: GoogleFonts.poppins(
                                                fontSize: 15, fontWeight: FontWeight.w400, color: const Color(0xff747474)),
                                          ),
                                          const SizedBox(
                                            height: 40,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ])));
  }
}
