import 'dart:ffi';
import 'dart:io';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:image_picker/image_picker.dart';

import 'donor_home.dart';

class FormPage extends StatefulWidget {
  @override
  _FormPageState createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  Future<FirebaseApp> _intializeFirebase() async {
    FirebaseApp fisebaseApp = await Firebase.initializeApp();
    return fisebaseApp;
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Donate1();
        }
        return Donate1();
      }),
    );
  }
}

class Donate1 extends StatefulWidget {
  const Donate1({Key? key}) : super(key: key);

  @override
  State<Donate1> createState() => _Donate1State();
}

class _Donate1State extends State<Donate1> {
  late String name, email, phone;
  final _formKey = GlobalKey<FormState>();
  late FormField<DateTime> formState;
  late ValueChanged<DateTime> onChanged;

  Future submit(String foodName, String phoneNo) async {
    try {
      FirebaseAuth auth = FirebaseAuth.instance;
    } catch (e) {}
  }

  //TextController to read text entered in text field
  TextEditingController fnameController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController durationController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController imageController = TextEditingController();

  File? _image;
  final picker = ImagePicker();
  late String a;
  var formattedDate;

  Future imagePicker() async {
    final pick = await picker.pickImage(source: ImageSource.camera);
    setState(() {
      if (pick != null) {
        _image = File(pick.path);
      } else {
        print("No image selected");
      }
    });
  }

  File? _image1;
  // final picker1 = ImagePicker();
  late String imageUrl;
  int _value = 1;

  var value = "";
  String valueChoose='Select Duration (in hrs)';
  List <String> dropItems = ["Select Duration (in hrs)","1", "2", "3", "4", "5", "6"];

  // Future imagePicker1() async {
  //   final pick1 = await picker1.pickImage(source: ImageSource.gallery);
  //   String uniqueName= DateTime.now().microsecondsSinceEpoch.toString();
  //   // setState(() {
  //     if (pick1 != null) {
  //       _image1 = File(pick1.path);
  //       // print("${pick1.path}");
  //       Reference referenceRoot=FirebaseStorage.instance.ref();
  //       Reference referenceImage= referenceRoot.child('images');
  //
  //       Reference referenceImageToUpload= referenceImage.child(uniqueName);
  //       try  {
  //         await referenceImageToUpload.putFile(File(pick1!.path));
  //         imageUrl= await referenceImageToUpload.getDownloadURL();
  //       }
  //       catch (error){
  //
  //       }
  //     } else {
  //       print("No image selected");
  //     }
  //   // });
  // }

 Future<Position> getUserloction() async{
   await Geolocator.requestPermission().then((value) {

   }).onError((error, stackTrace) {
     print("error");
   });

   return await Geolocator.getCurrentPosition();
 }

  @override
  void initState() {
    super.initState();
    dateController.text = "";
  }


  String fname = '';
  String ph_no = '';
  String date = '';
  String address = '';
  String quantity = '';
  int duration = 1;
  String category = '';

  @override
  Widget build(BuildContext context) {
    return Container(
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
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10,90, 10, 150),
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
            child: Form(
                key: _formKey,
                child:
                    Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  SizedBox(
                    height: 30,
                  ),
                  Column(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        margin: EdgeInsets.symmetric(horizontal: 24),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24)),
                        child: TextFormField(
                          controller: fnameController,
                          keyboardType: TextInputType.text,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please Enter food name';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            setState(() => fname = value);
                          },
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Food Name",
                              prefixIcon: Icon(Icons.fastfood)),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        margin: EdgeInsets.fromLTRB(24, 15, 24, 0),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24)),
                        child: TextFormField(
                          controller: phoneController,
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter phone no';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            setState(() => ph_no = value);
                          },
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Phone Number",
                              prefixIcon: Icon(Icons.phone)),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        margin: EdgeInsets.fromLTRB(24, 15, 24, 0),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24)),
                        child: TextFormField(
                          controller: dateController,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter the date';
                            }
                            return null;
                          },
                          readOnly: true,
                          onTap: () async {
                            DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2101),
                            );
                            if (pickedDate != null) {
                              formattedDate =
                                  "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                              setState(() {
                                dateController.text = formattedDate.toString();
                                date = formattedDate;
                              });
                            } else {
                              print("Not selected");
                            }
                          },
                          onChanged: (value) {
                            setState(() => date = value);
                          },
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Date",
                              prefixIcon: Icon(Icons.calendar_month)),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        margin: EdgeInsets.fromLTRB(24, 15, 24, 0),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24)),
                        child: TextFormField(
                          controller: addressController,
                          keyboardType: TextInputType.text,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter the Address';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            setState(() => address = value);
                          },
                          // onTap:(){
                          // getUserloction().then((value) {
                          //   setState(() {
                          //     address="${value.latitude}${value.longitude}";
                          //   });
                          // });
                          // },
                          // onChanged: (value){
                          //   setState(() =>address = value);
                          // },
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Address",
                              prefixIcon: Icon(Icons.location_on)),
                        ),
                      ),
                      Container(
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
                              Icons.watch_later_outlined,
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
                                  duration=int.parse(valueChoose);
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
                        // TextFormField(
                        //   controller: durationController,
                        //   keyboardType: TextInputType.number,
                        //   validator: (value) {
                        //     if (value!.isEmpty) {
                        //       return 'Please enter the duration';
                        //     }
                        //     return null;
                        //   },
                        //   onChanged: (value) {
                        //     setState(() => ph_no = value);
                        //   },
                        //   decoration: InputDecoration(
                        //       border: InputBorder.none,
                        //       hintText: "Duration",
                        //       prefixIcon: Icon(Icons.watch_later_outlined)),
                        // ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        margin: EdgeInsets.fromLTRB(24, 15, 24, 0),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24)),
                        child: TextFormField(
                          controller: quantityController,
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter Quantity';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            setState(() => quantity = value);
                          },
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Quantity (in kgs)",
                              prefixIcon: Icon(Icons.shopping_bag_outlined)),
                        ),
                      ),
                      Container(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          margin: EdgeInsets.fromLTRB(24, 15, 24, 20),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(24)),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 5,
                              ),
                              Icon(
                                Icons.restaurant,
                                color: Colors.grey[600],
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                "Category:",
                                style: TextStyle(
                                    fontSize: 16, color: Colors.grey[600]),
                              ),
                              Row(
                                children: [
                                  Radio(
                                      value: "Veg",
                                      groupValue: value,
                                      onChanged: (val) {
                                        setState(() {
                                          value = val.toString() ;
                                        });
                                      }),
                                  // SizedBox(
                                  //   width: 5,
                                  // ),
                                  Text("Veg",style: TextStyle(
                                      fontSize: 14, color: Colors.grey[600]),),
                                  // SizedBox(width: 5,),
                                  Radio(
                                      value: "Non-Veg",
                                      groupValue: value,
                                      onChanged: (val) {
                                        setState(() {
                                          value = val.toString() ;
                                        });
                                      }),
                                  // SizedBox(
                                  //   width: 5,
                                  // ),
                                  Text("Non-Veg",style: TextStyle(
                                      fontSize: 14, color: Colors.grey[600]),),
                                ],
                              ),],
                          )
                          // TextFormField(
                          //   controller: categoryController,
                          //   keyboardType: TextInputType.text,
                          //   validator: (value) {
                          //     if (value!.isEmpty) {
                          //       return 'Please enter Category';
                          //     }
                          //     return null;
                          //   },
                          //   onChanged: (value) {
                          //     setState(() => fname = value);
                          //   },
                          //   decoration: InputDecoration(
                          //       border: InputBorder.none,
                          //       hintText: "Category",
                          //       prefixIcon: Icon(Icons.restaurant)),
                          // ),
                          ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // ElevatedButton(
                          //   onPressed: () async{
                          //     ImagePicker picker1= ImagePicker();
                          //     XFile? pick1=await picker1.pickImage(source: ImageSource.camera);
                          //     String uniqueName= DateTime.now().microsecondsSinceEpoch.toString();
                          //     // setState(() {
                          //     if (pick1 != null) {
                          //       _image1 = File(pick1.path);
                          //       // print("${pick1.path}");
                          //       Reference referenceRoot=FirebaseStorage.instance.ref();
                          //       Reference referenceImage= referenceRoot.child('images');
                          //
                          //       Reference referenceImageToUpload= referenceImage.child(uniqueName);
                          //       try  {
                          //         await referenceImageToUpload.putFile(File(pick1.path));
                          //         imageUrl= await referenceImageToUpload.getDownloadURL();
                          //       }
                          //       catch (error){
                          //
                          //       }
                          //     } else {
                          //       print("No image selected");
                          //     }
                          //     // });
                          //   },
                          //   child: Text("Camera"),
                          // ),
                          // SizedBox(width: 10,),
                          ElevatedButton(
                            onPressed: () async {
                              ImagePicker picker1 = ImagePicker();
                              XFile? pick1 = await picker1.pickImage(
                                  source: ImageSource.gallery);
                              String uniqueName =
                                  DateTime.now().microsecondsSinceEpoch.toString();
                              // setState(() {
                              if (pick1 != null) {
                                _image1 = File(pick1.path);
                                // print("${pick1.path}");
                                Reference referenceRoot =
                                    FirebaseStorage.instance.ref();
                                Reference referenceImage =
                                    referenceRoot.child('images');

                                Reference referenceImageToUpload =
                                    referenceImage.child(uniqueName);
                                try {
                                  await referenceImageToUpload
                                      .putFile(File(pick1.path));
                                  imageUrl =
                                      await referenceImageToUpload.getDownloadURL();
                                } catch (error) {}
                              } else {
                                print("No image selected");
                              }
                              // });
                            },
                            child: Text("Add Image from Gallery"),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      InkWell(
                        onTap: () async {
                          DateTime now = DateTime.now();
                          DateTime futureTime = now.add(Duration(hours: duration));
                          Duration time=futureTime.difference(now);
                          // print(futureTime);
                          if (_formKey.currentState!.validate()) {
                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (context) => new HomePage()));
                            // insertData(fnameController.text, phoneController.text, dateController.text, durationController.text, addressController.text, quantityController.text, categoryController.text);
                            Map<String, dynamic> data = {
                              "food name": fnameController.text,
                              "phone number": phoneController.text,
                              "date": dateController.text,
                              "duration": time.inHours,
                              "time": futureTime,
                              "address": addressController.text,
                              "quantity": quantityController.text,
                              "category": value,
                              "image": imageUrl,
                              "timestamp": DateTime.now(),
                              "email": FirebaseAuth.instance.currentUser?.email
                                  .toString()
                            };
                            FirebaseFirestore.instance
                                .collection(
                                  "Posts",
                                )
                                .add(data);
                          }
                        },
                        child: Container(
                          // padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                          height: 50,
                          width: 150,
                          // color: Colors.white,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.green,
                              // gradient: LinearGradient(
                              //     begin: Alignment.topLeft,
                              //     end: Alignment.bottomRight,
                              //     colors: [
                              //       Color.fromARGB(255, 254, 141, 121),
                              //       Color.fromARGB(255, 255, 82, 118)
                              //     ]),
                              // border: Border.all(width: 2.0),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50.0))),
                          child: Center(
                              child: Text(
                            'Submit',
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          )),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      )
                    ],
                  ),
                ])),
          ),
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<File>('_image', _image));
  }
}
