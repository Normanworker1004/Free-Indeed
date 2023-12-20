part of 'community_bloc.dart';

abstract class CommunityState extends Equatable {
  const CommunityState();
}

class CommunityInitial extends CommunityState {
  @override
  List<Object> get props => [];
}

// ignore: must_be_immutable
class CommunityReadyState extends CommunityState {
  final List<PostModel> posts;
  final UserModel user;
  final bool refreshData;
  bool? changePostDetails;
  PostModel? likedPost;
  List<PostModel>? everyonePosts;
  List<PostModel>? friendsPosts;
  List<PostModel>? myPosts;

  CommunityReadyState(
      {required this.posts,
      required this.user,
      required this.refreshData,
      this.likedPost,
      this.changePostDetails,
      this.everyonePosts,
      this.friendsPosts,
      this.myPosts});

  @override
  List<Object> get props => [posts, user];
}

class CommunityLoadingState extends CommunityState {
  final UserModel user;

  const CommunityLoadingState({required this.user});

  @override
  List<Object> get props => [];
}
