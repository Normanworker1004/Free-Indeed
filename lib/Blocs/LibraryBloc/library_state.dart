part of 'library_bloc.dart';

abstract class LibraryState extends Equatable {
  const LibraryState();
}

class LibraryInitial extends LibraryState {
  @override
  List<Object> get props => [];
}

class LibraryReadyState extends LibraryState {
  final List<BlogPreviewModel> fellowIndeedBlogs;
  final List<BlogPreviewModel> moreBlogs;

  const LibraryReadyState(
      {required this.fellowIndeedBlogs,
      required this.moreBlogs});

  @override
  List<Object> get props => [ fellowIndeedBlogs, moreBlogs];
}

class LibraryLoadingState extends LibraryState {
  @override
  List<Object> get props => [];
}
