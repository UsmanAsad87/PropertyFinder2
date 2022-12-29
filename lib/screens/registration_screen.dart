// ignore_for_file: unnecessary_new, prefer_const_constructors, camel_case_types, unused_local_variable, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/user_model.dart';
import 'package:flutter_application_1/screens/photp_screen.dart';
//import 'package:flutter_application_1/screens/home_screen.dart';
//import 'package:flutter_application_1/screens/verify_screen.dart';
import 'package:fluttertoast/fluttertoast.dart';

class registrationscreen extends StatefulWidget {
  const registrationscreen({Key? key}) : super(key: key);

  @override
  State<registrationscreen> createState() => _registrationscreenState();
}

class _registrationscreenState extends State<registrationscreen> {
  final _auth = FirebaseAuth.instance;
  //form
  final _formkey = GlobalKey<FormState>();
  final firstnameEditingController = new TextEditingController();
  final secondnameEditingController = new TextEditingController();
  final emailEditingController = new TextEditingController();
  final passwordEditingController = new TextEditingController();
  final confirmpasswordEditingController = new TextEditingController();
  
  final addressEditingController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    final firstnamefield = TextFormField(
        autofocus: false,
        controller: firstnameEditingController,
        keyboardType: TextInputType.name,
        validator: (value) {
          RegExp regex = new RegExp(r'^.{3,}$');
          if (value!.isEmpty) {
            return ("First Name cannot be Empty");
          }
          if (!regex.hasMatch(value)) {
            return ("Enter a Valid name(Min. 3 Character)");
          }
          return null;
        },
        onSaved: (value) {
          firstnameEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
            prefixIcon: Icon(Icons.account_circle),
            contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
            hintText: "First Name",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            )));

    final secondnamefield = TextFormField(
        autofocus: false,
        controller: secondnameEditingController,
        keyboardType: TextInputType.name,
        validator: (value) {
          if (value!.isEmpty) {
            return ("Second Name cannot be Empty");
          }
          return null;
        },
        onSaved: (value) {
          secondnameEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
            prefixIcon: Icon(Icons.account_circle),
            contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
            hintText: "Second Name",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            )));

    final emailfield = TextFormField(
        autofocus: false,
        controller: emailEditingController,
        keyboardType: TextInputType.emailAddress,
        validator: (value) {
          if (value!.isEmpty) {
            return ("Please Enter Your Email");
          }
          if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
              .hasMatch(value)) {
            return ("Please Enter a valid email");
          }
          return null;
        },
        onSaved: (value) {
          emailEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
            prefixIcon: Icon(Icons.mail),
            contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
            hintText: "Email",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            )));

    final passwordfield = TextFormField(
        autofocus: false,
        controller: passwordEditingController,
        obscureText: true,
        validator: (value) {
          RegExp regex = new RegExp(r"(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*\W)");
          if (value!.isEmpty) {
            return ("Password is required for SignUp");
          }
          if (!regex.hasMatch(value)) {
            return ("Password should contain Capital,small letter & Number & Special");
          }
          return null;
        },
        onSaved: (value) {
          passwordEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
            prefixIcon: Icon(Icons.vpn_key),
            contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
            hintText: "Password",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            )));

    final confirmpasswordfield = TextFormField(
        autofocus: false,
        controller: confirmpasswordEditingController,
        obscureText: true,
        validator: (value) {
          if (value!.isEmpty) {
            return ("Password is required for SignUp");
          }
          if (confirmpasswordEditingController.text !=
              passwordEditingController.text) {
            return "Password don't match";
          }
          return null;
        },
        onSaved: (value) {
          confirmpasswordEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
            prefixIcon: Icon(Icons.vpn_key),
            contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
            hintText: "Confirm Password",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            )));

    final addressfield = TextFormField(
        autofocus: false,
        controller: addressEditingController,
        keyboardType: TextInputType.streetAddress,
        validator: (value) {
          if (value!.isEmpty) {
            return ("Please Enter Your Address");
          }
          return null;
        },
        onSaved: (value) {
          addressEditingController.text = value!;
        },
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
            prefixIcon: Icon(Icons.add_home_rounded),
            contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
            hintText: "Address",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            )));

    final signupbutton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.blue,
      child: MaterialButton(
        padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () {
          signUp(emailEditingController.text, passwordEditingController.text);
        },
        child: Text(
          "SignUp",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.red),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(36.0),
              child: Form(
                key: _formkey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 180,
                      child: Image.asset(
                        "assets/images.jpg",
                        fit: BoxFit.contain,
                      ),
                    ),
                    firstnamefield,
                    SizedBox(height: 15),
                    secondnamefield,
                    SizedBox(height: 15),
                    emailfield,
                    SizedBox(height: 15),
                    addressfield,
                    SizedBox(height: 15),
                    passwordfield,
                    SizedBox(height: 15),
                    confirmpasswordfield,
                    SizedBox(height: 15),
                    signupbutton,
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void signUp(String email, String password) async {
    //try {
    //await FirebaseAuth.instance.createUserWithEmailAndPassword(
    //email: emailEditingController.text.trim(),
    //password: passwordEditingController.text.trim(),
    //);
    //} on FirebaseAuthException catch (e) {
    //print(e);
    //Fluttertoast.showToast(msg: e.toString());
    //}

    if (_formkey.currentState!.validate()) {
      await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) => {postdetailstofirestore()})
          .catchError((e) {
        Fluttertoast.showToast(msg: e!.message);
      });
    }
  }

  postdetailstofirestore() async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;
    UserModel usermodel = UserModel();

    usermodel.email = user!.email;
    usermodel.uid = user.uid;
    usermodel.firstname = firstnameEditingController.text;
    usermodel.secondname = secondnameEditingController.text;
    usermodel.address = addressEditingController.text;
    usermodel.phone='';
    usermodel.profilePic='';

    await firebaseFirestore
        .collection("users")
        .doc(user.uid)
        .set(usermodel.toMap());
    Fluttertoast.showToast(
        msg: "Account created Successfully Enter phone number for verification :) ");

    Navigator.pushAndRemoveUntil(
        (context),
        MaterialPageRoute(builder: (context) => photpscreen()),
        (route) => false);
  }
}
