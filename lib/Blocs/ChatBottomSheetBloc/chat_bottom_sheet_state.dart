part of 'chat_bottom_sheet_bloc.dart';

abstract class ChatBottomSheetState extends Equatable {
  const ChatBottomSheetState();
}

class ChatBottomSheetInitial extends ChatBottomSheetState {
  @override
  List<Object> get props => [];
}
class ChatBottomSheetReadyState extends ChatBottomSheetState {
  @override
  List<Object> get props => [];
}
