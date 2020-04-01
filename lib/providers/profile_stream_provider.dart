

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fun_app/models/player_model.dart';

class ProfileStreamProvider {

  String docId;
  ProfileStreamProvider(this.docId);

  final _db = Firestore.instance;

  Stream<PlayerModel> playerProfile() {
    return _db
        .collection("users")
        .document(docId)
        .snapshots()
        .map((snapshot) => PlayerModel.fromMap(snapshot.data))
        .handleError((e) =>print(e));
  }

}