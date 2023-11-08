import 'dart:convert';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:resvago_customer/model/coupon_modal.dart';
import 'package:resvago_customer/screen/coupon_list_screen.dart';
import 'package:resvago_customer/screen/helper.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../model/menu_model.dart';
import '../../model/model_store_slots.dart';
import '../../model/resturant_model.dart';
import '../../widget/addsize.dart';
import '../../widget/appassets.dart';
import '../../widget/apptheme.dart';
import '../checkout_for_dining/oder_screen.dart';

extension ChangeToDate on String {
  DateTime get formatDate {
    var kk = DateFormat("dd-MMM-yyyy");
    return kk.parse(this);
  }
}

List<CreateSlotData> slotDataList = [];

class SelectDateFlowScreen extends StatefulWidget {
  const SelectDateFlowScreen({super.key, required this.userId, this.restaurantItem});
  final String userId;
  final RestaurantModel? restaurantItem;
  @override
  State<SelectDateFlowScreen> createState() => _SelectDateFlowScreenState();
}

class _SelectDateFlowScreenState extends State<SelectDateFlowScreen> {
  RestaurantModel? get restaurantData => widget.restaurantItem;
  double kk = 0.0;
  List<String> fields = [
    "Date",
    "Time",
    "Guest",
    "Offer",
  ];

  void _onDaySelected(DateTime day, DateTime focusedDay) {
    setState(() {
      today = DateTime(day.year, day.month, day.day);
    });
  }

  DateTime today = DateTime.now();
  List<MenuData>? menuList;
  getMenuList() {
    FirebaseFirestore.instance
        .collection("vendor_menu")
        .where("vendorId", isEqualTo: widget.userId)
        .where("bookingForDining", isEqualTo: true)
        .get()
        .then((value) {
      for (var element in value.docs) {
        var gg = element.data();
        menuList ??= [];
        menuList!.add(MenuData.fromMap(gg, element.id));
      }
      setState(() {});
    });
  }

  CreateSlotData? slotData;
  Future getSlotData() async {
    log(today.toString());
    slotData = null;
    await FirebaseFirestore.instance
        .collection("vendor_slot")
        .doc(widget.userId)
        .collection("slot")
        .doc(today.toString())
        .get()
        .then((value) {
      log(value.data().toString());
      if (value.exists == false) return;
      slotData = CreateSlotData.fromMap(value.data()!);
      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();
    getMenuList();
  }

  CouponData? couponData;

  @override
  Widget build(BuildContext context) {
    log(widget.userId.toString());
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: Column(
          children: [
            SizedBox(
              height: 40,
              width: double.maxFinite,
              child: Stack(
                children: [
                  Positioned.fill(
                      child: Center(
                          child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: TweenAnimationBuilder(
                                tween: Tween<double>(begin: 0, end: kk),
                                duration: const Duration(milliseconds: 600),
                                builder: (BuildContext context, double value, Widget? child) {
                                  return LinearProgressIndicator(
                                    color: AppTheme.primaryColor,
                                    value: value,
                                    minHeight: 2,
                                  );
                                },
                              )))),
                  Positioned.fill(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(
                      4,
                      (index) => IconButton(
                        visualDensity: const VisualDensity(horizontal: -4),
                        onPressed: () async {
                          if (index == 0) {
                            kk = 0;
                          }
                          if (index == 1) {
                            await getSlotData();
                            if (slotData != null) {
                              kk = .3333333;
                              setState(() {});
                            } else {
                              showToast("Slots not available");
                            }
                          }
                          if (index == 2) {
                            if (slot != null) {
                              kk = .66666666;
                              setState(() {});
                            } else {
                              showToast("Please select slot number");
                            }
                            setState(() {});
                          }
                          if (index == 3) {
                            if (guest != null) {
                              kk = 1;
                            } else {
                              showToast("Please select guest number");
                            }
                          }
                          setState(() {});
                        },
                        icon: Container(
                          height: 20,
                          width: 20,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: Colors.white,
                              border: Border.all(color: AppTheme.primaryColor, width: 2)),
                          child: Center(
                            child: Container(
                              height: 8,
                              width: 8,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: AppTheme.primaryColor,
                                  border: Border.all(color: AppTheme.primaryColor, width: 2)),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(
                  fields.length,
                  (index) => Text(fields[index]),
                ),
              ),
            ),
            const Divider(
              color: Colors.grey,
              thickness: 0.5,
            ),
            if (kk == 0) tableCalenderWidget(),
            if (kk == .3333333) slotsWidget(),
            if (kk == .66666666) guestCountWidget(),
            if (kk == 1)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                        Get.to(() => PromoCodeList(
                              id: widget.restaurantItem!.docid,
                              couponData: (CouponData coupon) {
                                couponData = coupon;
                                setState(() {});
                              },
                            ));
                      },
                      child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: const Color(0xFFC7C7C7), width: 1.0)),
                          width: AddSize.screenWidth,
                          height: 50,
                          child: GestureDetector(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(AppAssets.vector, height: 20),
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
                          )),
                    ),
                    const SizedBox(
                      height: 13,
                    ),
                    couponData != null
                        ? Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(color: const Color(0xFFC7C7C7), width: 1.0)),
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 15),
                            width: AddSize.screenWidth,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${couponData!.discount}% Off On “A La Carte” Menu',
                                        style:
                                            GoogleFonts.poppins(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 16),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        'Discount available for the booked timeslot preset menus and drinks not inclused',
                                        style: GoogleFonts.poppins(
                                            color: const Color(0xFF384953), fontWeight: FontWeight.w300, fontSize: 13),
                                        maxLines: 5,
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      Container(
                                        width: 90,
                                        padding: const EdgeInsets.symmetric(vertical: 6),
                                        decoration:
                                            BoxDecoration(color: AppTheme.primaryColor, borderRadius: BorderRadius.circular(5)),
                                        child: Center(
                                          child: Text(
                                            '${couponData!.discount}% off',
                                            style: GoogleFonts.poppins(
                                                color: Colors.white, fontWeight: FontWeight.w500, fontSize: 14),
                                          ),
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
                            ))
                        : const Center(
                            child: Text("No Offer Selected"),
                          ),
                    const SizedBox(
                      height: 13,
                    ),
                    Text(
                      'Restaurants Menu Chosen For You',
                      style: GoogleFonts.poppins(color: const Color(0xFF1E2538), fontWeight: FontWeight.w500, fontSize: 17),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    if (menuList != null)
                      ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: menuList!.length,
                          itemBuilder: (context, index) {
                            var menuListData = menuList![index];
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
                                        value: menuListData.isCheck,
                                        activeColor: AppTheme.primaryColor,
                                        visualDensity: const VisualDensity(vertical: 0, horizontal: 0),
                                        onChanged: (newValue) {
                                          setState(() {
                                            menuListData.isCheck = newValue!;
                                            if (menuListData.isCheck == true) {
                                              menuListData.qty++;
                                              log(menuListData.qty.toString());
                                            } else {
                                              menuListData.qty = 0;
                                              log(menuListData.qty.toString());
                                            }
                                            setState(() {});
                                          });
                                        }),
                                  ),
                                  const SizedBox(
                                    width: 7,
                                  ),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.network(
                                      menuListData.image ?? "",
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
                                          (menuListData.dishName ?? "").toString(),
                                          style: GoogleFonts.poppins(
                                              fontSize: 15, fontWeight: FontWeight.w500, color: const Color(0xFF1E2538)),
                                        ),
                                        const SizedBox(
                                          height: 3,
                                        ),
                                        Text(
                                          "\$${menuListData.price ?? "0"}",
                                          style: GoogleFonts.poppins(
                                              fontSize: 14, fontWeight: FontWeight.w300, color: const Color(0xFF74848C)),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 7,
                              ),
                              const DottedLine(
                                dashColor: Color(0xffBCBCBC),
                                dashGapLength: 2,
                              ),
                              const SizedBox(
                                height: 7,
                              ),
                            ]);
                          }),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              if (menuList!.where((e) => e.isCheck == true).toList().isNotEmpty) {
                                log("aaaaaaa-----${jsonEncode(menuList!.where((e) => e.isCheck == true).map((e) => e.toMap()).toList())}");
                                dynamic discountValue = 0;
                                if (couponData != null) {
                                  discountValue = couponData!.discount;
                                }
                                Get.to(() => OderScreen(
                                    discountValue: discountValue,
                                    lunchSelected: lunchSelected,
                                    slot: slot,
                                    guest: guest,
                                    date: today,
                                    restaurantItem: widget.restaurantItem,
                                    menuList: menuList!.where((e) => e.isCheck == true).toList()));
                              } else {
                                showToast("Please select menu");
                              }
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.primaryColor,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    side: const BorderSide(
                                      width: 2.0,
                                      color: AppTheme.primaryColor,
                                    )),
                                textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                            child: Text(
                              "Checkout".toUpperCase(),
                              style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }

  guestCountWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(
            'Number Of Guests',
            style: GoogleFonts.poppins(color: const Color(0xFF545B61), fontWeight: FontWeight.w500, fontSize: 16),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          itemCount: guestNo,
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 10,
            mainAxisSpacing: 0,
            mainAxisExtent: AddSize.screenHeight * 0.080,
          ),
          itemBuilder: (BuildContext context, int index) {
            return Column(
              children: [
                InkWell(
                  onTap: () {
                    selectGuestNo = index;
                    guest = index + 1;
                    log(guest.toString());
                    setState(() {});
                  },
                  child: Container(
                    height: 48,
                    width: 66,
                    decoration: BoxDecoration(
                      color: selectGuestNo == index ? AppTheme.primaryColor : Colors.white,
                      border: Border.all(
                        color: Colors.grey,
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Center(
                      child: Text(
                        "${index + 1}".toString(), // Display the number
                        style: GoogleFonts.poppins(color: selectGuestNo == index ? Colors.white : AppTheme.primaryColor),
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
          child: Text(
            'We have max $guestNo sitting capacity'.toUpperCase(),
            style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600, color: const Color(0xFFFF2D2D)),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    kk = 1;
                    setState(() {});
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: const BorderSide(
                            width: 2.0,
                            color: AppTheme.primaryColor,
                          )),
                      textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                  child: Text(
                    "Next".toUpperCase(),
                    style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  int selectSlot = -1;
  int selectSlotDinner = -1;
  int selectGuestNo = -1;
  int guestNo = 0;
  String? slot;
  int? guest;

  bool lunchSelected = false;

  slotsWidget() {
    final DateFormat timeFormat = DateFormat("hh:mm a");
    List<String> morningSlots = slotData!.morningSlots!.entries.map((e) => e.key).toList();
    List<String> eveningSlots = slotData!.eveningSlots!.entries.map((e) => e.key).toList();
    morningSlots.sort((a, b) {
      final timeA = TimeOfDay.fromDateTime(timeFormat.parse(a.split(",").last));
      final timeB = TimeOfDay.fromDateTime(timeFormat.parse(b.split(",").last));
      return timeA.hour * 60 + timeA.minute - (timeB.hour * 60 + timeB.minute);
    });
    eveningSlots.sort((a, b) {
      final timeA = TimeOfDay.fromDateTime(timeFormat.parse(a.split(",").last));
      final timeB = TimeOfDay.fromDateTime(timeFormat.parse(b.split(",").last));
      return timeA.hour * 60 + timeA.minute - (timeB.hour * 60 + timeB.minute);
    });
    print(eveningSlots);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(
            'Lunch',
            style: GoogleFonts.poppins(color: const Color(0xFF545B61), fontWeight: FontWeight.w500, fontSize: 16),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: GridView.builder(
            itemCount: morningSlots.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4, crossAxisSpacing: 10, mainAxisSpacing: 0, mainAxisExtent: AddSize.screenHeight * .080),
            itemBuilder: (BuildContext context, int index) {
              return Column(
                children: [
                  slotData!.morningSlots![morningSlots[index]] != 0
                      ? InkWell(
                          onTap: () {
                            lunchSelected = true;
                            selectSlot = index;
                            selectSlotDinner = -1;
                            guestNo = slotData!.morningSlots![morningSlots[index]]!;
                            slot = morningSlots[index];
                            print(slot);
                            log(guestNo.toString());
                            setState(() {});
                          },
                          child: FittedBox(
                            child: Container(
                              height: 48,
                              // width: 70,
                              decoration: BoxDecoration(
                                  color: selectSlot == index ? AppTheme.primaryColor : Colors.white,
                                  border: Border.all(
                                    color: Colors.grey,
                                  ),
                                  borderRadius: BorderRadius.circular(4)),
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    morningSlots[index].split(",").first,
                                    style: GoogleFonts.poppins(color: selectSlot == index ? Colors.white : AppTheme.primaryColor),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      : FittedBox(
                          child: Container(
                            height: 48,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                  color: Colors.grey,
                                ),
                                borderRadius: BorderRadius.circular(4)),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: Text(
                                  morningSlots[index].split(",").first,
                                  style: GoogleFonts.poppins(color: Colors.grey),
                                ),
                              ),
                            ),
                          ),
                        ),
                ],
              );
            },
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(
            'Dinner',
            style: GoogleFonts.poppins(color: const Color(0xFF545B61), fontWeight: FontWeight.w500, fontSize: 16),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: GridView.builder(
            itemCount: eveningSlots.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4, crossAxisSpacing: 10, mainAxisSpacing: 0, mainAxisExtent: AddSize.screenHeight * .080),
            itemBuilder: (BuildContext context, int index) {
              return Column(
                children: [
                  slotData!.eveningSlots![eveningSlots[index]] != 0
                      ? InkWell(
                          onTap: () {
                            lunchSelected = false;
                            selectSlotDinner = index;
                            selectSlot = -1;
                            guestNo = slotData!.eveningSlots![eveningSlots[index]]!;
                            slot = slotData!.eveningSlots!.entries.toList()[index].key;
                            log(guestNo.toString());
                            log(slot.toString());
                            setState(() {});
                          },
                          child: FittedBox(
                            child: Container(
                              height: 48,
                              decoration: BoxDecoration(
                                  color: selectSlotDinner == index ? AppTheme.primaryColor : Colors.white,
                                  border: Border.all(
                                    color: Colors.grey,
                                  ),
                                  borderRadius: BorderRadius.circular(4)),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(
                                  child: Text(
                                    eveningSlots[index].split(",").first,
                                    style: GoogleFonts.poppins(
                                        color: selectSlotDinner == index ? Colors.white : AppTheme.primaryColor),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      : FittedBox(
                          child: Container(
                            height: 48,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                  color: Colors.grey,
                                ),
                                borderRadius: BorderRadius.circular(4)),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: Text(
                                  eveningSlots[index].split(",").first,
                                  style: GoogleFonts.poppins(color: Colors.grey),
                                ),
                              ),
                            ),
                          ),
                        ),
                ],
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    if (guestNo != 0) {
                      kk = .66666666;
                      setState(() {});
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: const BorderSide(
                            width: 2.0,
                            color: AppTheme.primaryColor,
                          )),
                      textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                  child: Text(
                    "Next".toUpperCase(),
                    style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  tableCalenderWidget() {
    log("Today   ${today.millisecondsSinceEpoch}");
    // log("availableDates   $availableDates");
    return Column(
      children: [
        TableCalendar(
          rowHeight: 43,
          headerStyle: const HeaderStyle(formatButtonVisible: false, titleCentered: true),
          locale: "en_US",
          availableGestures: AvailableGestures.all,
          focusedDay: today,
          firstDay: DateTime.now(),
          lastDay: DateTime.utc(2030, 3, 14),
          onDaySelected: _onDaySelected,
          selectedDayPredicate: (day) => isSameDay(day, today),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              "Cancel",
              style: GoogleFonts.poppins(color: AppTheme.primaryColor, fontWeight: FontWeight.w500, fontSize: 16),
            ),
            const SizedBox(
              width: 20,
            ),
            InkWell(
              onTap: () async {
                await getSlotData();
                if (slotData != null) {
                  kk = .3333333;
                } else {
                  showToast("Slots not available");
                }
                setState(() {});
              },
              child: Text(
                "Ok",
                style: GoogleFonts.poppins(color: AppTheme.primaryColor, fontWeight: FontWeight.w500, fontSize: 16),
              ),
            ),
            const SizedBox(
              width: 20,
            ),
          ],
        )
      ],
    );
  }
}
