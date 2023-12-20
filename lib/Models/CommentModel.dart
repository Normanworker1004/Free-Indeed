class CommentModel {
  final int? id;
  final String? username;
  final String? timeStamp;
  final String? timeStampNew;
  final String? commentText;
  final bool? success;
  final bool? isMyComment;

  CommentModel({
    required this.id,
    required this.username,
    required this.timeStamp,
    required this.success,
    required this.commentText,
    required this.timeStampNew,
    required this.isMyComment,
  });

  factory CommentModel.fromJson(Map<String, dynamic> jsonObject) {
    int? id;
    String? username;
    String? commentText;
    String? timeStamp;
    bool? isMyComment;
    String? timeStampNew;

    id = jsonObject["id"];
    username = jsonObject["username"];
    commentText = jsonObject["commentText"];
    timeStamp = jsonObject["timeStamp"];
    timeStampNew = jsonObject["timeStampNew"];
    isMyComment = jsonObject["isOwnComment"];

    return CommentModel(
      id: id,
      username: username,
      timeStamp: timeStamp,
      isMyComment: isMyComment,
      timeStampNew: timeStampNew,
      success: true,
      commentText: commentText,
    );
  }

  @override
  String toString() {
    return '''CommentModel:
    id: $id,
    username: $username,
    liked: $timeStamp,
    success: $success,
    commentText: $commentText,
    isMyComment: $isMyComment,
    ''';
  }
}
