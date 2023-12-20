import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:free_indeed/Managers/Implementation/Local-data-manager.impl.dart';
import 'package:free_indeed/Managers/LocalDataManager.dart';
import 'package:free_indeed/Managers/named-navigator.dart';
import 'package:free_indeed/Models/CommentModel.dart';
import 'package:free_indeed/Models/PostModel.dart';
import 'package:free_indeed/Models/UserModel.dart';
import 'package:free_indeed/Repo/community_repo.dart';
import 'package:free_indeed/Repo/friendsRepo.dart';
import 'package:free_indeed/Repo/login_repo.dart';
import 'package:free_indeed/Screens/CommunityScreen/Post/CommunityPostScreen.dart';
import 'package:free_indeed/Screens/MyJournalScreen/NewJournalScreen.dart';

import '../../Models/NotificationModel.dart';

part 'community_event.dart';

part 'community_state.dart';

class CommunityBloc extends Bloc<CommunityEvent, CommunityState> {
  final LoginRepo _loginRepo;
  final NamedNavigator _namedNavigator;
  final CommunityRepo _communityRepo;
  final FriendsRepo _friendsRepo;
  late List<PostModel> postModels;
  late String accessToken;
  late UserModel userModel;

  CommunityBloc(
      {required LoginRepo loginRepo,
      required NamedNavigator namedNavigator,
      required FriendsRepo friendsRepo,
      required CommunityRepo communityRepo})
      : this._loginRepo = loginRepo,
        this._namedNavigator = namedNavigator,
        this._friendsRepo = friendsRepo,
        this._communityRepo = communityRepo,
        super(CommunityInitial()) {
    on<CommunityInitialEvent>((event, emit) async {
      EasyLoading.show(status: '');
      emit(CommunityLoadingState(
          user: UserModel(
              username: '',
              cognitoId: "",
              hasNotifications: false,
              id: '',
              subscribed: false,
              success: true)));
      accessToken = LocalDataManagerImpl().readString(CachingKey.ACCESS_TOKEN);
      userModel = await _loginRepo.getUserDataFromCache();
      emit(CommunityReadyState(user: userModel, posts: [], refreshData: false));
      EasyLoading.dismiss();
    });
    on<CommunityRefreshDataEvent>((event, emit) async {
      emit(CommunityReadyState(
          posts: postModels, user: userModel, refreshData: false));
      EasyLoading.dismiss();
    });
    on<CommunityLikePostEvent>((event, emit) async {
      if (event.liked) {
        bool success =
            await _communityRepo.unlikePost(accessToken, event.postId);
        if (success) {
        } else {
          EasyLoading.showToast("error occurred while unliking post");
        }
      } else if (!event.liked) {
        bool success = await _communityRepo.likePost(accessToken, event.postId);
        if (success) {
        } else {
          EasyLoading.showToast("error occurred while liking post");
        }
      }
    });
    on<CommunityGoToFriendsEvent>((event, emit) async {
      _namedNavigator.push(Routes.FRIENDS_ROUTER);
    });
    on<CommunityGoToCommentsEvent>((event, emit) async {
      EasyLoading.show(status: '');
      int didUserLike = 0;
      int commentNumber = event.post.numberOfComments!;
      List<CommentModel> comments =
          await _communityRepo.getPostComments(accessToken, event.post.id!);
      CommunityCommentScreenArgs screenArgs = CommunityCommentScreenArgs(
          comments: comments,
          post: event.post,
          deleteComment: (String postId, String commentId) async {
            EasyLoading.show(status: '');
            bool success = await _communityRepo.deleteComment(
                accessToken, postId, commentId);
            EasyLoading.dismiss();
            if (success) {
              List<CommentModel> newComments = await _communityRepo
                  .getPostComments(accessToken, event.post.id!);
              return newComments;
            } else {
              EasyLoading.showToast("Failed to add comment");
            }
            return comments;
          },
          addComment: (String commentText) async {
            EasyLoading.show(status: '');
            bool success = await addComment(commentText, event.post.id!);
            EasyLoading.dismiss();
            if (success) {
              List<CommentModel> newComments = await _communityRepo
                  .getPostComments(accessToken, event.post.id!);
              commentNumber = newComments.length;
              return newComments;
            } else {
              EasyLoading.showToast("Failed to add comment");
            }
            commentNumber = comments.length;
            return comments;
          },
          likePost: (bool liked, String postId) async {
            if (liked) {
              bool success =
                  await _communityRepo.unlikePost(accessToken, postId);
              if (success) {
                didUserLike = 2;
              } else {
                EasyLoading.showToast("error occurred while unliking post");
              }
            } else if (!liked) {
              bool success = await _communityRepo.likePost(accessToken, postId);
              if (success) {
                didUserLike = 1;
              } else {
                EasyLoading.showToast("error occurred while liking post");
              }
            }
          });
      EasyLoading.dismiss();

      await _namedNavigator.push(Routes.COMMUNITY_COMMENT_ROUTER,
          arguments: screenArgs);

      ///HACK UNTIL WE ADD THE PAGING CONTROLLERS TO BLOC
      // emit(CommunityInitial());
      // await Future.delayed(Duration(milliseconds: 100));
      if (event.activeIndex == 0) {
        event.everyonePosts![event.postIndex].numberOfComments = commentNumber;
      } else if (event.activeIndex == 1) {
        event.friendsPosts![event.postIndex].numberOfComments = commentNumber;
      } else {
        event.myPosts![event.postIndex].numberOfComments = commentNumber;
      }
      if (didUserLike == 1) {
        if (event.activeIndex == 0) {
          event.everyonePosts![event.postIndex].liked = true;
        } else if (event.activeIndex == 1) {
          event.friendsPosts![event.postIndex].liked = true;
        } else {
          event.myPosts![event.postIndex].liked = true;
        }
      } else if (didUserLike == 2) {
        if (event.activeIndex == 0) {
          event.everyonePosts![event.postIndex].liked = false;
        } else if (event.activeIndex == 1) {
          event.friendsPosts![event.postIndex].liked = false;
        } else {
          event.myPosts![event.postIndex].liked = false;
        }
      }

      if (didUserLike != 0) {
        if (event.activeIndex != 0) {
          int index = event.everyonePosts!.indexOf(event.post);
          if (didUserLike == 1) {
            event.everyonePosts![index].liked = true;
            event.everyonePosts![index].numberOfLikes =
                event.everyonePosts![index].numberOfLikes! + 1;
          } else if (didUserLike == 2) {
            event.everyonePosts![index].liked = false;
            event.everyonePosts![index].numberOfLikes =
                event.everyonePosts![index].numberOfLikes! - 1;
          }
        }
        //Post was in Everyone we update in Mine list
        else if (event.post.isMyPost! &&
            event.activeIndex != 2 &&
            event.myPosts != null) {
          int index = event.myPosts!.indexOf(event.post);
          if (didUserLike == 1) {
            event.myPosts![index].liked = true;
            event.myPosts![index].numberOfLikes =
                event.myPosts![index].numberOfLikes! + 1;
          } else if (didUserLike == 2) {
            event.myPosts![index].liked = false;
            event.myPosts![index].numberOfLikes =
                event.myPosts![index].numberOfLikes! - 1;
          }
        } else if (!event.post.isMyPost! &&
            event.activeIndex == 0 &&
            event.friendsPosts != null) {
          if (event.friendsPosts!.contains(event.post)) {
            int index = event.myPosts!.indexOf(event.post);
            if (didUserLike == 1) {
              event.friendsPosts![index].liked = true;
              event.friendsPosts![index].numberOfLikes =
                  event.friendsPosts![index].numberOfLikes! + 1;
            } else if (didUserLike == 2) {
              event.friendsPosts![index].liked = false;

              event.friendsPosts![index].numberOfLikes =
                  event.friendsPosts![index].numberOfLikes! - 1;
            }
          }
        }
      }

      emit(CommunityLoadingState(user: userModel));

      ///HACK TO FORCE REFRESH THE BLOC IN THE UI
      await Future.delayed(Duration(milliseconds: 100));
      emit(CommunityReadyState(
          posts: postModels,
          user: userModel,
          refreshData: false,
          changePostDetails: true,
          friendsPosts: event.friendsPosts,
          everyonePosts: event.everyonePosts,
          myPosts: event.myPosts,
          likedPost: event.post));
    });
    on<CommunityAddFriendEvent>((event, emit) async {
      try {
        EasyLoading.show(status: '');
        bool added =
            await _friendsRepo.addFriend(accessToken, event.friendCognitoId);
        if (added) {
        } else {
          EasyLoading.showToast("Friend already added");
        }
        EasyLoading.dismiss();
        _namedNavigator.pop();
      } catch (e) {
        EasyLoading.dismiss();
        EasyLoading.showToast("Something went wrong .. please try again later");
        print(e);
      }
    });
    on<CommunityMuteUserEvent>((event, emit) async {
      try {
        EasyLoading.show(status: '');
        bool added =
            await _friendsRepo.muteUser(accessToken, event.friendCognitoId);
        if (added) {
          EasyLoading.showToast("User muted");
        } else {
          EasyLoading.showToast("User already muted");
        }
        EasyLoading.dismiss();
        _namedNavigator.pop();
      } catch (e) {
        EasyLoading.dismiss();
        EasyLoading.showToast("Something went wrong .. please try again later");
        print(e);
      }
    });
    on<CommunityReportUserEvent>((event, emit) async {
      try {
        EasyLoading.show(status: '');
        bool added = await _communityRepo.reportPost(
            accessToken, event.postId.toString());
        if (added) {
        } else {
          EasyLoading.showToast(
              "Something went wrong .. please try again later");
        }
        EasyLoading.dismiss();
        _namedNavigator.pop();
      } catch (e) {
        EasyLoading.dismiss();
        EasyLoading.showToast("Something went wrong .. please try again later");
        print(e);
      }
    });
    on<CommunityAddPostEvent>((event, emit) async {
      await namedNavigator.push(Routes.CREATE_JOURNAL_ROUTER,
          arguments: CreateNewPostArgs(
              submitFunction: (String val) async {
                try {
                  bool success = await _communityRepo.addPost(accessToken, val);
                  if (success) {
                    _namedNavigator.push(Routes.LANDING_ROUTER, clean: true);
                  } else {
                    EasyLoading.showToast(
                        "Failed to add your Post .. Please try again later");
                  }
                } catch (e) {
                  print(e);
                }
              },
              titleKey: "add_post_screen_header",
              isJournal: false));
      emit(CommunityInitial());
      await Future.delayed(Duration(milliseconds: 100));
      emit(CommunityReadyState(
          posts: postModels, user: userModel, refreshData: true));
    });
    on<CommunityDeletePostEvent>((event, emit) async {
      _namedNavigator.pop();
      EasyLoading.show(status: '');
      try {
        bool success =
            await _communityRepo.deletePost(accessToken, event.postId);
        EasyLoading.dismiss();
        if (success) {
          emit(CommunityInitial());
          await Future.delayed(Duration(milliseconds: 100));
          emit(CommunityReadyState(
              posts: postModels, user: userModel, refreshData: true));
        }
      } catch (e) {
        EasyLoading.dismiss();
        print(e);
      }
    });
    on<CommunityEditPostEvent>((event, emit) async {
      _namedNavigator.pop();
      emit(CommunityLoadingState(user: userModel));
      bool success = false;
      await namedNavigator.push(
        Routes.CREATE_JOURNAL_ROUTER,
        arguments: CreateNewPostArgs(
            submitFunction: (String val) async {
              try {
                EasyLoading.show(status: "");
                print("hERE IS THE val $val");
                success = await _communityRepo.editPost(
                    accessToken, event.postId, val);

                if (success) {
                  EasyLoading.dismiss();
                  _namedNavigator.pop();
                } else {
                  EasyLoading.dismiss();
                  EasyLoading.showToast(
                      "Failed to add your Post .. Please try again later");
                }
              } catch (e) {
                print(e);
              }
            },
            initialText: event.oldText,
            titleKey: "add_post_screen_header",
            isJournal: false),
      );
      if (success) {
        emit(CommunityLoadingState(user: userModel));
        await Future.delayed(Duration(milliseconds: 100));
        emit(CommunityReadyState(
            posts: postModels, user: userModel, refreshData: true));
      } else {
        emit(CommunityReadyState(
            posts: postModels,
            user: userModel,
            refreshData: false,
            everyonePosts: event.everyonePosts,
            myPosts: event.myPosts,
            friendsPosts: event.friendsPosts));
      }
    });

    on<CommunityDeleteCommentEvent>((event, emit) async {
      EasyLoading.show(status: '');
      try {
        bool success =
            await _communityRepo.deletePost(accessToken, event.postId);
        if (success) {
          // EasyLoading.showToast("Post deleted successfully");
          emit(CommunityInitial());
          await Future.delayed(Duration(milliseconds: 100));
          emit(CommunityReadyState(
              posts: postModels, user: userModel, refreshData: true));
        }
      } catch (e) {
        EasyLoading.dismiss();
        print(e);
      }
    });
    on<CommunityOpenFriendsEvent>((event, emit) async {
      await _namedNavigator.push(Routes.FRIENDS_ROUTER);
      emit(CommunityReadyState(
          posts: postModels, user: userModel, refreshData: true));
    });
  }

  Future<bool> addComment(String commentText, int id) async {
    try {
      print("hERE IS THE val $commentText");
      bool success = await _communityRepo.addComment(
          accessToken, commentText, id.toString());
      if (success) {
        // EasyLoading.showToast("Comment Added Successfully");
        return true;
      } else {
        EasyLoading.showToast(
            "Failed to add your Comment .. Please try again later");
        return false;
      }
    } catch (e) {
      print(e);
    }
    return false;
  }

  Future<List<PostModel>> getNextEveryonePage(int pageNumber) async {
    postModels = [];
    postModels = await _communityRepo.getEveryonePosts(
        accessToken, pageNumber.toString());
    return postModels;
  }

  Future<List<PostModel>> getNextFriendsPage(int pageNumber) async {
    postModels = [];
    postModels = await _communityRepo.getMyFriendsPosts(
        accessToken, pageNumber.toString());
    return postModels;
  }

  Future<List<PostModel>> getNextMinePage(int pageNumber) async {
    postModels = [];
    postModels =
        await _communityRepo.getMinePosts(accessToken, pageNumber.toString());
    return postModels;
  }

  Future<List<NotificationModel>> getNextNotificationPage(
      int pageNumber) async {
    List<NotificationModel> notifications = [];
    notifications =
        await _communityRepo.getMyNotifications(accessToken, pageNumber);
    return notifications;
  }
}
