part of 'friends_bloc.dart';

abstract class FriendsEvent extends Equatable {
  const FriendsEvent();
}

class FriendsInitializeEvent extends FriendsEvent {
  @override
  List<Object?> get props => [];
}
class FriendsInitializeMyFriendsEvent extends FriendsEvent {
  @override
  List<Object?> get props => [];
}

class AddFriendEvent extends FriendsEvent {
  final FriendModel friendId;

  const AddFriendEvent({required this.friendId});

  @override
  List<Object?> get props => [friendId];
}

class SearchFriendsEvent extends FriendsEvent {
  final String friendName;
  final int pageNumber = 1;

  const SearchFriendsEvent({required this.friendName});

  @override
  List<Object?> get props => [friendName];
}


class GetNextFriendsEvent extends FriendsEvent {
  final int pageNumber;

  const GetNextFriendsEvent({required this.pageNumber});

  @override
  List<Object?> get props => [pageNumber];
}

class GetNextFriendsOnlyEvent extends FriendsEvent {
  final int pageNumber;

  const GetNextFriendsOnlyEvent({required this.pageNumber});

  @override
  List<Object?> get props => [pageNumber];
}

class GetNextSearchEvent extends FriendsEvent {
  final int pageNumber;

  const GetNextSearchEvent({required this.pageNumber});

  @override
  List<Object?> get props => [pageNumber];
}
