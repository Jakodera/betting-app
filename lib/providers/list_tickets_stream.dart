import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fun_app/models/user_ticket.dart';

class TicketListStream {
  String docId;
  TicketListStream(this.docId);

  final _db = Firestore.instance;

  Stream<List<UserTicket>> getTicket() {
    return _db
        .collection("users")
        .document(docId)
        .collection("tickets")
        .orderBy('ticketNum', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.documents
            .map((document) =>
                UserTicket.fromMap(document.data, document.documentID))
            .toList());
  }
}
