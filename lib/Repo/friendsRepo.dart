import 'package:free_indeed/Models/FriendsModel.dart';
import 'package:free_indeed/configs/Config.dart';
import 'package:free_indeed/configs/Network.dart';

class FriendsRepo {
  Network network = Network();

  Future<List<FriendModel>> getEveryUser(
      String accessToken, int pageNumber) async {
    Map<String, dynamic>? jsonObject = await network.getDataGetMethod(
      UrlConfigurations().baseURL +
          UrlConfigurations()
              .getAllUsersURL
              .replaceAll("[@]", pageNumber.toString()),
      token: accessToken,
    );
    List<FriendModel> friendsList = [];
    if (jsonObject != null && jsonObject["success"] == "1") {
      jsonObject["data"].forEach((v) {
        friendsList.add(FriendModel.fromJson(v));
      });
    }
    return friendsList;
  }
 Future<List<FriendModel>> getMyFriends(
      String accessToken, int pageNumber) async {
    Map<String, dynamic>? jsonObject = await network.getDataGetMethod(
      UrlConfigurations().baseURL +
          UrlConfigurations()
              .getMyFriendsOnlyURL
              .replaceAll("[@]", pageNumber.toString()),
      token: accessToken,
    );
    List<FriendModel> friendsList = [];
    if (jsonObject != null && jsonObject["success"] == "1") {
      jsonObject["data"].forEach((v) {
        friendsList.add(FriendModel.fromFriendsJson(v));
      });
    }
    return friendsList;
  }

  Future<List<FriendModel>> getSearchedFriends(
      String accessToken, int pageNumber, String friendName) async {
    Map<String, dynamic>? jsonObject = await network.getDataGetMethod(
      UrlConfigurations().baseURL +
          UrlConfigurations()
              .getNamedUsersURL
              .replaceAll("[@]", pageNumber.toString())
              .replaceAll("[#]", friendName),
      token: accessToken,
    );
    List<FriendModel> friendsList = [];
    if (jsonObject != null && jsonObject["success"] == "1") {
      jsonObject["data"].forEach((v) {
        friendsList.add(FriendModel.fromJson(v));
      });
    }
    return friendsList;
  }

  Future<bool> addFriend(String accessToken, String friendId) async {
    Map<String, dynamic>? jsonObject = await network.getDataPostMethod(
      UrlConfigurations().baseURL + UrlConfigurations().addFriendURL,
      {
        "friendUserCognitoId": friendId,
      },
      token: accessToken,
    );
    return jsonObject != null && jsonObject["success"] == "1";
  }

  Future<bool> removeFriend(String accessToken, String friendId) async {
    Map<String, dynamic>? jsonObject = await network.deleteDataDeleteMethod(
      UrlConfigurations().baseURL + UrlConfigurations().removeFriendURL,
      {
        "friendUserCognitoId": friendId,
      },
      token: accessToken,
    );
    return jsonObject != null && jsonObject["success"] == "1";
  }

  Future<bool> muteUser(String accessToken, String friendId) async {
    Map<String, dynamic>? jsonObject = await network.getDataPostMethod(
      UrlConfigurations().baseURL + UrlConfigurations().muteUserURL,
      {
        "mutedUserCognitoId": friendId,
      },
      token: accessToken,
    );
    return jsonObject != null && jsonObject["success"] == "1";
  }

  Future<bool> unMuteUser(String accessToken, String friendId) async {
    Map<String, dynamic>? jsonObject = await network.deleteDataDeleteMethod(
      UrlConfigurations().baseURL + UrlConfigurations().muteUserURL,
      {
        "mutedUserCognitoId": friendId,
      },
      token: accessToken,
    );
    return jsonObject != null && jsonObject["success"] == "1";
  }
}
