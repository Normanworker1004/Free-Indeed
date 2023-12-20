import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:free_indeed/Managers/Implementation/Local-data-manager.impl.dart';
import 'package:free_indeed/Managers/LocalDataManager.dart';
import 'package:free_indeed/Models/ParticipantModel.dart';
import 'package:free_indeed/Models/UserModel.dart';
import 'package:free_indeed/Repo/login_repo.dart';
import 'package:free_indeed/Screens/ChatScreen/ChatScreen.dart';

import '../../Managers/named-navigator.dart';
import '../../Models/ChatCreatedModel.dart';
import '../../Repo/ChatsRepo.dart';

part 'chat_bottom_sheet_event.dart';

part 'chat_bottom_sheet_state.dart';

class ChatBottomSheetBloc
    extends Bloc<ChatBottomSheetEvent, ChatBottomSheetState> {
  final NamedNavigator namedNavigator;
  final ChatsRepo chatsRepo;

  ChatBottomSheetBloc({required this.namedNavigator, required this.chatsRepo})
      : super(ChatBottomSheetInitial()) {
    on<ChatBottomSheetAddParticipant>((event, emit) async {
      await namedNavigator.push(Routes.ADD_NEW_PARTICIPANT_ROUTER,
          arguments: event.chatId);
      String friendId = LocalDataManagerImpl().readString(CachingKey.FRIEND_ID);
      String friendUserName =
          LocalDataManagerImpl().readString(CachingKey.FRIEND_DISPLAY_NAME);
      LocalDataManagerImpl().removeData(CachingKey.FRIEND_ID);
      LocalDataManagerImpl().removeData(CachingKey.FRIEND_DISPLAY_NAME);

      ParticipantModel participantModel = ParticipantModel(
          cognitoId: friendId, userName: friendUserName, success: true);
      UserModel thisUser = await LoginRepo().getUserDataFromCache();
      namedNavigator.pop();
      namedNavigator.pop();
      event.chatCreatedModel.groupParticipants!.add(participantModel);
      namedNavigator.push(Routes.CHAT_ROUTER,
          arguments: ChatScreenArgs(
              chatCreatedModel: event.chatCreatedModel, userModel: thisUser));
    });
    on<ChatBottomSheetDeleteParticipant>((event, emit) async {
      EasyLoading.show(status: "");
      String accessToken =
          LocalDataManagerImpl().readString(CachingKey.ACCESS_TOKEN);
      bool success = await chatsRepo.removeChatParticipant(
          accessToken, event.chatId, event.participantId);
      EasyLoading.dismiss();
      if (success) {
        namedNavigator.pop();
      } else {
        EasyLoading.show(
            status: "Something went wrong .. Please try again later");
      }
    });
    on<ChatBottomSheetDeleteChat>((event, emit) async {
      EasyLoading.show(status: "");
      String accessToken =
          LocalDataManagerImpl().readString(CachingKey.ACCESS_TOKEN);
      bool success = await chatsRepo.deleteGroupChat(accessToken, event.chatId);
      EasyLoading.dismiss();
      if (success) {
        namedNavigator.pop();
        namedNavigator.pop();
      } else {
        EasyLoading.show(
            status: "Something went wrong .. Please try again later");
      }
    });
    on<ChatBottomSheetLeaveChat>((event, emit) async {
      EasyLoading.show(status: "");
      String accessToken =
          LocalDataManagerImpl().readString(CachingKey.ACCESS_TOKEN);
      bool success = await chatsRepo.leaveChat(accessToken, event.chatId);
      EasyLoading.dismiss();
      if (success) {
        namedNavigator.pop();
        namedNavigator.pop();
        EasyLoading.dismiss();
      }
      EasyLoading.dismiss();
    });
    on<ChatBottomSheetChangeGroupName>((event, emit) async {
      EasyLoading.show(status: "");
      String accessToken =
           LocalDataManagerImpl().readString(CachingKey.ACCESS_TOKEN);
      bool success = await chatsRepo.changeGroupName(
          accessToken, event.chatId, event.newGroupName);
      EasyLoading.dismiss();
      if (success) {
        namedNavigator.pop();
      } else {
        EasyLoading.show(
            status: "Something went wrong .. Please try again later");
      }
    });
  }
}
