import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:readmore/readmore.dart';

import 'const.dart';

class Notifications extends StatelessWidget {
  // final String title;
  // final String subtitle;
  // final String message;

  // Notification({
  //   required this.title,
  //   required this.subtitle,
  //   required this.message,
  // });

  String getTimeDifferenceFromNow(DateTime dateTime) {
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

  void showAlert(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          // actions: <Widget>[
          //   FlatButton(
          //     child: Text('OK'),
          //     onPressed: () {
          //       Navigator.of(context).pop();
          //     },
          //   ),
          // ],
        );
      },
    );
  }

  int generateOtp() {
    var random = Random();
    var randomNumber = random.nextInt(900000) +
        100000; // generates a random number between 100000 and 999999
    return randomNumber;
  }

  declineFeature(id) async {
    await FirebaseFirestore.instance
        .collection(
          "Notification",
        )
        .doc(id)
        .delete();
  }

  late String value1 = '';
  bool isAccepted = true;

  @override
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
              elevation: 0,
              title: Text(
                "Notifications",
                style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
              ),
              centerTitle: true,
            ),
            body: SingleChildScrollView(
              // keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.manual,
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("Notification")
                    .orderBy('timestamp', descending: true)
                    .snapshots(),
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  if (snapshot.data == null) return CircularProgressIndicator();
                  try {
                    if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                      return Column(
                        children: [
                          // SizedBox(
                          //   height: 80,
                          // ),
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
                                  if (snapshot.data.docs[index]['mail'] ==
                                      FirebaseAuth
                                          .instance.currentUser?.email&&snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                                    return Container(
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5),
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
                                                        "${snapshot.data.docs[index]['food name']}",
                                                        textAlign:
                                                            TextAlign.start,
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 18,
                                                        ),
                                                      ),
                                                      Text(
                                                        "${snapshot.data.docs[index]['email']}",
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                        ),
                                                      ),
                                                    ])
                                              ]),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(5.0),
                                                child: ReadMoreText(
                                                  'A request has been recieved for ${snapshot.data.docs[index]['food name']}:\n'
                                                  'Phone no. - ${snapshot.data.docs[index]['phone number']}\n'
                                                  'Date - ${snapshot.data.docs[index]['date']}\n'
                                                  'Address - ${snapshot.data.docs[index]['address']}\n'
                                                  'Duration - ${snapshot.data.docs[index]['duration']} hrs \n'
                                                  'Quantity - ${snapshot.data.docs[index]['quantity']} kgs\n'
                                                  'Caategory - ${snapshot.data.docs[index]['category']}',
                                                  trimLength: 31,
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.black),
                                                  colorClickableText:
                                                      Colors.pink,
                                                  trimMode: TrimMode.Length,
                                                  trimCollapsedText:
                                                      '...Read more',
                                                  trimExpandedText: ' Less',
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 13,
                                          ),
                                          Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    Map<String, dynamic> data =
                                                        {
                                                      "food name": snapshot
                                                              .data.docs[index]
                                                          ['food name'],
                                                      "timestamp":
                                                          DateTime.now(),
                                                      "date": snapshot.data
                                                          .docs[index]['date'],
                                                      "mail": snapshot.data
                                                          .docs[index]['mail'],
                                                      "email": snapshot.data
                                                          .docs[index]['email'],
                                                      "otp": generateOtp()
                                                    };
                                                    FirebaseFirestore.instance
                                                        .collection(
                                                          "Inbox",
                                                        )
                                                        .add(data);
                                                    showAlert(
                                                        context,
                                                        "Food Request",
                                                        "Request has been successfully accepted.");
                                                    declineFeature(snapshot
                                                        .data.docs[index].id);
                                                  },
                                                  child: Container(
                                                    // padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                                                    height: 50,
                                                    width: 120,
                                                    // color: Colors.white,
                                                    alignment: Alignment.center,
                                                    decoration: BoxDecoration(
                                                        gradient: LinearGradient(
                                                            begin: Alignment
                                                                .topLeft,
                                                            end: Alignment
                                                                .bottomRight,
                                                            colors: [
                                                              Color.fromARGB(
                                                                  255,
                                                                  164,
                                                                  219,
                                                                  255),
                                                              Color.fromARGB(
                                                                  255,
                                                                  54,
                                                                  165,
                                                                  240),
                                                            ]),
                                                        // border: Border.all(width: 2.0),
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    50.0))),
                                                    child: Center(
                                                        child: Text(
                                                      'Accept',
                                                      style: TextStyle(
                                                          fontSize: 20,
                                                          color: Colors.white),
                                                    )),
                                                  ),
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    declineFeature(snapshot
                                                        .data.docs[index].id);
                                                  },
                                                  child: Container(
                                                    // padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                                                    height: 50,
                                                    width: 120,
                                                    // color: Colors.white,
                                                    alignment: Alignment.center,
                                                    decoration: BoxDecoration(
                                                        gradient: LinearGradient(
                                                            begin: Alignment
                                                                .topLeft,
                                                            end: Alignment
                                                                .bottomRight,
                                                            colors: [
                                                              Color.fromARGB(
                                                                  255,
                                                                  164,
                                                                  219,
                                                                  255),
                                                              Color.fromARGB(
                                                                  255,
                                                                  54,
                                                                  165,
                                                                  240),
                                                            ]),
                                                        // border: Border.all(width: 2.0),
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    50.0))),
                                                    child: Center(
                                                        child: Text(
                                                      'Decline',
                                                      style: TextStyle(
                                                          fontSize: 20,
                                                          color: Colors.white),
                                                    )),
                                                  ),
                                                ),
                                              ]),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Container(
                                                child: Text(
                                                  "${getTimeDifferenceFromNow(time)}",
                                                  // ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    );
                                    // Center(child: Container(child: Text("No requests till now.")));
                                  } else {
                                    return  Container(

                                    );
                                  }
                                } catch (e) {
                                  // print(e);
                                  return Container();
                                }
                              })
                        ],
                      );
                    } else {
                      // Render text if there is no data in the collection
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 320),
                        child: Center(
                          child: Container(
                              child: Text(
                                'No requests available now',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold),
                              )),
                        ),
                      );
                    }
                  } catch (e) {
                    print(e);
                  }
                  return Container();
                },
              ),
            ),
          ),
        )
        // StreamBuilder(
        //   stream: FirebaseFirestore.instance.collection("food").snapshots(),
        //   builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        //     return ListView.builder(
        //         itemBuilder: (BuildContext context, int index){
        //           return Text('${snapshot.data!.docs[index]['category']}');
        //         }
        //     );
        //   },
        // ),
        );
  }
}
