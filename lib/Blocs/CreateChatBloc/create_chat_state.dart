part of 'create_chat_bloc.dart';

abstract class CreateChatState extends Equatable {
  const CreateChatState();
}

class CreateChatInitial extends CreateChatState {
  @override
  List<Object> get props => [];
}
class CreateChatReadyState extends CreateChatState {

  @override
  List<Object> get props => [];
}
