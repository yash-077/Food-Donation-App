import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Food',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final timlineRef = FirebaseFirestore.instance.collection('timeline');
  late final time1, time2, id;
  @override
  void initState(){
    super.initState();
    // getTimeline();i
  }
  //
  deleteFeature(id) async {
    await FirebaseFirestore.instance
        .collection(
          "Posts",
        )
        .doc(id)
        .delete();
  }
  updateFeature(id, value) async {
    await FirebaseFirestore.instance
        .collection(
          "Posts",
        )
        .doc(id)
        .update({"duration": value});
  }

  deleteTask(time1, time2, id)async{
     if(time1==time2){
       await FirebaseFirestore.instance..collection(
        "${FirebaseAuth.instance.currentUser?.email}",
      )
          .doc(id)
          .delete();
    }
  }

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
      return "${difference.inDays}";
    }
  }
  String getDuration(DateTime dateTime) {
    Duration difference = DateTime.now().difference(dateTime);
      return "${difference.inHours}";
  }

  var updatename;
  Widget build(BuildContext context) {
    return Scaffold(
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
      child: SingleChildScrollView(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("Posts")
              .orderBy('timestamp', descending: true)
              .snapshots(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if(snapshot.data == null) return CircularProgressIndicator();
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
                          DateTime time=snapshot.data.docs[index]['timestamp'].toDate();
                          DateTime dateTime=snapshot.data.docs[index]['time'].toDate();
                          Duration durations=dateTime.difference(time);
                          Duration duration=DateTime.now().difference(time);
                          // deleteTask(time,snapshot.data.docs[index]['duration'], snapshot.data.docs[index].id);
                          if(durations>duration && snapshot.data.docs[index]['email']==FirebaseAuth.instance.currentUser?.email){
                            // if(durations>duration){
                            //   setState(() {
                            //     deleteFeature(snapshot.data.docs[index].id);
                            //   });
                            // }
                            return Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 15),
                              color: Colors.white,
                              padding: EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                          width: 4,
                                        ),
                                        Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "${snapshot.data
                                                    .docs[index]['food name']}",
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20,
                                                ),
                                              ),
                                              Text("${snapshot.data
                                                  .docs[index]['email']}",
                                                style: TextStyle(
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ])
                                      ]),
                                      SizedBox(width: 5,),
                                      Row(
                                          mainAxisAlignment: MainAxisAlignment
                                              .end,
                                          children: [
                                            Icon(Icons.watch_later_outlined,
                                                color: Colors.black),
                                            // SizedBox(
                                            //   width: 5,
                                            // ),
                                            Text(
                                              "${snapshot.data.docs[index]['duration']} hrs",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            IconButton(
                                              icon: Icon(
                                                  Icons.delete),
                                              onPressed: () {
                                                setState(() {
                                                  deleteFeature(
                                                      snapshot.data.docs[index]
                                                          .id);
                                                });
                                              },
                                            ),
                                            GestureDetector(
                                              child: Icon(
                                                // Icons.more_horiz
                                                  Icons.more_vert),
                                              onTap: () {
                                                showDialog(
                                                    context: context,
                                                    builder: (BuildContext context) {
                                                      return AlertDialog(
                                                  title: Text("Update Duration"),
                                                  // barrierDismissible: true,
                                                  content: Form(
                                                    child: TextFormField(
                                                        keyboardType:
                                                        TextInputType.number,
                                                        decoration: InputDecoration(
                                                            hintText: "Duration"
                                                        ),
                                                        onChanged: (value) {
                                                          setState(()
                                                          {
                                                            updatename = value;
                                                          });
                                                        }),
                                                  ),
                                                  actions: [
                                                    ElevatedButton(
                                                        onPressed: () {
                                                          updateFeature(
                                                              snapshot.data
                                                                  .docs[index]
                                                                  .id,
                                                              updatename);
                                                          setState(() {});
                                                        },
                                                        child: Text("Update"))
                                                  ],
                                                );});
                                              },
                                            )
                                          ])
                                    ],
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(top: 16),
                                    height: 300,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
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
                                        Row(
                                          children: [
                                            // Icon(
                                            //   Icons.restaurant_outlined,
                                            //   color: Colors.black,
                                            // ),
                                            // SizedBox(width: 8),
                                            Text(
                                                "Category: ${snapshot.data
                                                    .docs[index]['category']}"),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            // Icon(
                                            //   Icons.shopping_bag_outlined,
                                            //   color: Colors.black,
                                            // ),
                                            // SizedBox(width: 8),
                                            Text(
                                                "Quantity: ${snapshot.data
                                                    .docs[index]['quantity']} kgs"),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 5,),
                                  Container(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment
                                          .spaceBetween,
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
                                            "${getTimeDifferenceFromNow(time)}",
                                            // style: TextStyle(
                                            //   color: Colors.black,
                                            //   fontSize: 16,
                                            // ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Container(
                                  //   margin: EdgeInsets.only(top: 16),
                                  //   child: Text(
                                  //     "${snapshot.data.docs[index]['address']}",
                                  //     style: TextStyle(
                                  //       fontWeight: FontWeight.bold,
                                  //       fontSize: 16,
                                  //     ),
                                  //   ),
                                  // ),
                                ],
                              ),
                            );
                            }
                          else{
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
            }catch(e){
              print(e);
            }return Container();
          },
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
