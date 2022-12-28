// import 'package:flutter/material.dart';
// import 'package:flutter_application_1/search_screen/search_screen.dart';
//
// class C1 extends StatefulWidget {
//   static const routeName="c1";
//
//   @override
//   State<C1> createState() => _C1State();
// }
//
// class _C1State extends State<C1> {
//   static var store;
//
// final options=[
//   'city',
//   'resOrCom',
//
// ];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(18.0),
//           child: Container(
//             width: 200,
//             height: 200,
//             color: Colors.blue,
//           child: Center(
//             child: Column(
//               children: [
//                 Center(
//                   child: DropdownButton(
//  value: store,
//                     items: options.map((obj) {
//                       return  DropdownMenuItem(child: Text(obj.toString()), value: obj.toString(), );
//                     }).toList(),
//                     onChanged: (value) {
//    setState(() {
//      store=value;
//    });
//                   },
//
//                   ),
//                 ),
//
//                 GestureDetector(
//                     onTap: (){
//                       Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>SearchProperty(store:store)));
//                     },
//                     child: Text("submit"))
//               ],
//             ),
//           ),
//           ),
//         ),
//       ),
//     );
//   }
// }
