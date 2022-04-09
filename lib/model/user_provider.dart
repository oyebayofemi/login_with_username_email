import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:login_with_username_email/model/userModel.dart';
import 'package:login_with_username_email/services/auth_controller.dart';

class UserProvider extends ChangeNotifier {
  UserModel? currentData;

  void getUserData() async {
    UserModel userModel;
    var value = await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    if (value.exists) {
      userModel = UserModel(
        email: value.get('email'),
        regNO: value.get('regNO'),
        uid: value.get('uid'),
        url: value.get('url'),
        username: value.get('username'),
      );
      currentData = userModel;
      notifyListeners();
    }
  }

  UserModel? get currentUserData {
    return currentData;
  }
}
