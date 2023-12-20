class UserModel {
  final String? id;
  final String? cognitoId;
  final String? username;
  final bool? hasNotifications;
  final bool? success;
  final bool? subscribed;
  late final String? status;

  UserModel({
    required this.id,
    required this.username,
    required this.hasNotifications,
    required this.success,
    required this.subscribed,
    required this.cognitoId,
    this.status,
  });

  factory UserModel.fromJson(Map<String, dynamic> jsonObject) {
    String? id;
    String? username;
    String? cognitoId;
    bool? hasNotifications;
    bool? subscribed;
    bool success = jsonObject["success"] == "1" ? true : false;
    if (success && jsonObject["data"] != null) {
      Map<String, dynamic> jsonObject1 = jsonObject["data"];

      id = jsonObject1["id"] != null ? jsonObject1["id"].toString() : "";
      username = jsonObject1["userName"] ?? "";
      hasNotifications = jsonObject1["hasNotifications"] ?? false;
      subscribed = jsonObject1["isSubscribed"] == "1" ? true : false;
      cognitoId = jsonObject1["cognitoId"];
    } else {
      return UserModel(
        id: " ",
        username: " ",
        hasNotifications: false,
        success: success,
        cognitoId: "",
        subscribed: false,
      );
    }
    return UserModel(
        id: id,
        username: username,
        hasNotifications: hasNotifications,
        success: success,
        cognitoId: cognitoId,
        subscribed: subscribed);
  }

  @override
  String toString() {
    return '''UserModel:
    id: $id,
    username: $username,
    hasNotifications: $hasNotifications,
    subscriber: $subscribed,
    success: $success,
    ''';
  }
}
