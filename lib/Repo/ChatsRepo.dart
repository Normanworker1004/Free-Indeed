import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:free_indeed/Models/ChatCreatedModel.dart';
import 'package:free_indeed/Models/FriendsModel.dart';
import 'package:free_indeed/Models/MessagePreviewModel.dart';
import 'package:free_indeed/Models/ParticipantModel.dart';
import 'package:free_indeed/Repo/FirebaseRepo.dart';
import 'package:free_indeed/configs/Config.dart';
import 'package:free_indeed/configs/Network.dart';

class ChatsRepo {
  Network network = Network();
  FirebaseRepo firebaseRepo = FirebaseRepo();

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

  Future<List<MessagePreviewModel>> getMyMyChats(
      String accessToken, int pageNumber) async {
    Map<String, dynamic>? jsonObject = await network.getDataGetMethod(
      UrlConfigurations().baseURL +
          UrlConfigurations()
              .getAllChatsURL
              .replaceAll("[@]", pageNumber.toString()),
      token: accessToken,
    );
    List<MessagePreviewModel> chatsList = [];
    if (jsonObject != null && jsonObject["success"] == "1") {
      jsonObject["data"].forEach((v) {
        chatsList.add(MessagePreviewModel.fromJson(v));
      });
      // for (var v in jsonObject["data"]) {
      //   MessagePreviewModel messagePreviewModel =
      //       MessagePreviewModel.fromJson(v);
      //   try {
      //     ChatMessages? chatMessages =
      //         await FirebaseRepo().getLastMessage(messagePreviewModel.id!);
      //     messagePreviewModel.lastMessageDateTime = chatMessages?.timestamp;
      //     messagePreviewModel.lastMessage = chatMessages?.content;
      //   } catch (e) {
      //     print(e);
      //   }
      //   chatsList.add(messagePreviewModel);
      // }
    }
    return chatsList;
  }

  Future<List<ParticipantModel>> getChatParticipants(
      String accessToken, String chatId) async {
    Map<String, dynamic>? jsonObject = await network.getDataGetMethod(
      UrlConfigurations().baseURL +
          UrlConfigurations()
              .getGroupParticipantListURL
              .replaceAll("[@]", chatId),
      token: accessToken,
    );
    List<ParticipantModel> participantList = [];
    if (jsonObject != null && jsonObject["success"] == "1") {
      jsonObject["data"].forEach((v) {
        participantList.add(ParticipantModel.fromJson(v));
      });
    }
    return participantList;
  }

  Future<String> getThisUserId(String accessToken) async {
    Map<String, dynamic>? jsonObject = await network.getDataGetMethod(
      UrlConfigurations().baseURL + UrlConfigurations().getUserCognitoIdURL,
      token: accessToken,
    );
    String id = "";
    if (jsonObject != null && jsonObject["success"] == "1") {
      var jsonObject1 = jsonObject["data"];
      id = jsonObject1["cognitoId"];
    }
    return id;
  }

  Future<ChatCreatedModel> startIndividualChat(
      String accessToken, List<String> ids) async {
    Map<String, dynamic>? jsonObject = await network.getDataPostMethod(
      UrlConfigurations().baseURL +
          UrlConfigurations().startNewIndividualChatURL,
      {"participantsIds": ids},
      token: accessToken,
    );
    ChatCreatedModel? model;
    if (jsonObject != null) {
      model = ChatCreatedModel.fromJson(jsonObject["data"]);
    }
    print(jsonObject);
    return model ??
        ChatCreatedModel(
            id: "1",
            displayName: "displayName",
            participantFrom: "participantFrom",
            participantTo: "participantTo",
            success: true);
  }

  Future<ChatCreatedModel> startGroupChat(
      String accessToken, List<String> ids, String groupName) async {
    Map<String, dynamic>? jsonObject = await network.getDataPostMethod(
      UrlConfigurations().baseURL + UrlConfigurations().startNewGroupChatURL,
      {"participantsIds": ids, "groupName": groupName},
      token: accessToken,
    );
    ChatCreatedModel? model;
    if (jsonObject != null) {
      model = ChatCreatedModel.fromJson(jsonObject["data"]);
    }
    print(jsonObject);
    return model ??
        ChatCreatedModel(
            id: "1",
            displayName: "displayName",
            participantFrom: "participantFrom",
            participantTo: "participantTo",
            success: true);
  }

  Future<bool> changeGroupName(
      String accessToken, String chatId, String groupNewName) async {
    Map<String, dynamic>? jsonObject = await network.editDataPutMethod(
      UrlConfigurations().baseURL +
          UrlConfigurations().changeGroupChatNameURL.replaceAll("[@]", chatId),
      {
        "groupName": groupNewName,
      },
      token: accessToken,
    );
    return jsonObject != null && jsonObject["success"] == "1";
  }

  Future<bool> addLastMessage(String accessToken, String chatId,
      String lastMessageText, String userCognitoId) async {
    Map<String, dynamic>? jsonObject = await network.editDataPutMethod(
      UrlConfigurations().baseURL +
          UrlConfigurations().addLastMessageURL.replaceAll("[@]", chatId),
      {"lastMessage": lastMessageText, "fromUserCognitoId": userCognitoId},
      token: accessToken,
    );
    return jsonObject != null && jsonObject["success"] == "1";
  }

  Future<bool> removeChatParticipant(
      String accessToken, String chatId, String userName) async {
    Map<String, dynamic>? jsonObject = await network.deleteDataDeleteMethod(
      UrlConfigurations().baseURL +
          UrlConfigurations().removeParticipantURL.replaceAll("[@]", chatId),
      {
        "userCognitoId": userName,
      },
      token: accessToken,
    );
    return jsonObject != null && jsonObject["success"] == "1";
  }

  Future<bool> leaveChat(String accessToken, String chatId) async {
    Map<String, dynamic>? jsonObject = await network.deleteDataDeleteMethod(
      UrlConfigurations().baseURL +
          UrlConfigurations().leaveChatURL.replaceAll("[@]", chatId),
      {},
      token: accessToken,
    );
    if ((jsonObject != null && jsonObject["success"] == "0")) {
      EasyLoading.showToast(jsonObject["msg"]);
    }

    return jsonObject != null && jsonObject["success"] == "1";
  }

  Future<bool> deleteGroupChat(String accessToken, String chatId) async {
    Map<String, dynamic>? jsonObject = await network.deleteDataDeleteMethod(
      UrlConfigurations().baseURL +
          UrlConfigurations().deleteGroupChatURL.replaceAll("[@]", chatId),
      {},
      token: accessToken,
    );
    return jsonObject != null && jsonObject["success"] == "1";
  }

  Future<bool> deleteIndividualChat(String accessToken, String chatId) async {
    Map<String, dynamic>? jsonObject = await network.deleteDataDeleteMethod(
      UrlConfigurations().baseURL +
          UrlConfigurations().deleteIndividualChatURL.replaceAll("[@]", chatId),
      {},
      token: accessToken,
    );
    return jsonObject != null && jsonObject["success"] == "1";
  }

  Future<bool> addParticipantGroupChat(
      String accessToken, String chatId, String friendId) async {
    Map<String, dynamic>? jsonObject = await network.getDataPostMethod(
      UrlConfigurations().baseURL +
          UrlConfigurations()
              .addGroupChatParticipantURL
              .replaceAll("[@]", chatId),
      {"userCognitoId": friendId},
      token: accessToken,
    );
    return jsonObject != null && jsonObject["success"] == "1";
  }
}
