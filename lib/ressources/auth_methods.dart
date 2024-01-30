import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram_flutter/ressources/storage_methods.dart';
import 'package:instagram_flutter/models/user.dart' as model;

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // sign up user
  Future<String> signUpUser({
    required String email,
    required String password,
    required String username,
    required String bio,
    required Uint8List file,
  }) async {
    String res = "Some error occured";
    try {
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          username.isNotEmpty ||
          bio.isNotEmpty) {
        // register user with firbase
        // this step gets stored into the authetication tab of firebase
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        print(cred.user!.uid);

        String photoUrl = await StorageMethods()
            .uploadImageToStorage('profilePics', file, false);

        model.User user = model.User(
            username: username,
            uid: cred.user!.uid,
            email: email,
            bio: bio,
            followers: [],
            following: [],
            photoUrl: photoUrl);

        //Store additional data to the data base
        await _firestore
            .collection('users')
            .doc(cred.user!.uid)
            .set(user.toJson()); // !-> makes sure it's not null
        res = "success";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> loginUser(
      {required String email, required String password}) async {
    String res = "Some errored Occured";

    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        //throws exception when creds are wrong
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        res = 'success';
        print(res);
      } else {
        res = "Please fill in all fields";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
}
