import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../infrastructure/models/user.dart';
import '../infrastructure/services/auth.dart';
import '../infrastructure/services/user.dart';

enum SignUpStatus { Initial, Registered, Registering, Failed }

enum ValidatedStatus { Validated, NotValidated }

class SignUpBusinessLogic with ChangeNotifier {
  SignUpStatus _status = SignUpStatus.Initial;
  ValidatedStatus _vStatus = ValidatedStatus.NotValidated;

  SignUpStatus get status => _status;

  void setState(SignUpStatus status) {
    _status = status;
    notifyListeners();
  }

  AuthServices _authServices = AuthServices.instance();

  UserServices _userServices = UserServices();

  ///Register new user and Add its details in Firestore
  Future registerNewUser(
      {required String email,
      required String password,
      required UserModel userModel,
      required BuildContext context}) async {
    _status = SignUpStatus.Registering;
    notifyListeners();

    return await _authServices
        .signUp(
      context,
      email: email,
      password: password,
    )
        .then((User? user) async {
      if (user != null) {
        setState(SignUpStatus.Registered);

        await _userServices.createUser(context,
            model: userModel, userID: user.uid);

        _authServices.signOut();
      } else {
        setState(SignUpStatus.Failed);
      }
    });
  }
}
