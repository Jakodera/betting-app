import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class FirebaseUserAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<FirebaseUser> registerUser(String email, String password) async {
    try {
      AuthResult authResult = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      return authResult.user;
    } on PlatformException catch (err) {
      throw Exception(err.toString());
    }
  }

  Future<FirebaseUser> loginUser(String email, String password) async {
    try {
      AuthResult authResult = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return authResult.user;
    } on PlatformException catch (err) {
      throw Exception(err.toString());
    }
  }

  Future<bool> isLogged() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user != null;
  }

  Future<FirebaseUser> currentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user;
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<File> getImage() async {
    File image = await ImagePicker.pickImage(source: ImageSource.gallery);
    return image;
  }

  Future<StorageReference> uplodadImage(File imageName) async {
    String baseName = basename(imageName.path);
    StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child(baseName);
    StorageUploadTask uploadTask = firebaseStorageRef.putFile(imageName);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    print(taskSnapshot);
    return firebaseStorageRef;
  }

  Future<void> userData(String email, String password, String userId,
      String username, String fileName) async {
    await Firestore.instance.collection("users").
    document(userId).setData({
      "email": email,
      "uid": userId,
      "password": password,
      "username": username,
      "userAvatar": fileName,
      "availableFunds": "200.00",
      "totalBets": 0,
      "profits": "0.0",
      "winRate": 0,
      "form": "0.0",
      "biggestWin": "0.0",
      "averageStake": "0.0",
      "averageOdd": "0.0",
      "moneyLost": "0.0",
      "totalStake": "0.0",
      "totalOdd": "0.0",
      "ticketsWon": 0,
      "ticketsLost": 0
    }).catchError((e) {
      e.message.toString();
    });
  }
}
