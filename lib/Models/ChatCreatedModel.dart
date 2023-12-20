import 'ParticipantModel.dart';

class ChatCreatedModel {
  final String? id;
  final String? displayName;
  final String? participantFrom;
  final String? participantTo;
  bool? isGroup;
  final bool? success;
  bool? isGroupAdmin;
  List<ParticipantModel>? groupParticipants;

  ChatCreatedModel({
    required this.id,
    required this.displayName,
    required this.participantFrom,
    required this.participantTo,
    this.isGroupAdmin,
    this.isGroup,
    this.groupParticipants,
    required this.success,
  });

  factory ChatCreatedModel.fromJson(Map<String, dynamic> jsonObject) {
    String? id;
    String? displayName;
    String? participantFrom;
    String? participantTo;

    id = jsonObject["chatId"].toString();
    displayName = jsonObject["displayName"];
    participantTo = jsonObject["participantTo"];
    participantFrom = jsonObject["participantFrom"];

    return ChatCreatedModel(
      id: id,
      displayName: displayName,
      participantFrom: participantFrom,
      participantTo: participantTo,
      success: true,
    );
  }

  @override
  String toString() {
    return '''ChatCreatedModel:
    id: $id,
    displayName: $displayName,
    participantFrom: $participantFrom,
    success: $success,
    participantTo: $participantTo,
    ''';
  }
}
