part of 'home_bloc.dart';

abstract class HomeState extends Equatable {
  const HomeState();
}

class HomeInitial extends HomeState {
  @override
  List<Object> get props => [];
}

class HomeLoading extends HomeState {
  @override
  List<Object> get props => [];
}

class HomeReadyState extends HomeState {
  final GoalModel goal;

  const HomeReadyState({required this.goal});

  @override
  List<Object> get props => [goal];
}
