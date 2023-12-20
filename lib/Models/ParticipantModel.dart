
import 'package:equatable/equatable.dart';

class ParticipantModel with EquatableMixin {
  final String? cognitoId;
  final String? userName;
  final bool? success;

  ParticipantModel({
    required this.cognitoId,
    required this.userName,
    required this.success,
  });

  factory ParticipantModel.fromJson(Map<String, dynamic> jsonObject) {
    String? cognitoId;
    String? userName;

    cognitoId = jsonObject["cognitoId"].toString();
    userName = jsonObject["userName"].toString();

    return ParticipantModel(
      cognitoId: cognitoId,
      userName: userName,
      success: true,
    );
  }

  @override
  String toString() {
    return '''ParticipantModel:
    id: $cognitoId,
    username: $userName,
    success: $success,
    ''';
  }

  @override
  List<Object?> get props => [cognitoId];
}
