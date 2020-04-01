import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fun_app/models/odd_model.dart';
import 'package:fun_app/providers/ticket_validation_provider.dart';

class FirebaseCrud {
  String uid;
  String docId;
  FirebaseCrud(this.uid, this.docId);

  final _db = Firestore.instance;

  //Posting Info of Ticket to Firebase
  Future<DocumentReference> addTicketInfo(
      Map<String, dynamic> ticketInfo) async {
    DocumentReference docRef = await _db
        .collection("users")
        .document(docId)
        .collection("tickets")
        .add(ticketInfo);

    return docRef;
  }


  //Ading match as document to collection, I am adding more matches to same ticket
  Future<void> addMatch(
      Map<String, dynamic> match, DocumentReference docRef) async {
    await _db
        .collection("users")
        .document(docId)
        .collection("tickets")
        .document(docRef.documentID)
        .collection("matches")
        .add(match);
  }

  //Get matches from specific ticket with id
  Future<List<OddModel>> getMatches(String ticketId) async {
    List<OddModel> _model = [];
    QuerySnapshot snap = await _db
        .collection("users")
        .document(docId)
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
  Future<void> updateUserProfile(Map<String, dynamic> updateData) async {
    _db.runTransaction((transaction) async {
      DocumentSnapshot freshSnap =
          await transaction.get(_db.collection("users").document(docId));
      await transaction.update(freshSnap.reference, updateData);
    });
  }

  //Profile Query for averageOdd
  Future<double> getSummedOdd() async {
    QuerySnapshot snap = await _db
        .collection("users")
        .document(docId)
        .collection("tickets")
        .getDocuments();

    double summedOdd = 0.0;
    int bets = snap.documents.length;

    snap.documents.forEach((doc) {
      summedOdd += double.parse(doc.data["resultOdd"]);
    });

    double averageOdd = summedOdd / bets;
    return averageOdd;
  }

  //Profile Query for averageStake
  Future<double> getSummedStake() async {
    QuerySnapshot snap = await _db
        .collection("users")
        .document(docId)
        .collection("tickets")
        .getDocuments();

    double summedStake = 0.0;
    int bets = snap.documents.length;

    snap.documents.forEach((doc) {
      summedStake += doc.data["bet"];
    });

    double averageStake = summedStake / bets;
    return averageStake;
  }

  //Getting stream of matches from tickets
  Stream<List<OddModel>> matches(String ticketId) {
    return _db
      .collection("users")
      .document(docId)
      .collection("tickets")
      .document(ticketId)
      .collection("matches")
      .orderBy("time", descending: false)
      .snapshots()
      .map((snap) => snap.documents
        .map((doc) => OddModel.fromJson(doc.data, doc.documentID))
        .toList());
      
  }


  //Get all users active tickets with matches
  Future<void> userTips(TicketValidationProvider provider) async {
    List<String> ticketKeys = [];
    List<List<OddModel>> _userActiveTips = [];
    QuerySnapshot snap = await _db
        .collection("users")
        .document(docId)
        .collection("tickets")
        .getDocuments();

    snap.documents.forEach((doc) {
      ticketKeys.add(doc.documentID);
    });

    provider.ticketIds = ticketKeys;

    for (var i = 0; i < ticketKeys.length; i++) {
      QuerySnapshot snapshot = await _db
          .collection("users")
          .document(docId)
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
      .document(docId)
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

    await _db.collection("users")
      .document(docId)
      .collection("tickets")
      .document(ticketId)
      .updateData(data)
      .catchError((e) => print(e));
  }


  //Update ticket Status
  Future<void> updateTicket(String ticketId, String status) async {
    var data = Map<String, dynamic>();
    data["ticketStatus"] = status;

    await _db.collection("users")
      .document(docId)
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
    await _db.collection("users")
      .document(docId)
      .collection("tickets")
      .getDocuments()
      .then((snapshot) {
        snapshot.documents.forEach((document) {
          if(document.data["ticketStatus"] == "win") {
            winCounter++;
          } else if(document.data["ticketStatus"] == "active") {
            activeCounter++;
          }
        });
      });
      tickets.add(winCounter);
      tickets.add(activeCounter);
      return tickets;
  }

}
