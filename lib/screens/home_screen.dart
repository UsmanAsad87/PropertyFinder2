// ignore_for_file: prefer_const_constructors, camel_case_types, unnecessary_this, unused_local_variable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/user_model.dart';
import 'package:flutter_application_1/my_files/map.dart';
import 'package:flutter_application_1/my_files/scraping.dart';
import 'package:flutter_application_1/screens/addprop_screen.dart';
import 'package:flutter_application_1/screens/c1.dart';
import 'package:flutter_application_1/screens/drawer.dart';
import 'package:flutter_application_1/screens/login_screen.dart';
import 'package:flutter_application_1/screens/myprop_screen.dart';
import 'package:flutter_application_1/screens/registration_screen.dart';
import 'package:flutter_application_1/search_screen/search_screen.dart';
import 'package:flutter_application_1/utils/loader.dart';
import 'package:flutter_application_1/utils/title_with_more_btn.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../my_files/practice.dart';
import '../provider/user_provider.dart';
import '../search_screen/components/adtile.dart';

class homescreen extends StatefulWidget {
  const homescreen({Key? key}) : super(key: key);

  @override
  State<homescreen> createState() => _homescreenState();
}

class _homescreenState extends State<homescreen> {
  @override
  void initState() {
    addData();
    super.initState();
  }

  addData() async {
    UserProvider _userProvider = Provider.of(context, listen: false);
    await _userProvider.refreshUser();
  }

  @override
  Widget build(BuildContext context) {

    final UserModel loggedinuser = Provider.of<UserProvider>(context).getUser;

    return Scaffold(
      appBar: AppBar(
        title: Text("Property Finder"),
        centerTitle: true,
        elevation: 0,
        backgroundColor:  Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        physics: BouncingScrollPhysics(),
        child: Column(
         // mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(
                left:20,
                right:20,
                bottom:  20,
              ),
              height: MediaQuery.of(context).size.height * 0.25,
              decoration: const BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(36),
                  bottomRight: Radius.circular(36),
                ),),
              child: Column(
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width*0.6,
                        child: Text('Welcome to Property Finder', style: Theme.of(context).textTheme.headline5?.copyWith(
                            color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const Spacer(),
                      Image.asset('assets/logo.png',width: 100,height: 100,)
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ActionChip(
                        labelPadding: EdgeInsets.symmetric(horizontal: 30,vertical: 2),
                          label: Text("Sell"),
                          labelStyle: TextStyle(color: Colors.blueAccent,fontSize: 18),
                          onPressed: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (_) => addProperty()));
                          }),
                      const SizedBox(
                        width: 20,
                      ),
                      ActionChip(
                          labelPadding: EdgeInsets.symmetric(horizontal: 30,vertical: 2),
                          labelStyle: TextStyle(color: Colors.blueAccent,fontSize: 18),
                          label: Text("Buy"),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => SearchProperty()));
                          }),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20,),
            // GestureDetector(
            //     onTap: (){
            //       Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>C1()));
            //     },
            //     child: Text("search")),
            TitleWithMoreBtn(title: "Properties",press: () {
              Navigator.pushNamed(
                  context, SearchProperty.routeName);

                         },),

            SizedBox(
              height: 265,
              child: FutureBuilder(
                future: FirebaseFirestore.instance
                    .collection('ads')
                    .where('uid', isNotEqualTo:loggedinuser.uid)
                    .get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return  Center(
                        child:spinKit(color: Colors.black)
                    );
                  }
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                      itemCount: (snapshot.data! as dynamic).docs.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot snap =
                        (snapshot.data! as dynamic).docs[index];
                        return  AdTile(
                            snap: snap);
                      });
                },
              ),
            ),
            SizedBox(height: 20,),
            TitleWithMoreBtn(title: "My Properties",press: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => myproperty()));
            },),
            SizedBox(
              height: 265,
              child: FutureBuilder(
                future: FirebaseFirestore.instance
                    .collection('ads')
                    .where('uid', isEqualTo:loggedinuser.uid)
                    .get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return  Center(
                      child:spinKit(color: Colors.black)
                    );
                  }
                  return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: (snapshot.data! as dynamic).docs.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot snap =
                        (snapshot.data! as dynamic).docs[index];
                        return  AdTile(
                            snap: snap);
                      });
                },
              ),
            ),



          ],
        ),
      ),
      drawer: NavigationDrawerWidget(),
    );
  }


}
