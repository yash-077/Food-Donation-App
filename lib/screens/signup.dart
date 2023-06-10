import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food/screens/roles1.dart';
import 'package:ionicons/ionicons.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'const.dart';
import 'login.dart';

class SignUp1 extends StatelessWidget {
  const SignUp1({Key? key}) : super(key: key);

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
  }
}

class MyLoginPage extends StatefulWidget {
  const MyLoginPage({
    Key? key,
  }) : super(key: key);

  State<MyLoginPage> createState() => _MyLoginPageState();
}


class NotNgo{
  static late bool isDonor=false;
}

class _MyLoginPageState extends State<MyLoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  final _firestore = FirebaseFirestore.instance;

  Future<bool> checkEmail(String email) async {
    var result = await _firestore
        .collection('Users')
        .where('email', isEqualTo: email)
        .get();
    return result.docs.isNotEmpty;
  }

  Widget signupButton(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 16),
      child: ElevatedButton(
        onPressed: () async{
          final email = emailController.text;
          final isEmailPresent = await checkEmail(email);
           // Navigator.pushReplacement(
           //     context, MaterialPageRoute(builder: (context) => LoginPage1()));
            if(!isEmailPresent){
              FirebaseAuth.instance.createUserWithEmailAndPassword(email: emailController.text, password: passwordController.text).then((value){
                Navigator.pushReplacement(context, new  MaterialPageRoute(builder: (context) => new LoginPage1()));
              })
                  .onError((error, stackTrace){
                print("Error ${error.toString()}");
              });
              Map<String, dynamic> data= await{
                "name":nameController.text,
                "email":emailController.text,
                "password":passwordController.text,
                "role": 'donor'
              };
              await FirebaseFirestore.instance.collection("Users",).add(data);

              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Success'),
                  content: Text('Donor is registered successfully!'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('OK'),
                    ),
                  ],
                ),
              );
            } else {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Error'),
                  content: Text('This email already exist. Please enter other email.'),
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
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: const StadiumBorder(),
          elevation: 8,
          shadowColor: Colors.black87,
        ),
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
  String valueChoose='Donor';
  List <String> dropItems = ['Donor','NGOs'];
  Widget roles(){
    return                  Container(
      padding: EdgeInsets.symmetric(horizontal: 8),
      margin: EdgeInsets.fromLTRB(24, 15, 24, 0),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24)),
      child: Row(
        children: [
          SizedBox(
            width: 10,
          ),
          Icon(
            Icons.people_outline,
            color: Colors.grey[600],
          ),
          SizedBox(
            width: 12,
          ),
          DropdownButton(
            hint: Text("Select Duration (in hrs)"),
            value: valueChoose,
            onChanged: (val) {
              setState(() {
                valueChoose = val as String;
              });
            },
            items: dropItems.map((String valueItem) {
              return DropdownMenuItem(
                value: valueItem,
                child: Text(valueItem),
              ); // DropdownMenuItem
            }).toList(),
          ),
        ],
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
            // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage1()));
            Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage1()));
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

  @override
  void initState() {
    signupContent= [
    inputField('Name', Ionicons.person_outline,nameController),
    inputField('Email', Ionicons.mail_outline, emailController),
    // roles(),
    inputField('Password', Ionicons.lock_closed_outline, passwordController, isPassword: true),
    signupButton("Sign Up"),
    bottomText()
    ];
    super.initState();
  }

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
        appBar: AppBar(
          title: Text("Donor"),
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
                padding: const EdgeInsets.fromLTRB(10,140, 10, 150),
                child: GlassContainer(
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
                      SizedBox(height: 15,),
                            Text(
                                "Create Account",
                                style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
                              ),
                      SizedBox(height: 10,),
                      Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children:[
                                inputField('Name', Ionicons.person_outline,nameController),
                                inputField('Email', Ionicons.mail_outline, emailController),
                                // roles(),
                                inputField('Password', Ionicons.lock_closed_outline, passwordController, isPassword: true),
                                signupButton("Sign Up"),
                                bottomText()
                              ],
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
