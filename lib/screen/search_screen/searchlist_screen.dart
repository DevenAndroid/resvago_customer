import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resvago_customer/routers/routers.dart';

import '../../widget/custom_textfield.dart';

class SerachListScreen extends StatefulWidget {
  const SerachListScreen({super.key});

  @override
  State<SerachListScreen> createState() => _SerachListScreenState();
}

class _SerachListScreenState extends State<SerachListScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
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
                                onTap: () {
                                  Get.toNamed(MyRouters.searchRestaurantScreen);
                                },
                                child: const Column(
                                  children: [Text("Near Bys"), Divider()],
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
          bottom: TabBar(
            tabs: [
              Tab(
                child: Text("Delivery"),
              ),
              Tab(
                child: Text("Delivery"),
              ),
            ],
          ),
          // title: Text('Tabs Demo'),
        ),
        body: TabBarView(
          children: [
            Icon(Icons.flight, size: 350),
            Icon(Icons.directions_transit, size: 350),
            Icon(Icons.directions_car, size: 350),
          ],
        ),
      ),
    );
  }
}
