import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widget/apptheme.dart';
import '../widget/common_text_field.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  NotificationScreenState createState() => NotificationScreenState();
}

class NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: backAppBar(title: "Notification".tr, context: context,
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: width * 0.02, vertical: height * .01),
            child: Column(
              children: [
                ListView.builder(
                    itemCount: 5,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.only(left: 5, right: 5),
                        child: Card(
                          elevation: 0,
                          child: Row(
                            children: [
                              SizedBox(
                                width: width * 0.02,
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: width * .005,
                                ),
                                child: Container(
                                  width: width * .010,
                                  height: height * .08,
                                  decoration: const BoxDecoration(
                                    color:Color(0xffFAAF40),
                                    borderRadius: BorderRadius.all(Radius.circular(5)),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: width * 0.03,
                              ),
                              Row(mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    decoration: const BoxDecoration(
                                      color:Color(0xffFAAF40),
                                      shape: BoxShape.circle
                                    ),
                                    height: 30,
                                    width: 30,
                                    child: Center(
                                      child: Text('B',  style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                        fontSize: 14,
                                      ),),
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                width: width * 0.03,
                              ),
                              Expanded(
                                child: Container(
                                  margin: const EdgeInsets.fromLTRB(12, 8, 8, 12),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [

                                      Text(
                                        'Date - 17-02-2022',
                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w700,
                                          color:const Color(0xffFAAF40),
                                          fontSize: 14,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 4,
                                      ),
                                      Text(
                                        'Lorem ipsum dolor sit amet',
                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w500,
                                          color: const Color(0xff2A3757),
                                          fontSize: 14,
                                        ),
                                      ),
                                      //textBold(snapshot.data!.data.notifications[index].title),
                                      const SizedBox(
                                        height: 4,
                                      ),
                                      Text(
                                      "Lorem ipsum dolor sit amet consectetur adipiscing elit, sed do eiusmod",
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w400,
                                          color: const Color(0xff797F8F),
                                          fontSize: 12,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    })
              ],
            ),
          ),
        ));
  }
}
