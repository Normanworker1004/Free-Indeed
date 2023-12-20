part of 'messaging_bloc.dart';

abstract class MessagingEvent extends Equatable {
  const MessagingEvent();
}

class MessagingInitializeEvent extends MessagingEvent {
  @override
  List<Object> get props => [];
}

class MessagingGetNextFriendsEvent extends MessagingEvent {
  @override
  List<Object> get props => [];
}

class MessagingGoToNewGroupScreenEvent extends MessagingEvent {
  @override
  List<Object> get props => [];
}

class MessagingGoToIndividualChatScreenEvent extends MessagingEvent {
  final MessagePreviewModel message;

  const MessagingGoToIndividualChatScreenEvent({required this.message});

  @override
  List<Object> get props => [];
}

class MessagingStartChatScreenEvent extends MessagingEvent {
  @override
  List<Object> get props => [];
}

class MessagingSearchScreenEvent extends MessagingEvent {
  final List<MessagePreviewModel> messagesList;
  final String searchTerm;

  const MessagingSearchScreenEvent(
      {required this.messagesList, required this.searchTerm});

  @override
  List<Object> get props => [];
}

class MessagingDeleteChatEvent extends MessagingEvent {
  final MessagePreviewModel message;

  const MessagingDeleteChatEvent({
    required this.message,
  });

  @override
  List<Object> get props => [];
}
