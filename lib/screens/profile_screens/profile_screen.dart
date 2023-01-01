import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/user_model.dart';
import 'package:flutter_application_1/repository/auth_methods.dart';
import 'package:flutter_application_1/screens/login_and_signup/login_screen.dart';
import 'package:flutter_application_1/screens/login_and_signup/registration_screen.dart';
import 'package:flutter_application_1/screens/profile_screens/change_profile_screen.dart';
import 'package:flutter_application_1/utils/loader.dart';
import 'package:flutter_application_1/utils/toast.dart';
import 'package:provider/provider.dart';

import '../../provider/user_provider.dart';

class profilesetting extends StatefulWidget {
  @override
  State<profilesetting> createState() => _profilesettingState();
}

class _profilesettingState extends State<profilesetting> {
  final TextEditingController _addController = TextEditingController();
  final TextEditingController _fnameController = TextEditingController();
  final TextEditingController _lnameController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _addController.dispose();
    _fnameController.dispose();
    _lnameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final UserModel loggedInUser = Provider.of<UserProvider>(context).getUser;
    _addController.text = loggedInUser.address ?? "";
    _fnameController.text = loggedInUser.firstname ?? "";

    _lnameController.text = loggedInUser.secondname ?? "";
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.blue,
        title: const Text('User Profile'),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            Container(
              height: 210,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue, Colors.blueAccent.shade200],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  stops: [0.5, 0.9],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CircleAvatar(
                    backgroundColor: Colors.white70,
                    minRadius: 60.0,
                    child: loggedInUser.profilePic == ""
                        ? const CircleAvatar(
                            radius: 53,
                            backgroundImage:
                                AssetImage('assets/profilePic.png'))
                        : CircleAvatar(
                            radius: 53,
                            backgroundImage: NetworkImage(
                              loggedInUser.profilePic!,
                            )),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: RawMaterialButton(
                      elevation: 2,
                      fillColor: Colors.black,
                      //splashColor: Colors.greenAccent,
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => ChangeProfileScreen()));
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: SizedBox(
                        height: 30,
                        width: 120,
                        child: Center(
                          child:Text(
                                  'Change Pic',
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.white.withOpacity(0.7)),
                                ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              color: Colors.white,
              child: Column(
                children: <Widget>[
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    child: Column(
                      children: <Widget>[
                        ListTile(
                          trailing: Icon(
                            Icons.edit_outlined,
                            color: Colors.black,
                          ),
                          title: const Text(
                            'First Name',
                            style: TextStyle(
                              color: Colors.blueAccent,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: TextField(
                            controller: _fnameController,
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.black.withOpacity(0.7)),
                            decoration: const InputDecoration(
                              hintText: 'Enter first Name',
                              hintStyle: TextStyle(
                                fontSize: 18,
                              ),
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                            ),
                          ),
                        ),
                        const Divider(),
                        ListTile(
                          trailing: Icon(
                            Icons.edit_outlined,
                            color: Colors.black,
                          ),
                          title: const Text(
                            'Last Name',
                            style: TextStyle(
                              color: Colors.blueAccent,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: TextField(
                            controller: _lnameController,
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.black.withOpacity(0.7)),
                            decoration: const InputDecoration(
                              hintText: 'Enter Last Name',
                              hintStyle: TextStyle(
                                fontSize: 18,
                              ),
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                            ),
                          ),
                        ),
                        const Divider(),
                        ListTile(
                          title: const Text(
                            'Email',
                            style: TextStyle(
                              color: Colors.blueAccent,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              '${loggedInUser.email}',
                              style: const TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                        const Divider(),
                        ListTile(
                          title: const Text(
                            'Phone',
                            style: TextStyle(
                              color: Colors.blueAccent,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              loggedInUser.phone ?? '',
                              style: const TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                        const Divider(),
                        ListTile(
                          trailing: Icon(
                            Icons.edit_outlined,
                            color: Colors.black,
                          ),
                          title: const Text(
                            'Address',
                            style: TextStyle(
                              color: Colors.blueAccent,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: TextField(
                            controller: _addController,
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.black.withOpacity(0.7)),
                            decoration: const InputDecoration(
                              hintText: 'Enter Address',
                              hintStyle: TextStyle(
                                fontSize: 18,
                              ),
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: RawMaterialButton(
                      elevation: 2,
                      fillColor: Colors.blue,
                      //splashColor: Colors.greenAccent,
                      onPressed: () async {
                        if (_fnameController.text.isEmpty ||
                            _lnameController.text.isEmpty ||
                            _addController.text.isEmpty) {
                          showFlagMsg(
                              context: context,
                              msg: 'Enter all required fields',
                              textColor: Colors.red);
                          return null;
                        }
                          setState(() {
                            _isLoading = true;
                          });
                          String res = await AuthMethods().updateUser(
                              fName: _fnameController.text,
                              lName: _lnameController.text,
                              address: _addController.text,
                              context: context,
                              userdata: loggedInUser);
                          setState(() {
                            _isLoading = false;
                          });
                          if (res != 'success') {
                            showFlagMsg(
                                context: context,
                                msg: res,
                                textColor: Colors.red);
                          } else {
                            showToast('Account Updated Successfully');
                          }

                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: SizedBox(
                        height: 40,
                        width: 200,
                        child: Center(
                          child: _isLoading
                              ? spinKit(color: Colors.black)
                              : Text(
                                  'Update Profile',
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white.withOpacity(0.7)),
                                ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: RawMaterialButton(
                      elevation: 2,
                      fillColor: Colors.blue,
                      //splashColor: Colors.greenAccent,
                      onPressed: () {
                        AuthMethods().signOut();
                        Navigator.of(context)
                            .pushReplacement(MaterialPageRoute(builder: (context) => loginscreen()));
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: SizedBox(
                        height: 40,
                        width: 200,
                        child: Center(
                          child: _isLoading
                              ? spinKit(color: Colors.black)
                              : Text(
                            'Log Out',
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.white.withOpacity(0.7)),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
