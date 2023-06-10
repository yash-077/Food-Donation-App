import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/cupertino.dart';
import 'package:readmore/readmore.dart';

class Inbox extends StatelessWidget {

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

  declineFeature(id) async {
    await FirebaseFirestore.instance
        .collection(
      "Notification",
    )
        .doc(id)
        .delete();
  }

  late String value1 = '';
  bool isAccepted=true;
  var username;
  var text;
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
            body: SingleChildScrollView(
              // keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.manual,
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("Inbox")
                    .orderBy('timestamp', descending: true)
                    .snapshots(),
                builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  if (snapshot.data == null) return CircularProgressIndicator();
                  try {
                    return Column(
                      children: [
                        SizedBox(
                          height: 80,
                        ),
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
                                if (snapshot.data.docs[index]['mail']==FirebaseAuth.instance.currentUser?.email || snapshot.data.docs[index]['email']==FirebaseAuth.instance.currentUser?.email) {
                                  if(snapshot.data.docs[index]['mail']==FirebaseAuth.instance.currentUser?.email){
                                    username=snapshot.data.docs[index]['email'];
                                  }
                                  else{
                                    username=snapshot.data.docs[index]['mail'];
                                  }
                                  if(snapshot.data.docs[index]['mail']==FirebaseAuth.instance.currentUser?.email){
                                    text='You accepted the request for ${snapshot.data.docs[index]['food name']}. The One Time Password for verification is ${snapshot.data.docs[index]['otp']}.';
                              }
                                  else{
                                    text='Your request for ${snapshot.data.docs[index]['food name']} has been accepted. The One Time Password for verification is ${snapshot.data.docs[index]['otp']}.';
                                  }
                                  return
                                    Container(
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
                                                        textAlign: TextAlign.start,
                                                        style: TextStyle(
                                                          fontWeight:
                                                          FontWeight.bold,
                                                          fontSize: 18,
                                                        ),
                                                      ),
                                                      Text(
                                                        "${username}",
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
                                                padding: const EdgeInsets.all(5.0),
                                                child: Text(text,
                                                  style: TextStyle(fontSize: 16),
                                                ),
                                              ),
                                            ],
                                          ),
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
                                } else {
                                  return Container(
                                    // child: Text("No Posts till now"),
                                  );
                                }
                              } catch (e) {
                                // print(e);
                                return Container();
                              }
                            })
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
