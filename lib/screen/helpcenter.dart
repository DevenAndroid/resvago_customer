import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widget/common_text_field.dart';


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
      appBar: backAppBar(title: "Help Center", context: context,
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
                    const SizedBox(width: 20,),
                    Text("Chat/Email", style:GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
                        fontSize: 19,
                        color: const Color(0xFF1A2E33)
                    ),),
                  ],
                ),
              ),
            ),
           const SizedBox(height: 15,),
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
                    const SizedBox(width: 20,),
                    Text("Resvago team", style:GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
                        fontSize: 19,
                        color: const Color(0xFF1A2E33)
                    ),),
                  ],
                ),
              ),
            ),
     const SizedBox(height: 15,),
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
                    const SizedBox(width: 20,),
                    Text("FAQ", style:GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
                        fontSize: 19,
                        color: const Color(0xFF1A2E33)
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