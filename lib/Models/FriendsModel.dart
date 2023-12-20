import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class FriendModel extends Equatable {
  final String? cognitoId;
  final String? username;
  bool? isFriend;
  final bool? success;

  FriendModel({
    required this.cognitoId,
    required this.username,
    required this.isFriend,
    required this.success,
  });

  factory FriendModel.fromJson(Map<String, dynamic> jsonObject) {
    String? id;
    String? username;
    bool? isFriend;
    // bool success = jsonObject["success"];

    id = jsonObject["cognitoId"];
    username = jsonObject["userName"];
    isFriend = jsonObject["isFriend"];

    return FriendModel(
      cognitoId: id,
      username: username,
      isFriend: isFriend,
      success: true,
    );
  }

  factory FriendModel.fromFriendsJson(Map<String, dynamic> jsonObject) {
    String? id;
    String? username;
    bool? isFriend;
    // bool success = jsonObject["success"];

    id = jsonObject["friendCognitoId"];
    username = jsonObject["friendName"];
    isFriend = true;

    return FriendModel(
      cognitoId: id,
      username: username,
      isFriend: isFriend,
      success: true,
    );
  }

  @override
  String toString() {
    return '''FriendModel:
    cognitoId: $cognitoId,
    username: $username,
    isFriend: $isFriend,
    success: $success,
    ''';
  }

  @override
  List<Object?> get props => [
        cognitoId,
      ];
}
