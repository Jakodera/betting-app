
import 'dart:core';
import 'package:firebase_database/firebase_database.dart';

class MatchApiProvider {
  String today = DateTime.now().toString().substring(0, 10);

  DatabaseReference ref = FirebaseDatabase.instance.reference();

  DatabaseReference getDb() {
    DatabaseReference game = ref.child("2020-01-26");
    return game;
  }
}
