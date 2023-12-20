part of 'irelapsed_bloc.dart';

abstract class IrelapsedState extends Equatable {
  const IrelapsedState();
}

class IrelapsedInitial extends IrelapsedState {
  @override
  List<Object> get props => [];
}
class IRelapsedReadyState extends IrelapsedState {
  final List<IRelapsedTileObject> relapsesList;
  final List<TriggerObject> triggersList;

  const IRelapsedReadyState(
      {required this.relapsesList, required this.triggersList});

  @override
  List<Object> get props => [relapsesList, triggersList];
}
class IRelapsedLoadingState extends IrelapsedState {
  @override
  List<Object> get props => [];
}