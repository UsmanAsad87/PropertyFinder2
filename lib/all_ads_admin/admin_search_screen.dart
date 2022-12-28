import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Getx/search_controller.dart';
import 'package:flutter_application_1/all_ads_admin/components/Admin_header_with_searchbox.dart';
import 'package:flutter_application_1/all_ads_admin/components/admin_ad_tile.dart';
import 'package:flutter_application_1/my_files/practice.dart';
import 'package:flutter_application_1/screens/c1.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../my_files/area.dart';

const double kDefaultPadding = 20.0;

class AdminSearchProperty extends StatefulWidget {
  static const routeName = "/search";
  // final store;
// final String cat;

  // const SearchProperty( this.cat);

  @override
  State<AdminSearchProperty> createState() => _AdminSearchPropertyState();
}

class _AdminSearchPropertyState extends State<AdminSearchProperty> {
// var sObj;
  var s = "city";
  var siz;
  final options = [
    'Residential',
    'Commercial',
    'Area',
  ];

  var store = "residential";
  final searchAdminController = Get.put(SearchAdminController());

  void reset() {
    setState(() {
      searchAdminController.searchText = ''.obs;
    });
  }

  // _SearchPropertyState( this.store);
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Size siz = MediaQuery.of(context).size;
    final data = ModalRoute.of(context)!.settings.arguments;
    AdminHeaderWithSearchBox sObj =
        AdminHeaderWithSearchBox(size: MediaQuery.of(context).size);

    //it will enable scrolling on small device
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.blueAccent,
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context, AdminSearchProperty.routeName);
              setState(() {
                searchAdminController.searchText = ''.obs;
              });
            },
            child: Icon(Icons.arrow_back)),
        title: Text("All Ads"),
      ),
      body: Column(
        children: [
          AdminHeaderWithSearchBox(size: size),
          searchAdminController.searchText == ''
              ? Expanded(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(width: 10.w,),
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
                                      Navigator.pushNamed(
                                          context, Area.routeName,
                                          arguments: store);
                                    } else {
                                      Navigator.pushNamed(
                                          context, Practice.routeName,
                                          arguments: store);
                                    }
                                  });
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        child: StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('ads')
                              .orderBy('datePublished', descending: true)
                              .snapshots(),
                          builder: (context,
                              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                                  snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(
                                  color: Colors.blueAccent,
                                ),
                              );
                            }
                            return GridView.builder(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      childAspectRatio: 2 / 3),
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, index) => AdminAdTile(
                                snap: snapshot.data!.docs[index].data(),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                )
              :
              //Text(searchController.searchText.toString()),
              Expanded(
                  child: FutureBuilder(
                    future: FirebaseFirestore.instance
                        .collection('ads')
                        .where('title',
                            // 'title',
                            // searchController.searchText.toString(),
                            isEqualTo: searchAdminController.searchText
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
                                  searchAdminController.searchText =
                                      RxString('');
                                  print(searchAdminController.searchText);
                                  setState(() {});
                                },
                              )
                            ],
                          ),
                        );
                      } else {
                        return GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2, childAspectRatio: 2 / 3),
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) => AdminAdTile(
                            snap: snapshot.data!.docs[index].data(),
                          ),
                        );
                      }
                    },
                  ),
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
