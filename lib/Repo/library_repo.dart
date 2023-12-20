import 'package:free_indeed/Models/BlogModel.dart';
import 'package:free_indeed/Models/BlogPreviewModel.dart';
import 'package:free_indeed/configs/Config.dart';
import 'package:free_indeed/configs/Network.dart';

class BlogRepo {
  Network network = Network();

  Future<List<BlogPreviewModel>> getFellowIndeedBlogs(
      String accessToken) async {
    Map<String, dynamic>? jsonObject = await network.getDataGetMethod(
        UrlConfigurations().baseURL + UrlConfigurations().getAdminBlogsURL,
        token: accessToken);
    List<BlogPreviewModel> blogs = [];
    if (jsonObject != null && jsonObject["success"] == "1") {
      jsonObject["data"].forEach((v) {
        blogs.add(BlogPreviewModel.fromJson(v));
      });
    }
    return blogs;
  }

  Future<BlogModel?> getAdminBlog(String accessToken, String blogId) async {
    Map<String, dynamic>? jsonObject = await network.getDataGetMethod(
      UrlConfigurations().baseURL +
          UrlConfigurations().getAdminBlogDetailsURL.replaceAll("[@]", blogId),
      token: accessToken,
    );
    BlogModel? blog;
    if (jsonObject != null && jsonObject["success"] == "1") {
      blog = BlogModel.fromJson(jsonObject["data"]);
    }
    return blog;
  }

  Future<BlogModel?> getUserBlogDetails(
      String accessToken, String blogId) async {
    Map<String, dynamic>? jsonObject = await network.getDataGetMethod(
      UrlConfigurations().baseURL +
          UrlConfigurations().getUserBlogDetailsURL.replaceAll("[@]", blogId),
      token: accessToken,
    );
    BlogModel? blog;
    if (jsonObject != null && jsonObject["success"] == "1") {
      blog = BlogModel.fromJson(jsonObject["data"]);
    }
    return blog;
  }

  Future<List<BlogPreviewModel>> getMoreBlogs(String accessToken) async {
    Map<String, dynamic>? jsonObject = await network.getDataGetMethod(
        UrlConfigurations().baseURL + UrlConfigurations().getUsersBlogsURL,
        token: accessToken);
    List<BlogPreviewModel> blogs = [];
    if (jsonObject != null && jsonObject["success"] == "1") {
      jsonObject["data"].forEach((v) {
        blogs.add(BlogPreviewModel.fromJson(v));
      });
    }
    return blogs;
  }

  Future<bool> submitBlog(
      {required String accessToken,
      required String title,
      required String blogBody,
      required String imageName,
      required String extension,
      required String imageBase64}) async {
    Map<String, dynamic>? jsonObject = await network.getDataPostMethod(
        UrlConfigurations().baseURL + UrlConfigurations().submitBlogURL,
        {
          "title": title,
          "description": blogBody,
          "imageName": imageName,
          "value": imageBase64,
          "extension": extension,
        },
        token: accessToken);
    return jsonObject != null && jsonObject["success"] == "1";
  }

  void likePost(String accessToken) async {}

  void writeComment(String accessToken, String postId, String comment) async {
    await network.getDataPostMethod(UrlConfigurations().baseURL, {
      "postId": postId,
      "comment": comment,
      "accessToken": accessToken,
    });
  }

  void deletePost(String accessToken, String postId) async {
    await network.getDataPostMethod(UrlConfigurations().baseURL, {
      "postId": postId,
      "accessToken": accessToken,
    });
  }

  void editPost(String accessToken, String postId, String newText) async {
    await network.getDataPostMethod(UrlConfigurations().baseURL, {
      "postId": postId,
      "newText": newText,
      "accessToken": accessToken,
    });
  }
}
