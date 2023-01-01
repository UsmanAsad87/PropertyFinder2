// ignore_for_file: camel_case_types

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/user_model.dart';
import 'package:flutter_application_1/provider/user_provider.dart';
import 'package:flutter_application_1/screens/admin_dashboad/all_ads_admin/components/admin_ad_tile.dart';
import 'package:flutter_application_1/screens/login_and_signup/registration_screen.dart';
import 'package:provider/provider.dart';

class myproperty extends StatefulWidget {
  const myproperty({Key? key}) : super(key: key);

  @override
  State<myproperty> createState() => _mypropertyState();
}

class _mypropertyState extends State<myproperty> {

  @override
  Widget build(BuildContext context) {

    final UserModel user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text(user.firstname?.toUpperCase()??""),
        centerTitle: false,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    user.profilePic==""
                        ? const CircleAvatar(
                        radius: 40,
                        backgroundImage: AssetImage('assets/profilePic.png'))
                        : CircleAvatar(
                        radius: 40,
                        backgroundImage: NetworkImage(
                          user.profilePic!,
                        )),
                  ],
                ),
                    Column(
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(top: 15, left: 5),
                      child: Text(
                        "${user.firstname??""} ${user.secondname??""}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(top: 1, left: 5),
                      child: Text(
                        user.email??"",
                      ),
                    )
                  ],
                ),

              ],
            ),
          ),
          const Divider(),
          Expanded(
            child: FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection('ads')
                  .where('uid', isEqualTo:user.uid)
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Colors.blueAccent,
                    ),
                  );
                }
                return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,childAspectRatio: 2/3),
                    itemCount: (snapshot.data! as dynamic).docs.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot snap =
                      (snapshot.data! as dynamic).docs[index];

                      return AdminAdTile(
                          snap: snap);
                    });
              },
            ),
          )
        ],
      ),
    );
  }
}
