
class SignUpModel {
  final String? id;
  final String? username;
  final String? email;
  final String? password;
  final bool? success;
  final String? message;
  final String? refreshToken;

  SignUpModel({
    required this.id,
    required this.username,
    required this.email,
    required this.password,
    required this.success,
    required this.message,
    required this.refreshToken,
  });

  factory SignUpModel.fromJson(Map<String, dynamic> jsonObject) {
    String? id;
    String? username;
    String? email;
    String? password;
    String? message;
    String? refreshToken;
    bool success = jsonObject["success"];

    if (success) {
      id = jsonObject["id"];
      username = jsonObject["username"];
      email = jsonObject["email"];
      password = jsonObject["password"];
      refreshToken = jsonObject["refreshToken"];
      message = "";
    } else {
      jsonObject["message"] != null
          ? message = jsonObject["message"]
          : message = "";
      return SignUpModel(
        id: "",
        username: "",
        email: "",
        password: "",
        refreshToken: "",
        success: success,
        message: message,
      );
    }
    return SignUpModel(
      id: id,
      username: username,
      email: email,
      password: password,
      success: success,
      message: message,
      refreshToken: refreshToken,
    );
  }

  @override
  String toString() {
    return '''SignUpModel:
    id: $id,
    username: $username,
    email: $email,
    password: $password,
    success: $success,
    message: $message,
    ''';
  }
}
