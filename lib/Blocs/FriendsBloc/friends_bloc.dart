import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:free_indeed/Managers/Implementation/Local-data-manager.impl.dart';
import 'package:free_indeed/Managers/LocalDataManager.dart';
import 'package:free_indeed/Managers/named-navigator.dart';
import 'package:free_indeed/Repo/friendsRepo.dart';

import '../../Models/FriendsModel.dart';

part 'friends_event.dart';

part 'friends_state.dart';

class FriendsBloc extends Bloc<FriendsEvent, FriendsState> {
  final FriendsRepo _friendsRepo;
  late List<FriendModel> friends;
  late List<FriendModel> myFriends;
  late List<FriendModel> oldMyFriends;
  late List<FriendModel> newFriends;
  late List<FriendModel> searchFriends;
  late String accessToken;
  late String searchName;
  int pageNumber = 1;
  int friendsOnlyPageNumber = 1;
  int searchPageNumber = 1;

  FriendsBloc(
      {required NamedNavigator namedNavigator,
      required FriendsRepo friendsRepo})
      : this._friendsRepo = friendsRepo,
        super(FriendsInitial()) {
    on<FriendsInitializeEvent>((event, emit) async {
      emit(FriendsInitial());
      EasyLoading.show(status: "");
      friends = [];
      accessToken = "";
      newFriends = [];
      pageNumber++;
      EasyLoading.dismiss();
      emit(FriendsReadyState(
          friends: [],
          newFriendsList: newFriends,
          refreshFriendsTab: false,
          refreshUsersTab: false));
    });
    on<GetNextFriendsEvent>((event, emit) async {
      newFriends = [];
      pageNumber++;
      emit(FriendsReadyState(
          friends: [],
          newFriendsList: newFriends,
          refreshUsersTab: false,
          refreshFriendsTab: false));
    });

    on<FriendsInitializeMyFriendsEvent>((event, emit) async {
      emit(FriendsInitial());
      friendsOnlyPageNumber = 1;
      myFriends = [];
      myFriends = [];
      friendsOnlyPageNumber++;
      emit(FriendsFriendsOnlyReadyState(
          friends: myFriends, newFriendsList: myFriends));
    });
    on<GetNextFriendsOnlyEvent>((event, emit) async {
      myFriends = [];
      friendsOnlyPageNumber++;
      emit(
          FriendsFriendsOnlyReadyState(friends: [], newFriendsList: myFriends));
    });

    on<SearchFriendsEvent>((event, emit) async {
      emit(FriendsInitial());
      EasyLoading.show(status: "");
      searchFriends = [];
      try {
        searchPageNumber = event.pageNumber;
        accessToken =
             LocalDataManagerImpl().readString(CachingKey.ACCESS_TOKEN);
        searchName = event.friendName;
        searchFriends = await _friendsRepo.getSearchedFriends(
            accessToken, searchPageNumber, event.friendName);
        searchPageNumber++;
      } catch (e) {
        EasyLoading.showToast("Something went wrong .. try again later");
        print(e);
      }
      EasyLoading.dismiss();
      emit(FriendsReadyState(
          friends: [],
          newFriendsList: searchFriends,
          refreshUsersTab: false,
          refreshFriendsTab: false));
    });
    on<GetNextSearchEvent>((event, emit) async {
      searchFriends = await _friendsRepo.getSearchedFriends(
          accessToken, searchPageNumber, searchName);
      searchPageNumber++;
      emit(FriendsReadyState(
          friends: friends,
          newFriendsList: searchFriends,
          refreshUsersTab: false,
          refreshFriendsTab: false));
    });

    on<AddFriendEvent>((event, emit) async {
      if (event.friendId.isFriend!) {
        EasyLoading.show(status: "");
        bool added = await _friendsRepo.addFriend(
            accessToken, event.friendId.cognitoId!);
        if (added) {
          // EasyLoading.showToast("Friend added successfully");
        } else {
          EasyLoading.showToast(
              "Something went wrong .. please try again later");
        }
        EasyLoading.dismiss();
      } else {
        EasyLoading.show(status: "");

        bool added = await _friendsRepo.removeFriend(
            accessToken, event.friendId.cognitoId!);
        if (added) {
          // EasyLoading.showToast("Friend removed successfully");
        } else {
          EasyLoading.showToast(
              "Something went wrong .. please try again later");
        }
        EasyLoading.dismiss();
      }
    });
  }

  Future<List<FriendModel>> getNextUsers(int pageNumber) async {
    return await _friendsRepo.getEveryUser(accessToken, pageNumber);
  }

  Future<List<FriendModel>> getNextFriends(int pageNumber) async {
    return await _friendsRepo.getMyFriends(accessToken, pageNumber);
  }
}
