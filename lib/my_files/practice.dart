import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/search_screen/components/header_with_searchbox.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../Getx/search_controller.dart';
import '../search_screen/components/adtile.dart';
import '../search_screen/search_screen.dart';
//for residential and commerciAL FIlter;
class Practice extends StatefulWidget {
static const routeName="practice";

  @override
  State<Practice> createState() => _PracticeState();
}

class _PracticeState extends State<Practice> {
final searchController = Get.put(SearchController());

@override
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
final    data= ModalRoute.of(context)!.settings.arguments as String;


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
]),

        Expanded(
            child: FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection('ads')
                  .where('resOrCom',
                 isEqualTo: data
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
            .where('resOrCom',
            // 'title',
            // searchController.searchText.toString(),
            isEqualTo: data

        ).where(
              'title',
              isEqualTo: searchController.searchText.toString().trim().toLowerCase()
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
  )  );}
}
