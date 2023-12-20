part of 'goal_bloc.dart';

abstract class GoalEvent extends Equatable {
  const GoalEvent();
}

class GoalInitializeEvent extends GoalEvent {
  @override
  List<Object?> get props => [];
}

class GoalSetGoalEvent extends GoalEvent {
  final int goalDays;
  final int showProgress;

  const GoalSetGoalEvent({required this.goalDays, required this.showProgress});

  @override
  List<Object?> get props => [];
}
