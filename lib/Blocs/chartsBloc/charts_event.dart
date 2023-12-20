part of 'charts_bloc.dart';

abstract class ChartsEvent extends Equatable {
  const ChartsEvent();
}

class ChartsInitializeEvent extends ChartsEvent {
  @override
  List<Object> get props => [];
}

class ChartsSelectRelapsePerEvent extends ChartsEvent {
  final int? choice;

  const ChartsSelectRelapsePerEvent({required this.choice});

  @override
  List<Object> get props => [];
}
