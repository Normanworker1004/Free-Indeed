part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();
}

class HomeInitializeEvent extends HomeEvent {
  @override
  List<Object?> get props => [];
}

class HomeGoToStatsEvent extends HomeEvent {
  @override
  List<Object?> get props => [];
}

class HomeSetGoalEvent extends HomeEvent {
  @override
  List<Object?> get props => [];
}

class HomeGoToKindaWannaRelapseEvent extends HomeEvent {
  @override
  List<Object?> get props => [];
}

class HomeGoToIRelapsedEvent extends HomeEvent {
  @override
  List<Object?> get props => [];
}

class HomeGoToMyJournalsEvent extends HomeEvent {
  @override
  List<Object?> get props => [];
}

class HomeTellUsAboutYourselfEvent extends HomeEvent {
  final String tellYourselfText;

  const HomeTellUsAboutYourselfEvent({required this.tellYourselfText});

  @override
  List<Object?> get props => [];
}
