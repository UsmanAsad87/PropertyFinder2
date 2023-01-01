import 'package:flutter/material.dart';
import 'package:flutter_application_1/Getx/search_controller.dart';
import 'package:get/get.dart';

const double kDefaultPadding =20.0;
class SubHeaderHomeWithSearchBox extends StatefulWidget {

  // TextEditingController store=TextEditingController();

   SubHeaderHomeWithSearchBox({
    Key? key,
    required this.size,
  }) : super(key: key);

  final Size size;

  @override
  State<SubHeaderHomeWithSearchBox> createState() => _SubHeaderHomeWithSearchBoxState();
}

class _SubHeaderHomeWithSearchBoxState extends State<SubHeaderHomeWithSearchBox> {
  final TextEditingController searchController = TextEditingController();
  bool isShowSearch = false;
  var store="area";
  final options=[
    'area',
    'resOrCom',
    'title',
  ];

  @override
// void didChangeDependencies() {
//   setState(() {
//     widget.store="city";
//   });
//   // TODO: implement didChangeDependencies
//     super.didChangeDependencies();
//   }
// void initState() {
//     // Navigator.popAndPushNamed(context, SearchProperty.routeName, arguments: store);
//     // TODO: implement initState
//     super.initState();
//   }
  @override
  void dispose() {
    searchController.dispose();

    super.dispose();
  }
@override
  // // void initState() {
  // // setState(() {
  // //   widget.store="city";
  // // });
  // // TODO: implement initState
  //   super.initState();
  // }
  @override
  Widget build(BuildContext context) {
    final SearchHomeController c = Get.find();
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
        padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
        height: 54,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, 10),
              blurRadius: 50,
              color: Colors.blueAccent.withOpacity(0.23),
            )
          ],
        ),
        child: Row(
          children: [
            Expanded(child:
            TextFormField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: "Search",
                hintStyle: TextStyle(
                  color: Colors.blueAccent.withOpacity(0.5),
                ),
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                suffixIcon: GestureDetector(
                    onTap: (){

                      setState(() {
                        c.searchText=RxString(searchController.text);
                        //print("On submit "+c.searchText.toString());
                        searchController.clear();
                      });
                    },
                    child: Icon(Icons.search)),
              ),
              onFieldSubmitted: (String _) {
                setState(() {
                  c.searchText=RxString(searchController.text);
                  //print("On submit "+c.searchText.toString());
                  searchController.clear();
                });
              },
            ),
            ),
            // Image.asset("assets/images.jpg"),

          ],

        ),
      ),
    );
  }
}
