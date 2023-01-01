// ignore_for_file: prefer_const_constructors, camel_case_types, unnecessary_this, unused_local_variable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/user_model.dart';
import 'package:flutter_application_1/my_files/map.dart';
import 'package:flutter_application_1/my_files/scraping.dart';
import 'package:flutter_application_1/screens/add_property/addprop_screen.dart';
import 'package:flutter_application_1/screens/admin_dashboad/all_ads_admin/admin_search_screen.dart';
import 'package:flutter_application_1/screens/admin_dashboad/reported_ads_admin/admin_Rep_search_screen.dart';
import 'package:flutter_application_1/screens/admin_dashboad/users_admin/all_users_search_screen.dart';
import 'package:flutter_application_1/screens/c1.dart';
import 'package:flutter_application_1/screens/drawer.dart';
import 'package:flutter_application_1/screens/login_and_signup/login_screen.dart';
import 'package:flutter_application_1/screens/my_property/myprop_screen.dart';
import 'package:flutter_application_1/screens/login_and_signup/registration_screen.dart';
import 'package:flutter_application_1/utils/loader.dart';
import 'package:flutter_application_1/utils/title_with_more_btn.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../my_files/practice.dart';
import '../../provider/user_provider.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({Key? key}) : super(key: key);

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  @override
  void initState() {
    super.initState();
  }

  List<Map<String, dynamic>> topicsList = [
    {
      'title': 'All Property Ads',
      'img': 'assets/property.png',
    },
    {
      'title': 'Buyers & Sellers',
      'img': 'assets/users.png',
    },
    {
      'title': 'Reported Property Ads',
      'img': 'assets/reported.png',
    },
  ];
  @override
  Widget build(BuildContext context) {
    final UserModel loggedinuser = Provider.of<UserProvider>(context).getUser;
    List<Function()> onPress=[
          () {
        Navigator.push(context, MaterialPageRoute(builder: (_)=> AdminSearchProperty()));
      },
          () {
            Navigator.push(context, MaterialPageRoute(builder: (_)=> AllUsersSearchScreen()));
      },
          () {
            Navigator.push(context, MaterialPageRoute(builder: (_)=> AdminRepSearchProperty()));
      },
    ];

    return Scaffold(
      body: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height * 0.33,
            decoration: const BoxDecoration(
              color: Colors.blueAccent,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(36),
                bottomRight: Radius.circular(36),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 30.h,),
                IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.arrow_back,color: Colors.white,)),
                SizedBox(height: 10.h,),
                Padding(
                  padding: EdgeInsets.only(left: 30.0.w,right: 40.w),
                  child: Row(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: Text(
                          'Admin DashBoard',
                          style: Theme.of(context).textTheme.headline5?.copyWith(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const Spacer(),
                      Image.asset(
                        'assets/man.png',
                        width: 70,
                        height: 70,
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 40.h,
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Text(
                          'Total Ads',
                          style:
                          TextStyle(
                              color: Colors.white,
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w600),

                        ),
                        StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('ads')
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
                            return Text(snapshot.data!.docs.length.toString(),style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.sp,
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.w600),);
                          },
                        ),
                      ],
                    ),
                    Container(height: 25.h,width: 2.w,color: Colors.white24,),
                    Column(
                      children: [
                        Text(
                          'Total Users',
                          style:
                          TextStyle(
                              color: Colors.white,
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w600),

                        ),
                        StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('users')
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
                            return Text(snapshot.data!.docs.length.toString(),style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.sp,
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.w600),);
                          },
                        ),
                      ],
                    ),
                  ],
                ),

              ],
            ),
          ),
          SizedBox(
            height: 10.h,
          ),
          Padding(
            padding:  EdgeInsets.symmetric(horizontal:20.0.w ,vertical: 10.0.h),
            child: GridView.builder(
                itemCount: 3,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.4,
                  crossAxisSpacing: 10.0,
                ),
                itemBuilder: (context, index) {
                  return TopicCard(
                      title: topicsList[index]['title'],
                      img: topicsList[index]['img'],
                      onPress:onPress[index]);
                }),
          ),
        ],
      ),
    );
  }
}

class TopicCard extends StatelessWidget {
  const TopicCard({
    Key? key,
    required this.title,
    required this.img,
    required this.onPress,
  }) : super(key: key);

  final String title;
  final String img;
  final Function() onPress;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 10.h, bottom: 10.h),
          child: Container(
            height: 127.h,
            width: size.width / 2 - 25.w,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(img,fit: BoxFit.cover,)
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 10.h, bottom: 10.h),
          child: InkWell(
            onTap: onPress,
            child: Container(
              height: 127.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.black.withOpacity(0.5),
              ),
              width: size.width / 2 - 25.w,
              child: Center(
                child: Text(
                  title,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
