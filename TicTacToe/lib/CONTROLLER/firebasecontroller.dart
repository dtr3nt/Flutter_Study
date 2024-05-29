import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:tictac/MODEL/fireGameData.dart';

class FirebaseController {
  static updateFireGameData(FireGameData fireGameUpdate, String docId) async {
    await FirebaseFirestore.instance
        .collection(FireGameData.COLLECTION)
        .doc(docId)
        .set(fireGameUpdate.serialize());
  }

  //
  static Future<String> setupFireGameData(FireGameData fireGameData) async {
    DocumentReference ref = await FirebaseFirestore.instance
        .collection(FireGameData.COLLECTION)
        .add(fireGameData.serialize());
    return ref.id;
  }

  //
  static Future<List<FireGameData>> getFireGameData() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(FireGameData.COLLECTION)
        .get();

    var result = <FireGameData>[];
    if (querySnapshot != null && querySnapshot.docs.length != 0) {
      for (var doc in querySnapshot.docs) {
        result.add(FireGameData.deserialized(doc.data(), doc.id));
      }
    }
    return result;
  }

  //
  static Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  //
  static Future signIn(String email, String password) async {
    UserCredential auth =
        await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return auth.user;
  }
  //
}
