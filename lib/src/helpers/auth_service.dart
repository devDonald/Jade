import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:medcare/src/helpers/user_model.dart';

class AuthService extends ChangeNotifier {
  FirebaseFirestore _db = FirebaseFirestore.instance;
  final DateTime timestamp = DateTime.now();
  final usersRef = FirebaseFirestore.instance.collection('users');
  String userId;
  bool isPremium = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  UserModel _userFromFirebaseUser(User user) {
    if (user != null) {
      userId = user.uid;
      return UserModel(userId: user.uid, email: user.email);
    } else {
      return null;
    }
  }

  Future<void> addUser(UserModel user) {
    return _db.collection('users').doc(user.userId).set(user.toJson());
  }

  Future<UserModel> fetchUser(String userId) {
    return _db
        .collection('users')
        .doc(userId)
        .get()
        .then((snapshot) => UserModel.fromSnapshot(snapshot));
  }

  Future signIn(String email, String password) async {
    try {
      final result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;
      Fluttertoast.showToast(
          msg: "Login successful",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.blue,
          textColor: Colors.white,
          fontSize: 16.0);
      //await _populateCurrentUser(result.user);

      return _userFromFirebaseUser(user);
    } catch (e) {
      Fluttertoast.showToast(
          msg: "Login Failed",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      return null;
    }
  }

  //Sign in with google

  Future createAccount(
      String email, String password, UserModel userModel) async {
    try {
      var result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User user = result.user;
      userModel.userId = user.uid;

      usersRef.doc(user.uid).set(userModel.toJson());

      return _userFromFirebaseUser(user);
    } catch (e) {
      return null;
    }
  }

  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email).then((_) {
      Fluttertoast.showToast(
          msg: "Password Reset successful",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
    }).catchError((error) {
      Fluttertoast.showToast(
          msg: "Password Reset Failed, Please input correct email",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    });
  }

  //Sign out a current user from Firebase, google and facebook.
  Future<Null> signOutUser() async {
    try {
      // Sign out with firebase
      await _auth.signOut().then((value) async {
        Fluttertoast.showToast(
            msg: "Logged out successfully",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0);
      });
      // Sign out with google

    } catch (e) {
      Fluttertoast.showToast(
          msg: e.toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }
}
