import 'package:flutter/material.dart';
import 'package:flutter_application_1/Getx/search_controller.dart';
import 'package:get/get.dart';

const double kDefaultPadding =20.0;
class ReportedAdminHeaderWithSearchBox extends StatefulWidget {

  // TextEditingController store=TextEditingController();

   ReportedAdminHeaderWithSearchBox({
    Key? key,
    required this.size,
  }) : super(key: key);

  final Size size;

  @override
  State<ReportedAdminHeaderWithSearchBox> createState() => _ReportedAdminHeaderWithSearchBoxState();
}

class _ReportedAdminHeaderWithSearchBoxState extends State<ReportedAdminHeaderWithSearchBox> {
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
    final SearchRepAdminController c = Get.find();
    return Container(
      margin: const EdgeInsets.only(bottom: kDefaultPadding),
      height: widget.size.height * 0.1,
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.only(
              left:kDefaultPadding,
              right: kDefaultPadding,
              bottom: 36+ kDefaultPadding,
            ),
            height: widget.size.height * 0.1 - 27,
            decoration: const BoxDecoration(
              color: Colors.blueAccent,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(36),
                bottomRight: Radius.circular(36),
              ),),
            child: Row(
              children: [
                // Text('Property Finder', style: Theme.of(context).textTheme.headline5?.copyWith(
                //     color: Colors.white, fontWeight: FontWeight.bold),
                // ),
//                 DropdownButton(
//                     value: store,
//                     items: options.map((obj) {
//                       return  DropdownMenuItem(child: Text(obj.toString()), value: obj.toString(), );
//                     }).toList(),
//                     onChanged: (value) {
//                       setState(() {
//                         store=value.toString();
// Navigator.pushNamed(context, SearchProperty.routeName, arguments: store );
//                       });
//                     },
//
//                   ),

              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
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
          ),
        ],
      ),
    );
  }
}
