part of 'settings_bloc.dart';

abstract class SettingsEvent extends Equatable {
  const SettingsEvent();
}

class SettingsInitializeEvent extends SettingsEvent {
  @override
  List<Object> get props => [];
}

class SettingsChangeUserNameEvent extends SettingsEvent {
  final String newUserName;

  const SettingsChangeUserNameEvent({required this.newUserName});

  @override
  List<Object> get props => [];
}

class SettingsNotificationEvent extends SettingsEvent {
  @override
  List<Object> get props => [];
}

class SettingsManageSubscriptionEvent extends SettingsEvent {
  @override
  List<Object> get props => [];
}

class SettingsContactUsEvent extends SettingsEvent {
  @override
  List<Object> get props => [];
}

class SettingsRateUsEvent extends SettingsEvent {
  @override
  List<Object> get props => [];
}

class SettingsPrivacyPolicyEvent extends SettingsEvent {
  @override
  List<Object> get props => [];
}

class SettingsTermsAndConditionsEvent extends SettingsEvent {
  @override
  List<Object> get props => [];
}

class SettingsSignOutEvent extends SettingsEvent {
  @override
  List<Object> get props => [];
}

class SettingsDeleteUserEvent extends SettingsEvent {
  @override
  List<Object> get props => [];
}
