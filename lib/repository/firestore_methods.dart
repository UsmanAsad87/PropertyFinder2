import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/ad_model.dart';
import 'package:flutter_application_1/model/user_model.dart';
import 'package:flutter_application_1/repository/storage_methods.dart';
import 'package:flutter_application_1/screens/registration_screen.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> uploadAd(
    String title,
    String type,
    String price,
    String area,
    String city,
    String desc,
    String purpose,
    Uint8List file,
    String address,
  ) async {
    String res = "Some error occurred";
    try {
      String adImageUrl =
          await StorageMethods().uploadImageToStorage('ads', file, true);

      String adId = const Uuid().v1();

      UserModel user = UserModel();
      await FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get()
          .then((value) {
        user = UserModel.fromMap(value.data());
      });

      AdModel ad = AdModel(
          title: title,
          uid: user.uid!,
          adId: adId,
          username: user.firstname!,
          adImageUrl: adImageUrl,
          resOrComm: type,
          area: area,
          city: city,
          price: price,
          description: desc,
          datePublished: DateTime.now(),
          purpose: purpose,
          address: address,
          isReported: false, reportReason: '');
      _firestore.collection('ads').doc(adId).set(ad.toJson());

      res = "success";
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<String> reportAd(
    String adId,
    String reason,
  ) async {
    String res = "Some error occurred";
    try {
      print('reason :' + reason);

      AdModel adModel = AdModel(
          title: '',
          uid: '',
          adId: adId,
          username: '',
          datePublished: '',
          adImageUrl: '',
          resOrComm: '',
          area: '',
          city: '',
          price: '',
          description: '',
          purpose: '',
          address: '',
          isReported: false,
          reportReason: '');
      await FirebaseFirestore.instance
          .collection("ads")
          .doc(adId)
          .get()
          .then((value) {
        adModel = AdModel.fromMap(value.data()!);
      });

      AdModel repAd = AdModel(
          title: adModel.title,
          uid: adModel.uid,
          adId: adModel.adId,
          username: adModel.username,
          adImageUrl: adModel.adImageUrl,
          resOrComm: adModel.resOrComm,
          area: adModel.area,
          city: adModel.city,
          price: adModel.price,
          description: adModel.description,
          datePublished: adModel.datePublished,
          purpose: adModel.purpose,
          address: adModel.address,
          isReported: true,
          reportReason: reason);
      _firestore.collection('ads').doc(adId).update(repAd.toJson());
      print(repAd.toJson());

      res = "Ad reported succesfully";
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<String> deleteAd(
      String adId,
      ) async{
    String res = "Some error occurred";
    try {
      _firestore.collection('ads').doc(adId).delete();
      res = "Ad Deleted successfully";
    } catch (e) {
      res = e.toString();
    }
    return res;

  }
}
