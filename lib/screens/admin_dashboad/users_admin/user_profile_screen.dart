import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/user_model.dart';
import 'package:flutter_application_1/repository/auth_methods.dart';
import 'package:flutter_application_1/screens/admin_dashboad/users_admin/change_user_profile_pic_screen.dart';
import 'package:flutter_application_1/screens/login_and_signup/login_screen.dart';
import 'package:flutter_application_1/screens/login_and_signup/registration_screen.dart';
import 'package:flutter_application_1/utils/constant.dart';
import 'package:flutter_application_1/utils/loader.dart';
import 'package:flutter_application_1/utils/toast.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';


class UserProfileScreen extends StatefulWidget {
  final UserModel user;

  const UserProfileScreen({super.key, required this.user});
  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
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
    _addController.text = widget.user.address ?? "";
    _fnameController.text = widget.user.firstname ?? "";
    _lnameController.text = widget.user.secondname ?? "";
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.blue,
        title:  Text("${widget.user.firstname}'s Profile"),
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
                    child: widget.user.profilePic == ""
                        ? const CircleAvatar(
                            radius: 53,
                            backgroundImage:
                                AssetImage('assets/profilePic.png'))
                        : CircleAvatar(
                            radius: 53,
                            backgroundImage: NetworkImage(
                              widget.user.profilePic!,
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
                                builder: (_) => ChangeUserProfilePicScreen(user: widget.user,)));
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
                              '${widget.user.email}',
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
                              widget.user.phone ?? '',
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
                              userdata: widget.user);
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
                            Navigator.pop(context);
                          }

                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: SizedBox(
                        height: 40,
                        width: 240,
                        child: Center(
                          child: _isLoading
                              ? spinKit(color: Colors.black)
                              : Text(
                                  "Update ${widget.user.firstname.toString().substring(0,3)}'s Profile",
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
                      onPressed: () async {
                        if(widget.user.email==kAdminEmail){
                          showToast('Admin account cannot be deleted');
                          return;
                        }
                        String res = await AuthMethods().deleteUserByAdmin(
                            userdata: widget.user);
                        setState(() {
                          _isLoading = false;
                        });
                        if (res != 'success') {
                          showFlagMsg(
                              context: context,
                              msg: res,
                              textColor: Colors.red);
                        } else {
                          showToast('Account Deleted Successfully');
                          Navigator.pop(context);
                        }

                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: SizedBox(
                        height: 40,
                        width: 240,
                        child: Center(
                          child: _isLoading
                              ? spinKit(color: Colors.black)
                              : Text(
                            "delete ${widget.user.firstname.toString().substring(0,3)}'s Profile",
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
