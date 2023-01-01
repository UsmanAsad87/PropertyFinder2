import 'package:flutter/cupertino.dart';
import 'package:flutter_application_1/repository/auth_methods.dart';

import '../model/user_model.dart';
import '../screens/login_and_signup/registration_screen.dart';

class UserProvider extends ChangeNotifier {
  UserModel? _user =UserModel(
    uid: '',
    email:'',
    firstname: '',
    secondname: '',
    phone: '',
    address: '',
  );
  final AuthMethods _authMethods = AuthMethods();

  UserModel get getUser => _user!;

  Future<void> refreshUser() async {
    UserModel user = await _authMethods.getUserDetails();
    _user = user;
    notifyListeners();
  }
}
