import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:free_indeed/Managers/Implementation/Local-data-manager.impl.dart';
import 'package:free_indeed/Managers/LocalDataManager.dart';
import 'package:free_indeed/Models/ChatCreatedModel.dart';
import 'package:free_indeed/Models/MessagePreviewModel.dart';
import 'package:free_indeed/Models/ParticipantModel.dart';
import 'package:free_indeed/Models/UserModel.dart';
import 'package:free_indeed/Repo/login_repo.dart';
import 'package:free_indeed/Screens/ChatScreen/ChatScreen.dart';

import '../../Managers/named-navigator.dart';
import '../../Repo/ChatsRepo.dart';

part 'messaging_event.dart';

part 'messaging_state.dart';

class MessagingBloc extends Bloc<MessagingEvent, MessagingState> {
  final ChatsRepo chatsRepo;
  final NamedNavigator namedNavigator;
  late List<MessagePreviewModel> myMessages;
  late String accessToken;

  MessagingBloc({required this.chatsRepo, required this.namedNavigator})
      : super(MessagingInitial()) {
    on<MessagingInitializeEvent>((event, emit) async {
      // EasyLoading.show(status: "");
      accessToken = "";
      myMessages = [];
      // myMessages = await chatsRepo.getMyMyChats(accessToken);

      // EasyLoading.dismiss();
      emit(MessagingReadyState(messages: myMessages, refreshScreen: false));
    });
    on<MessagingStartChatScreenEvent>((event, emit) async {
      // EasyLoading.show(status: "");
      await namedNavigator.push(Routes.CREATE_MESSAGE_ROUTER);
      emit(MessagingInitial());
      EasyLoading.show(status: "");
      accessToken = LocalDataManagerImpl().readString(CachingKey.ACCESS_TOKEN);
      myMessages = [];
      // myMessages = await chatsRepo.getMyMyChats(accessToken);
      EasyLoading.dismiss();
      emit(MessagingReadyState(messages: myMessages, refreshScreen: true));
    });
    on<MessagingSearchScreenEvent>((event, emit) async {
      // EasyLoading.show(status: "");
      // await namedNavigator.push(Routes.CREATE_MESSAGE_ROUTER);
      emit(MessagingInitial());
      // EasyLoading.show(status: "");
      accessToken = "";
      List<MessagePreviewModel> itemsFound = [];
      if (event.searchTerm.isEmpty) {
        emit(MessagingSearchState(messages: event.messagesList));
      }
      for (var element in event.messagesList) {
        if (element.displayName != null &&
            element.displayName!
                .toLowerCase()
                .contains(event.searchTerm.toLowerCase())) {
          itemsFound.add(element);
        } else if (element.groupName != null &&
            element.groupName!
                .toLowerCase()
                .contains(event.searchTerm.toLowerCase())) {
          itemsFound.add(element);
        }
      }
      EasyLoading.dismiss();
      emit(MessagingSearchState(messages: itemsFound));
    });
    on<MessagingDeleteChatEvent>((event, emit) async {
      emit(MessagingInitial());
      // EasyLoading.show(status: "");
      accessToken = "";
      bool success =
          await chatsRepo.deleteIndividualChat(accessToken, event.message.id!);
      EasyLoading.dismiss();
      if (success) {
        emit(MessagingReadyState(messages: myMessages, refreshScreen: true));
      } else {
        EasyLoading.showToast("Something went wrong .. Please try again later");
      }
    });

    on<MessagingGoToIndividualChatScreenEvent>((event, emit) async {
      // EasyLoading.show(status: "");

      List<ParticipantModel> groupParticipants =
          await chatsRepo.getChatParticipants(accessToken, event.message.id!);

      String userId = await chatsRepo.getThisUserId(accessToken);
      String otherParticipant = "";
      for (int i = 0; i < groupParticipants.length; i++) {
        if (groupParticipants[i].cognitoId!.compareTo(userId) == 1) {
          otherParticipant = groupParticipants[i].cognitoId!;
        }
      }

      UserModel thisUser = await LoginRepo().getUserDataFromCache();
      ChatCreatedModel chatScreenArgs = ChatCreatedModel(
          id: event.message.id,
          displayName: event.message.displayName,
          participantFrom: userId,
          participantTo: otherParticipant,
          isGroup: event.message.isGroup,
          isGroupAdmin: event.message.isGroupAdmin,
          groupParticipants: groupParticipants,
          success: true);
      EasyLoading.dismiss();
      await namedNavigator.push(Routes.CHAT_ROUTER,
          arguments: ChatScreenArgs(
              chatCreatedModel: chatScreenArgs, userModel: thisUser));
      // EasyLoading.show(status: "");
      emit(MessagingInitial());
      accessToken = LocalDataManagerImpl().readString(CachingKey.ACCESS_TOKEN);
      myMessages = [];
      // myMessages = await chatsRepo.getMyMyChats(accessToken);
      EasyLoading.dismiss();
      emit(MessagingReadyState(
        messages: myMessages,
        refreshScreen: true,
      ));
      EasyLoading.dismiss();
    });
  }

  Future<List<MessagePreviewModel>> getNextChats(int pageNumber) async {
    return await chatsRepo.getMyMyChats(accessToken, pageNumber);
  }
}
