part of 'friends_bloc.dart';

abstract class FriendsState extends Equatable {
  const FriendsState();
}

class FriendsInitial extends FriendsState {
  @override
  List<Object> get props => [];
}

class FriendsReadyState extends FriendsState {
  final List<FriendModel> friends;
  final List<FriendModel> newFriendsList;
  final bool refreshFriendsTab;
  final bool refreshUsersTab;

  const FriendsReadyState(
      {required this.friends,
      required this.newFriendsList,
      required this.refreshFriendsTab,
      required this.refreshUsersTab});

  @override
  List<Object> get props => [friends, newFriendsList];
}

class FriendsFriendsOnlyReadyState extends FriendsState {
  final List<FriendModel> friends;
  final List<FriendModel> newFriendsList;

  const FriendsFriendsOnlyReadyState(
      {required this.friends, required this.newFriendsList});

  @override
  List<Object> get props => [friends, newFriendsList];
}

// class FriendsInitial extends FriendsState {
//   @override
//   List<Object> get props => [];
// }
