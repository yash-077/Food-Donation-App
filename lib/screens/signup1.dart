import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food/screens/roles1.dart';
import 'package:ionicons/ionicons.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'const.dart';
import 'login.dart';

class SignUp2 extends StatelessWidget {
  const SignUp2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Home',
      theme: ThemeData(
        primarySwatch: Const.primary,
      ),
      home: MySignUp2Page(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MySignUp2Page extends StatefulWidget {
  const MySignUp2Page({
    Key? key,
  }) : super(key: key);

  State<MySignUp2Page> createState() => _MySignUp2PageState();
}

class Ngo{
 static late bool isNgo=true;
}

class _MySignUp2PageState extends State<MySignUp2Page> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController ngoidController = TextEditingController();
  final _firestore = FirebaseFirestore.instance;

  Future<bool> checkNgoId(String ngoId) async {
    var result = await _firestore
        .collection('Ngo Details')
        .where('uid', isEqualTo: ngoId)
        .get();
    return result.docs.isNotEmpty;
  }

  Widget signupButton(String title,Color color, Color tcolor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 16),
      child: ElevatedButton(
        onPressed: () async{
          final ngoId = ngoidController.text;
          final isValidNgoId = await checkNgoId(ngoId);
          if (isValidNgoId) {
              FirebaseAuth.instance.createUserWithEmailAndPassword(
                  email: emailController.text, password: passwordController.text)
                  .then((value) {
                Navigator.pushReplacement(context, new MaterialPageRoute(
                    builder: (context) => new LoginPage1()));
              })
                  .onError((error, stackTrace) {
                print("Error ${error.toString()}");
              });
              Map<String, dynamic> data = await{
                "name": nameController.text,
                "email": emailController.text,
                "ngo_id": ngoidController.text,
                "password": passwordController.text,
                "role": 'receiver'
              };
              await FirebaseFirestore.instance.collection("Users",).add(data);

            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text('Success'),
                content: Text('NGO is registered successfully!'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('OK'),
                  ),
                ],
              ),
            );
          }
          else {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text('Error'),
                content: Text('NGO ID is not valid. Please enter a valid ID.'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('OK'),
                  ),
                ],
              ),
            );
          }
        },
        style: ElevatedButton.styleFrom(
          fixedSize: Size(140, 50),
          backgroundColor: color,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: const StadiumBorder(),
          elevation: 8,
          shadowColor: Colors.black87,
        ),
        child: Text(
          title,
          style: TextStyle(
            color: tcolor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget inputField(String hint, IconData iconData, TextEditingController controller,{isPassword=false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 8),
      child: SizedBox(
        height: 50,
        child: Material(
          elevation: 8,
          shadowColor: Colors.black87,
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(30),
          child: TextField(
            controller: controller,
            textAlignVertical: TextAlignVertical.bottom,
            obscureText: isPassword,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.white,
              hintText: hint,
              prefixIcon: Icon(iconData),
            ),
          ),
        ),
      ),
    );
  }

  Widget bottomText()=>  Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Already have an account?',
            style: TextStyle(color: Colors.black),
          ),
          TextButton(onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => LoginPage1()));
          }, child: Text('Log in'))
        ],
      ),
      TextButton(onPressed: () {
        // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage1()));
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Roles1()));
      }, child: Text('Roles'))
    ],
  );

  late List<Widget>  signupContent ;
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
  void initState() {
    signupContent= [
      inputField('Name', Ionicons.person_outline,nameController),
      inputField('Email', Ionicons.mail_outline, emailController),
      inputField('NGO Id', Ionicons.id_card_outline, ngoidController),
      // roles(),
      inputField('Password', Ionicons.lock_closed_outline, passwordController,isPassword: true),
      signupButton("Sign Up", Colors.white,Colors.black),
      bottomText()
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text("NGOs"),
          centerTitle: true,
          backgroundColor: Const.primary,
        ),
        body:Container(
          decoration: BoxDecoration(
              gradient:
              LinearGradient(colors: [Const.secondary, Colors.white]
              )),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10,120, 10, 150),
                child: GlassContainer(
                  blur: 4,
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(25),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      // Colors.white.withOpacity(0.6),
                      Const.primary.withOpacity(0.6),
                      Colors.blue.withOpacity(0.2),
                    ],
                  ),
                  //--code to remove border
                  border: Border.fromBorderSide(BorderSide.none),
                  shadowStrength: 5,
                  shadowColor: Colors.white.withOpacity(0.24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 15,),
                      Text(
                        "Create Account",
                        style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10,),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: signupContent,
                      ),
                      SizedBox(height: 15,),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),

      ),
    );
  }
}
