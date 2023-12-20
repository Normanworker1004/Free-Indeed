import 'package:free_indeed/configs/Config.dart';

class ContactModel {
  final String? id;
  final String? contactName;
  final String? timeStamp;
  final ContactStatus contactStatus;
  final bool? success;

  ContactModel({
    required this.id,
    required this.contactName,
    required this.timeStamp,
    required this.success,
    required this.contactStatus,
  });

  factory ContactModel.fromJson(Map<String, dynamic> jsonObject) {
    String? id;
    String? journalText;
    String? lastMessage;
    bool success = jsonObject["success"];
    String contactStatus;

    if (success) {
      id = jsonObject["id"];
      journalText = jsonObject["journalText"];
      lastMessage = jsonObject["lastMessage"];
      contactStatus = jsonObject["contactStatus"];
    } else {
      return ContactModel(
          id: "",
          contactName: "",
          timeStamp: "",
          success: success,
          contactStatus: ContactStatus.OFFLINE);
    }
    return ContactModel(
        id: id,
        contactName: journalText,
        timeStamp: lastMessage,
        success: success,
        contactStatus: ContactStatus(contactStatus));
  }

  @override
  String toString() {
    return '''JournalModel:
    id: $id,
    username: $contactName,
    success: $success,
    lastMessage: $timeStamp,
    ContactStatus: ${contactStatus.value},
    ''';
  }
}
