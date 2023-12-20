import 'package:flutter/cupertino.dart';
import 'package:free_indeed/Models/FriendsModel.dart';
import 'package:free_indeed/Screens/ChatScreen/ShowFriendsList/CreateChatFriendTile.dart';
import 'package:free_indeed/configs/ScreenConfig.dart';
import 'package:free_indeed/configs/general_configs.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class FriendsChatsInfiniteList extends StatefulWidget {
  final Function startChatWithFriend;
  final Function fetchData;
  final List<FriendModel> selectedFriends;
  final PagingController<int, FriendModel> pagingController;

  const FriendsChatsInfiniteList(
      {Key? key,
      required this.startChatWithFriend,
      required this.fetchData,
      required this.selectedFriends,
      required this.pagingController})
      : super(key: key);

  @override
  State<FriendsChatsInfiniteList> createState() =>
      _FriendsChatsInfiniteListState();
}

class _FriendsChatsInfiniteListState extends State<FriendsChatsInfiniteList> {
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
      physics: NeverScrollableScrollPhysics(),
      builderDelegate: PagedChildBuilderDelegate<FriendModel>(
        noItemsFoundIndicatorBuilder: (_) => SizedBox(
          // padding: EdgeInsets.only(top: 40.0),
          height: ScreenConfig.screenHeight / 2,
          child: Center(
            child: Text(
              "Add users as friends so you can message them privately!",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 15,
                  color: GeneralConfigs.SECONDARY_COLOR),
            ),
          ),
        ),
        itemBuilder: (context, item, index) => CreateChatFriendTile(
          contact: item,

          selected: widget.selectedFriends.contains(item),
          onTap: (FriendModel cognitoId) {
            widget.startChatWithFriend(cognitoId);
          },
        ),
      ),
      shrinkWrap: true,
    );
  }
}
