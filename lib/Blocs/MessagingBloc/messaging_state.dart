part of 'messaging_bloc.dart';

abstract class MessagingState extends Equatable {
  const MessagingState();
}

class MessagingInitial extends MessagingState {
  @override
  List<Object> get props => [];
}

class MessagingReadyState extends MessagingState {
  final List<MessagePreviewModel> messages;
  final bool refreshScreen;

  const MessagingReadyState({required this.messages,required this.refreshScreen});

  @override
  List<Object> get props => [];
}
class MessagingSearchState extends MessagingState {
  final List<MessagePreviewModel> messages;

  const MessagingSearchState({required this.messages});

  @override
  List<Object> get props => [];
}
