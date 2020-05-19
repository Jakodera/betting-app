import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fun_app/models/odd_model.dart';

class TicketMatchesStream {
  final String uid;
  final String ticketId;

  final _db = Firestore.instance;

  TicketMatchesStream(this.uid, this.ticketId);

  Stream<List<OddModel>> matches() {
    return _db
        .collection("users")
        .document(uid)
        .collection("tickets")
        .document(ticketId)
        .collection("matches")
        .orderBy("time", descending: false)
        .snapshots()
        .map((snap) => snap.documents
            .map((doc) => OddModel.fromJson(doc.data, doc.documentID))
            .toList());
  }

}
