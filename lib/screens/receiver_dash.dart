import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:food/login/screens/login_screen/login_screen.dart';
import 'package:food/screens/login.dart';
import 'package:food/screens/profile.dart';
import 'package:food/screens/reciever_home.dart';
import 'const.dart';
import 'filterpage.dart';
import 'map.dart';
import 'inbox.dart';
import 'donor_notification.dart';

class Receiver extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Food',
      theme: ThemeData(
        primarySwatch: Const.primary,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Reciever Dashboard'),
      debugShowCheckedModeBanner: false,
    );
  }
}
class MyHomePage extends StatefulWidget {
  MyHomePage({Key ? key, required this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}
class _MyHomePageState extends State<MyHomePage> {
  List pages=[
    RecieverHomePage(),
    Map(),
    // Notifications(),
    Inbox(),
  ];
  List<String> filterItems = [
    "Date",
    "Location",
    "Duration",
    "Quantity",
    "Category"
  ];

  int currentIndex=0;
  void onTap(int index){
    setState((){
      currentIndex=index;
    });}
  Future<bool> _onWillPop() async {
    return (await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: new Text('Are you sure?'),
        content: new Text('Do you want to exit an App'),
        actions: <Widget>[
          TextButton(
            onPressed: () =>
                Navigator.of(context).pop(false), //<-- SEE HERE
            child: new Text('No'),
          ),
          TextButton(
            onPressed: () =>
                Navigator.of(context).pop(true), // <-- SEE HERE
            child: new Text('Yes'),
          ),
        ],
      ),
    )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.transparent,
        body:Container(
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
            body: pages[currentIndex],
          ),
        ),
        appBar: AppBar(
          // backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(widget.title,style: TextStyle(fontSize: 18),),
          centerTitle: true,
          actions: <Widget>[
            // IconButton(
            //   icon:Icon(Icons.sync),
            //   onPressed: () {
            //     Navigator.pushReplacement(context, new  MaterialPageRoute(builder: (context) => new Donor()));
            //   },
            // ),
            IconButton(
              icon:Icon(Icons.filter_list_alt),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => FilterPage()));
              },
            ),
          ],
        ),
        drawer: Drawer(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 50),
              children: <Widget>[
                Icon(
                  Icons.account_circle,
                  size: 150,
                  color: Colors.grey[700],
                ),
                const SizedBox(
                  height: 15,
                ),
                Text(
                  "${FirebaseAuth.instance.currentUser?.email}",
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize:20,fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 30,
                ),
                const Divider(
                  height: 2,
                ),
                ListTile(
                  onTap: () {},
                  selectedColor: Colors.blue,
                  selected: true,
                  contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  leading: const Icon(Icons.dashboard),
                  title: const Text(
                    "Dashboard",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                ListTile(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProfilePage()));
                  },
                  contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  leading: const Icon(Icons.group),
                  title: const Text(
                    "Profile",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                ListTile(
                  onTap: () async {
                    showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text("Logout"),
                            content: const Text("Are you sure you want to logout?"),
                            actions: [
                              IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: const Icon(
                                  Icons.cancel,
                                  color: Colors.red,
                                ),
                              ),
                              IconButton(
                                onPressed: () async {
                                  Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(
                                          builder: (context) => LoginPage1()),
                                          (route) => false);
                                },
                                icon: const Icon(
                                  Icons.done,
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          );
                        });
                  },
                  contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  leading: const Icon(Icons.exit_to_app),
                  title: const Text(
                    "Logout",
                    style: TextStyle(color: Colors.black),
                  ),
                )
              ],
            )),


        bottomNavigationBar: BottomNavigationBar(
          type:BottomNavigationBarType.fixed,
          onTap: onTap,
          currentIndex: currentIndex,
          backgroundColor: Colors.white,
          unselectedItemColor: Colors.grey.withOpacity(1),
          selectedItemColor:  Color(0xFF31ACBA),
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(
                icon: Icon(Icons.location_on), label: 'Map'),
            // BottomNavigationBarItem(icon: Icon(Icons.notifications), label: 'Notification'),
            BottomNavigationBarItem(
                icon: Icon(Icons.mail), label: 'Inbox'),
          ],

        ),
      ),
    );
  }
}
