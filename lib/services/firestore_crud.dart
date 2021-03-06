import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fun_app/models/odd_model.dart';
import 'package:fun_app/providers/ticket_validation_provider.dart';
import 'package:meta/meta.dart';

class FirebaseCrud {
  final String uid;
  FirebaseCrud({@required this.uid});

  final _db = Firestore.instance;

  //Posting Info of Ticket to Firebase
  Future<DocumentReference> addTicketInfo(
      Map<String, dynamic> ticketInfo) async {
    DocumentReference docRef = await _db
        .collection("users")
        .document(uid)
        .collection("tickets")
        .add(ticketInfo);

    return docRef;
  }

  // Convert Matches into Maps -------------> Helper Function
  List<Map<String, dynamic>> convertMatches(List<OddModel> newMatches) {
    List<Map<String, dynamic>> parsedMatches = List();
    OddModel oddModel = OddModel();
    for(var match in newMatches) {
      parsedMatches.add(oddModel.oddModelToMap(match));
    }
    return parsedMatches;
  }

  //Ading match as document to collection, I am adding more matches to same ticket
  Future<String> addMatches(
      List<Map<String, dynamic>> matches, DocumentReference docRef) async {
        String successStr;
        int successCovert = 0;
    for(var i = 0; i < matches.length; i++) {
      await _db
        .collection("users")
        .document(uid)
        .collection("tickets")
        .document(docRef.documentID)
        .collection("matches")
        .add(matches[i]);
      successCovert++;
    }
    (successCovert == matches.length) ? successStr = "Success!" : successStr = "Failure!";
    return successStr;
  }

  //Get matches from specific ticket with id
  Future<List<OddModel>> getMatches(String ticketId) async {
    List<OddModel> _model = [];
    QuerySnapshot snap = await _db
        .collection("users")
        .document(uid)
        .collection("tickets")
        .document(ticketId)
        .collection("matches")
        .orderBy("time", descending: false)
        .getDocuments();

    snap.documents.forEach((doc) {
      _model.add(OddModel.fromJson(doc.data, doc.documentID));
    });
    return _model;
  }

  //Updating User Profile on Bet Submit
  Future<String> updateUserProfile(Map<String, dynamic> updateData) async {
    String successString;
    _db.runTransaction((transaction) async {
      DocumentSnapshot freshSnap =
          await transaction.get(_db.collection("users").document(uid));
      await transaction.update(freshSnap.reference, updateData);
      successString = "User Profile Updated!";
    });
    return successString;
  }

  //Get all users active tickets with matches
  Future<void> userTips(TicketValidationProvider provider) async {
    List<String> ticketKeys = [];
    List<List<OddModel>> _userActiveTips = [];
    QuerySnapshot snap = await _db
        .collection("users")
        .document(uid)
        .collection("tickets")
        .where("ticketStatus", isEqualTo: "active")
        .getDocuments();

    snap.documents.forEach((doc) {
      ticketKeys.add(doc.documentID);
    });

    provider.ticketIds = ticketKeys;

    for (var i = 0; i < ticketKeys.length; i++) {
      QuerySnapshot snapshot = await _db
          .collection("users")
          .document(uid)
          .collection("tickets")
          .document(ticketKeys[i])
          .collection("matches")
          .getDocuments();

      List<OddModel> _models = [];
      snapshot.documents.forEach((doc) {
        _models.add(OddModel.fromJson(doc.data, doc.documentID));
      });
      _userActiveTips.add(_models);
    }
    provider.ticketMatches = _userActiveTips;
  }

  //Update match status when match is finished
  Future<void> updateMatchStatus(
      String ticketId, String status, String matchId) async {
    var data = Map<String, dynamic>();
    data["status"] = status;

    await _db
        .collection("users")
        .document(uid)
        .collection("tickets")
        .document(ticketId)
        .collection("matches")
        .document(matchId)
        .updateData(data)
        .catchError((e) => print(e));
  }

  // Set ticket process to finished
  Future<void> updateTicketProcess(String ticketId) async {
    var data = Map<String, dynamic>();
    data["processFinished"] = "yes";

    await _db
        .collection("users")
        .document(uid)
        .collection("tickets")
        .document(ticketId)
        .updateData(data)
        .catchError((e) => print(e));
  }

  //Update ticket Status
  Future<void> updateTicket(String ticketId, String status) async {
    var data = Map<String, dynamic>();
    data["ticketStatus"] = status;

    await _db
        .collection("users")
        .document(uid)
        .collection("tickets")
        .document(ticketId)
        .updateData(data)
        .catchError((e) => print(e));
  }

  //Get all winning tickets
  Future<List<int>> numberOfWinningOrActiveTickets() async {
    List<int> tickets = [];
    int winCounter = 0;
    int activeCounter = 0;
    await _db
        .collection("users")
        .document(uid)
        .collection("tickets")
        .getDocuments()
        .then((snapshot) {
      snapshot.documents.forEach((document) {
        if (document.data["ticketStatus"] == "win") {
          winCounter++;
        } else if (document.data["ticketStatus"] == "active") {
          activeCounter++;
        }
      });
    });
    tickets.add(winCounter);
    tickets.add(activeCounter);
    return tickets;
  }
}
