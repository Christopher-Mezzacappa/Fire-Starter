import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram_flutter/models/user.dart' as model;
import 'package:instagram_flutter/screens/profilePage.dart';

class Query {
  static Future<model.User> getUserInfo() async {
    DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    String bio = (snap.data() as Map<String, dynamic>)['bio'];
    String email = (snap.data() as Map<String, dynamic>)['email'];
    List followers = (snap.data() as Map<String, dynamic>)['followers'];
    List following = (snap.data() as Map<String, dynamic>)['following'];
    String photoUrl = (snap.data() as Map<String, dynamic>)['photoUrl'];
    String uid = (snap.data() as Map<String, dynamic>)['uid'];
    String username = (snap.data() as Map<String, dynamic>)['username'];

    model.User user = model.User(
      email: email,
      uid: uid,
      followers: followers,
      following: following,
      bio: bio,
      username: username,
      photoUrl: photoUrl,
    );

    // Return the User object
    return user;
  }

  static void updateProfilePic(String newImg) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({
      'photoUrl': newImg,
    });
  }
}
