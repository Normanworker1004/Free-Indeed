part of 'bible_bloc.dart';

abstract class BibleState extends Equatable {
  const BibleState();
}

class BibleInitial extends BibleState {
  @override
  List<Object> get props => [];
}

class BibleLoading extends BibleState {
  final List<VersesCategoriesModel> categories;

  const BibleLoading({required this.categories});

  @override
  List<Object> get props => [];
}

class BibleReadyState extends BibleState {
  final List<VersesCategoriesModel> categories;

  const BibleReadyState({required this.categories});

  @override
  List<Object> get props => [];
}
