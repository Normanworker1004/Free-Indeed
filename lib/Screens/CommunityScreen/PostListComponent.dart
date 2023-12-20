import 'package:flutter/cupertino.dart';
import 'package:free_indeed/Models/PostModel.dart';
import 'package:free_indeed/Screens/CommunityScreen/CommunityPostCard.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../Blocs/CommunityBloc/community_bloc.dart';
import 'NoFriendsYetEmptyState.dart';
import 'NoPostsYetEmptyState.dart';

class PostInfiniteList extends StatefulWidget {
  final Function fetchData;
  final PagingController<int, PostModel> pagingController;
  final Function openComments;
  final int activeTabIndex;
  final Function? editPostFunction;
  final bool isPostDetails;
  final CommunityBloc communityBloc;

  const PostInfiniteList(
      {Key? key,
      required this.fetchData,
      required this.openComments,
      required this.activeTabIndex,
      required this.editPostFunction,
      required this.isPostDetails,
      required this.communityBloc,
      required this.pagingController})
      : super(key: key);

  @override
  State<PostInfiniteList> createState() => _PostInfiniteListState();
}

class _PostInfiniteListState extends State<PostInfiniteList> {
  @override
  void initState() {
    widget.pagingController.addPageRequestListener((pageKey) {
      widget.fetchData(pageKey);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PagedListView<int, PostModel>(
      pagingController: widget.pagingController,
      builderDelegate: PagedChildBuilderDelegate<PostModel>(
        noItemsFoundIndicatorBuilder: (_) => Center(
          child: widget.activeTabIndex == 1
              ? FriendsPostsWidget()
              : widget.activeTabIndex == 2
                  ? MineEmptyStateWidget()
                  : Container(),
        ),
        itemBuilder: (context, item, index) => CommunityPostCard(
          postModel: item,
          isPostDetails: widget.isPostDetails,
          activeTabIndex: widget.activeTabIndex,
          likeButton: () {
            widget.communityBloc.add(CommunityLikePostEvent(
                postId: item.id!.toString(), liked: item.liked!));
            // item.liked = !item.liked!;
          },
          openComments: () {
            widget.openComments(item, index);
          },
          editPostFunction: () {
            widget.editPostFunction!(item.id!.toString(), item.postText!);
          },
          deletePostFunction: () {
            widget.communityBloc.add(CommunityDeletePostEvent(
                postId: item.id!.toString(),
                activeIndex: widget.activeTabIndex));
          },
          addFriendFunction: () {
            widget.communityBloc.add(
                CommunityAddFriendEvent(friendCognitoId: item.userCognitoId!));
          },
          muteUserFunction: () {
            widget.communityBloc.add(
                CommunityMuteUserEvent(friendCognitoId: item.userCognitoId!));
          },
          reportFunction: () {
            widget.communityBloc
                .add(CommunityReportUserEvent(postId: item.id!));
          },
        ),
      ),
    );
  }
}
