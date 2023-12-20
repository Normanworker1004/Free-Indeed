part of 'get_relapses_bloc.dart';

abstract class GetRelapsesState extends Equatable {
  const GetRelapsesState();
}

class GetRelapsesInitial extends GetRelapsesState {
  @override
  List<Object> get props => [];
}

class GetRelapsesReadyState extends GetRelapsesState {
  final List<List<IRelapsedModel>> relapses;

  const GetRelapsesReadyState({required this.relapses});

  @override
  List<Object> get props => [];
}

class GetRelapsesLoadingState extends GetRelapsesState {
  @override
  List<Object> get props => [];
}
