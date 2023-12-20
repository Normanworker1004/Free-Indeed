part of 'add_new_group_bloc.dart';

abstract class AddNewGroupState extends Equatable {
  const AddNewGroupState();
}

class AddNewGroupInitial extends AddNewGroupState {
  @override
  List<Object> get props => [];
}

class AddNewGroupReadyState extends AddNewGroupState {
  final List<FriendModel> friends;

  const AddNewGroupReadyState({required this.friends});

  @override
  List<Object> get props => [];
}
