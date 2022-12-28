import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Map_C extends StatefulWidget {
  @override
static const routeName="/map";

  State<Map_C> createState() => _Map_CState();
}

class _Map_CState extends State<Map_C> {
  var data;
 // static var long;
 //  static var lat;

  Completer<GoogleMapController> _controller=Completer();
//temporary location or initial camera position
  CameraPosition current= CameraPosition(
      target: LatLng(lat, long),
       zoom: 14
  );

List<Marker> _list=[];
//point the destination
List<Marker> _markers=[
     Marker(
      markerId: MarkerId("1"),
      position:
     //addres of the destination
      LatLng( lat , long),

      infoWindow: InfoWindow(
      title: "destination",

    ),
    ),
    // Marker(markerId: MarkerId("2"),
    //   position: LatLng(32.1877, 74.1945),),
    // Marker(markerId: MarkerId("3"),
    //   position: LatLng(long, lat),),
  ];

  static late double long=74.329376;
  //
   static late double lat=31.582045;


@override
  void initState() {

  setState(() {
    long=74.329376;
    lat=31.582045;

    temp();

 _list.addAll(_markers);
});;

  // TODO: implement initState
    super.initState();
  }
  Future<void> temp() async{


    setState(() {

   long=data["long"];
   lat=data["lat"];

 });
    print("longitude value:"+ long.toString());
  print("latitude value:"+ lat.toString());

  }
  @override
  Widget build(BuildContext context) {

   data=ModalRoute.of(context)!.settings.arguments  as String;
   return Scaffold(
floatingActionButton: FloatingActionButton(
  child: Icon(Icons.directions),
  onPressed: ()async{
    List<Location> locations = await locationFromAddress(data);

    long=locations.last.longitude;
        lat=locations.last.latitude;
Navigator.pushReplacementNamed(context,Map_C.routeName, arguments: data
  // {
  // "lat" :  lat.toString(),
  // "long" :long.toString(),

// }

);
  },
),
      body: GoogleMap(
        initialCameraPosition: current,
markers:
      Set<Marker>.of(_list),
        onMapCreated: (GoogleMapController controller){
          _controller.complete(controller);
        },
      myLocationEnabled: true,
        compassEnabled: true,
      ),
    );
  }
}
