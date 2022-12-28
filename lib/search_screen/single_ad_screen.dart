import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/ad_model.dart';
import 'package:flutter_application_1/my_files/map.dart';
import 'package:flutter_application_1/screens/registration_screen.dart';
import 'package:flutter_application_1/utils/report_ad.dart';
import 'package:geocoding/geocoding.dart';

import '../model/user_model.dart';

class SinglePostScreen extends StatefulWidget {
  final ad;
  const SinglePostScreen({Key? key, required this.ad}) : super(key: key);

  @override
  State<SinglePostScreen> createState() => _SinglePostScreenState();
}

class _SinglePostScreenState extends State<SinglePostScreen> {
  bool loading = true;
  double imageHeight = 0;
  String sellerName = '';
  String sellerNumber = '';
  String sellerEmail = '';

  @override
  void initState() {
    imageDim();
    getSellerInfo();
    super.initState();
  }

  void getSellerInfo() async {
    UserModel user = UserModel();
    await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.ad['uid'])
        .get()
        .then((value) {
      user = UserModel.fromMap(value.data());
      sellerName = user.firstname ?? "";
      sellerNumber = user.phone ?? "";
      sellerEmail = user.email ?? "";
      setState(() {});
    });
  }

  void doReport(BuildContext context,String adId) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Color(0xFF252628),
      useRootNavigator: true,
      isScrollControlled: true,
      isDismissible: true,
      barrierColor: Colors.black45.withOpacity(0.8),
      elevation: 10,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
        topRight: Radius.circular(20),
        topLeft: Radius.circular(20),
      )),
      builder: (context) {
        return ReportAdPage(adId: adId);
      },
    );
    //Navigator.pop(context);
  }

  Future<Size> _calculateImageDimension(String img) {
    Completer<Size> completer = Completer();
    Image image = Image.network(img);
    image.image.resolve(const ImageConfiguration()).addListener(
      ImageStreamListener(
        (ImageInfo image, bool synchronousCall) {
          var myImage = image.image;
          Size size = Size(myImage.width.toDouble(), myImage.height.toDouble());
          completer.complete(size);
        },
      ),
    );
    return completer.future;
  }

  imageDim() async {
    _calculateImageDimension(widget.ad["adImageUrl"]).then((size) {
      double ratio = size.width / size.height;
      double tempHeight = 220;

      if (mounted) {
        if (ratio < 0.8) {
          tempHeight = MediaQuery.of(context).size.width / 0.8;
        } else if (ratio < 1.5) {
          tempHeight = MediaQuery.of(context).size.width / ratio;
        } else {
          tempHeight = MediaQuery.of(context).size.width / 1.5;
        }
        setState(() {
          imageHeight = tempHeight;
        });
      }
    });
  }

  buildBody() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      scrollDirection: Axis.vertical,
      child: Padding(
        padding: const EdgeInsets.all(0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // img
            Container(
              height: imageHeight,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(widget.ad["adImageUrl"]),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  ListTile(
                    title: Text('Title'),
                    subtitle: Text(widget.ad['title']),
                  ),
                  const Divider(
                    height: 2,
                  ),
                  ListTile(
                    title: Text('Price'),
                    subtitle: Text(widget.ad['price']),
                  ),
                  Divider(
                    height: 2,
                  ),
                  ListTile(
                    title: Text('Type'),
                    subtitle: Text(widget.ad['resOrCom']),
                  ),
                  Divider(
                    height: 2,
                  ),
                  ListTile(
                    title: Text('Area'),
                    subtitle: Text(widget.ad['area']),
                  ),
                  Divider(
                    height: 2,
                  ),
                  ListTile(
                    title: Text('City'),
                    subtitle: Text(widget.ad['city']),
                  ),
                  // Divider(height: 2,),
                  // ListTile(
                  //   title: Text('City'),
                  //   subtitle: Text(widget.ad['city']),
                  // ),
                  Divider(
                    height: 2,
                  ),
                  ListTile(
                    title: Text('Purpose'),
                    subtitle: Text(widget.ad['purpose']),
                  ),
                  Divider(
                    height: 2,
                  ),
                  ListTile(
                    title: Text('Description'),
                    subtitle: Text(widget.ad['description']),
                  ),
                  // Divider(height: 2,),
                  // ListTile(
                  //   title: Text('Purpose'),
                  //   subtitle: Text(widget.ad['purpose']),
                  // ),

                  Divider(
                    height: 2,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.blueAccent.shade100,
                        borderRadius: BorderRadius.circular(10)),
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    padding: EdgeInsets.all(10),
                    child: ListTile(
                      title: Text('Seller details'),
                      leading: CircleAvatar(
                        child: Icon(Icons.person),
                      ),
                      subtitle:
                          Text("$sellerName\n $sellerNumber\n$sellerEmail"),
                    ),
                  ),
                  Divider(
                    height: 2,
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () async {
                List<Location> locations =
                    await locationFromAddress("Islamabad pakistan");
                var long = locations.last.longitude;
                var lat = locations.last.latitude;
// Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>Map_C( lat:lat, long: long,)));
                Navigator.pushNamed(context, Map_C.routeName,
                    arguments: widget.ad["address"]
                    // arguments:{

                    // "lat" :  lat.toString(),
                    // "long" :long.toString(),
                    // }
                    );
              },
              child: Container(
                  height: 40,
                  width: 130,
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(18)),
                  child: Center(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.directions),
                      Text(
                        "Direction",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ))),
            ),
            SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.more_vert,
              color: Colors.white,
            ),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                backgroundColor: Colors.blueAccent,
                useRootNavigator: true,
                isScrollControlled: true,
                isDismissible: true,
                barrierColor: Colors.black45.withOpacity(0.8),
                elevation: 10,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20),
                  topLeft: Radius.circular(20),
                )),
                builder: (context) {
                  return ListTile(
                    onTap: () => doReport(context,widget.ad['adId']),
                    tileColor: Colors.black12,
                    leading: const Icon(Icons.report, color: Colors.white),
                    title: Text('Report Ad',
                        style: Theme.of(context).textTheme.headline2!.copyWith(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w900)),
                  );
                },
              );
              //Navigator.pop(context);
            },
          ),
        ],
      ),
      body: buildBody(),
    );
  }
}
