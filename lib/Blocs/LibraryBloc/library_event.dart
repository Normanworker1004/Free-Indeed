part of 'library_bloc.dart';

abstract class LibraryEvent extends Equatable {
  const LibraryEvent();
}

class LibraryInitialEvent extends LibraryEvent {
  @override
  List<Object?> get props => [];
}

class LibrarySubmitBlogEvent extends LibraryEvent {

  const LibrarySubmitBlogEvent();

  @override
  List<Object?> get props => [];
}
class LibraryGetFreeIndeedBlogsEvent extends LibraryEvent {

  const LibraryGetFreeIndeedBlogsEvent();

  @override
  List<Object?> get props => [];
}
class LibraryGetMoreTabBlogsEvent extends LibraryEvent {

  const LibraryGetMoreTabBlogsEvent();

  @override
  List<Object?> get props => [];
}

class LibraryGoToBlogEvent extends LibraryEvent {
  final String id;

  const LibraryGoToBlogEvent({required this.id});

  @override
  List<Object?> get props => [id];
}

class LibraryGoToUserBlogEvent extends LibraryEvent {
  final String id;

  const LibraryGoToUserBlogEvent({required this.id});

  @override
  List<Object?> get props => [id];
}




