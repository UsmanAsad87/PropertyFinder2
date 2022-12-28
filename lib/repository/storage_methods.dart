import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class StorageMethods{
  final FirebaseStorage _storage =FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //adding image to firebasestorage
  Future<String> uploadImageToStorage(String childName,Uint8List file,bool isPost) async{
    print('int the storage1');

    Reference ref = await _storage.ref().child(childName).child(_auth.currentUser!.uid);

    if(isPost){
      String id= const Uuid().v1();
      ref=ref.child(id);
    }
    print('int the storage2');


    UploadTask uploadTask = ref.putData(file);

    TaskSnapshot snap= await uploadTask;
    String downloadUrl=await snap.ref.getDownloadURL();
    print('int the storage3');


    return downloadUrl;
    //ref.putFile(file)  if not in web
  }

}