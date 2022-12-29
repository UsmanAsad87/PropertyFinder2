import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/user_model.dart';
import 'package:flutter_application_1/provider/user_provider.dart';
import 'package:flutter_application_1/repository/auth_methods.dart';
import 'package:flutter_application_1/utils/loader.dart';
import 'package:flutter_application_1/utils/select_image.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../utils/toast.dart';

class ChangeUserProfilePicScreen extends StatefulWidget {
  final UserModel user;
  const ChangeUserProfilePicScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<ChangeUserProfilePicScreen> createState() => _ChangeUserProfilePicScreenState();
}

class _ChangeUserProfilePicScreenState extends State<ChangeUserProfilePicScreen> {
  Uint8List? _image;
  bool _isLoading = false;
  bool _isLoading2 = false;
  //UserModel? user;

  @override
  void initState() {
    //getUserData();
    super.initState();
  }

  // getUserData() async {
  //   setState(() {
  //     _isLoading = true;
  //   });
  //   user = await AuthMethods().getUserDetails();
  //   setState(() {
  //     _isLoading = false;
  //   });
  // }

  void selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    setState(() {
      _image = im;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      appBar: AppBar(
        leading: const BackButton(color: Colors.white),
        backgroundColor: Colors.blue,
        elevation: 0,
      ),
      body: /* _isLoading
          ? spinKit()
          : */
          Padding(
        padding: EdgeInsets.all(20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _image != null
                  ? CircleAvatar(
                      radius: 84, backgroundImage: MemoryImage(_image!))
                  : widget.user.profilePic==""
                      ? const CircleAvatar(
                          radius: 84,
                          backgroundImage: AssetImage('assets/profilePic.png'))
                      : CircleAvatar(
                          radius: 84,
                          backgroundImage: NetworkImage(
                            widget.user.profilePic!,
                          )),
              SizedBox(
                height: 20,
              ),
              _isLoading2
                  ? spinKit()
                  : SizedBox(
                      height: 20,
                    ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomCreateButton(
                      onPressed: selectImage,
                      buttonText: 'Select Image',
                      fillColor: Colors.black),
                  CustomCreateButton(
                      onPressed: () async {
                        if (_image != null) {
                          setState(() {
                            _isLoading2 = true;
                          });
                          String res = await AuthMethods().updateUsersProfilePic(user:widget.user,
                              file: _image!, context: context);
                          if (res == "success") {
                            setState(() {
                              _isLoading2 = false;
                            });
                            showToast('Profile Image Updated');
                          } else {
                            showFlagMsg(
                                context: context,
                                msg: res,
                                textColor: Colors.red);
                          }
                          setState(() {
                            _isLoading2 = false;
                          });
                        } else {
                          showFlagMsg(
                              context: context,
                              msg: 'Select an image',
                              textColor: Colors.red);
                        }
                      },
                      buttonText: 'Update',
                      fillColor:Colors.black)
                ],
              ),
              SizedBox(
                height: 60,
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class CustomCreateButton extends StatelessWidget {
  CustomCreateButton({
    required this.onPressed,
    required this.buttonText,
    required this.fillColor,
    this.isDottedBorder = false,
  });
  final Function()? onPressed;
  final String buttonText;
  final Color fillColor;
  final bool isDottedBorder;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: RawMaterialButton(
        elevation: 2,
        fillColor: fillColor,
        //splashColor: Colors.greenAccent,
        onPressed: onPressed,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),),
        child: SizedBox(
          height: 50,
          width: (MediaQuery.of(context).size.width / 2) - 30,
          child: Center(
            child: Text(
              buttonText,
              style:const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w400),
            ),
          ),
        ),
      ),
    );
  }
}
