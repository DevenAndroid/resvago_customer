import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:resvago_customer/screen/helper.dart';
import '../model/notification_model.dart';
import '../widget/common_text_field.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  NotificationScreenState createState() => NotificationScreenState();
}

String formatDate(DateTime date) {
  return DateFormat.yMMMd().format(date);
}

class NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: backAppBar(
          title: "Notification".tr,
          context: context,
        ),
        body: StreamBuilder<List<NotificationData>>(
          stream: getPagesStream(),
          builder: (BuildContext context,
              AsyncSnapshot<List<NotificationData>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text("No Pages Found"));
            } else {
              List<NotificationData>? notification = snapshot.data;

              return notification!.isNotEmpty
                  ? ListView.builder(
                      itemCount: notification.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        final item = notification[index];

                        // if (item.deactivate) {
                        //   return SizedBox.shrink();
                        // }
                        return Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          margin: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          width: Get.width,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(11),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                spreadRadius: 1,
                                blurRadius: 2,
                                offset: Offset(0, 1),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 5,
                                height: 70,
                                color: Color(0xffFAAF40),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              CircleAvatar(
                                maxRadius: 25,
                                minRadius: 25,
                                backgroundColor: Color(0xffFAAF40),
                                child: Text('B'),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Date: ${formatDate(item.date.toDate())}",
                                      style: const TextStyle(
                                          color: Color(0xffFAAF40),
                                          fontSize: 12,
                                          fontWeight: FontWeight.normal),
                                    ),
                                    Text(
                                      item.body.toString(),
                                      style: const TextStyle(
                                          color: Color(0xff384953),
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      item.title.toString(),
                                      style: const TextStyle(
                                          color: Color(0xff384953),
                                          fontSize: 12,
                                          fontWeight: FontWeight.normal),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ).appPaddingForScreen;
                      })
                  : const Center(
                      child: Text("No Pages Found"),
                    );
            }
            return const Center(child: CircularProgressIndicator());
          },
        ));
  }

  Stream<List<NotificationData>> getPagesStream() {
    return FirebaseFirestore.instance
        .collection('notification')
        .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => NotificationData(
                  title: doc.data()['title'],
                  docid: doc.id,
                  userId: doc.data()['userId'],
                  date: doc.data()['date'],
                  body: doc.data()['body'],
                ))
            .toList());
  }
}
