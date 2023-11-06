import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:resvago_customer/widget/addsize.dart';
import 'package:resvago_customer/widget/appassets.dart';
import 'package:resvago_customer/widget/apptheme.dart';

class RestaurantsStepperScreen extends StatefulWidget {
  const RestaurantsStepperScreen({super.key});

  @override
  State<RestaurantsStepperScreen> createState() => _RestaurantsStepperScreenState();
}

class _RestaurantsStepperScreenState extends State<RestaurantsStepperScreen> {
  int currentStep = 0;
  bool value = false;
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'ras',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Theme(
        data: Theme.of(context).copyWith(colorScheme: const ColorScheme.light(primary: Color(0xFF3B5998))),
        child: Stepper(
          type: StepperType.horizontal,
          steps: getSteps(),
          currentStep: currentStep,
          onStepContinue: () {
            final isLastStep = currentStep == getSteps().length - 1;
            if (isLastStep) {
              if (kDebugMode) {
                print('Complete');
              }
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
                child: (currentStep != 3 && currentStep != 0)
                    ? SizedBox(
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
                            style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white),
                          ),
                        ),
                      )
                    : (currentStep == 3)
                        ? SizedBox(
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
                                style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white),
                              ),
                            ),
                          )
                        : const SizedBox());
          },
        ),
      ),
    );
  }

  List<Step> getSteps() => [
        Step(
            title: const Text(''),
            state: currentStep > 0 ? StepState.complete : StepState.indexed,
            isActive: currentStep >= 0,
            label: currentStep > 0
                ? const Text(
                    'Date',
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.w300, fontSize: 12),
                  )
                : const Text(
                    'Date',
                    style: TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.w500, fontSize: 12),
                  ),
            content: const Column(
              children: [],
            )),
        Step(
            isActive: currentStep >= 1,
            state: currentStep > 1 ? StepState.complete : StepState.indexed,
            label: const Text(
              'Time',
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.w300, fontSize: 12),
            ),
            title: const Text(''),
            content: Column(
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
                  child: Text(
                    'Lunch',
                    style: GoogleFonts.poppins(color: const Color(0xFF545B61), fontWeight: FontWeight.w500, fontSize: 16),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                GridView.builder(
                  itemCount: 6,
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4, crossAxisSpacing: 10, mainAxisSpacing: 0, mainAxisExtent: AddSize.screenHeight * .080),
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
                              borderRadius: BorderRadius.circular(4)),
                          child: Center(
                            child: Text(
                              '11:33',
                              style: GoogleFonts.poppins(color: AppTheme.primaryColor),
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
                  child: Text(
                    'Dinner',
                    style: GoogleFonts.poppins(color: const Color(0xFF545B61), fontWeight: FontWeight.w500, fontSize: 16),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                GridView.builder(
                  itemCount: 7,
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4, crossAxisSpacing: 10, mainAxisSpacing: 0, mainAxisExtent: AddSize.screenHeight * .080),
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
                              borderRadius: BorderRadius.circular(4)),
                          child: Center(
                            child: Text(
                              '19:30',
                              style: GoogleFonts.poppins(color: AppTheme.primaryColor),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            )),
        Step(
            state: currentStep > 2 ? StepState.complete : StepState.indexed,
            isActive: currentStep >= 2,
            label: const Text(
              'Guest',
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.w300, fontSize: 12),
            ),
            title: const Text(''),
            content: Column(
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
                  child: Text(
                    'Number Of Guests',
                    style: GoogleFonts.poppins(color: const Color(0xFF545B61), fontWeight: FontWeight.w500, fontSize: 16),
                  ),
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
                  child: Text(
                    'We have max 100 sitting capacity'.toUpperCase(),
                    style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600, color: const Color(0xFFFF2D2D)),
                  ),
                )
              ],
            )),
        Step(
            state: currentStep > 3 ? StepState.complete : StepState.indexed,
            isActive: currentStep >= 3,
            label: const Text(
              'Offer',
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.w300, fontSize: 12),
            ),
            title: const Text(''),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4), border: Border.all(color: const Color(0xFFC7C7C7), width: 1.0)),
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
                            style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w600, color: const Color(0xFF3B5998)),
                          ),
                        ],
                      ),
                    )),
                const SizedBox(
                  height: 13,
                ),
                Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4), border: Border.all(color: const Color(0xFFC7C7C7), width: 1.0)),
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
                                '20% Off On “A La Carte” Menu',
                                style: GoogleFonts.poppins(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 16),
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
                                decoration: BoxDecoration(color: AppTheme.primaryColor, borderRadius: BorderRadius.circular(5)),
                                child: Center(
                                  child: Text(
                                    '20% off',
                                    style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 14),
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
                    )),
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
                                      log(value.toString());
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
                                        fontSize: 15, fontWeight: FontWeight.w500, color: const Color(0xFF1E2538)),
                                  ),
                                  const SizedBox(
                                    height: 3,
                                  ),
                                  Text(
                                    "\$10.00",
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
                        const DottedLine(
                          dashColor: Color(0xffBCBCBC),
                        ),
                        const SizedBox(
                          height: 18,
                        ),
                      ]);
                    }),
              ],
            )),
      ];
}
