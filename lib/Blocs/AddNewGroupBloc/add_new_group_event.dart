part of 'add_new_group_bloc.dart';

abstract class AddNewGroupEvent extends Equatable {
  const AddNewGroupEvent();
}

class AddNewGroupInitializeEvent extends AddNewGroupEvent {
  @override
  List<Object> get props => [];
}

class AddNewGroupStartChatEvent extends AddNewGroupEvent {
  final List<FriendModel> friends;
  final String groupName;

  const AddNewGroupStartChatEvent({required this.friends,required this.groupName});

  @override
  List<Object> get props => [];
}
class AddNewParticipantToChatEvent extends AddNewGroupEvent {
  final FriendModel friends;
  final String chatId;

  const AddNewParticipantToChatEvent({required this.friends,required this.chatId});

  @override
  List<Object> get props => [];
}
