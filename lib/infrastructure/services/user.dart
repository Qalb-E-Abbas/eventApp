import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/user.dart';

class UserServices {
  ///Create User
  Future<void> createUser(BuildContext context,
      {required UserModel model, required String userID}) async {
    DocumentReference docRef =
        FirebaseFirestore.instance.collection('userCollection').doc(userID);
    await docRef.set(model.toJson(docRef.id));
  }
  ///Fetch User Data
  Future<UserModel> fetchUserData(String uid) {
    return FirebaseFirestore.instance
        .collection('userCollection')
        .doc(uid)
        .get()
        .then((event) => event.data() == null
            ? UserModel()
            : UserModel.fromJson(event.data()!));
  }
}
