import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widget/custom_textfield.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  static var homePageScreen = "/homePageScreen";

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color(0xffF6F6F6),
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                // profileController.scaffoldKey.currentState!.openDrawer();
              },
              child: Image.asset(
                'assets/images/customerprofile.png',
                height: 40,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {},
                    child: Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Image.asset(
                          'assets/icons/location.png',
                          height: 15,
                        ),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            'Home',
                            style: GoogleFonts.poppins(fontWeight: FontWeight.w500, fontSize: 15),
                          ),
                        ),
                        const SizedBox(width: 5),
                        Image.asset(
                          'assets/icons/dropdown.png',
                          height: 8,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  Text(
                    '184 Main Collins Street....',
                    style: GoogleFonts.poppins(
                      color: const Color(0xFF1E2538),
                      fontSize: 12,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {},
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  'assets/images/shoppinbag.png',
                  height: 30,
                ),
              ),
            ),
          ],
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        //toolbarHeight: 70,
        //toolbarHeight: 70,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 18, right: 18),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                      height: 42,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF37C666).withOpacity(0.10),
                              offset: const Offset(
                                .1,
                                .1,
                              ),
                              blurRadius: 20.0,
                              spreadRadius: 1.0,
                            ),
                          ],
                          color: Colors.white),
                      child: CommonTextFieldWidget1(
                        hint: 'Find for food or restaurant...',
                        // controller: filterDataController.storeSearchController,
                        prefix: InkWell(
                          onTap: () {},
                          child: Icon(
                            Icons.search,
                            size: 19,
                            color: const Color(0xFF000000).withOpacity(0.56),
                          ),
                        ),
                        onChanged: (val) {},
                      )),
                ),
                SizedBox(
                  width: 10,
                ),
                Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: Colors.white,
                    // boxShadow: [
                    //   BoxShadow(
                    //     color: const Color(0xFF37C666).withOpacity(0.30),
                    //     offset: const Offset(
                    //       .1,
                    //       .1,
                    //     ),
                    //     blurRadius: 20.0,
                    //     spreadRadius: 1.0,
                    //   ),
                    // ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(
                      'assets/icons/filter.png',
                      height: 18,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: size.height * 0.27,
            // width: size.width,
            child: Swiper(
              itemBuilder: (context, index) {
                return Image.asset(
                  'assets/images/sliderImages.png',
                  fit: BoxFit.fill,
                );
              },
              autoplay: false,
              outer: false,
              itemCount: 3,
              autoplayDelay: 1,
              autoplayDisableOnInteraction: true,
              scrollDirection: Axis.horizontal,
              // pagination: const SwiperPagination(),
              control: const SwiperControl(size: 5),
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            itemCount: 7,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  Image.asset(
                    'assets/images/tyoesmenu.png',
                    fit: BoxFit.fill,height: 10,
                  ),
                  Text(
                    'Indian',
                    style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w300,color: Color(0xff384953)),
                  )
                ],
              );
            },
          )
        ],
      ),
    );
  }
}
