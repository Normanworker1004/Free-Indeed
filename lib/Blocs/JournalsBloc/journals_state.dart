part of 'journals_bloc.dart';

abstract class JournalsState extends Equatable {
  const JournalsState();
}

class JournalsInitial extends JournalsState {
  @override
  List<Object> get props => [];
}

class JournalsLoading extends JournalsState {
  @override
  List<Object> get props => [];
}

class JournalReadyState extends JournalsState {
  final bool refresh;

  const JournalReadyState({required this.refresh});

  @override
  List<Object> get props => [refresh];
}
