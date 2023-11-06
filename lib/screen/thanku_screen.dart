import 'package:flutter/material.dart';

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
        backgroundColor: Colors.transparent,
        body: Container(
          width: size.width,
          decoration: const BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage(
                "assets/images/Thank you.png",
              ))),
          child: Column(crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
            Text('Thank you '.toUpperCase(),style: TextStyle(fontSize: 40,fontWeight: FontWeight.w600,color: Colors.white),),


Text('Your Order is confirmed',style: TextStyle(fontSize: 16),),
              Container(
                decoration: BoxDecoration(
                  // color: Color()
                ),
              )
          ],),
        ));
  }
}
