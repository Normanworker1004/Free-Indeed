part of 'create_chat_bloc.dart';

abstract class CreateChatEvent extends Equatable {
  const CreateChatEvent();
}

class CreateChatInitializeEvent extends CreateChatEvent {
  @override
  List<Object> get props => [];
}


class CreateChatGoToNewGroupScreenEvent extends CreateChatEvent {
  @override
  List<Object> get props => [];
}

class CreateChatStartChatScreenEvent extends CreateChatEvent {
  final String otherParticipant;

  const CreateChatStartChatScreenEvent({required this.otherParticipant});

  @override
  List<Object> get props => [];
}
