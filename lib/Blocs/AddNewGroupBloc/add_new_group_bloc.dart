import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:free_indeed/Managers/Implementation/Local-data-manager.impl.dart';
import 'package:free_indeed/Managers/LocalDataManager.dart';
import 'package:free_indeed/Models/ChatCreatedModel.dart';
import 'package:free_indeed/Models/FriendsModel.dart';
import 'package:free_indeed/Models/ParticipantModel.dart';
import 'package:free_indeed/Models/UserModel.dart';
import 'package:free_indeed/Repo/login_repo.dart';
import 'package:free_indeed/Screens/ChatScreen/ChatScreen.dart';

import '../../Managers/named-navigator.dart';
import '../../Repo/ChatsRepo.dart';

part 'add_new_group_event.dart';

part 'add_new_group_state.dart';

class AddNewGroupBloc extends Bloc<AddNewGroupEvent, AddNewGroupState> {
  final ChatsRepo chatsRepo;
  final NamedNavigator namedNavigator;
  late List<FriendModel> myFriends;
  int friendsOnlyPageNumber = 1;
  late String accessToken;

  AddNewGroupBloc({required this.chatsRepo, required this.namedNavigator})
      : super(AddNewGroupInitial()) {
    on<AddNewGroupInitializeEvent>((event, emit) async {
      accessToken = LocalDataManagerImpl().readString(CachingKey.ACCESS_TOKEN);

      emit(AddNewGroupReadyState(friends: []));
    });

    on<AddNewGroupStartChatEvent>((event, emit) async {
      EasyLoading.show(status: "loading");
      List<String> ids = [];
      String userId = await chatsRepo.getThisUserId(accessToken);
      ids.add(userId);
      for (int i = 0; i < event.friends.length; i++) {
        ids.add(event.friends[i].cognitoId!);
      }
      ChatCreatedModel model =
          await chatsRepo.startGroupChat(accessToken, ids, event.groupName);

      model.isGroup = true;
      List<ParticipantModel> groupParticipants =
          await chatsRepo.getChatParticipants(accessToken, model.id!);
      model.groupParticipants = groupParticipants;
      model.isGroupAdmin = true;
      UserModel thisUser = await LoginRepo().getUserDataFromCache();
      EasyLoading.dismiss();
      namedNavigator.pop();
      namedNavigator.pop();
      namedNavigator.pop();
      namedNavigator.push(Routes.CHAT_ROUTER,
          arguments:
              ChatScreenArgs(chatCreatedModel: model, userModel: thisUser));
    });

    on<AddNewParticipantToChatEvent>((event, emit) async {
      EasyLoading.show(status: "");

      bool success = await chatsRepo.addParticipantGroupChat(
          accessToken, event.chatId, event.friends.cognitoId!);
      if (success) {
        await LocalDataManagerImpl()
            .writeData(CachingKey.FRIEND_ID, event.friends.cognitoId);
        await LocalDataManagerImpl()
            .writeData(CachingKey.FRIEND_DISPLAY_NAME, event.friends.username);
        namedNavigator.pop();
      } else {
        EasyLoading.show(
            status: "Something went wrong .. please try again later");
      }
      EasyLoading.dismiss();
      namedNavigator.pop();
    });
  }

  Future<List<FriendModel>> getNextFriends(int pageNumber) async {
    myFriends = await chatsRepo.getMyFriends(accessToken, pageNumber);
    return myFriends;
  }
}
