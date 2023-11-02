import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';


class HelpCenterScreen extends StatefulWidget {
  const HelpCenterScreen({Key? key}) : super(key: key);
  static var helpCenterScreen="/helpCenterScreen";
  @override
  State<HelpCenterScreen> createState() => _HelpCenterScreenState();
}

class _HelpCenterScreenState extends State<HelpCenterScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        shadowColor: Color(0xff363539).withOpacity(.1),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        leading: InkWell(
          onTap: () {
            Get.back();
          },
          child: Padding(
            padding: const EdgeInsets.all(13.0),
            child: SvgPicture.asset("assets/images/back.svg"),
          ),
        ),
        elevation: 1.5,
        title: Text(
          "Help Center",
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xff423E5E),
          ),
        ),
      ),
      body:  Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 20),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),

              ),
              padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 15),
              child: InkWell(
                onTap: (){
                  // Get.toNamed(ChatScreen.chatScreen);
                },
                child: Row(
                  children: [
                    Image.asset(
                      'assets/images/chat.png',
                      width: 52,
                      height:40,
                    ),
                    SizedBox(width: 20,),
                    Text("Chat/Email", style:GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
                        fontSize: 19,
                        color: Color(0xFF1A2E33)
                    ),),
                  ],
                ),
              ),
            ),
           SizedBox(height: 15,),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),

              ),
              padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 15),
              child: InkWell(
                onTap: (){

                },
                child: Row(
                  children: [
                    Image.asset(
                      'assets/images/resvagoteam.png',
                      width: 52,
                      height:40,
                    ),
                    SizedBox(width: 20,),
                    Text("HomeMady team", style:GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
                        fontSize: 19,
                        color: Color(0xFF1A2E33)
                    ),),
                  ],
                ),
              ),
            ),
     SizedBox(height: 15,),
            GestureDetector(
              onTap: (){

              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),

                ),
                padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 15),
                child: Row(
                  children: [
                    Image.asset(
                      'assets/images/faq.png',
                      width: 52,
                      height:40,
                    ),
                    SizedBox(width: 20,),
                    Text("FAQ", style:GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
                        fontSize: 19,
                        color: Color(0xFF1A2E33)
                    ),),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}