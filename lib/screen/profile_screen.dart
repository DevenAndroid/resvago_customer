import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../model/profile_model.dart';
import '../widget/addsize.dart';
import '../widget/apptheme.dart';
import '../widget/common_text_field.dart';
import 'helper.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController mobileController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  ProfileData profileData = ProfileData();
  String code = "+91";
  File categoryFile = File("");
  Uint8List? pickedFile;
  String fileUrl = "";
  void fetchdata() {
    FirebaseFirestore.instance.collection("customer_users").doc(FirebaseAuth.instance.currentUser!.uid).get().then((value) {
      if (value.exists) {
        if (value.data() == null) return;
        profileData = ProfileData.fromJson(value.data()!);
        log("profile data" + profileData.mobileNumber.toString());
        categoryFile = File(profileData.profile_image.toString());
        mobileController.text = (profileData.mobileNumber ?? "").toString();
        firstNameController.text = (profileData.userName ?? "").toString();
        lastNameController.text = (profileData.userName ?? "").toString();
        emailController.text = (profileData.email ?? "").toString();
        if (!kIsWeb) {
          categoryFile = File(profileData.profile_image ?? "");
        } else {
          fileUrl = profileData.profile_image ?? "";
        }
        apiLoaded = true;
        setState(() {});
      }
    });
  }

  Future<void> updateProfileToFirestore() async {
    OverlayEntry loader = Helper.overlayLoader(context);
    Overlay.of(context).insert(loader);
    String? imageUrl = kIsWeb ? null : categoryFile.path;;
    if (kIsWeb) {
      if (pickedFile != null) {
        UploadTask uploadTask = FirebaseStorage.instance.ref("profile_image}").child("image").putData(pickedFile!);
        TaskSnapshot snapshot = await uploadTask;
        imageUrl = await snapshot.ref.getDownloadURL();
      } else {
        imageUrl = fileUrl;
      }
    } else {
      if (!categoryFile.path.contains("https")) {
        if (profileData.profile_image.toString().isNotEmpty) {
          Reference gg = FirebaseStorage.instance.refFromURL(profileData.profile_image.toString());
          await gg.delete();
        }
        UploadTask uploadTask = FirebaseStorage.instance
            .ref("profile_image")
            .child(DateTime.now().millisecondsSinceEpoch.toString())
            .putFile(categoryFile);
        TaskSnapshot snapshot = await uploadTask;
        imageUrl = await snapshot.ref.getDownloadURL();
      }
    }
    try {
      await FirebaseFirestore.instance.collection("customer_users").doc(FirebaseAuth.instance.currentUser!.uid).update({
        "userName": firstNameController.text.trim(),
        "email": emailController.text.trim(),
        "mobileNumber": mobileController.text.trim(),
        "profile_image": imageUrl,
        "deactivate": false,
      }).then((value) => Fluttertoast.showToast(msg: "Profile Updated"));
      log("profile data" + profileData.mobileNumber.toString());
      Helper.hideLoader(loader);
      fetchdata();
    } catch (e) {
      Helper.hideLoader(loader);
      throw Exception(e);
    } finally {
      Helper.hideLoader(loader);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchdata();
  }

  bool apiLoaded = false;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      body: apiLoaded
          ? SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    Container(
                      width: size.width,
                      height: size.height,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Stack(
                            children: [
                              Container(
                                  width: kIsWeb ? 500 : size.width,
                                  padding: const EdgeInsets.only(bottom: 30),
                                  clipBehavior: Clip.antiAlias,
                                  decoration: BoxDecoration(border: Border.all(color: Colors.white)),
                                  child: Image.asset('assets/images/profilebg.png')),
                              Positioned(
                                top: 90,
                                left: 0,
                                right: 0,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      height: 100,
                                      width: 100,
                                      child: kIsWeb
                                          ? Stack(
                                              children: [
                                                ClipRRect(
                                                  borderRadius: BorderRadius.circular(10000),
                                                  child: Container(
                                                      height: 100,
                                                      width: 100,
                                                      clipBehavior: Clip.antiAlias,
                                                      decoration: BoxDecoration(
                                                        color: const Color(0xffFAAF40),
                                                        border: Border.all(color: const Color(0xff3B5998), width: 6),
                                                        borderRadius: BorderRadius.circular(5000),
                                                        // color: Colors.brown
                                                      ),
                                                      child: pickedFile != null
                                                          ? Image.memory(
                                                              pickedFile!,
                                                              fit: BoxFit.cover,
                                                              errorBuilder: (_, __, ___) => CachedNetworkImage(
                                                                fit: BoxFit.cover,
                                                                imageUrl: categoryFile.path,
                                                                height: AddSize.size30,
                                                                width: AddSize.size30,
                                                                errorWidget: (_, __, ___) => const Icon(
                                                                  Icons.person,
                                                                  size: 60,
                                                                ),
                                                                placeholder: (_, __) => const SizedBox(),
                                                              ),
                                                            )
                                                          : Image.network(
                                                              fileUrl,
                                                              fit: BoxFit.cover,
                                                              errorBuilder: (_, __, ___) => CachedNetworkImage(
                                                                fit: BoxFit.cover,
                                                                imageUrl: categoryFile.path,
                                                                height: AddSize.size30,
                                                                width: AddSize.size30,
                                                                errorWidget: (_, __, ___) => const Icon(
                                                                  Icons.person,
                                                                  size: 60,
                                                                ),
                                                                placeholder: (_, __) => const SizedBox(),
                                                              ),
                                                            )),
                                                ),
                                                Positioned(
                                                  bottom: 0,
                                                  right: 0,
                                                  child: GestureDetector(
                                                    behavior: HitTestBehavior.translucent,
                                                    onTap: () {
                                                      Helper.addFilePicker().then((value) {
                                                        pickedFile = value;
                                                        print(pickedFile);
                                                        setState(() {});
                                                      });
                                                    },
                                                    child: Container(
                                                      height: 30,
                                                      width: 30,
                                                      clipBehavior: Clip.antiAlias,
                                                      decoration: BoxDecoration(
                                                        color: const Color(0xff04666E),
                                                        borderRadius: BorderRadius.circular(50),
                                                      ),
                                                      child: const Icon(
                                                        Icons.camera_alt,
                                                        color: Colors.white,
                                                        size: 15,
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            )
                                          : Stack(
                                              children: [
                                                ClipRRect(
                                                  borderRadius: BorderRadius.circular(10000),
                                                  child: Container(
                                                      height: 100,
                                                      width: 100,
                                                      clipBehavior: Clip.antiAlias,
                                                      decoration: BoxDecoration(
                                                        color: const Color(0xffFAAF40),
                                                        border: Border.all(color: const Color(0xff3B5998), width: 6),
                                                        borderRadius: BorderRadius.circular(5000),
                                                        // color: Colors.brown
                                                      ),
                                                      child: categoryFile.path.contains("http") || categoryFile.path.isEmpty
                                                          ? Image.network(
                                                              categoryFile.path,
                                                              fit: BoxFit.cover,
                                                              errorBuilder: (_, __, ___) => CachedNetworkImage(
                                                                fit: BoxFit.cover,
                                                                imageUrl: categoryFile.path,
                                                                height: AddSize.size30,
                                                                width: AddSize.size30,
                                                                errorWidget: (_, __, ___) => const Icon(
                                                                  Icons.person,
                                                                  size: 60,
                                                                ),
                                                                placeholder: (_, __) => const SizedBox(),
                                                              ),
                                                            )
                                                          : Image.memory(
                                                              categoryFile.readAsBytesSync(),
                                                              fit: BoxFit.cover,
                                                              errorBuilder: (_, __, ___) => CachedNetworkImage(
                                                                fit: BoxFit.cover,
                                                                imageUrl: categoryFile.path,
                                                                height: AddSize.size30,
                                                                width: AddSize.size30,
                                                                errorWidget: (_, __, ___) => const Icon(
                                                                  Icons.person,
                                                                  size: 60,
                                                                ),
                                                                placeholder: (_, __) => const SizedBox(),
                                                              ),
                                                            )),
                                                ),
                                                Positioned(
                                                  bottom: 0,
                                                  right: 0,
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      showActionSheet(context);
                                                    },
                                                    child: Container(
                                                      height: 30,
                                                      width: 30,
                                                      clipBehavior: Clip.antiAlias,
                                                      decoration: BoxDecoration(
                                                        color: const Color(0xff04666E),
                                                        borderRadius: BorderRadius.circular(50),
                                                      ),
                                                      child: const Icon(
                                                        Icons.camera_alt,
                                                        color: Colors.white,
                                                        size: 15,
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Align(
                            alignment: Alignment.topCenter,
                            child: Text(
                              profileData.userName.toString(),
                              style: GoogleFonts.poppins(color: AppTheme.registortext, fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              profileData.email.toString(),
                              style: GoogleFonts.poppins(color: Colors.grey, fontWeight: FontWeight.normal, fontSize: 12),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Name'.tr,
                                  style: GoogleFonts.poppins(
                                      color: AppTheme.registortext, fontWeight: FontWeight.w500, fontSize: 15),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                RegisterTextFieldWidget(
                                    controller: firstNameController,
                                    validator: RequiredValidator(errorText: 'Please enter your name'.tr).call,
                                    hint: "Name".tr),
                                // const SizedBox(
                                //   height: 20,
                                // ),
                                // Text(
                                //   "Last name",
                                //   style: GoogleFonts.poppins(color: AppTheme.registortext, fontWeight: FontWeight.w500, fontSize: 15),
                                // ),
                                // const SizedBox(
                                //   height: 10,
                                // ),
                                // RegisterTextFieldWidget(
                                //     controller: lastNameController,
                                //     validator: RequiredValidator(errorText: 'Please enter your Last name ').call,
                                //     // keyboardType: TextInputType.number,
                                //     // textInputAction: TextInputAction.next,
                                //     hint: "Last name"),
                                const SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  "Email".tr,
                                  style: GoogleFonts.poppins(
                                      color: AppTheme.registortext, fontWeight: FontWeight.w500, fontSize: 15),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                RegisterTextFieldWidget(
                                  readOnly: true,
                                  controller: emailController,
                                  validator: MultiValidator([
                                    RequiredValidator(errorText: 'Please enter your email'.tr),
                                    EmailValidator(errorText: 'Enter a valid email address'.tr),
                                  ]).call,
                                  keyboardType: TextInputType.emailAddress,
                                  // textInputAction: TextInputAction.next,
                                  hint: "abc@gmail.com",
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  "Mobile Number".tr,
                                  style: GoogleFonts.poppins(
                                      color: AppTheme.registortext, fontWeight: FontWeight.w500, fontSize: 15),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                RegisterTextFieldWidget(
                                    readOnly: true,
                                    controller: mobileController,
                                    validator: RequiredValidator(errorText: 'Please enter your mobile number ').call,
                                    keyboardType: TextInputType.number,
                                    // textInputAction: TextInputAction.next,
                                    hint: "Mobile number".tr),
                                const SizedBox(
                                  height: 20,
                                ),
                                CommonButtonBlue(
                                  onPressed: () {
                                    if (formKey.currentState!.validate()) {
                                      updateProfileToFirestore();
                                    }
                                  },
                                  title: 'Save'.tr,
                                ),
                              ],
                            ).appPaddingForScreen,
                          ),
                          const SizedBox(
                            height: 80,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  void showActionSheet(BuildContext context) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title:  Text(
          'Select Picture from'.tr,
          style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w600),
        ),
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            onPressed: () {
              Helper.addImagePicker(imageSource: ImageSource.camera, imageQuality: 50).then((value) async {
                // CroppedFile? croppedFile = await ImageCropper().cropImage(
                //   sourcePath: value.path,
                //   aspectRatioPresets: [
                //     CropAspectRatioPreset.square,
                //     CropAspectRatioPreset.ratio3x2,
                //     CropAspectRatioPreset.original,
                //     CropAspectRatioPreset.ratio4x3,
                //     CropAspectRatioPreset.ratio16x9
                //   ],
                //   uiSettings: [
                //     AndroidUiSettings(
                //         toolbarTitle: 'Cropper',
                //         toolbarColor: Colors.deepOrange,
                //         toolbarWidgetColor: Colors.white,
                //         initAspectRatio: CropAspectRatioPreset.ratio4x3,
                //         lockAspectRatio: false),
                //     IOSUiSettings(
                //       title: 'Cropper',
                //     ),
                //     WebUiSettings(
                //       context: context,
                //     ),
                //   ],
                // );
                if (value != null) {
                  categoryFile = File(value.path);
                  setState(() {});
                }
                Get.back();
              });
            },
            child:  Text("Camera".tr),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              Helper.addImagePicker(imageSource: ImageSource.gallery, imageQuality: 50).then((value) async {
                // CroppedFile? croppedFile = await ImageCropper().cropImage(
                //   sourcePath: value.path,
                //   aspectRatioPresets: [
                //     CropAspectRatioPreset.square,
                //     CropAspectRatioPreset.ratio3x2,
                //     CropAspectRatioPreset.original,
                //     CropAspectRatioPreset.ratio4x3,
                //     CropAspectRatioPreset.ratio16x9
                //   ],
                //   uiSettings: [
                //     AndroidUiSettings(
                //         toolbarTitle: 'Cropper',
                //         toolbarColor: Colors.deepOrange,
                //         toolbarWidgetColor: Colors.white,
                //         initAspectRatio: CropAspectRatioPreset.ratio4x3,
                //         lockAspectRatio: false),
                //     IOSUiSettings(
                //       title: 'Cropper',
                //     ),
                //     WebUiSettings(
                //       context: context,
                //     ),
                //   ],
                // );
                if (value != null) {
                  categoryFile = File(value.path);
                  setState(() {});
                }

                Get.back();
              });
            },
            child:  Text('Gallery'.tr),
          ),
          CupertinoActionSheetAction(
            isDestructiveAction: true,
            onPressed: () {
              Get.back();
            },
            child:  Text('Cancel'.tr),
          ),
        ],
      ),
    );
  }
}
