import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food/screens/signup.dart';
import 'package:food/screens/signup1.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:ionicons/ionicons.dart';
import 'const.dart';
import 'splashscreen.dart';
import 'login.dart';

class Roles1 extends StatelessWidget {
  const Roles1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FeedNow',
      theme: ThemeData(
        primarySwatch: Const.primary,
      ),
      home: MyRolesPage(),
      debugShowCheckedModeBanner: false,
    );;
  }
}

class MyRolesPage extends StatefulWidget {
  const MyRolesPage({Key? key,}) : super(key: key);

  State<MyRolesPage> createState() => _MyRolesPageState();
}

class _MyRolesPageState extends State<MyRolesPage> {

  Widget rolesButton1(String title, Color color, Color tcolor) {
    return  Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () async {
          // Navigator.pushReplacement(context, new  MaterialPageRoute(builder: (context) => new SignUp2()));
        },
        child: Container(
          // padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
          height: 70,
          width: 400,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: color,
              borderRadius:
              BorderRadius.all(Radius.circular(70.0))),
          child: Center(
              child: Text(
                title,
                style: TextStyle(fontSize: 30, color: tcolor),
              )),
        ),
      ),
    );
  }

  centerImg()=>Center(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
      Column(
        children: [
          InkWell(
            onTap: (){
              Navigator.pushReplacement(context, new  MaterialPageRoute(builder: (context) => new SignUp1()));
            },
            child: CircleAvatar(
              radius: 71,
              backgroundColor: Colors.black,
              child: CircleAvatar(
                radius: 70,
                foregroundImage: AssetImage("assets/images/donor logo.jpg"),
              ),
            ),
          ),
          SizedBox(height: 20),
          Text("Donor",style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))
        ],
      ),
      SizedBox(width: 15,),
      Column(
        children: [
          InkWell(
            onTap: (){
              Navigator.pushReplacement(context, new  MaterialPageRoute(builder: (context) => new SignUp2()));
            },
            child: CircleAvatar(
              radius: 71,
              backgroundColor: Colors.black,
              child: CircleAvatar(
                radius: 70,
                foregroundImage: AssetImage("assets/images/reciever.jpg"),
              ),
            ),
          ),
          SizedBox(height: 20),
          Text("Reciever",style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),)
        ],
      )
    ],),
  );

  Widget topText()=> Padding(
    padding: EdgeInsets.fromLTRB(10, 50, 0, 0),
    child: Text("SELECT THE ROLES", style: TextStyle(fontSize: 35,fontWeight: FontWeight.bold),),
  );
  late List<Widget> loginContent;


  @override
  void initState() {
    loginContent = [
      topText(),
      SizedBox(height: 40,),
      centerImg(),
      // rolesButton("Form", Colors.tealAccent, Colors.white)
      // SizedBox(height: 400,),
      // rolesButton('Donor',Const.primary,Colors.black),
      // SizedBox(height: 1,),
      // rolesButton1('NGOs',Colors.white, Colors.black),
    ];
    // super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("FeedNow"),centerTitle: true,backgroundColor: Const.primary,),
      body: Container(
        decoration: BoxDecoration(
            gradient:
            LinearGradient(colors: [Const.secondary, Colors.white]
            )),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body:  Center(
            child: GlassContainer(
              // height: 450,
              height: MediaQuery.of(context).size.height/2,
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
                // --code to remove border
                border: Border.fromBorderSide(BorderSide.none),
                shadowStrength: 5,
                shadowColor: Colors.white.withOpacity(0.24),
                            child: Center(
                              child: Column(mainAxisAlignment: MainAxisAlignment.start,
                                children: loginContent,
                              ),
                            ),
                          ),
          ),
        ),
      ),
    );
  }
}

