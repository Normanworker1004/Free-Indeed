part of 'sign_up_bloc.dart';

abstract class SignUpState extends Equatable {
  const SignUpState();
}

class SignUpInitialState extends SignUpState {
  @override
  List<Object> get props => [];
}

class SignUpLoadingState extends SignUpState {
  @override
  List<Object> get props => [];
}
