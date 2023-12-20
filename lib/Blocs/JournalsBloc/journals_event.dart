part of 'journals_bloc.dart';

abstract class JournalsEvent extends Equatable {
  const JournalsEvent();
}

class JournalInitialEvent extends JournalsEvent {
  @override
  List<Object?> get props => [];
}

class CreateJournalEvent extends JournalsEvent {
  @override
  List<Object?> get props => [];
}


class OpenJournalEvent extends JournalsEvent {
  final String journalId;

  const OpenJournalEvent({required this.journalId});

  @override
  List<Object?> get props => [journalId];
}

class UpdateJournalEvent extends JournalsEvent {
  final JournalModel journal;

  const UpdateJournalEvent({required this.journal});

  @override
  List<Object?> get props => [journal];
}

class DeleteJournalEvent extends JournalsEvent {
  final String journalId;

  const DeleteJournalEvent({required this.journalId});

  @override
  List<Object?> get props => [journalId];
}
