part of 'bible_bloc.dart';

abstract class BibleEvent extends Equatable {
  const BibleEvent();
}

class BibleInitialize extends BibleEvent {
  @override
  List<Object> get props => [];
}

class BibleGetVersesEvent extends BibleEvent {
  final VersesCategoriesModel categoriesModel;

  const BibleGetVersesEvent({required this.categoriesModel});

  @override
  List<Object> get props => [];
}

