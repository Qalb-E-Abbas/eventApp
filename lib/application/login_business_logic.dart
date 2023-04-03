import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../infrastructure/models/user.dart';
import '../infrastructure/services/auth.dart';
import '../infrastructure/services/user.dart';
import 'error_string.dart';
import 'package:event_app/application/user_provider.dart';
import 'package:event_app/configs/enums.dart';

class LoginBusinessLogic {
  UserServices _userServices = UserServices();

  Future loginUserLogic(BuildContext context,
      {required String email,
      required String password}) async {
    var login = Provider.of<AuthServices>(context, listen: false);
    var userProvider = Provider.of<UserProvider>(context, listen: false);
    return await login
        .signIn(context, email: email, password: password)
        .then((User? user) async {
      if (user != null) {
        await _userServices.fetchUserData(user.uid).then((event) {
          login.setState(Status.Authenticated);
          userProvider.saveUserDetails(event);
        });
      }
    });
  }
}
