// ignore_for_file: camel_case_types, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/login_screen.dart';
import 'package:flutter_application_1/screens/registration_screen.dart';

class test extends StatefulWidget {
  const test({Key? key}) : super(key: key);

  @override
  State<test> createState() => _testState();
}

class _testState extends State<test> {
  @override
  Widget build(BuildContext context) {

    final loginbutton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.blue,
      child: MaterialButton(
        padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
        minWidth: MediaQuery.of(context).size.width/1.5,
        onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context)=> loginscreen()));
          },
         child: Text("Login",textAlign: TextAlign.center,style: TextStyle(
          fontSize: 16,color: Colors.white, fontWeight: FontWeight.bold
        ),),
      ),
    );


    final signupbutton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.blue,
      child: MaterialButton(
        padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
        minWidth: MediaQuery.of(context).size.width/1.5,
        onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context)=> registrationscreen()));
          },
        child: Text("SignUp",textAlign: TextAlign.center,style: TextStyle(
          fontSize: 16,color: Colors.white, fontWeight: FontWeight.bold
        ),),
      ),
    );



    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(50.0),
              child: Form(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Column(
                // ignore: prefer_const_literals_to_create_immutables
                children: <Widget>[
                  SizedBox(
                    height: 50,
                  ),
                  Text(
                    "Welcome to Property Finder",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.black
                    ),   
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text("Browse thousands of houses for rent or sale on the Property Finder app in pakistan",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 12,
                  ),)
                ],
              ),
                    SizedBox(
                      height: 350,
                      child: Image.asset("assets/images.jpg",fit: BoxFit.contain,),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      // ignore: prefer_const_literals_to_create_immutables
                      children: <Widget>[
                        Text("Already have an Account?"),],
                    ),
                    SizedBox(height: 15),
                    loginbutton,
                    SizedBox(height: 15),
                    signupbutton,
                    SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}