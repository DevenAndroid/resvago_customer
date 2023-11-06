import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resvago_customer/screen/search_singlerestaurant_screen.dart';

import '../widget/custom_textfield.dart';

class SerachListScreen extends StatefulWidget {
  const SerachListScreen({super.key});

  @override
  State<SerachListScreen> createState() => _SerachListScreenState();
}

class _SerachListScreenState extends State<SerachListScreen> {
  String searchKeyword = "";
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
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
                        prefix: InkWell(
                          onTap: () {},
                          child: Icon(
                            Icons.search,
                            size: 19,
                            color: const Color(0xFF000000).withOpacity(0.56),
                          ),
                        ),
                        onChanged: (val) {
                          setState(() {
                            searchKeyword = val;
                          });
                        },
                      )),
                ),
                const SizedBox(
                  width: 10,
                ),
                Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: Colors.white,
                  ),
                  child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: PopupMenuButton<int>(
                          shadowColor: Colors.white,
                          padding: EdgeInsets.zero,
                          icon: const Icon(
                            Icons.filter_list_sharp,
                            color: Colors.black,
                          ),
                          color: Colors.white,
                          surfaceTintColor: Colors.white,
                          itemBuilder: (context) {
                            return [
                              PopupMenuItem(
                                value: 1,
                                onTap: () {},
                                child: const Column(
                                  children: [Text("Near By"), Divider()],
                                ),
                              ),
                              PopupMenuItem(
                                value: 1,
                                onTap: () {},
                                child: const Column(
                                  children: [Text("Rating"), Divider()],
                                ),
                              ),
                              PopupMenuItem(
                                value: 1,
                                onTap: () {},
                                child: const Column(
                                  children: [Text("Offers"), Divider()],
                                ),
                              ),
                              PopupMenuItem(
                                value: 1,
                                onTap: () {},
                                child: const Column(
                                  children: [
                                    Text("Popular"),
                                    Divider(
                                      color: Colors.white,
                                    )
                                  ],
                                ),
                              ),
                            ];
                          })),
                ),
              ],
            ),
          ),
          bottom: const TabBar(
            dividerColor: Colors.grey,
            indicatorSize: TabBarIndicatorSize.tab,
            tabs: [
              Tab(
                child: Text("Delivery"),
              ),
              Tab(
                child: Text("Dine In"),
              ),
            ],
          ),
          // title: Text('Tabs Demo'),
        ),
        body: TabBarView(
          children: [
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('vendor_menu')
                  .where("bookingForDelivery" , isEqualTo: true)
                  .where('category',
                  isGreaterThanOrEqualTo: searchKeyword)
                  .where('category', isLessThan: '${searchKeyword}z')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {

                  var products = snapshot.data!.docs;
                  List<String> kk = products.map((e) => e.data()['category'].toString()).toList().toSet().toList();
                  List<String> image = products.map((e) => e.data()['image'].toString()).toList().toSet().toList();
                  print(products);
                  return ListView.builder(
                    itemCount: kk.length,
                    itemBuilder: (context, index) {
                      var product = kk[index];
                      return GestureDetector(
                        onTap: (){
                          Get.to(SearchRestaurantScreen(
                            category: product,

                          ));
                        },
                        child: ListTile(
                          title: Text(product),
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(image[index]),
                          ),
                        ),
                      );
                    },
                  );
                }
                return const Center(child: CircularProgressIndicator());
              },
            ),
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('vendor_menu')
                  .where("bookingForDining" , isEqualTo: true)
                  .where('category',
                  isGreaterThanOrEqualTo: searchKeyword)
                  .where('category', isLessThan: '${searchKeyword}z')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {

                  var products = snapshot.data!.docs;
                  List<String> kk = products.map((e) => e.data()['category'].toString()).toList().toSet().toList();
                  List<String> name = products.map((e) => e.data()['name'].toString()).toList().toSet().toList();
                  List<String> image = products.map((e) => e.data()['image'].toString()).toList().toSet().toList();
                  print(products);
                  return ListView.builder(
                    itemCount: kk.length,
                    itemBuilder: (context, index) {
                      var product = kk[index];
                      return GestureDetector(
                        onTap: (){
                          Get.to(SearchRestaurantScreen(
                            category: product,

                          ));
                        },
                        child: ListTile(
                          title: Text(name[index]),
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(image[index]),
                          ),
                        ),
                      );
                    },
                  );
                }
                return const Center(child: CircularProgressIndicator());
              },
            ),
          ],
        ),
      ),
    );
  }
}
