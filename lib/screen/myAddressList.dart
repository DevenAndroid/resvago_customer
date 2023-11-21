import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resvago_customer/screen/addAddress.dart';
import 'package:resvago_customer/screen/helper.dart';
import '../controller/profile_controller.dart';
import '../model/add_address_modal.dart';
import '../widget/common_text_field.dart';

class MyAddressList extends StatefulWidget {
  const MyAddressList({super.key, this.addressChanged});
  final Function(AddressModel address)? addressChanged;

  @override
  State<MyAddressList> createState() => _MyAddressListState();
}

class _MyAddressListState extends State<MyAddressList> {
  bool userDeactivate = false;
  String searchQuery = '';
  bool isTextFieldVisible = false;
  bool isDescendingOrder = true;
  void toggleTextFieldVisibility() {
    setState(() {
      isTextFieldVisible = !isTextFieldVisible;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: backAppBar(
        title: "My Address",
        context: context,
        icon2: GestureDetector(
          onTap: () {
            Get.to(ChooseAddress(
              isEditMode: false,
            ));
          },
          child: const Padding(
            padding: EdgeInsets.only(right: 10),
            child: Icon(
              Icons.add_circle_outline,
              color: Colors.black,
              size: 30,
            ),
          ),
        ),
      ),
      body: SizedBox(
        width:  Get.width,
        child: StreamBuilder<List<AddressModel>>(
          stream: getPagesStream(),
          builder: (BuildContext context, AsyncSnapshot<List<AddressModel>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text("No Address Found"));
            } else {
              List<AddressModel>? pages = snapshot.data;
              final filteredPages = filterUsers(pages!, searchQuery);

              return filteredPages.isNotEmpty
                  ? ListView.builder(
                      itemCount: filteredPages.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        final item = filteredPages[index];
                        return InkWell(
                          onTap: () {
                            if (widget.addressChanged != null) {
                              widget.addressChanged!(item);
                              final profileController = Get.put(ProfileController());
                              profileController.updateAddress(item.docid.toString()).then((value) {
                                showToast("Address Updated");
                                Get.back();
                              });
                              // widget.addressChanged!(item);
                            }
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(11),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.2),
                                  spreadRadius: 5,
                                  blurRadius: 7,
                                  // offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Center(
                                child: ListTile(
                                    contentPadding: const EdgeInsets.only(left: 15, right: 5),
                                    title: Text(
                                      item.AddressType.toString(),
                                      style: const TextStyle(color: Color(0xff384953), fontWeight: FontWeight.bold),
                                    ),
                                    leading: const CircleAvatar(
                                      maxRadius: 40,
                                      minRadius: 40,
                                      backgroundColor: Color(0x1a3b5998),
                                      child: CircleAvatar(
                                        minRadius: 20,
                                        maxRadius: 20,
                                        backgroundColor: Color(0xff3B5998),
                                        child: Icon(
                                          Icons.location_on,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    subtitle: Text(
                                      "${item.flatAddress}, ${item.streetAddress}",
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        PopupMenuButton<int>(
                                          surfaceTintColor: Colors.white,
                                            icon: const Icon(
                                              Icons.more_vert,
                                              color: Colors.black,
                                            ),
                                            color: Colors.white,
                                            itemBuilder: (context) {
                                              return [
                                                PopupMenuItem(
                                                  value: 1,
                                                  onTap: () {
                                                    Get.to(ChooseAddress(
                                                      isEditMode: true,
                                                      streetAddress: item.streetAddress,
                                                      selectedChip: item.AddressType,
                                                      name: item.name,
                                                      flatAddress: item.flatAddress,
                                                      docID: item.docid,
                                                    ));
                                                  },
                                                  child: const Text("Edit"),
                                                ),
                                                PopupMenuItem(
                                                  value: 1,
                                                  onTap: () {
                                                    showDialog(
                                                      context: context,
                                                      builder: (ctx) => AlertDialog(
                                                        title: const Text("Delete Address"),
                                                        content: const Text("Are you sure you want to delete this Address"),
                                                        actions: <Widget>[
                                                          TextButton(
                                                            onPressed: () {
                                                              Navigator.of(ctx).pop();
                                                            },
                                                            child: Container(
                                                              decoration: BoxDecoration(
                                                                  color: Colors.red, borderRadius: BorderRadius.circular(11)),
                                                              width: 100,
                                                              padding: const EdgeInsets.all(14),
                                                              child: const Center(
                                                                  child: Text(
                                                                "Cancel",
                                                                style: TextStyle(color: Colors.white),
                                                              )),
                                                            ),
                                                          ),
                                                          TextButton(
                                                            onPressed: () {
                                                              FirebaseFirestore.instance
                                                                  .collection('Address')
                                                                  .doc(FirebaseAuth.instance.currentUser!.uid)
                                                                  .collection('TotalAddress')
                                                                  .doc(item.docid)
                                                                  .delete()
                                                                  .then((value) {
                                                                setState(() {});
                                                              });
                                                              Navigator.of(ctx).pop();
                                                            },
                                                            child: Container(
                                                              decoration: BoxDecoration(
                                                                  color: Colors.green,
                                                                  borderRadius: BorderRadius.circular(11)),
                                                              width: 100,
                                                              padding: const EdgeInsets.all(14),
                                                              child: const Center(
                                                                  child: Text(
                                                                "okay",
                                                                style: TextStyle(color: Colors.white),
                                                              )),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  },
                                                  child: const Text("Delete"),
                                                ),
                                              ];
                                            }),
                                      ],
                                    ))),
                          ).appPaddingForScreen,
                        );
                      })
                  : const Center(
                      child: Text("No Address Found"),
                    );
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }

  List<AddressModel> filterUsers(List<AddressModel> users, String query) {
    if (query.isEmpty) {
      return users; // Return all users if the search query is empty
    } else {
      // Filter the users based on the search query
      return users.where((user) {
        if (user.name is String) {
          return user.name.toLowerCase().contains(query.toLowerCase());
        }
        return false;
      }).toList();
    }
  }

  Stream<List<AddressModel>> getPagesStream() {
    return FirebaseFirestore.instance
        .collection('Address')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('TotalAddress')
        .orderBy('time', descending: isDescendingOrder)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => AddressModel(
                AddressType: doc.data()['AddressType'],
                streetAddress: doc.data()['streetAddress'],
                name: doc.data()['name'],
                flatAddress: doc.data()['flatAddress'],
                docid: doc.id))
            .toList());
  }
}
