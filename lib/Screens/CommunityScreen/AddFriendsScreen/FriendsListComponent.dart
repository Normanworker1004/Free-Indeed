import 'package:flutter/cupertino.dart';
import 'package:free_indeed/Models/FriendsModel.dart';
import 'package:free_indeed/Screens/CommunityScreen/AddFriendsScreen/FriendsListTile.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class FriendsInfiniteList extends StatefulWidget {
  final Function addFriend;
  final Function fetchData;
  final PagingController<int, FriendModel> pagingController;

  const FriendsInfiniteList(
      {Key? key,
      required this.addFriend,
      required this.fetchData,
      required this.pagingController})
      : super(key: key);

  @override
  State<FriendsInfiniteList> createState() => _FriendsInfiniteListState();
}

class _FriendsInfiniteListState extends State<FriendsInfiniteList> {
  @override
  void initState() {
    widget.pagingController.addPageRequestListener((pageKey) {
      widget.fetchData(pageKey);
    });
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return PagedListView<int, FriendModel>(
      pagingController: widget.pagingController,
      builderDelegate: PagedChildBuilderDelegate<FriendModel>(
        itemBuilder: (context, item, index) => FriendsListTile(
          friendModel: item,
          addFriend: (FriendModel cognitoId) {
            widget.addFriend(cognitoId);
          },
        ),
      ),
      shrinkWrap: true,
    );
  }
}
