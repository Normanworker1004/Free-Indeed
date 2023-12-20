part of 'sign_up_bloc.dart';

abstract class SignUpEvent extends Equatable {
  const SignUpEvent();
}

class SignUpInitializeEvent extends SignUpEvent {
  @override
  List<Object?> get props => [];
}

class SignUpGoToSignInEvent extends SignUpEvent {
  @override
  List<Object?> get props => [];
}

class SignUpResendCodeEvent extends SignUpEvent {
  final String email;

  const SignUpResendCodeEvent({required this.email});

  @override
  List<Object?> get props => [];
}

class SigningUpEvent extends SignUpEvent {
  final String userName;
  final String password;
  final String email;

  const SigningUpEvent(
      {required this.userName, required this.email, required this.password});

  @override
  List<Object?> get props => [];
}

class VerifyCodeEvent extends SignUpEvent {
  final String code;
  final String email;

  const VerifyCodeEvent({required this.email, required this.code});

  @override
  List<Object?> get props => [];
}
