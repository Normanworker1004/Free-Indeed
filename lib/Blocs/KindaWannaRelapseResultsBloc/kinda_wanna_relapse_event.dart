part of 'kinda_wanna_relapse_bloc.dart';

abstract class KindaWannaRelapseEvent extends Equatable {
  const KindaWannaRelapseEvent();
}

class KindaWannaInitializeEvent extends KindaWannaRelapseEvent {
  @override
  List<Object> get props => [];
}


class KindaWannaInitializeSubmitEvent extends KindaWannaRelapseEvent {
  @override
  List<Object> get props => [];
}

class KindaWannaCreateEvent extends KindaWannaRelapseEvent {
  final KindaWannaRelapseModel kindaWannaRelapseModel;

  const KindaWannaCreateEvent({required this.kindaWannaRelapseModel});

  @override
  List<Object> get props => [];
}

class KindaWannaUpdateEvent extends KindaWannaRelapseEvent {
  final KindaWannaRelapseModel kindaWannaRelapseModel;

  const KindaWannaUpdateEvent({required this.kindaWannaRelapseModel});

  @override
  List<Object> get props => [];
}

class KindaWannaOpenEditEvent extends KindaWannaRelapseEvent {
  final KindaWannaRelapseModel kindaWannaRelapseModel;

  const KindaWannaOpenEditEvent({required this.kindaWannaRelapseModel});

  @override
  List<Object> get props => [];
}

class KindaWannaDeleteEvent extends KindaWannaRelapseEvent {
  final KindaWannaRelapseModel kindaWannaRelapseModel;
  final List<KindaWannaRelapseModel> allRelapses;
  final int index;

  const KindaWannaDeleteEvent(
      {required this.kindaWannaRelapseModel, required this.allRelapses,required this.index});

  @override
  List<Object> get props => [];
}
