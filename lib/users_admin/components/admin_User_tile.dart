import 'package:flutter/material.dart';
import 'package:flutter_application_1/Getx/search_controller.dart';
import 'package:flutter_application_1/all_ads_admin/single_admin_ad_screen.dart';
import 'package:flutter_application_1/model/user_model.dart';
import 'package:flutter_application_1/reported_ads_admin/single_admin_reported_ad_screen.dart';
import 'package:flutter_application_1/users_admin/user_profile_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

const double kDefaultPadding = 20.0;

class AdminUserTile extends StatefulWidget {
  final UserModel user;
  const AdminUserTile({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  State<AdminUserTile> createState() => _AdminUserTileState();
}

class _AdminUserTileState extends State<AdminUserTile> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: (){
        final SearchUserAdminController c = Get.find();
        c.searchText=RxString('');
        Navigator.push(context, MaterialPageRoute(builder: (_)=>UserProfileScreen(user: widget.user)));
      },
      child: Container(
        width: double.infinity,
        height: 80.h,
        margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
        //padding:EdgeInsets.symmetric(horizontal: 10.w,vertical: 10.h) ,
        decoration: BoxDecoration(
          color: Colors.blueAccent,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.white70,
            radius: 33.0,
            child: widget.user.profilePic == ""
                ? CircleAvatar(
                    radius: 33,

              backgroundColor: Colors.transparent,
              child: ClipOval(
                child: Image.asset(
                  'assets/profilePic.png',
                  width: 60.w,
                  height: 70.h,
                  fit: BoxFit.cover,
                ),
              ),

            )
                : CircleAvatar(
                    radius: 33,
              backgroundColor: Colors.transparent,
                    child: ClipOval(
                      child: Image.network(
                        widget.user.profilePic!,
                        width: 60.w,
                        height: 70.h,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
          ),
          title: Text(
            "${widget.user.firstname} ${widget.user.secondname}",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            "${widget.user.email} ",
            style: TextStyle(
              color: Colors.white,
              fontSize: 14.sp,
            ),
          ),
        ),
      ),
    );
  }
}
// class _AdminUserTileState extends State<AdminUserTile> {
//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;
//     return Container(
//       height: 150,
// // color: Colors.blue,
//       //color: Colors.blueAccent.shade200,
//       margin: const EdgeInsets.only(
//         left: kDefaultPadding,
//         right: kDefaultPadding,
//         top: kDefaultPadding ,
//         //bottom: kDefaultPadding ,
//       ),
//       width: size.width * 0.4,
//       child: GestureDetector(
//         onTap: (){
//           Navigator.push(context, MaterialPageRoute(builder: (_)=>SingleAdminReportedPostScreen(ad:widget.snap)));
//         },
//         child: Column(
//           children: [
//             Container(
//               height: 140,
//               width: MediaQuery.of(context).size.width/2.2,
//               decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(12),
//                   border: Border.all(color: Colors.blueAccent),
//                   image: DecorationImage(
//                       image: NetworkImage(widget.snap['adImageUrl']), fit: BoxFit.cover)),
//             ),
//             Container(
//               padding: const EdgeInsets.all(kDefaultPadding / 2),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 // border: Border.all(color: Colors.black),
//                 boxShadow: [
//                   BoxShadow(
//                     offset: const Offset(0, 10),
//                     blurRadius: 50,
//                     color: Colors.blueAccent.withOpacity(0.23),
//                   ),
//                 ],
//                 // borderRadius: const BorderRadius.only(
//                 //     bottomLeft: Radius.circular(10),
//                 //     bottomRight: Radius.circular(10)),
//               ),
//               child: Row(
//                 children: [
//                   RichText(
//                     text: TextSpan(
//                       children: [
//                         TextSpan(
//                           text: "${widget.snap['title']}\n".toUpperCase(),
//                           style: Theme.of(context).textTheme.button,
//                         ),
//                         TextSpan(
//                           text: "${widget.snap['city']}\n".toUpperCase(),
//                           style: TextStyle(
//                             color: Colors.blueAccent.withOpacity(0.5),
//                           ),
//                         ),
//                         TextSpan(
//                           text: '\$${widget.snap['price']}',
//                           style: Theme.of(context)
//                               .textTheme
//                               .button
//                               ?.copyWith(color: Colors.blueAccent),
//                         ),
//
//
//                       ],
//                     ),
//
//                   ),
//
//
//                 ],
//               ),
//
//             ),
//             Container(
//
//               decoration: BoxDecoration(
//                   color: Colors.white,
//
//                   borderRadius: BorderRadius.only(bottomRight: Radius.circular(10),bottomLeft: Radius.circular(10)),
//                   border: Border.all(color: Colors.black)
//               ),
//               child:   Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Center(
//                     child: Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Text(widget.snap['purpose'], style: TextStyle(
//                           fontWeight: FontWeight.bold
//                       ),),
//                     ),
//                   )
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
