import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food/screens/login.dart';
import 'package:food/screens/roles1.dart';
import 'package:food/screens/signup.dart';

import 'const.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Home',
      theme: ThemeData(
        primarySwatch: Const.primary,
      ),
      home: MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    Timer(
        Duration(seconds: 4),
        () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>  Roles1())));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Const.primary,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "FeedNow",
              style: TextStyle(
                  fontSize: 35,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.none),
            ),
            SizedBox(
              height: 10,
            ),
            Icon(
              Icons.fastfood,
              color: Colors.white,
              size: MediaQuery.of(context).size.height / 3,
            )
            // FlutterLogo(size: MediaQuery.of(context).size.height/2),
          ],
        ));
  }
}
