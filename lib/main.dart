import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:food/screens/splashscreen.dart';

Future main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(SplashScreen());
}
