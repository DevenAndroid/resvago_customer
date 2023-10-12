import 'package:flutter/material.dart';

import '../widget/custom_textfield.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  // final GoogleSignIn _googleSignIn = GoogleSignIn();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  var obscureText1 = true;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      // body: SingleChildScrollView(
      //   physics: const BouncingScrollPhysics(),
      //   child: SafeArea(
      //     child: Form(
      //       key: _formKey,
      //       child: Column(children: [
      //         Stack(
      //           children: [
      //             SizedBox(
      //                 height: screenHeight * .35,
      //                 width: double.maxFinite,
      //                 child: Image.asset(
      //                   'assets/images/LoginBackground.png',
      //                   fit: BoxFit.cover,
      //                 )),
      //             SizedBox(
      //               width: screenWidth,
      //               child: Column(
      //                 children: [
      //                   SizedBox(
      //                     height: screenHeight * .02,
      //                   ),
      //                   Image.asset(
      //                     'assets/images/AppLogo.png',
      //                     width: 203,
      //                   ),
      //                   SizedBox(
      //                     height: screenHeight * .05,
      //                   ),
      //                   const Center(
      //                     child: Text(
      //                       'Login To Your Account',
      //                       style: TextStyle(
      //                         fontSize: 18,
      //                         fontFamily: 'poppinsSans',
      //                         fontWeight: FontWeight.w600,
      //                         color: Color(0xFF66656B),
      //                       ),
      //                     ),
      //                   ),
      //                   SizedBox(
      //                     height: screenHeight * .03,
      //                   ),
      //                   Padding(
      //                     padding: const EdgeInsets.symmetric(horizontal: 16),
      //                     child: Container(
      //                       width: screenWidth,
      //                       decoration: BoxDecoration(
      //                         borderRadius: BorderRadius.circular(10),
      //                         boxShadow: [
      //                           BoxShadow(
      //                             color:
      //                                 const Color(0xFF37C666).withOpacity(0.10),
      //                             offset: const Offset(
      //                               .1,
      //                               .1,
      //                             ),
      //                             blurRadius: 20.0,
      //                             spreadRadius: 1.0,
      //                           ),
      //                         ],
      //                       ),
      //                       child: CommonTextFieldWidget(
      //                         textInputAction: TextInputAction.next,
      //                         hint: 'Enter your email or phone number',
      //                         controller: emailController,
      //                         validator: (value) {
      //                           if (value!.isEmpty) {
      //                             return "Email or Phone is required";
      //                           } else {
      //                             return null;
      //                           }
      //                         },
      //                       ),
      //                     ),
      //                   ),
      //                   SizedBox(
      //                     height: screenHeight * .02,
      //                   ),
      //                 ],
      //               ),
      //             ),
      //           ],
      //         ),
      //         Padding(
      //           padding: const EdgeInsets.symmetric(horizontal: 16),
      //           child: Column(
      //             children: [
      //               Container(
      //                 width: screenWidth,
      //                 decoration: BoxDecoration(
      //                   borderRadius: BorderRadius.circular(10),
      //                   boxShadow: [
      //                     BoxShadow(
      //                       color: const Color(0xFF37C666).withOpacity(0.10),
      //                       offset: const Offset(
      //                         .1,
      //                         .1,
      //                       ),
      //                       blurRadius: 20.0,
      //                       spreadRadius: 1.0,
      //                     ),
      //                   ],
      //                 ),
      //                 child: CommonTextFieldWidget(
      //                   hint: 'Password',
      //                   controller: passwordController,
      //                   obscureText: obscureText1,
      //                   suffix: GestureDetector(
      //                       onTap: () {
      //                         setState(() {
      //                           obscureText1 = !obscureText1;
      //                         });
      //                       },
      //                       child: obscureText1
      //                           ? const Icon(
      //                               Icons.visibility_off,
      //                               color: Colors.grey,
      //                             )
      //                           : const Icon(
      //                               Icons.visibility,
      //                               color: Color(0xFF53B176),
      //                             )),
      //                   validator: (value) {
      //                     if (value!.isEmpty) {
      //                       return "Password is required";
      //                     } else {
      //                       return null;
      //                     }
      //                   },
      //                 ),
      //               ),
      //               SizedBox(
      //                 height: screenHeight * .03,
      //               ),
      //               const Center(
      //                 child: Text(
      //                   'Or Continue With',
      //                   style: TextStyle(
      //                     fontWeight: FontWeight.w600,
      //                     fontSize: 14,
      //                     fontFamily: 'poppinsSans',
      //                     color: Color(0xFF333848),
      //                   ),
      //                 ),
      //               ),
      //               SizedBox(
      //                 height: screenHeight * .03,
      //               ),
      //               Row(
      //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //                 children: [
      //                   Container(
      //                     width: 152,
      //                     height: 50,
      //                     decoration: BoxDecoration(
      //                       color: Colors.white,
      //                       borderRadius: BorderRadius.circular(10),
      //                       boxShadow: [
      //                         BoxShadow(
      //                           color:
      //                               const Color(0xFF37C666).withOpacity(0.10),
      //                           offset: const Offset(
      //                             .1,
      //                             .1,
      //                           ),
      //                           blurRadius: 20.0,
      //                           spreadRadius: 1.0,
      //                         ),
      //                       ],
      //                     ),
      //                     child: Row(
      //                       mainAxisAlignment: MainAxisAlignment.center,
      //                       children: [
      //                         const Icon(
      //                           Icons.facebook,
      //                           color: Colors.blue,
      //                           size: 30,
      //                         ),
      //                         const Text(
      //                           'Facebook',
      //                           style: TextStyle(
      //                               fontSize: 15,
      //                               fontWeight: FontWeight.w600,
      //                               color: Color(0xFF4C5369)),
      //                         )
      //                       ],
      //                     ),
      //                   ),
      //                   GestureDetector(
      //                     onTap: () {
      //                       // signInWithGoogle();
      //                     },
      //                     child: Container(
      //                       width: 152,
      //                       height: 50,
      //                       decoration: BoxDecoration(
      //                         color: Colors.white,
      //                         borderRadius: BorderRadius.circular(10),
      //                         boxShadow: [
      //                           BoxShadow(
      //                             color:
      //                                 const Color(0xFF37C666).withOpacity(0.10),
      //                             offset: const Offset(
      //                               .1,
      //                               .1,
      //                             ),
      //                             blurRadius: 20.0,
      //                             spreadRadius: 1.0,
      //                           ),
      //                         ],
      //                       ),
      //                       child: Row(
      //                         mainAxisAlignment: MainAxisAlignment.center,
      //                         children: [
      //                           Image.asset(
      //                             'assets/images/google.png',
      //                             height: 25,
      //                           ),
      //                           const Text(
      //                             'Google',
      //                             style: TextStyle(
      //                                 fontSize: 15,
      //                                 fontWeight: FontWeight.w600,
      //                                 color: Color(0xFF4C5369)),
      //                           )
      //                         ],
      //                       ),
      //                     ),
      //                   ),
      //                 ],
      //               ),
      //               SizedBox(
      //                 height: screenHeight * .03,
      //               ),
      //               InkWell(
      //                 onTap: () {
      //                   // Get.toNamed(MyRouters.emailVerificationScreen2);
      //                 },
      //                 child: const Center(
      //                   child: Text(
      //                     'Forget your Password?',
      //                     style: TextStyle(
      //                         fontWeight: FontWeight.w600,
      //                         fontSize: 16,
      //                         letterSpacing: 0.5,
      //                         color: Color(0xFF7ED957)),
      //                   ),
      //                 ),
      //               ),
      //               SizedBox(
      //                 height: screenHeight * .03,
      //               ),
      //               CommonButton(title: 'Login', onPressed: () {}),
      //               SizedBox(
      //                 height: screenHeight * .03,
      //               ),
      //               Row(
      //                 mainAxisAlignment: MainAxisAlignment.center,
      //                 children: [
      //                   const Text(
      //                     'Don\'t have an account?',
      //                     style: TextStyle(
      //                         color: Color(0xFF3A3737),
      //                         fontWeight: FontWeight.w300,
      //                         fontSize: 14),
      //                   ),
      //                   InkWell(
      //                     onTap: () {
      //                       // Get.toNamed(MyRouters.signupScreen);
      //                     },
      //                     child: const Text(
      //                       '  Signup',
      //                       style: TextStyle(
      //                           color: Color(0xFF69C541),
      //                           fontWeight: FontWeight.w600,
      //                           fontSize: 14),
      //                     ),
      //                   )
      //                 ],
      //               )
      //             ],
      //           ),
      //         ),
      //       ]),
      //     ),
      //   ),
      // ),
    );
  }
// signInWithGoogle() async {
//   await GoogleSignIn().signOut();
//   final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
//   final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;
//   final credential = GoogleAuthProvider.credential(
//     idToken: googleAuth.idToken,
//     accessToken: googleAuth.accessToken,
//   );
//   print("Token---------${googleAuth.accessToken}");
//   final value = await FirebaseAuth.instance.signInWithCredential(credential);
//   log(value.credential!.accessToken!);
//   //log(value.additionalUserInfo.a);
//   var fromToken = await FirebaseMessaging.instance.getToken();
//
//   socialLogin(provider: "google", token: value.credential!.accessToken!, context: context).then((value) async {
//     if (value.status == true) {
//       SharedPreferences pref = await SharedPreferences.getInstance();
//       pref.setString('user_info', jsonEncode(value));
//       showToast(value.message);
//       Get.offAllNamed(MyRouters.bottomNavbar);
//     } else {
//       showToast(value.message);
//     }
//   });
// }
}
