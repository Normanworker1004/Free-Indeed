part of 'charts_bloc.dart';

abstract class ChartsState extends Equatable {
  const ChartsState();
}

class ChartsInitial extends ChartsState {
  @override
  List<Object> get props => [];
}

class ChartsLoadingState extends ChartsState {
  @override
  List<Object> get props => [];
}

class ChartsReadyState extends ChartsState {
  final List<IRelapsedTileObject> triggers;

  const ChartsReadyState({
      required this.triggers});

  @override
  List<Object> get props => [];
}
