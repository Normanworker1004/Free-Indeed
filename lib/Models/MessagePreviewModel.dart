import 'package:equatable/equatable.dart';

class MessagePreviewModel extends Equatable {
  final String? id;
  final String? displayName;
  final String? groupName;
  final String? lastMessage;
  final String? lastMessageDateTime;
  final bool? success;
  final bool? isGroup;
  final bool? isGroupAdmin;

  const MessagePreviewModel({
    required this.id,
    required this.displayName,
    required this.groupName,
    required this.isGroupAdmin,
    required this.lastMessage,
    required this.lastMessageDateTime,
    required this.isGroup,
    required this.success,
  });

  factory MessagePreviewModel.fromJson(Map<String, dynamic> jsonObject) {
    String? id;
    String? displayName;
    String? groupName;
    String? lastMessage;
    String? lastMessageDateTime;
    bool? isGroup;
    bool? isGroupAdmin;

    id = jsonObject["id"].toString();
    displayName = jsonObject["displayName"];
    groupName = jsonObject["groupName"];
    lastMessage = jsonObject["lastMessage"] ?? "";
    lastMessageDateTime = jsonObject["lastMessageDateTime"] ?? "";
    isGroup = jsonObject["isGroup"] == 1;
    isGroupAdmin = jsonObject["isGroupAdmin"] == 1;
    return MessagePreviewModel(
      id: id,
      displayName: displayName,
      lastMessage: lastMessage,
      lastMessageDateTime: lastMessageDateTime,
      groupName: groupName,
      success: true,
      isGroupAdmin: isGroupAdmin,
      isGroup: isGroup,
    );
  }

  @override
  String toString() {
    return '''MessagePreviewModel:
    id: $id,
    username: $displayName,
    email: $groupName,
    success: $success,
    lastMessage: $lastMessage,
    ''';
  }

  @override
  List<Object?> get props => [id];
}
