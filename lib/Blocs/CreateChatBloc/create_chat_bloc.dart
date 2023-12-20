import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:free_indeed/Managers/named-navigator.dart';
import 'package:free_indeed/Models/ChatCreatedModel.dart';
import 'package:free_indeed/Models/FriendsModel.dart';
import 'package:free_indeed/Models/UserModel.dart';
import 'package:free_indeed/Repo/ChatsRepo.dart';
import 'package:free_indeed/Repo/login_repo.dart';
import 'package:free_indeed/Screens/ChatScreen/ChatScreen.dart';

part 'create_chat_event.dart';

part 'create_chat_state.dart';

class CreateChatBloc extends Bloc<CreateChatEvent, CreateChatState> {
  final ChatsRepo chatsRepo;
  final NamedNavigator namedNavigator;
  int friendsOnlyPageNumber = 1;
  late String accessToken;

  CreateChatBloc({required this.chatsRepo, required this.namedNavigator})
      : super(CreateChatInitial()) {
    on<CreateChatInitializeEvent>((event, emit) async {
      accessToken = "";
      emit(CreateChatReadyState());
    });

    on<CreateChatStartChatScreenEvent>((event, emit) async {
      EasyLoading.show(status: "");
      List<String> ids = [];
      String userId = await chatsRepo.getThisUserId(accessToken);
      ids.add(userId);
      ids.add(event.otherParticipant);
      ChatCreatedModel model =
          await chatsRepo.startIndividualChat(accessToken, ids);
      model.isGroup = false;
      UserModel thisUser = await LoginRepo().getUserDataFromCache();
      EasyLoading.dismiss();
      namedNavigator.push(Routes.CHAT_ROUTER,
          arguments:
              ChatScreenArgs(chatCreatedModel: model, userModel: thisUser));
      // emit(CreateChatReadyState(friends: myFriends));
    });
    on<CreateChatGoToNewGroupScreenEvent>((event, emit) async {
      namedNavigator.push(Routes.ADD_NEW_GROUP_ROUTER);
    });
  }

  Future<List<FriendModel>> getNextFriends(int pageNumber) async {
    return await chatsRepo.getMyFriends(accessToken, pageNumber);
  }

  List<FriendModel> searchFriends(
      List<FriendModel> friends, String searchTerm) {
    List<FriendModel> resultFriends = [];

    for (var element in friends) {
      if (element.username!.contains(searchTerm)) {
        resultFriends.add(element);
      }
    }
    return resultFriends;
  }
}
