import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login_with_username_email/model/userModel.dart';
import 'package:login_with_username_email/shared/snackbar.dart';

class AuthController extends ChangeNotifier {
  UserModel? user;

  late bool _isSigningIn;

  AuthController() {
    _isSigningIn = false;
  }

  bool get isSigningIn => _isSigningIn;

  set isSigningIn(bool isSigningIn) {
    _isSigningIn = isSigningIn;
    notifyListeners();
  }

  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Returns the current [User] if they are currently signed-in, or null if not.
  User? get getCurrentUser => _auth.currentUser;

  /// Notifies about changes to the user's sign-in state (such as sign-in or sign-out).
  Stream<User?> authChanges() => _auth.authStateChanges();

  Future<UserModel> getUserDetails() async {
    User currentUser = _auth.currentUser!;

    DocumentSnapshot documentSnapshot =
        await _firestore.collection('users').doc(currentUser.uid).get();

    notifyListeners();

    return UserModel.fromSnap(documentSnapshot);
  }

  Future signUp(
      {required String email,
      required String password,
      required String username,
      required String regNO,
      required BuildContext context}) async {
    isSigningIn = true;
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      user = UserModel(
          email: email,
          regNO: regNO,
          uid: userCredential.user!.uid,
          username: username);

      await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .set(user!.toJson());

      if (userCredential.user != null) {
        return userCredential.user!;
      }
      isSigningIn = false;
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
        showSnackBar(context, "The password provided is too weak.");
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
        showSnackBar(context, "An account already exists for that email.");
      } else if (e.code == 'invalid-email') {
        print('Invalid email.');
        showSnackBar(context, "Invalid email.");
      }
    } catch (e) {
      isSigningIn = false;
      print(e);
    }
  }

  Future signin(
      {required String email,
      required String password,
      required BuildContext context}) async {
    isSigningIn = true;
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      isSigningIn = false;

      notifyListeners();
    } on FirebaseAuthException catch (e) {
      isSigningIn = false;
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        showSnackBar(context, "No user found for that email.");
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
        showSnackBar(context, "Wrong password provided for that user.");
      } else if (e.code == 'invalid-email') {
        print('Invalid email.');
        showSnackBar(context, "Invalid email.");
      } else if (e.code == 'user-disabled') {
        print('This user has been disabled.');
        showSnackBar(context, "This user has been disabled");
      } else if (e.code == 'too-many-requests') {
        print('Too Many requests.');
        showSnackBar(context, "Too Many requests");
      } else if (e.code == 'operation-not-allowed') {
        print('This operation isnt allowed.');
        showSnackBar(context, "This operation isnt allowed");
      }
      notifyListeners();
    }
  }

  Future signout() async {
    await FirebaseAuth.instance.signOut();
    // nbvawait GoogleSignIn.signOut();
    user = null;
    notifyListeners();
  }
}
