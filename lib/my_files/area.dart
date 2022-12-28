import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../Getx/search_controller.dart';
import '../search_screen/components/adtile.dart';
import '../search_screen/components/header_with_searchbox.dart';
import '../search_screen/search_screen.dart';
//for filtering the area;
class Area extends StatefulWidget {
static const routeName="area";
  const Area({Key? key}) : super(key: key);

  @override
  State<Area> createState() => _AreaState();
}

class _AreaState extends State<Area> {
  final searchController = Get.put(SearchController());
//filter options
  final options=[
    '8',
    '4',
    '5',
    'all'
  ];
  var store='8';

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final data =ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
        body:
        Column(
          children: [
            HeaderWithSearchBox(size: size,),
            searchController.searchText==''?


            Expanded(
                child: Column(
                    children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const TitleWithCustomUnderline(text: 'Property for Sell',),

                            Row(
                              children: [
                                Text("Area", style: TextStyle(fontSize: 17),),
SizedBox(width: 10,),
                                Padding(
                                  padding: const EdgeInsets.only(right: 18.0),
                                  child: Container(
                                    child:  DropdownButton(
                                      value: store,
                                      items: options.map((obj) {
                                        return  DropdownMenuItem(child: Text(obj.toString()), value: obj.toString(), );
                                      }).toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          store=value.toString();
                                       if(store=="all"){
                                         Navigator.pushReplacementNamed(context, SearchProperty.routeName);
                                       }
                                        });
                                      },

                                    ),),
                                ),
                              ],
                            ),


                          ]),

                      Expanded(
                          child: FutureBuilder(
                            future: FirebaseFirestore.instance
                                .collection('ads')
                                .where('area',
                                isEqualTo: store,
                              // 'title',
                              // searchController.searchText.toString(),
                              // isGreaterThanOrEqualTo: searchController.searchText.toString()

                            )
                                .get(),
                            builder: (context,
                                AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                                snapshot) {
                              if (!snapshot.hasData) {
                                print('no data');
                                return const Center(
                                  child: CircularProgressIndicator(
                                  ),
                                );
                              }
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                print('waiting');
                                return const Center(
                                  child: CircularProgressIndicator(
                                  ),
                                );
                              }

                              if (snapshot.data!.docs.isEmpty) {
                                return Padding(
                                  padding:
                                  EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children:[
                                      Expanded(child: SizedBox()),
                                      Center(child: const Text('No ads found')),
                                      Expanded(child: SizedBox()),

                                      TextButton(
                                        child: const Text(
                                          "See all Ads",
                                          style: TextStyle(fontSize: 12),
                                        ),
                                        onPressed: () {
                                          searchController.searchText =RxString('');
                                          print(searchController.searchText);
                                          setState(() {

                                          });
                                        },
                                      )
                                    ],
                                  ),
                                );
                              }
                              else {
                                return   GridView.builder(
                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,childAspectRatio: 2/3),
                                  itemCount: snapshot.data!.docs.length,
                                  itemBuilder: (context, index) =>  AdTile(
                                    snap: snapshot.data!.docs[index].data(),
                                  ),

                                );
                              }

                            },
                          )
                      ),
                    ])
            ):
            Expanded(
              child: FutureBuilder(
                future: FirebaseFirestore.instance
                    .collection('ads')
                    .where('area',
                    // 'title',
                    // searchController.searchText.toString(),
                    isEqualTo: store

                ).where(
                    'title',
                    isEqualTo: searchController.searchText.toString()
                )
                    .get(),
                builder: (context,
                    AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                    snapshot) {
                  if (!snapshot.hasData) {
                    print('no data');
                    return const Center(
                      child: CircularProgressIndicator(
                      ),
                    );
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    print('waiting');
                    return const Center(
                      child: CircularProgressIndicator(
                      ),
                    );
                  }

                  if (snapshot.data!.docs.isEmpty) {
                    return Padding(
                      padding:
                      EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children:[
                          Expanded(child: SizedBox()),
                          Center(child: const Text('No ads found')),
                          Expanded(child: SizedBox()),

                          TextButton(
                            child: const Text(
                              "See all Ads",
                              style: TextStyle(fontSize: 12),
                            ),
                            onPressed: () {
                              searchController.searchText =RxString('');
                              print(searchController.searchText);
                              setState(() {

                              });
                            },
                          )
                        ],
                      ),
                    );
                  }
                  else {
                    return   GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,childAspectRatio: 2/3),
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) =>  AdTile(
                        snap: snapshot.data!.docs[index].data(),
                      ),

                    );
                  }

                },
              ),
            ),



          ],
        )  );

  }
}
