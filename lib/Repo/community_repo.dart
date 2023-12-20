import 'package:free_indeed/Models/CommentModel.dart';
import 'package:free_indeed/Models/NotificationModel.dart';
import 'package:free_indeed/Models/PostModel.dart';
import 'package:free_indeed/configs/Config.dart';
import 'package:free_indeed/configs/Network.dart';

class CommunityRepo {
  Network network = Network();

  Future<List<PostModel>> getEveryonePosts(
      String accessToken, String pageNumber) async {
    Map<String, dynamic>? jsonObject = await network.getDataGetMethod(
      UrlConfigurations().baseURL +
          UrlConfigurations().getAllPostsURL.replaceAll("[@]", pageNumber),
      token: accessToken,
    );
    List<PostModel> postModels = [];
    if (jsonObject != null && jsonObject["success"] == "1") {
      jsonObject["data"].forEach((v) {
        postModels.add(PostModel.fromJson(v));
      });
    }
    return postModels;
  }

  Future<List<PostModel>> getMyFriendsPosts(
      String accessToken, String pageNumber) async {
    Map<String, dynamic>? jsonObject = await network.getDataGetMethod(
      UrlConfigurations().baseURL +
          UrlConfigurations().getFriendsPostsURL.replaceAll("[@]", pageNumber),
      token: accessToken,
    );
    List<PostModel> postModels = [];
    if (jsonObject != null && jsonObject["success"] == "1") {
      jsonObject["data"].forEach((v) {
        postModels.add(PostModel.fromJson(v));
      });
    }
    return postModels;
  }

  Future<List<PostModel>> getMinePosts(
      String accessToken, String pageNumber) async {
    Map<String, dynamic>? jsonObject = await network.getDataGetMethod(
      UrlConfigurations().baseURL +
          UrlConfigurations().getMyPostsURL.replaceAll("[@]", pageNumber),
      token: accessToken,
    );
    List<PostModel> postModels = [];
    if (jsonObject != null && jsonObject["success"] == "1") {
      jsonObject["data"].forEach((v) {
        postModels.add(PostModel.fromJson(v));
      });
    }
    return postModels;
  }

  Future<List<NotificationModel>> getMyNotifications(
      String accessToken, int pageNumber) async {
    Map<String, dynamic>? jsonObject = await network.getDataGetMethod(
      UrlConfigurations().baseURL +
          UrlConfigurations()
              .getMyNotificationsURL
              .replaceAll("[@]", pageNumber.toString()),
      token: accessToken,
    );
    List<NotificationModel> notificationList = [];
    if (jsonObject != null && jsonObject["success"] == "1") {
      jsonObject["data"].forEach((v) {
        notificationList.add(NotificationModel.fromJson(v));
      });
    }
    return notificationList;
  }

  Future<List<CommentModel>> getPostComments(
      String accessToken, int postId) async {
    Map<String, dynamic>? jsonObject = await network.getDataGetMethod(
      UrlConfigurations().baseURL +
          UrlConfigurations().getPostsCommentsURL +
          postId.toString() +
          "?commentsLimit=10",
      token: accessToken,
    );
    List<CommentModel> commentsModels = [];
    if (jsonObject != null && jsonObject["success"] == "1") {
      Map<String, dynamic>? jsonObject1 = jsonObject["data"];
      if (jsonObject1 != null) {
        jsonObject1["comments"].forEach((v) {
          commentsModels.add(CommentModel.fromJson(v));
        });
      }
    }
    return commentsModels;
  }

  Future<bool> likePost(String accessToken, String postId) async {
    Map<String, dynamic>? jsonObject = await network.getDataPostMethod(
        UrlConfigurations().baseURL +
            UrlConfigurations().likePostURL.replaceAll("[@]", postId),
        {},
        token: accessToken);
    return jsonObject != null && jsonObject["success"] == "1";
  }

  Future<bool> unlikePost(String accessToken, String postId) async {
    Map<String, dynamic>? jsonObject = await network.deleteDataDeleteMethod(
        UrlConfigurations().baseURL +
            UrlConfigurations().unlikePostURL.replaceAll("[@]", postId),
        {},
        token: accessToken);
    return jsonObject != null && jsonObject["success"] == "1";
  }

  Future<bool> deletePost(String accessToken, String postId) async {
    Map<String, dynamic>? jsonObject = await network.deleteDataDeleteMethod(
        UrlConfigurations().baseURL +
            UrlConfigurations().deletePostURL.replaceAll("[@]", postId),
        {},
        token: accessToken);
    return jsonObject != null && jsonObject["success"] == "1";
  }

  Future<bool> editPost(
      String accessToken, String postId, String newText) async {
    Map<String, dynamic>? jsonObject = await network.editDataPutMethod(
        UrlConfigurations().baseURL +
            UrlConfigurations().editPostURL.replaceAll("[@]", postId),
        {
          "postText": newText,
        },
        token: accessToken);

    return jsonObject != null && jsonObject["success"] == "1";
  }

  Future<bool> addPost(String accessToken, String newText) async {
    Map<String, dynamic>? jsonObject = await network.getDataPostMethod(
        UrlConfigurations().baseURL + UrlConfigurations().createNewPostURL,
        {
          "postText": newText,
        },
        token: accessToken);

    return jsonObject != null && jsonObject["success"] == "1";
  }

  Future<bool> reportPost(String accessToken, String postId) async {
    Map<String, dynamic>? jsonObject = await network.getDataPostMethod(
        UrlConfigurations().baseURL +
            UrlConfigurations().reportPostURL.replaceAll("[@]", postId),
        {
          "postId": postId,
        },
        token: accessToken);

    return jsonObject != null && jsonObject["success"] == "1";
  }

  Future<bool> addComment(
      String accessToken, String newComment, String postId) async {
    Map<String, dynamic>? jsonObject = await network.getDataPostMethod(
        UrlConfigurations().baseURL +
            UrlConfigurations().addCommentURL.replaceAll("[@]", postId),
        {
          "commentText": newComment,
          "postId": postId,
        },
        token: accessToken);

    return jsonObject != null && jsonObject["success"] == "1";
  }

  Future<bool> deleteComment(
      String accessToken, String postId, String commentId) async {
    Map<String, dynamic>? jsonObject = await network.deleteDataDeleteMethod(
        UrlConfigurations().baseURL +
            UrlConfigurations()
                .deleteCommentURL
                .replaceAll("[@]", postId)
                .replaceAll("[#]", commentId),
        {},
        token: accessToken);
    return jsonObject != null && jsonObject["success"] == "1";
  }
}
