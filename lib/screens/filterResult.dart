import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:get/get_core/src/get_main.dart';

import 'const.dart';
import 'filterpage.dart';


// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:get/get_navigation/src/root/get_material_app.dart';

class FilteredPage extends StatefulWidget {
  const FilteredPage({Key? key,}) : super(key: key);
// final attribute;
  @override
  State<FilteredPage> createState() => _FilteredPageState();
}

class Condition{
  static var condition;
  static  var attribute;
  static var condition1='';
  static  var attribute1='';
  static var condition2='';
  static  var attribute2='';
}
class _FilteredPageState extends State<FilteredPage> {
  final timlineRef = FirebaseFirestore.instance.collection('timeline');
  late final time1, time2, id;
  @override
  void initState() {
    super.initState();
    // getTimeline();i
  }
  //

  deleteTask(time1, time2, id) async {
    if (time1 == time2) {
      await FirebaseFirestore.instance
        ..collection(
          "${FirebaseAuth.instance.currentUser?.email}",
        ).doc(id).delete();
    }
  }

  TextEditingController searchController = new TextEditingController();
  TextEditingController searchController1 = new TextEditingController();

  getTimeDifferenceFromNow(DateTime dateTime) {
    Duration difference = DateTime.now().difference(dateTime);
    if (difference.inSeconds < 5) {
      return "Just now";
    } else if (difference.inMinutes < 1) {
      return "${difference.inSeconds}s ago";
    } else if (difference.inHours < 1) {
      return "${difference.inMinutes}m ago";
    } else if (difference.inHours < 24) {
      return "${difference.inHours}h ago";
    } else {
      return "${difference.inDays}d ago";
    }
  }

  List<String> navBarItem = [
    "category",
    "duration",
    "location",
    "date",
    "quantity",
  ];
  late String Query = '';
  late String value1 = '';
  late String updatename;

  late final Map<String, dynamic> posts;

  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          alignment: Alignment.topCenter,
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.cyanAccent,
                  Colors.white

                ],
              )),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              backgroundColor: Const.primary,
              elevation: 0,
              title: Text(
                "Filter Page",
                style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
              ),
              centerTitle: true,
            ),
            body: SingleChildScrollView(
              // keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.manual,
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("Posts")
                    .orderBy('timestamp', descending: true)
                    .snapshots(),
                builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {

                  if (snapshot.data == null) return CircularProgressIndicator();
                  try {
                    return Column(
                      children: [
                        ListView.builder(
                            padding: EdgeInsets.symmetric(vertical: 5),
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: snapshot.data.docs.length,
                            itemBuilder: (context, index) {
                              try {
                                DateTime time = snapshot
                                    .data.docs[index]['timestamp']
                                    .toDate();
                                deleteTask(
                                    time,
                                    snapshot.data.docs[index]['duration'],
                                    snapshot.data.docs[index].id);
                                DateTime dateTime=snapshot.data.docs[index]['time'].toDate();
                                Duration durations=dateTime.difference(time);
                                Duration duration=DateTime.now().difference(time);
                                if(durations>duration && snapshot.data.docs[index]['${Condition.attribute}'] ==Condition.condition
                                    // && snapshot.data.docs[index]['${Condition.attribute1}'] ==Condition.condition1
                                    // &&snapshot.data.docs[index]['${Condition.attribute2}'] ==Condition.condition2
                                    && snapshot.data.docs[index]['email']!=FirebaseAuth.instance.currentUser?.email
                                // snapshot.data.docs[index]['food name'] !=value1 && snapshot.data.docs[index]['email']!=FirebaseAuth.instance.currentUser?.email
                                // && getTimeDifferenceFromNow(time)< snapshot
                                // .data.docs[index]['duration']
                                ) {
                                  return Container(
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 15),
                                    color: Colors.white,
                                    padding: EdgeInsets.all(16),
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(children: [
                                              CircleAvatar(
                                                child: Icon(
                                                  Icons.person,
                                                  size: 30,
                                                  color: Colors.white,
                                                ),
                                                backgroundColor: Colors.grey,
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Column(
                                                 crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "${snapshot.data
                                                          .docs[index]['food name']}",
                                                      textAlign: TextAlign
                                                          .left,
                                                      style: TextStyle(
                                                        fontWeight:
                                                        FontWeight.bold,
                                                        fontSize: 20,
                                                      ),
                                                    ),
                                                    Text(
                                                      "${snapshot.data
                                                          .docs[index]['email']}",
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                  ])
                                            ]),
                                            Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.end,
                                                children: [
                                                  Icon(Icons
                                                      .watch_later_outlined,
                                                      color: Colors.black),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text(
                                                    "${snapshot.data
                                                        .docs[index]['duration']} hrs",
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 18,
                                                        fontWeight:
                                                        FontWeight.bold),
                                                  ),
                                                ])
                                          ],
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(top: 16),
                                          height: 300,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                            BorderRadius.circular(10),
                                            image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: NetworkImage(
                                                  "${snapshot.data
                                                      .docs[index]['image']}"),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(top: 16),
                                          child: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                      child: Text(
                                                          "Category: ${snapshot
                                                              .data
                                                              .docs[index]['category']}")),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  Container(
                                                    child: Text(
                                                        "Quantity: ${snapshot
                                                            .data
                                                            .docs[index]['quantity']} kgs"),
                                                  ),
                                                ],
                                              ),
                                              // SizedBox(width: 40,),
                                              InkWell(
                                                onTap: () {
                                                  // Navigator.push(
                                                  //     context,
                                                  //     MaterialPageRoute(
                                                  //         builder: (context) =>
                                                  //             new Notification()));
                                                  Map<String,
                                                      dynamic> data = {
                                                    "food name": snapshot.data
                                                        .docs[index]['food name'],
                                                    "phone number": snapshot
                                                        .data
                                                        .docs[index]['phone number'],
                                                    "date": snapshot.data
                                                        .docs[index]['date'],
                                                    "address": snapshot.data
                                                        .docs[index]['address'],
                                                    "duration": snapshot.data
                                                        .docs[index]['duration'],
                                                    "quantity": snapshot.data
                                                        .docs[index]['quantity'],
                                                    "mail": snapshot.data
                                                        .docs[index]['email'],
                                                    "category": snapshot.data
                                                        .docs[index]['category'],
                                                    "timestamp": DateTime
                                                        .now(),
                                                    "email": FirebaseAuth
                                                        .instance
                                                        .currentUser?.email
                                                        .toString()
                                                  };
                                                  FirebaseFirestore.instance
                                                      .collection(
                                                    "Notification",
                                                  )
                                                      .add(data);
                                                },
                                                child: Container(
                                                  // padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                                                  height: 40,
                                                  width: 100,
                                                  // color: Colors.white,
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                      gradient: LinearGradient(
                                                          begin:
                                                          Alignment.topLeft,
                                                          end: Alignment
                                                              .bottomRight,
                                                          colors: [
                                                            Color.fromARGB(
                                                                255,
                                                                164, 219,
                                                                255),
                                                            Color.fromARGB(
                                                                255,
                                                                54, 165, 240),
                                                          ]),
                                                      // border: Border.all(width: 2.0),
                                                      borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              50.0))),
                                                  child: Center(
                                                      child: Text(
                                                        'Request',
                                                        style: TextStyle(
                                                            fontSize: 20,
                                                            color: Colors
                                                                .white),
                                                      )),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Container(
                                          child: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                child: Text(
                                                  "Date: ${snapshot.data
                                                      .docs[index]['date']}",
                                                  // style: TextStyle(
                                                  //   color: Colors.black,
                                                  //   fontSize: 16,
                                                  // ),
                                                ),
                                              ),
                                              Container(
                                                child:
                                                // Text(
                                                Text(
                                                  "${getTimeDifferenceFromNow(
                                                      time)}",
                                                  // style: TextStyle(
                                                  //   color: Colors.black,
                                                  //   fontSize: 16,
                                                  // ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                } else {
                                  return Container();
                                }
                              } catch (e) {
                                // print(e);
                                return Container();
                              }
                            }),
                        Center(
                          child: ElevatedButton(onPressed: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => FilterPage()));
                          }, child: Text("Back"),
                            style: ElevatedButton.styleFrom(

                            ),
                          ),
                        )

                      ],
                    );


                  } catch (e) {
                    print(e);
                  }
                  return Container();
                },
              ),
            ),
          ),
        )
    );
  }
}
