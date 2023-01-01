// ignore_for_file: unnecessary_new, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/user_model.dart';
import 'package:flutter_application_1/repository/auth_methods.dart';
import 'package:flutter_application_1/screens/home_screen/home_screen.dart';
import 'package:flutter_application_1/screens/login_and_signup/photp_screen.dart';
import 'package:flutter_application_1/screens/login_and_signup/registration_screen.dart';
import 'package:fluttertoast/fluttertoast.dart';

// ignore: camel_case_types
class loginscreen extends StatefulWidget {
  const loginscreen({Key? key}) : super(key: key);

  @override
  State<loginscreen> createState() => _loginscreenState();
}

// ignore: camel_case_types
class _loginscreenState extends State<loginscreen> {

// form key
final _formkey = GlobalKey<FormState>();

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
      validator: (value)
      {
        if(value!.isEmpty)
        {
          return ("Please Enter your Email");
        }
        //email validation
        if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
              .hasMatch(value)) {
            return ("Please Enter a valid email");
          }
          return null;
      },
      onSaved: (value)
      {
        emailcontroller.text = value!;
      },
      textInputAction:  TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.mail),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Email",
        border:OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        )
       ));

    final passwordfield = TextFormField(
      autofocus: false,
      controller: passwordcontroller,
      obscureText: true,
      validator: (value)
       {
          RegExp regex = new RegExp(r'^.{6,}$');
          if (value!.isEmpty) {
            return ("Password is required for login");
          }
          if (!regex.hasMatch(value)) {
            return ("Enter Valid Password(Min. 6 Character)");
          }
          return null;
        },
      onSaved: (value)
      {
        passwordcontroller.text = value!;
      },
      textInputAction:  TextInputAction.done,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.vpn_key),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Password",
        border:OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        )
       ));
      
    final loginbutton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.blue,
      child: MaterialButton(
        padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () {
            signIn(emailcontroller.text, passwordcontroller.text);
          },
        child: Text("Login",textAlign: TextAlign.center,style: TextStyle(
          fontSize: 20,color: Colors.white, fontWeight: FontWeight.bold
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
              padding: const EdgeInsets.all(36.0),
              child: Form(
                key: _formkey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 200,
                      child: Image.asset("assets/images.jpg",fit: BoxFit.contain,),
                    ),
                    SizedBox(height: 45),
                    emailfield,
                    SizedBox(height: 25),
                    passwordfield,
                    SizedBox(height: 35),
                    loginbutton,
                    SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("Don't have an account?"),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => registrationscreen()));
                          },
                          child: Text(" Sign up",style: TextStyle(color: Colors.redAccent,fontWeight: FontWeight.w600, fontSize: 15),
                          ),
                        )
                      ],
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
  void signIn(String email, String password) async {
    if(_formkey.currentState!.validate()){
      await _auth.signInWithEmailAndPassword(email: email, password: password).then((uid) async{
        //This try block is checking if Admin has deleted the account or not if deleted then not go to homepage
        try {

          User currentUser = _auth.currentUser!;
          DocumentSnapshot snap =
          await FirebaseFirestore.instance.collection('users').doc(currentUser.uid).get();
          UserModel user= UserModel.fromMap(snap.data() as Map<String, dynamic>);
          print("User  :"+user.phone.toString());
          if(user.phone ==''){
            Fluttertoast.showToast(
                msg: "Phone number not verified.\nEnter phone number for verification :) ");

            Navigator.pushAndRemoveUntil(
                (context),
                MaterialPageRoute(builder: (context) => photpscreen()),
                    (route) => false);
          }else{
            Fluttertoast.showToast(msg: "Login Successful");
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => homescreen()));
          }
        } catch (e) {
          AuthMethods().signOut();
          Fluttertoast.showToast(msg: "Account is deleted by Admin");
          return;
        }

      }).catchError((e)
      {
        Fluttertoast.showToast(msg: e!.message);
      });

    }
  }
}
