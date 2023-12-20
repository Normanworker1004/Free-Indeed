part of 'get_relapses_bloc.dart';

abstract class GetRelapsesEvent extends Equatable {
  const GetRelapsesEvent();
}

class GetRelapseInitializeEvent extends GetRelapsesEvent {
  @override
  List<Object?> get props => [];
}

class GetRelapseDeleteRelapseEvent extends GetRelapsesEvent {
  final IRelapsedModel? iRelapsedModel;

  const GetRelapseDeleteRelapseEvent({required this.iRelapsedModel});

  @override
  List<Object?> get props => [];
}

class GetRelapseOpenRelapseEvent extends GetRelapsesEvent {
  final IRelapsedModel? iRelapsedModel;

  const GetRelapseOpenRelapseEvent({required this.iRelapsedModel});

  @override
  List<Object?> get props => [];
}
