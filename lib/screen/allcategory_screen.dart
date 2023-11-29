import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:resvago_customer/widget/common_text_field.dart';

import '../model/category_model.dart';
import '../widget/addsize.dart';
import 'category/resturant_by_category.dart';

class AllCategoryScreen extends StatefulWidget {
  const AllCategoryScreen({super.key});

  @override
  State<AllCategoryScreen> createState() => _AllCategoryScreenState();
}

class _AllCategoryScreenState extends State<AllCategoryScreen> {
  List<CategoryData>? categoryList;

  getVendorCategories() {
    FirebaseFirestore.instance.collection("resturent").where("deactivate", isEqualTo: false).get().then((value) {
      for (var element in value.docs) {
        var gg = element.data();
        categoryList ??= [];
        categoryList!.add(CategoryData.fromMap(gg));
      }
      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();
    getVendorCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: backAppBar(title: "Category", context: context),
      body: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: categoryList != null
            ? GridView.builder(
                itemCount: categoryList!.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: kIsWeb
                    ? SliverGridDelegateWithMaxCrossAxisExtent(
                        mainAxisExtent: AddSize.screenHeight * .080,
                        maxCrossAxisExtent: 250,
                        crossAxisSpacing: 2,
                        mainAxisSpacing: 0,
                      )
                    : SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3, crossAxisSpacing: 10, mainAxisSpacing: 0, mainAxisExtent: AddSize.screenHeight * .14),
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    onTap: () {
                      Get.to(() => RestaurantByCategory(categoryName: categoryList![index].name.toString()));
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 60,
                            width: 60,
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: CachedNetworkImage(
                                  imageUrl: categoryList![index].image,
                                  fit: BoxFit.cover,
                                  errorWidget: (_, __, ___) => Icon(
                                    Icons.error,
                                    color: Colors.red,
                                  ),
                                )),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            categoryList![index].name ?? "",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w300, color: const Color(0xff384953)),
                          )
                        ],
                      ),
                    ),
                  );
                },
              )
            : Center(
                child: Text("Category not available"),
              ),
      ),
    );
  }
}
