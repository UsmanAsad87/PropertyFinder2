import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Getx/search_controller.dart';
import 'package:flutter_application_1/all_ads_admin/components/Admin_header_with_searchbox.dart';
import 'package:flutter_application_1/all_ads_admin/components/admin_ad_tile.dart';
import 'package:flutter_application_1/model/user_model.dart';
import 'package:flutter_application_1/my_files/practice.dart';
import 'package:flutter_application_1/reported_ads_admin/components/Admin_rep_header_with_searchbox.dart';
import 'package:flutter_application_1/screens/c1.dart';
import 'package:flutter_application_1/users_admin/components/User_header_with_searchbox.dart';
import 'package:flutter_application_1/users_admin/components/admin_User_tile.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../my_files/area.dart';

const double kDefaultPadding = 20.0;

class AllUsersSearchScreen extends StatefulWidget {
  static const routeName = "/search";
  // final store;
// final String cat;

  // const SearchProperty( this.cat);

  @override
  State<AllUsersSearchScreen> createState() => _AllUsersSearchScreenState();
}

class _AllUsersSearchScreenState extends State<AllUsersSearchScreen> {
// var sObj;
  var s = "city";
  var siz;
  final options = [
    'Residential',
    'Commercial',
    'Area',
  ];

  var store = "residential";
  final searchUserAdminController = Get.put(SearchUserAdminController());

  void reset() {
    setState(() {
      searchUserAdminController.searchText = ''.obs;
    });
  }

  // _SearchPropertyState( this.store);
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Size siz = MediaQuery.of(context).size;
    final data = ModalRoute.of(context)!.settings.arguments;
    UserHeaderWithSearchBox sObj =
        UserHeaderWithSearchBox(size: MediaQuery.of(context).size);

    //it will enable scrolling on small device
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.blueAccent,
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context, AllUsersSearchScreen.routeName);
              setState(() {
                searchUserAdminController.searchText = ''.obs;
              });
            },
            child: Icon(Icons.arrow_back)),
        title: Text("All Buyers and Sellers"),
      ),
      body: Column(
        children: [
          UserHeaderWithSearchBox(size: size),
          SizedBox(height: 20.h,),
          searchUserAdminController.searchText == ''?
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .snapshots(),
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
                            searchUserAdminController.searchText =
                                RxString('');
                            print(searchUserAdminController.searchText);
                            setState(() {});
                          },
                        )
                      ],
                    ),
                  );
                } else {
                  print(searchUserAdminController.searchText + "usman a,mhjs df ");
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      UserModel user= UserModel.fromMap(snapshot.data!.docs[index].data());
                      return AdminUserTile(
                      user: user,
                    );
                    },
                  );
                }
              },
            ),
          ):
              Expanded(
                  child: FutureBuilder(
                    future: FirebaseFirestore.instance
                        .collection('users')
                        .where('firstname',
                            isGreaterThanOrEqualTo: searchUserAdminController.searchText
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
                        print('waiting   search');
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
                                  searchUserAdminController.searchText =
                                      RxString('');
                                  print(searchUserAdminController.searchText);
                                  setState(() {});
                                },
                              )
                            ],
                          ),
                        );
                      } else {
                        return ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            UserModel user= UserModel.fromMap(snapshot.data!.docs[index].data());
                            return AdminUserTile(
                              user: user,
                            );
                          },
                        );
                      }
                    },
                  ),
                ),
          SizedBox(
            height: 20,
          ),
        ],
      ),
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
            padding: const EdgeInsets.only(left: kDefaultPadding / 4),
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
              margin: const EdgeInsets.only(left: kDefaultPadding / 4),
            ),
          ),
        ],
      ),
    );
  }
}
