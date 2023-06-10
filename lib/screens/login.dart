import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:food/screens/receiver_dash.dart';
import 'package:food/screens/roles1.dart';
import 'package:food/screens/signup1.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food/screens/signup.dart';
import 'package:ionicons/ionicons.dart';
import 'const.dart';
import 'donor_dash.dart';
import 'splashscreen.dart';

class LoginPage1 extends StatelessWidget {
  const LoginPage1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Home',
      theme: ThemeData(
        primarySwatch: Const.primary,
      ),
      home: MyLoginPage(),
      debugShowCheckedModeBanner: false,
    );
    ;
  }
}

class MyLoginPage extends StatefulWidget {
  const MyLoginPage({
    Key? key,
  }) : super(key: key);

  State<MyLoginPage> createState() => _MyLoginPageState();
}

class _MyLoginPageState extends State<MyLoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  static Future<User?> login(
      {required String email,
      required String password,
      required BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      user = userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == "user-not-found") {
        print("No Helper Function found for that Email");
      }
    }
    return user;
  }

  Widget bottomText() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Don\'t have an account?',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => SignUp1()));
            },
            child: Text('Sign Up'),
          )
        ],
      );

  Widget inputField(
      String hint, IconData iconData, TextEditingController controller,
      {isPassword = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
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

  Widget forgotPassword() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 110),
      child: TextButton(
        onPressed: () {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => SignUp2()));
        },
        child: const Text(
          'Forgot Password?',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            // color: kSecondaryColor,
          ),
        ),
      ),
    );
  }

  late List<Widget> loginContent;
  String role1='donor';
  String role2='receiver';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
        centerTitle: true,
        backgroundColor: Const.primary,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            gradient:
                LinearGradient(colors: [Const.secondary, Colors.white])),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: SingleChildScrollView(
                child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("Users")
                        .snapshots(),
                    builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(10, 140, 10, 150),
                        child: ListView.builder(
                            padding: EdgeInsets.symmetric(vertical: 5),
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: 1,
                            itemBuilder: (context, index) {
                              return GlassContainer(
                                blur: 4,
                                color: Colors.white.withOpacity(0.9),
                                borderRadius: BorderRadius.circular(25),
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Colors.white.withOpacity(0.6),
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
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Text(
                                      "Welcome Back",
                                      style: TextStyle(
                                          fontSize: 35,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          inputField(
                                              'Email',
                                              Ionicons.mail_outline,
                                              emailController),
                                          inputField(
                                              'Password',
                                              Ionicons.lock_closed_outline,
                                              passwordController,
                                              isPassword: true),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        0, 10, 5, 0),
                                                child: ElevatedButton(
                                                  onPressed: () async {
                                                    // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => RolePage()));
                                                    // if (snapshot.data.docs[index]['role'] ==role1) {
                                                      User? user = await login(
                                                          email: emailController
                                                              .text,
                                                          password:
                                                              passwordController
                                                                  .text,
                                                          context: context);
                                                      if (user != null) {
                                                        Navigator.pushReplacement(
                                                            context, MaterialPageRoute(builder: (context) => Donor()));
                                                      }
                                                    // }
                                                  },
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    fixedSize: Size(125, 50),
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        vertical: 14),
                                                    shape:
                                                        const StadiumBorder(),
                                                    elevation: 8,
                                                    shadowColor: Colors.black87,
                                                  ),
                                                  child: Text(
                                                    "Donor Login",
                                                    style: const TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(5, 10, 0, 0),
                                                child: ElevatedButton(
                                                  onPressed: () async {
                                                    // if (snapshot.data.docs[index]['role'] ==role2) {
                                                      User? user = await login(
                                                          email: emailController.text,
                                                          password: passwordController.text,
                                                          context: context);
                                                      if (user != null) {
                                                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Receiver()));
                                                      }
                                                    // }
                                                  },
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    fixedSize: Size(125, 50),
                                                    backgroundColor:
                                                        Colors.white,
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        vertical: 14),
                                                    shape:
                                                        const StadiumBorder(),
                                                    elevation: 8,
                                                    shadowColor: Colors.black87,
                                                  ),
                                                  child: Text(
                                                    "NGO Login",
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                          // forgotPassword(),
                                          bottomText()
                                        ]),
                                    SizedBox(
                                      height: 15,
                                    ),
                                  ],
                                ),
                              );
                            }),
                      );
                    })),
          ),
        ),
      ), // ),
    );
  }
}
