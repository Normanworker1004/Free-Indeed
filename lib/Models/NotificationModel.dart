import 'package:equatable/equatable.dart';

class NotificationModel with EquatableMixin {
  final String? id;
  final String? entityId;
  final String? notificationText;
  final String? notificationType;
  final String? timeStamp;
  final String? timeStampNew;
  final String? userCognitoId;
  final bool? success;

  NotificationModel({
    required this.id,
    required this.entityId,
    required this.notificationText,
    required this.notificationType,
    required this.userCognitoId,
    required this.timeStamp,
    required this.timeStampNew,
    required this.success,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> jsonObject) {
    String? id;
    String? notificationText;
    String? timeStamp;
    String? notificationType;
    String? entityId;
    String? userCognitoId;
    String? timeStampNew;

    id = jsonObject["id"].toString();
    entityId = jsonObject["entityId"].toString();
    notificationText = jsonObject["notification"];
    timeStamp = jsonObject["created"];
    notificationType = jsonObject["notificationType"];
    userCognitoId = jsonObject["userCognitoId"];
    timeStampNew = jsonObject["timeStampNew"];

    return NotificationModel(
      id: id,
      entityId: entityId,
      notificationText: notificationText,
      userCognitoId: userCognitoId,
      notificationType: notificationType,
      timeStampNew: timeStampNew,
      timeStamp: timeStamp,
      success: true,
    );
  }

  @override
  String toString() {
    return '''NotificationModel:
    id: $id,
    notificationText: $notificationText,
    timeStamp: $timeStamp,
    timeStampNew: $timeStampNew,
    success: $success,
    ''';
  }

  @override
  List<Object?> get props => [id];
}
