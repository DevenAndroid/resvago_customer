import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:resvago_customer/screen/helper.dart';
import 'package:url_launcher/url_launcher.dart';

import '../widget/common_text_field.dart';
import 'faq_screen.dart';

class HelpCenterScreen extends StatefulWidget {
  const HelpCenterScreen({Key? key}) : super(key: key);
  static var helpCenterScreen = "/helpCenterScreen";
  @override
  State<HelpCenterScreen> createState() => _HelpCenterScreenState();
}

class _HelpCenterScreenState extends State<HelpCenterScreen> {
  _sendingMails() async {
    const emailAddress = 'anjalikumari5845@gmail.com';
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: emailAddress,
    );
    try {
      if (await canLaunchUrl(Uri.parse(emailLaunchUri.toString()))) {
        await launchUrl(Uri.parse(emailLaunchUri.toString()));
      } else {
        print('Could not launch $emailAddress');
      }
    } catch (e) {
      print('Error launching email: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: backAppBar(
        title: "Help Center".tr,
        context: context,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20),
        child: Column(
          children: [
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () async {
                final url = Uri.parse('mailto:example@developerxon.com?subject=Test&body=Test email');
                if (await canLaunchUrl(url)) {
                  await launchUrl(url);
                } else {
                  throw 'Could not launch $url';
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                child: Row(
                  children: [
                    Image.asset(
                      'assets/images/chat.png',
                      width: 52,
                      height: 40,
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Text(
                      "Chat/Email".tr,
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w500, fontSize: 19, color: const Color(0xFF1A2E33)),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              child: InkWell(
                onTap: () {},
                child: Row(
                  children: [
                    Image.asset(
                      'assets/images/resvagoteam.png',
                      width: 52,
                      height: 40,
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Text(
                      "Resvago team".tr,
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w500, fontSize: 19, color: const Color(0xFF1A2E33)),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                Get.to(() => FaqScreen());
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                child: Row(
                  children: [
                    Image.asset(
                      'assets/images/faq.png',
                      width: 52,
                      height: 40,
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Text(
                      "FAQ".tr,
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w500, fontSize: 19, color: const Color(0xFF1A2E33)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ).appPaddingForScreen,
      ),
    );
  }
}
