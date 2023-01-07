// ignore_for_file: unnecessary_new, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/user_model.dart';
import 'package:flutter_application_1/repository/auth_methods.dart';
import 'package:flutter_application_1/screens/home_screen/home_screen.dart';
import 'package:flutter_application_1/screens/login_and_signup/login_screen.dart';
import 'package:flutter_application_1/screens/login_and_signup/photp_screen.dart';
import 'package:flutter_application_1/screens/login_and_signup/registration_screen.dart';
import 'package:flutter_application_1/utils/loader.dart';
import 'package:flutter_application_1/utils/toast.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

// ignore: camel_case_types
class ForgetPassScreen extends StatefulWidget {
  const ForgetPassScreen({Key? key}) : super(key: key);

  @override
  State<ForgetPassScreen> createState() => _ForgetPassScreenState();
}

// ignore: camel_case_types
class _ForgetPassScreenState extends State<ForgetPassScreen> {
// form key
  final _formkey = GlobalKey<FormState>();
  bool _isLoading = false;

//controller
  final TextEditingController emailcontroller = new TextEditingController();
  final TextEditingController passwordcontroller = new TextEditingController();

  final _auth = FirebaseAuth.instance;

  String? errorMessage;

  @override
  Widget build(BuildContext context) {
    //email field
    final emailfield = TextFormField(
        autofocus: false,
        controller: emailcontroller,
        keyboardType: TextInputType.emailAddress,
        validator: (value) {
          if (value!.isEmpty) {
            return ("Please Enter your Email");
          }
          //email validation
          if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
              .hasMatch(value)) {
            return ("Please Enter a valid email");
          }
          return null;
        },
        onSaved: (value) {
          emailcontroller.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
            prefixIcon: Icon(Icons.mail),
            contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
            hintText: "Email",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            )));

    final resetButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.blue,
      child: MaterialButton(
        padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () {
          setState(() {
            _isLoading = true;
          });
          sendResetMail(emailcontroller.text, passwordcontroller.text);
          setState(() {
            _isLoading = false;
          });
        },
        child: _isLoading
            ? spinKit()
            : Text(
                "Send Reset Email",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
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
                      height: 200,
                      child: Image.asset(
                        "assets/images.jpg",
                        fit: BoxFit.contain,
                      ),
                    ),
                    SizedBox(height: 15),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Center(
                          child: Text(
                        'Enter your email, you will receive a email to change your password',
                        textAlign: TextAlign.center,
                      )),
                    ),
                    SizedBox(height: 15),
                    emailfield,
                    SizedBox(height: 25),
                    resetButton,
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void sendResetMail(String email, String password) async {
    if (_formkey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      String res = await AuthMethods().resetPassword(email: email);
      if (res == "success") {
        setState(() {
          _isLoading = false;
        });
        showToast('Reset password email is sent.');
        await Future.delayed(Duration(milliseconds: 2000), () {}).then(
            (value) => Navigator.push(context,
                MaterialPageRoute(builder: (context) => loginscreen())));
      } else {
        showFlagMsg(context: context, msg: res, textColor: Colors.red);
      }
      setState(() {
        _isLoading = false;
      });
    }
  }
}
