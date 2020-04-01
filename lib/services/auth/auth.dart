
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class BaseAuth{
  Stream<String> get onAuthStateChanged;
  Future<String> signInWithEmailAndPassword(String email, String password);
  Future<String> createUserWithEmailAndPassword(String email, String password);
  Future<String> currentUser();
  Future<void> signOut();
  Future<String >createData(String email, String password, 
    String userId, String username, String fileName);
}

class Auth implements BaseAuth{
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Stream<String> get onAuthStateChanged {
    return _firebaseAuth.onAuthStateChanged.map((FirebaseUser user) => user.uid);
  }

  Future<String> signInWithEmailAndPassword(
    String email, String password) async {
    AuthResult authResult = await _firebaseAuth
        .signInWithEmailAndPassword(email: email, password: password);
      return authResult.user?.uid;
  }

  Future<String> createUserWithEmailAndPassword(
      String email, String password) async {
    AuthResult authResult = await _firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password);
    return authResult.user?.uid;
  }

  Future<String> currentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user?.uid;
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<String> createData(String email, String password, 
    String userId, String username, String fileName) async {
    final docRef = await Firestore.instance.collection("users").add({
      "email": email,
      "uid": userId,
      "password": password,
      "username": username,
      "userAvatar": fileName,
      "availableFunds": "100.00".toString(),
      "totalBets": 0,
      "profits": "0.0".toString(),
      "winRate": 0,
      "form": "0.0".toString(),
      "biggestWin": "0.0".toString(),
      "averageStake": "0.0".toString(),
      "averageOdd": "0.0".toString(),
      "longestRun": 0
    }).catchError((e) {
      e.message.toString();
    }); 
    return docRef.documentID;
  }
}
