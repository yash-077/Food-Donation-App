import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:food/screens/login.dart';

import 'const.dart';

class ProfilePage extends StatefulWidget {
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController editingController = TextEditingController();
  var update;
  updateFeature(id, value,attribute) async {
    await FirebaseFirestore.instance
        .collection(
      "Users",
    )
        .doc(id)
        .update({"${attribute}": value});
  }
  @override
  Widget build(BuildContext context) {
    User? user = _auth.currentUser;

    return Scaffold(
        appBar: AppBar(
          title: Text('Profile Page'),
          centerTitle: true,
        ),
        body: Container(
          alignment: Alignment.topCenter,
          decoration: const BoxDecoration(
              gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.cyanAccent, Colors.white],
          )),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: StreamBuilder(
              stream:
                  FirebaseFirestore.instance.collection("Users").snapshots(),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                      padding: EdgeInsets.symmetric(vertical: 5),
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (context, index) {
                        if (_auth.currentUser?.email ==
                            snapshot.data.docs[index]['email']) {
                          if (snapshot.data.docs[index]['role'] == 'donor') {
                            return Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Center(
                                    child: CircleAvatar(
                                      radius:
                                          MediaQuery.of(context).size.height /
                                              12,
                                      backgroundColor: Colors.grey[400],
                                      child: Icon(
                                        Icons.person,
                                        size: 120,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 5),
                                    child: Container(
                                      padding: EdgeInsets.all(15),
                                      width: MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Icon(Icons.person_outline),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                "Name:",
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold
                                                ),
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Text("${snapshot.data.docs[index]['name']}",  style: TextStyle(
                                                fontSize: 18,
                                              ),
                                              )
                                            ],
                                          ),
                                          GestureDetector(
                                            child: Icon(
                                              // Icons.more_horiz
                                              Icons.edit,
                                              color:Const.primary,),
                                            onTap: () {
                                              showDialog(
                                                  context: context,
                                                  builder: (BuildContext context) {
                                                    return AlertDialog(
                                                      title: Text("Update"),
                                                      // barrierDismissible: true,
                                                      content: Form(
                                                        child: TextFormField(
                                                            keyboardType:
                                                            TextInputType.text,
                                                            decoration: InputDecoration(
                                                                hintText: "Name"
                                                            ),
                                                            onChanged: (value) {
                                                              setState(()
                                                              {
                                                                update = value;
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
                                                                  update, 'name');
                                                              setState(() {});
                                                            },
                                                            child: Text("Update"))
                                                      ],
                                                    );});
                                            },
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 5),
                                    child: Container(
                                      padding: EdgeInsets.all(15),
                                      width: MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Icon(Icons.mail_outline),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                "Email:",
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold
                                                ),
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Text("${snapshot.data.docs[index]['email']}",  style: TextStyle(
                                                fontSize: 18,
                                              ),)
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 5),
                                    child: Container(
                                      padding: EdgeInsets.all(15),
                                      width: MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Icon(Icons.people_outline),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                "Role:",
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold
                                                ),
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Text("${snapshot.data.docs[index]['role']}",  style: TextStyle(
                                                fontSize: 18,
                                              ),)
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          } else {
                            return Padding(
                              padding: const EdgeInsets.all(15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Center(
                                    child: CircleAvatar(
                                      radius:
                                      MediaQuery.of(context).size.height /
                                          12,
                                      backgroundColor: Colors.grey[400],
                                      child: Icon(
                                        Icons.person,
                                        size: 120,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 5),
                                    child: Container(
                                      padding: EdgeInsets.all(15),
                                      width: MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Icon(Icons.person_outline),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                "Name:",
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold
                                                ),
                                              ),
                                              Text("${snapshot.data.docs[index]['name']}",  style: TextStyle(
                                                fontSize: 18,
                                              ),
                                              )
                                            ],
                                          ),
                                          GestureDetector(
                                            child: Icon(
                                              // Icons.more_horiz
                                              Icons.edit,
                                              color:Const.primary,),
                                            onTap: () {
                                              showDialog(
                                                  context: context,
                                                  builder: (BuildContext context) {
                                                    return AlertDialog(
                                                      title: Text("Update"),
                                                      // barrierDismissible: true,
                                                      content: Form(
                                                        child: TextFormField(
                                                            keyboardType:
                                                            TextInputType.text,
                                                            decoration: InputDecoration(
                                                                hintText: "Name"
                                                            ),
                                                            onChanged: (value) {
                                                              setState(()
                                                              {
                                                                update = value;
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
                                                                  update, 'name');
                                                              setState(() {});
                                                            },
                                                            child: Text("Update"))
                                                      ],
                                                    );});
                                            },
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 5),
                                    child: Container(
                                      padding: EdgeInsets.all(15),
                                      width: MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Icon(Icons.mail_outline),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                "Email:",
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold
                                                ),
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Text("${snapshot.data.docs[index]['email']}",  style: TextStyle(
                                                fontSize: 18,
                                              ),)
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 5),
                                    child: Container(
                                      padding: EdgeInsets.all(15),
                                      width: MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Icon(Icons.people_outline),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                "Role:",
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold
                                                ),
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Text("${snapshot.data.docs[index]['role']}",  style: TextStyle(
                                                fontSize: 18,
                                              ),)
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 5),
                                    child: Container(
                                      padding: EdgeInsets.all(15),
                                      width: MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Icon(Icons.person_outline),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                "Unique Id:",
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold
                                                ),
                                              ),
                                              Text("${snapshot.data.docs[index]['ngo_id']}",  style: TextStyle(
                                                fontSize: 18,
                                              ),)
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }
                        } else {
                          return Container();
                        }
                      });
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ),
        ));
  }
}
