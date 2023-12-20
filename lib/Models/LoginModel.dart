class LoginModel {
  final String? id;
  final String? username;
  final String? email;
  final String? accessToken;
  final String? idToken;
  final bool? success;
  final String? message;
  final String? refreshToken;

  LoginModel({
    required this.id,
    required this.username,
    required this.email,
    required this.accessToken,
    required this.success,
    required this.message,
    required this.refreshToken,
    required this.idToken,
  });

  factory LoginModel.fromJson(Map<String, dynamic> jsonObject) {
    String? id;
    String? username;
    String? email;
    String? accessToken;
    String? message;
    String? refreshToken;
    String? idToken;
    bool success = jsonObject["success"] ?? true;

    if (success) {
      id = jsonObject["id"];
      username = jsonObject["username"];
      email = jsonObject["email"] ?? "";
      accessToken = jsonObject["AccessToken"];
      refreshToken = jsonObject["RefreshToken"];
      idToken = jsonObject["IdToken"];
      message = "";
    } else {
      jsonObject["message"] != null
          ? message = jsonObject["message"]
          : message = "";
      return LoginModel(
          id: "",
          username: "",
          email: "",
          accessToken: "",
          refreshToken: "",
          success: success,
          message: message,
          idToken: "");
    }
    return LoginModel(
      id: id,
      username: username,
      email: email,
      accessToken: accessToken,
      success: success,
      message: message,
      refreshToken: refreshToken,
      idToken: idToken,
    );
  }

  @override
  String toString() {
    return '''LoginModel:
    id: $id,
    username: $username,
    email: $email,
    accessToken: $accessToken,
    success: $success,
    message: $message,
    idToken: $idToken,
    ''';
  }
}
