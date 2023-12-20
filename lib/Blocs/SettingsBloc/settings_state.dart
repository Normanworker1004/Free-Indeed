part of 'settings_bloc.dart';

abstract class SettingsState extends Equatable {
  const SettingsState();
}

class SettingsInitial extends SettingsState {
  @override
  List<Object> get props => [];
}

class SettingsReadyState extends SettingsState {
  final UserModel userModel;

  const SettingsReadyState({required this.userModel});

  @override
  List<Object> get props => [];
}
