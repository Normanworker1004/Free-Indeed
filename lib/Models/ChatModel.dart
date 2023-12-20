import 'package:cloud_firestore/cloud_firestore.dart';

import '../configs/Config.dart';

class ChatMessages {
  String idFrom;
  String idTo;
  String timestamp;
  String content;
  String type;

  ChatMessages(
      {required this.idFrom,
        required this.idTo,
        required this.timestamp,
        required this.content,
        required this.type});

  Map<String, dynamic> toJson() {
    return {
      FirestoreConstants.idFrom.value: idFrom,
      FirestoreConstants.idTo.value: idTo,
      FirestoreConstants.timestamp.value: timestamp,
      FirestoreConstants.content.value: content,
      FirestoreConstants.type.value: type,
    };
  }

  factory ChatMessages.fromDocument(DocumentSnapshot documentSnapshot) {
    String idFrom = documentSnapshot.get(FirestoreConstants.idFrom.value);
    String idTo = documentSnapshot.get(FirestoreConstants.idTo.value);
    String timestamp = documentSnapshot.get(FirestoreConstants.timestamp.value);
    String content = documentSnapshot.get(FirestoreConstants.content.value);
    String type = documentSnapshot.get(FirestoreConstants.type.value);

    return ChatMessages(
        idFrom: idFrom,
        idTo: idTo,
        timestamp: timestamp,
        content: content,
        type: type);
  }


}