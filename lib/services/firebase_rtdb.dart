import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:fun_app/models/odd_model.dart';
import 'package:fun_app/providers/ticket_validation_provider.dart';

class FirebaseRTDB {
  static String today = DateTime.now().toString().substring(0, 10);

  static Future<void> matchStatusQuery(TicketValidationProvider matchProvider) async { 
    List<OddModel> _models = [];
    await FirebaseDatabase.instance
    .reference()
    .child("2020-03-07")
    .once()
    .then((DataSnapshot snap) {
      var keys = snap.value.keys;
      var data = snap.value;
      for(var key in keys) {
        var model = OddModel.fromDbJson(data[key]);
        if(data[key]["pick"] != "") {
          _models.add(model); 
        }
      }
    });
    matchProvider.finishedMatches = _models;
  }
}
