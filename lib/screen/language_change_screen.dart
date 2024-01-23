import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resvago_customer/screen/helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widget/apptheme.dart';
import '../widget/common_text_field.dart';

Locale locale = const Locale('en', 'US');

class LanguageChangeScreen extends StatefulWidget {
  const LanguageChangeScreen({super.key});
  static var languageChangeScreen = "/languageChangeScreen";

  @override
  State<LanguageChangeScreen> createState() => _LanguageChangeScreenState();
}

class _LanguageChangeScreenState extends State<LanguageChangeScreen> {
  RxString selectedLAnguage = "English".obs;

  @override
  void initState() {
    super.initState();
    checkLanguage();
  }

  updateLanguage(String gg) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString("app_language", gg);
  }

  checkLanguage() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? appLanguage = sharedPreferences.getString("app_language");
    if (appLanguage == null || appLanguage == "English") {
      Get.updateLocale(const Locale('en', 'US'));
      selectedLAnguage.value = "English";
    } else if (appLanguage == "Spanish") {
      Get.updateLocale(const Locale('es', 'ES'));
      selectedLAnguage.value = "Spanish";
    } else if (appLanguage == "French") {
      Get.updateLocale(const Locale('fr', 'FR'));
      selectedLAnguage.value = "French";
    } else if (appLanguage == "Arabic") {
      Get.updateLocale(const Locale('ar', 'AE'));
      selectedLAnguage.value = "Arabic";
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: backAppBar(title: 'Change Language'.tr, context: context),
      body: Column(children: [
        const SizedBox(
          height: 15,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 25,
              ),
              InkWell(
                onTap: () => showDialogLanguage(context),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  padding: const EdgeInsets.only(left: 12, right: 12),
                  width: size.width,
                  height: size.height * .10,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(.06),
                        spreadRadius: 2,
                        blurRadius: 15,
                        offset: const Offset(0, 1), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Language'.tr,
                        style: const TextStyle(color: AppTheme.blackcolor, fontSize: 16),
                      ),
                      const Icon(Icons.keyboard_arrow_right)
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ]).appPaddingForScreen,
    );
  }

  showDialogLanguage(context) {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  RadioListTile(
                      value: "English",
                      groupValue: selectedLAnguage.value,
                      title: const Text(
                        "English",
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xff000000)),
                      ),
                      onChanged: (value) {
                        locale = const Locale('en', 'US');
                        Get.updateLocale(locale);
                        selectedLAnguage.value = value!;
                        updateLanguage("English");
                        setState(() {});
                        print(selectedLAnguage);
                      }),
                  RadioListTile(
                      value: "Spanish",
                      groupValue: selectedLAnguage.value,
                      title: const Text(
                        "Spanish",
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xff000000)),
                      ),
                      onChanged: (value) {
                        locale = const Locale('es', 'ES');
                        Get.updateLocale(locale);
                        selectedLAnguage.value = value!;
                        updateLanguage("Spanish");
                        setState(() {});
                        print(selectedLAnguage);
                      }),
                  RadioListTile(
                      value: "French",
                      groupValue: selectedLAnguage.value,
                      title: const Text(
                        "French",
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xff000000)),
                      ),
                      onChanged: (value) {
                        locale = const Locale('fr', 'FR');
                        Get.updateLocale(locale);
                        selectedLAnguage.value = value!;
                        updateLanguage("French");
                        setState(() {});
                        print(selectedLAnguage);
                      }),
                  RadioListTile(
                      value: "Arabic",
                      groupValue: selectedLAnguage.value,
                      title: const Text(
                        "Arabic",
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xff000000)),
                      ),
                      onChanged: (value) {
                        locale = const Locale('ar', 'AE');
                        Get.updateLocale(locale);
                        selectedLAnguage.value = value!;
                        updateLanguage("Arabic");
                        setState(() {});
                        print(selectedLAnguage);
                      }),
                  Align(
                    alignment: Alignment.center,
                    child: GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: Container(
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: AppTheme.primaryColor),
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              "Update".tr,
                              style: TextStyle(color: Colors.white),
                            ),
                          )),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }
}
