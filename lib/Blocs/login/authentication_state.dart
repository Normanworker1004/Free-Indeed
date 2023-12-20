part of 'authentication_bloc.dart';

abstract class AuthenticationState extends Equatable {
  const AuthenticationState();
}

class AuthenticationInitial extends AuthenticationState {
  @override
  List<Object> get props => [];
}

class AuthenticationLoading extends AuthenticationState {
  @override
  List<Object> get props => [];
}

class AuthenticationReady extends AuthenticationState {
  @override
  List<Object> get props => [];
}

class AuthenticationForgetPasswordReady extends AuthenticationState {
  final bool enterPassword;

  const AuthenticationForgetPasswordReady({required this.enterPassword});

  @override
  List<Object> get props => [];
}
class AuthenticationLoggedIn extends AuthenticationState {
  @override
  List<Object> get props => [];
}
