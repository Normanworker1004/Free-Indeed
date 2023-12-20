part of 'community_bloc.dart';

abstract class CommunityEvent extends Equatable {
  const CommunityEvent();
}

class CommunityInitialEvent extends CommunityEvent {
  @override
  List<Object?> get props => [];
}

class CommunityRefreshDataEvent extends CommunityEvent {
  @override
  List<Object?> get props => [];
}

class CommunityGetMorePostsEveryoneEvent extends CommunityEvent {
  @override
  List<Object?> get props => [];
}

class CommunityEveryoneGetNextEvent extends CommunityEvent {
  final int pageNumber;

  const CommunityEveryoneGetNextEvent({required this.pageNumber});

  @override
  List<Object?> get props => [];
}

class CommunityFriendsGetNextEvent extends CommunityEvent {
  final int pageNumber;

  const CommunityFriendsGetNextEvent({required this.pageNumber});

  @override
  List<Object?> get props => [];
}

class CommunityMineGetNextEvent extends CommunityEvent {
  final int pageNumber;

  const CommunityMineGetNextEvent({required this.pageNumber});

  @override
  List<Object?> get props => [];
}

class CommunityLikePostEvent extends CommunityEvent {
  final String postId;
  final bool liked;

  const CommunityLikePostEvent({required this.postId, required this.liked});

  @override
  List<Object?> get props => [postId, liked];
}

class CommunityCommentPostEvent extends CommunityEvent {
  final String postId;
  final String commentText;

  const CommunityCommentPostEvent(
      {required this.postId, required this.commentText});

  @override
  List<Object?> get props => [postId, commentText];
}

class CommunityGoToFriendsEvent extends CommunityEvent {
  @override
  List<Object?> get props => [];
}

class CommunityGoToCommentsEvent extends CommunityEvent {
  final PostModel post;
  final List<PostModel>? everyonePosts;
  final List<PostModel>? friendsPosts;
  final List<PostModel>? myPosts;
  final int postIndex;
  final int activeIndex;

  const CommunityGoToCommentsEvent(
      {required this.post,
      required this.everyonePosts,
      required this.myPosts,
      required this.friendsPosts,
      required this.activeIndex,
      required this.postIndex});

  @override
  List<Object?> get props => [];
}

class CommunityAddFriendEvent extends CommunityEvent {
  final String friendCognitoId;

  const CommunityAddFriendEvent({required this.friendCognitoId});

  @override
  List<Object?> get props => [friendCognitoId];
}

class CommunityMuteUserEvent extends CommunityEvent {
  final String friendCognitoId;

  const CommunityMuteUserEvent({required this.friendCognitoId});

  @override
  List<Object?> get props => [friendCognitoId];
}

class CommunityReportUserEvent extends CommunityEvent {
  final int postId;

  const CommunityReportUserEvent({required this.postId});

  @override
  List<Object?> get props => [postId];
}

class CommunityDeletePostEvent extends CommunityEvent {
  final String postId;
  final int activeIndex;

  const CommunityDeletePostEvent(
      {required this.postId, required this.activeIndex});

  @override
  List<Object?> get props => [postId];
}

class CommunityDeleteCommentEvent extends CommunityEvent {
  final String commentId;
  final String postId;

  const CommunityDeleteCommentEvent(
      {required this.postId, required this.commentId});

  @override
  List<Object?> get props => [postId];
}

class CommunityEditPostEvent extends CommunityEvent {
  final String postId;
  final String oldText;
  final int activeIndex;
  final List<PostModel>? everyonePosts;
  final List<PostModel>? friendsPosts;
  final List<PostModel>? myPosts;

  const CommunityEditPostEvent(
      {required this.postId,
      required this.oldText,
      required this.activeIndex,
      required this.everyonePosts,
      required this.friendsPosts,
      required this.myPosts});

  @override
  List<Object?> get props => [postId];
}

class CommunityAddPostEvent extends CommunityEvent {
  @override
  List<Object?> get props => [];
}

class CommunityOpenFriendsEvent extends CommunityEvent {
  @override
  List<Object?> get props => [];
}
