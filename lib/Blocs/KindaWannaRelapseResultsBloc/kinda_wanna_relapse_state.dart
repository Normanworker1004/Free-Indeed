part of 'kinda_wanna_relapse_bloc.dart';

abstract class KindaWannaRelapseState extends Equatable {
  const KindaWannaRelapseState();
}

class KindaWannaRelapseInitial extends KindaWannaRelapseState {
  @override
  List<Object> get props => [];
}

class KindaWannaSubmissionReadyState extends KindaWannaRelapseState {
  @override
  List<Object> get props => [];
}

class KindaWannaReadyState extends KindaWannaRelapseState {
  final bool refresh;

  const KindaWannaReadyState({required this.refresh});

  @override
  List<Object> get props => [refresh];
}

class KindaWannaLoadingState extends KindaWannaRelapseState {
  @override
  List<Object> get props => [];
}
