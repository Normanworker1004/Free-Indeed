part of 'chat_bottom_sheet_bloc.dart';

abstract class ChatBottomSheetEvent extends Equatable {
  const ChatBottomSheetEvent();
}

class ChatBottomSheetInitializeEvent extends ChatBottomSheetEvent {
  @override
  List<Object> get props => [];
}

class ChatBottomSheetAddParticipant extends ChatBottomSheetEvent {
  final String chatId;
  final ChatCreatedModel chatCreatedModel;

  const ChatBottomSheetAddParticipant ({ required this.chatId,required this.chatCreatedModel});
  @override
  List<Object> get props => [];
}

class ChatBottomSheetDeleteParticipant extends ChatBottomSheetEvent {
  final String chatId;
  final String participantId;

  const ChatBottomSheetDeleteParticipant(
      {required this.chatId, required this.participantId});

  @override
  List<Object> get props => [];
}

class ChatBottomSheetDeleteChat extends ChatBottomSheetEvent {
  final String chatId;

  const ChatBottomSheetDeleteChat({required this.chatId});

  @override
  List<Object> get props => [];
}

class ChatBottomSheetLeaveChat extends ChatBottomSheetEvent {
  final String chatId;

  const ChatBottomSheetLeaveChat({required this.chatId});

  @override
  List<Object> get props => [];
}

class ChatBottomSheetChangeGroupName extends ChatBottomSheetEvent {
  final String chatId;
  final String newGroupName;

  const ChatBottomSheetChangeGroupName(
      {required this.chatId, required this.newGroupName});

  @override
  List<Object> get props => [];
}
