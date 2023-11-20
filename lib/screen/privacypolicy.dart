import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widget/common_text_field.dart';

class PrivacyPolicy extends StatefulWidget {
  const PrivacyPolicy({super.key});

  @override
  State<PrivacyPolicy> createState() => _PrivacyPolicyState();
}

class _PrivacyPolicyState extends State<PrivacyPolicy> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: backAppBar(
          title: "Privacy Policy",
          context: context,
        ),
        body: SingleChildScrollView(
          child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              decoration: const BoxDecoration(
                color: Color(0xffFFFFFF),
              ),
              child: Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
                RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                          text:
                              "For users with a separate Doc Send or Drop Lorem  Sign account, the DocSend Terms of Service can found",
                          style: GoogleFonts.poppins(
                              height: 1.8,
                              fontSize: 14,
                              color: const Color(0xff363539).withOpacity(.5),
                              fontWeight: FontWeight.w400)),
                      TextSpan(
                          text: ' here',
                          style: GoogleFonts.poppins(
                              height: 1.8, fontSize: 14, color: const Color(0xff7968E2), fontWeight: FontWeight.w400)),
                      TextSpan(
                          text: ' and the Lorem Sign Terms of Service can found ',
                          style: GoogleFonts.poppins(
                              height: 1.8,
                              fontSize: 14,
                              color: const Color(0xff363539).withOpacity(.5),
                              fontWeight: FontWeight.w400)),
                      TextSpan(
                          text: ' here',
                          style: GoogleFonts.poppins(
                              height: 1.8, fontSize: 14, color: const Color(0xff7968E2), fontWeight: FontWeight.w400)),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                          text:
                              "For users with a separate Doc Send or Drop Lorem  Sign account, the DocSend Terms of Service can found",
                          style: GoogleFonts.poppins(
                              height: 1.8,
                              fontSize: 14,
                              color: const Color(0xff363539).withOpacity(.5),
                              fontWeight: FontWeight.w400)),
                      TextSpan(
                          text: ' here',
                          style: GoogleFonts.poppins(
                              height: 1.8, fontSize: 14, color: const Color(0xff7968E2), fontWeight: FontWeight.w400)),
                      TextSpan(
                          text: ' and the Lorem Sign Terms of Service can found ',
                          style: GoogleFonts.poppins(
                              height: 1.8,
                              fontSize: 14,
                              color: const Color(0xff363539).withOpacity(.5),
                              fontWeight: FontWeight.w400)),
                      TextSpan(
                          text: ' here',
                          style: GoogleFonts.poppins(
                              height: 1.8, fontSize: 14, color: const Color(0xff7968E2), fontWeight: FontWeight.w400)),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                          text:
                              "For users with a separate Doc Send or Drop Lorem  Sign account, the DocSend Terms of Service can found",
                          style: GoogleFonts.poppins(
                              height: 1.8,
                              fontSize: 14,
                              color: const Color(0xff363539).withOpacity(.5),
                              fontWeight: FontWeight.w400)),
                      TextSpan(
                          text: ' here',
                          style: GoogleFonts.poppins(
                              height: 1.8, fontSize: 14, color: const Color(0xff7968E2), fontWeight: FontWeight.w400)),
                      TextSpan(
                          text: ' and the Lorem Sign Terms of Service can found ',
                          style: GoogleFonts.poppins(
                              height: 1.8,
                              fontSize: 14,
                              color: const Color(0xff363539).withOpacity(.5),
                              fontWeight: FontWeight.w400)),
                      TextSpan(
                          text: ' here',
                          style: GoogleFonts.poppins(
                              height: 1.8, fontSize: 14, color: const Color(0xff7968E2), fontWeight: FontWeight.w400)),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                          text:
                              "For users with a separate Doc Send or Drop Lorem  Sign account, the DocSend Terms of Service can found",
                          style: GoogleFonts.poppins(
                              height: 1.8,
                              fontSize: 14,
                              color: const Color(0xff363539).withOpacity(.5),
                              fontWeight: FontWeight.w400)),
                      TextSpan(
                          text: ' here',
                          style: GoogleFonts.poppins(
                              height: 1.8, fontSize: 14, color: const Color(0xff7968E2), fontWeight: FontWeight.w400)),
                      TextSpan(
                          text: ' and the Lorem Sign Terms of Service can found ',
                          style: GoogleFonts.poppins(
                              height: 1.8,
                              fontSize: 14,
                              color: const Color(0xff363539).withOpacity(.5),
                              fontWeight: FontWeight.w400)),
                      TextSpan(
                          text: ' here',
                          style: GoogleFonts.poppins(
                              height: 1.8, fontSize: 14, color: const Color(0xff7968E2), fontWeight: FontWeight.w400)),
                    ],
                  ),
                )
              ])),
        ));
  }
}
