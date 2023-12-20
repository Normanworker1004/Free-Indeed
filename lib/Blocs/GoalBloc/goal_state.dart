part of 'goal_bloc.dart';

abstract class GoalState extends Equatable {
  const GoalState();
}

class GoalInitial extends GoalState {
  @override
  List<Object> get props => [];
}
class GoalReadyState extends GoalState {
  @override
  List<Object> get props => [];
}
