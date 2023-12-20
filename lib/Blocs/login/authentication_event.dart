part of 'authentication_bloc.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();
}

class AuthenticationInitializeEvent extends AuthenticationEvent {
  @override
  List<Object?> get props => [];
}

class AuthenticationInitializeForgetPasswordEvent extends AuthenticationEvent {
  @override
  List<Object?> get props => [];
}

class AuthenticationLoginEvent extends AuthenticationEvent {
  final String userName;
  final String password;

  const AuthenticationLoginEvent(
      {required this.userName, required this.password});

  @override
  List<Object?> get props => [userName, password];
}

class AuthenticationGoToSignUp extends AuthenticationEvent {
  @override
  List<Object?> get props => [];
}

class AuthenticationForgetPasswordEmailConfirm extends AuthenticationEvent {
  final String username;

  const AuthenticationForgetPasswordEmailConfirm({required this.username});

  @override
  List<Object?> get props => [];
}

class AuthenticationForgetPasswordNewPasswordConfirm
    extends AuthenticationEvent {
  final String username;
  final String newPassword;
  final String code;

  const AuthenticationForgetPasswordNewPasswordConfirm(
      {required this.username, required this.newPassword, required this.code});

  @override
  List<Object?> get props => [];
}

class AuthenticationGoToForgetPassword extends AuthenticationEvent {
  @override
  List<Object?> get props => [];
}
