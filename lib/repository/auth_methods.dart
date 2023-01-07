
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/user_model.dart';
import 'package:flutter_application_1/provider/user_provider.dart';
import 'package:flutter_application_1/repository/storage_methods.dart';
import 'package:provider/provider.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserModel> getUserDetails() async {
    User currentUser = _auth.currentUser!;
    DocumentSnapshot snap =
        await _firestore.collection('users').doc(currentUser.uid).get();
    return UserModel.fromMap(snap.data() as Map<String, dynamic>);
  }
  Future<String> resetPassword({
    required String email,
  }) async {
    String res = "some error occurred";
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }



  Future<String> updateUser({
    required String fName,
    required String lName,
    required String address,
    required UserModel userdata,
    required BuildContext context
  }) async {
    String res = "Some error occurred";
    try {

      UserModel user = UserModel(
        uid: userdata.uid,
        email:userdata.email,
        firstname: fName,
        secondname:lName,
        phone: userdata.phone,
        address: address,
        profilePic: userdata.profilePic
      );
      await _firestore
          .collection('users')
          .doc(userdata.uid)
          .update(user.toMap());

      UserProvider _userProvider = Provider.of(context, listen: false);
      await _userProvider.refreshUser();
      res = 'success';
    } catch (e) {
      res = e.toString();
    }
    return res;
  }


  Future<String> deleteUserByAdmin({
    required UserModel userdata
  }) async {
    String res = "Some error occurred";
    try {
      await _firestore
          .collection('users')
          .doc(userdata.uid).delete();
      res = 'success';
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  // Future<String> updatePhone({
  //   required String phone,
  // }) async {
  //   String res = "Some error occurred";
  //   try {
  //
  //     await _firestore
  //         .collection('users')
  //         .doc(_auth.currentUser!.uid)
  //         .update({
  //       'phone':phone,
  //     });
  //     res = 'success';
  //   } catch (e) {
  //     res = e.toString();
  //   }
  //   return res;
  // }

  Future<String> updateProfilePic({
    required Uint8List file,
    required BuildContext context,
  }) async {
    String res = "some error occurred";
    try {
      String photoUrl = await StorageMethods().uploadImageToStorage('profilePics',file,false);
      await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .update({'profilePic': photoUrl});
      UserProvider _userProvider = Provider.of(context, listen: false);
      await _userProvider.refreshUser();
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }


  Future<String> updateUsersProfilePic({
    required Uint8List file,
    required UserModel user,
    required BuildContext context,
  }) async {
    String res = "some error occurred";
    try {
      String photoUrl = await StorageMethods().uploadImageToStorage('profilePics',file,false);
      await _firestore
          .collection('users')
          .doc(user.uid)
          .update({'profilePic': photoUrl});
      UserProvider _userProvider = Provider.of(context, listen: false);
      await _userProvider.refreshUser();
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> updatePhoneNo({
    required String phoneNo,
    required BuildContext context,
  }) async {
    String res = "some error occurred";
    print('phone no in function ' +phoneNo);
    print('_auth.currentUser!.uid');
    try {
      await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .update({'phone': phoneNo});
      UserProvider _userProvider = Provider.of(context, listen: false);
      await _userProvider.refreshUser();
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }





  Future<void> signOut() async {
    await _auth.signOut();
  }


}
