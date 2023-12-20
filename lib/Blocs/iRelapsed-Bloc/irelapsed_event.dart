part of 'irelapsed_bloc.dart';

abstract class IrelapsedEvent extends Equatable {
  const IrelapsedEvent();
}

class IRelapsedInitialEvent extends IrelapsedEvent {
  final IRelapsedModel? iRelapsedTileObject;

  const IRelapsedInitialEvent({required this.iRelapsedTileObject});

  @override
  List<Object?> get props => [];
}

class SubmitRelapseEvent extends IrelapsedEvent {
  final IRelapsedModel? iRelapsedTileObject;

  const SubmitRelapseEvent({required this.iRelapsedTileObject});

  @override
  List<Object?> get props => [];
}
