import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widget/apptheme.dart';

class ThankuScreen extends StatefulWidget {
  const ThankuScreen({super.key});

  @override
  State<ThankuScreen> createState() => _ThankuScreenState();
}

class _ThankuScreenState extends State<ThankuScreen> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Colors.white,
        bottomNavigationBar:Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Container(

       padding: const EdgeInsets.only(bottom: 20),
              child: SizedBox(
                width: size.width,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {

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
                    style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w600, color:AppTheme.primaryColor),
                  ),
                ),
              )),
        ) ,
        body: Container(
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
                  'assets/icons/thnaku.png',
                  height: 130,
                ),
                const SizedBox(height: 13,),
                Text(
                  'Thank you '.toUpperCase(),
                  style:GoogleFonts.poppins(fontSize: 40, fontWeight: FontWeight.w600, color: Colors.white),
                ),
const SizedBox(height: 5,),
                Text(
                  'your reservation is confirmed',
                  style:GoogleFonts.poppins(fontSize: 16, color: Colors.white),
                ),
                const SizedBox(
                  height: 18,
                ),
                Container(
                  width: size.width * .85,
                  height: 43,
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                      color: const Color(0xffFAAF40).withOpacity(.3),
                      border: Border.all(color: const Color(0xffFAAF40))
                      // color: Color()
                      ),
                  child: Center(
                      child: Text(
                    '6 Guest. Wed Oct 4. 2:00 PM',
                    style: GoogleFonts.poppins(color: const Color(0xffFAAF40,),fontWeight: FontWeight.w500),
                  )),
                ),
// SizedBox(height: size.height*2,),


              ],
            ),
          ),
        ));
  }
}
