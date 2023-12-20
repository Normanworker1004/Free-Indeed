// ignore_for_file: must_be_immutable

import 'package:equatable/equatable.dart';
import 'package:free_indeed/Models/CommentModel.dart';

class PostModel extends Equatable {
  final int? id;
  final String? username;
  int? numberOfComments;
  bool? liked;
  final bool? isMyPost;
  final bool? success;
  String? postText;
  int? numberOfLikes;
  final String? timeStamp;
  final String? timeStampNew;
  final String? userCognitoId;
  List<CommentModel> commentsList;

  PostModel({
    required this.id,
    required this.username,
    required this.numberOfComments,
    required this.liked,
    required this.success,
    required this.postText,
    required this.numberOfLikes,
    required this.timeStampNew,
    required this.timeStamp,
    required this.isMyPost,
    required this.commentsList,
    required this.userCognitoId,
  });

  factory PostModel.fromJson(Map<String, dynamic> jsonObject) {
    int? id;
    String? username;
    int? numberOfComments;
    bool? liked;
    String? postText;
    int? numberOfLikes;
    String? timeStamp;
    String? userCognitoId;
    String? timeStampNew;
    bool? isMyPost;

    id = jsonObject["id"];
    username = jsonObject["userName"];
    numberOfComments = jsonObject["numberOfComments"];
    liked = jsonObject["liked"];
    isMyPost = jsonObject["isMine"];
    numberOfLikes = jsonObject["numberOfLikes"];
    timeStamp = jsonObject["timeStamp"];
    postText = jsonObject["postText"];
    userCognitoId = jsonObject["userCognitoId"];
    timeStampNew = jsonObject["timeStampNew"];

    return PostModel(
        id: id,
        username: username,
        timeStamp: timeStamp,
        numberOfComments: numberOfComments,
        liked: liked,
        success: true,
        isMyPost: isMyPost,
        postText: postText,
        numberOfLikes: numberOfLikes,
        userCognitoId: userCognitoId,
        timeStampNew: timeStampNew,
        commentsList: []);
  }

  @override
  String toString() {
    return '''PostModel:
    id: $id,
    username: $username,
    liked: $liked,
    success: $success,
    postText: $postText,
    numberOfComments: $numberOfComments,
    numberOfLikes: $numberOfLikes,
    timeStamp: $timeStamp,
    isMyPost: $isMyPost,
    timeStampNew: $timeStampNew,
    userCognitoId, $userCognitoId,
    ''';
  }

  @override
  List<Object?> get props => [
        id,
        userCognitoId,
      ];
}
