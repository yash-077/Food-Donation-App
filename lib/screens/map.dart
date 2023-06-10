import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';



class Map extends StatefulWidget {
  const Map({Key? key}) : super(key: key);

  @override
  State<Map> createState() => _MapState();
}

class _MapState extends State<Map> {

  @override
  void initState() {
    addMarker();
    super.initState();
  }
  static final CameraPosition currentLocation = const CameraPosition(target: LatLng(25.1193, 55.3773), zoom: 15);
  BitmapDescriptor markerIcon= BitmapDescriptor.defaultMarker;
  void addMarker(){
    BitmapDescriptor.fromAssetImage(const ImageConfiguration(), "assets/images/donor logo.jpg").then((icon) {
      setState(() {
        markerIcon=icon;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // : Center(child: Text("Map", style: TextStyle(fontSize: 50, color: Colors.white), )),
        body:

        // Container(
        //   height: MediaQuery.of(context).size.height,
        //   width: MediaQuery.of(context).size.width,
        //   // child: Image(image: AssetImage("assets/images/map.jpg"))
        //   child: Image(image: NetworkImage("https://www.google.com/maps/d/thumbnail?mid=15ki3cbucBtd8waokhYP4jCCRMxE&hl=en"), fit: BoxFit.cover,),
        // )
        GoogleMap(initialCameraPosition:CameraPosition(target: LatLng(19.6967, 72.7699), zoom: 14),
          markers: {
            Marker(markerId: MarkerId("Donor"),
                position: LatLng(19.6967, 72.7699),
                draggable: true,
                onDragEnd: (value){

                },
                icon: markerIcon
            ),
          },
        )
    );
    // );
  }
}