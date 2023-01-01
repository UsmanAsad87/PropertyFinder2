// ignore_for_file: prefer_const_constructors, camel_case_types, unnecessary_this, unused_local_variable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Getx/search_controller.dart';
import 'package:flutter_application_1/model/user_model.dart';
import 'package:flutter_application_1/my_files/area.dart';
import 'package:flutter_application_1/my_files/map.dart';
import 'package:flutter_application_1/my_files/practice.dart';
import 'package:flutter_application_1/my_files/scraping.dart';
import 'package:flutter_application_1/provider/user_provider.dart';
import 'package:flutter_application_1/repository/auth_methods.dart';
import 'package:flutter_application_1/screens/add_property/addprop_screen.dart';
import 'package:flutter_application_1/screens/c1.dart';
import 'package:flutter_application_1/screens/drawer.dart';
import 'package:flutter_application_1/screens/home_screen/components/sub_header_home_with_searchbox.dart';
import 'package:flutter_application_1/screens/login_and_signup/login_screen.dart';
import 'package:flutter_application_1/screens/my_property/myprop_screen.dart';
import 'package:flutter_application_1/screens/login_and_signup/registration_screen.dart';
import 'package:flutter_application_1/screens/search_screen/search_screen.dart';
import 'package:flutter_application_1/utils/loader.dart';
import 'package:flutter_application_1/utils/title_with_more_btn.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../search_screen/components/adtile.dart';

class homescreen extends StatefulWidget {
  const homescreen({Key? key}) : super(key: key);

  @override
  State<homescreen> createState() => _homescreenState();
}

class _homescreenState extends State<homescreen> {
  var s = "city";
  var siz;
  final options = [
    'Residential',
    'Commercial',
    'Area',
  ];

  var store = "residential";
  final searchHomeController = Get.put(SearchHomeController());

  void reset() {
    setState(() {
      searchHomeController.searchText = ''.obs;
    });
  }

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
    Size size = MediaQuery.of(context).size;
    Size siz = MediaQuery.of(context).size;
    final data = ModalRoute.of(context)!.settings.arguments;
    SubHeaderHomeWithSearchBox sObj =
        SubHeaderHomeWithSearchBox(size: MediaQuery.of(context).size);
    final UserModel loggedinuser = Provider.of<UserProvider>(context).getUser;
    print(loggedinuser.phone!.length.toString());

    return Scaffold(
      appBar: AppBar(
        title: Text("Property Finder"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.blueAccent,
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
                left: 20,
                right: 20,
                bottom: 20,
              ),
              height: MediaQuery.of(context).size.height * 0.25,
              decoration: const BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(36),
                  bottomRight: Radius.circular(36),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: Text(
                          'Welcome to Property Finder',
                          style: Theme.of(context)
                              .textTheme
                              .headline5
                              ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                        ),
                      ),
                      const Spacer(),
                      Image.asset(
                        'assets/logo.png',
                        width: 100,
                        height: 100,
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ActionChip(
                          labelPadding:
                              EdgeInsets.symmetric(horizontal: 30, vertical: 2),
                          label: Text("Sell"),
                          labelStyle:
                              TextStyle(color: Colors.blueAccent, fontSize: 18),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => addProperty()));
                          }),
                      const SizedBox(
                        width: 20,
                      ),
                      ActionChip(
                          labelPadding:
                              EdgeInsets.symmetric(horizontal: 30, vertical: 2),
                          labelStyle:
                              TextStyle(color: Colors.blueAccent, fontSize: 18),
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
            SizedBox(
              height: 20,
            ),
            // GestureDetector(
            //     onTap: (){
            //       Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>C1()));
            //     },
            //     child: Text("search")),
            SubHeaderHomeWithSearchBox(size: size),

            searchHomeController.searchText == ''
                ?  Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const TitleWithCustomUnderline(
                      text: 'Property for Sell',
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 18.0),
                      child: Container(
                        child: DropdownButton(
                          value: store,
                          items: options.map((obj) {
                            return DropdownMenuItem(
                              child: Text(obj.toString()),
                              value: obj.toString().toLowerCase(),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              store = value.toString();

                              if (store == 'area') {
                                Navigator.pushNamed(context, Area.routeName,
                                    arguments: store);
                              } else {
                                Navigator.pushNamed(context, Practice.routeName,
                                    arguments: store);
                              }
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('ads')
                      .orderBy('datePublished', descending: true)
                      .snapshots(),
                  builder: (context,
                      AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                      snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: Colors.blueAccent,
                        ),
                      );
                    }
                    return GridView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, childAspectRatio: 2 / 3),
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) => AdTile(
                        snap: snapshot.data!.docs[index].data(),
                      ),
                    );
                  },
                ),
              ],
            )
                :
            //Text(searchController.searchText.toString()),
            FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection('ads')
                  .where('title',
                  // 'title',
                  // searchController.searchText.toString(),
                  isEqualTo: searchHomeController.searchText
                      .toString()
                      .trim()
                      .toLowerCase())
                  .get(),
              builder: (context,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                  snapshot) {
                if (!snapshot.hasData) {
                  print('no data');
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  print('waiting');
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (snapshot.data!.docs.isEmpty) {
                  return Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: 16, horizontal: 24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(child: SizedBox()),
                        Center(child: const Text('No ads found')),
                        Expanded(child: SizedBox()),
                        TextButton(
                          child: const Text(
                            "See all Ads",
                            style: TextStyle(fontSize: 12),
                          ),
                          onPressed: () {
                            searchHomeController.searchText = RxString('');
                            print(searchHomeController.searchText);
                            setState(() {});
                          },
                        )
                      ],
                    ),
                  );
                } else {
                  return Column(
                    children: [
                      const TitleWithCustomUnderline(
                        text: 'Property for Sell',
                      ),
                      GridView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        gridDelegate:
                        SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, childAspectRatio: 2 / 3),
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) => AdTile(
                          snap: snapshot.data!.docs[index].data(),
                        ),
                      ),
                    ],
                  );
                }
              },
            ),
            SizedBox(
              height: 20,
            ),
            GestureDetector(
                onTap: () {
                  reset();
                },
                child: Text("See all"))
          ],
        ),
      ),
      drawer: NavigationDrawerWidget(),
    );
  }
}

class TitleWithCustomUnderline extends StatelessWidget {
  const TitleWithCustomUnderline({
    Key? key,
    this.text = "",
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      height: 24,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20.0 / 4),
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              color: Colors.blueAccent.withOpacity(0.2),
              height: 7,
              margin: const EdgeInsets.only(left: 20.0 / 4),
            ),
          ),
        ],
      ),
    );
  }
}
