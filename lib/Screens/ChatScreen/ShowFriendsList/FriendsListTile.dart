import 'package:free_indeed/Models/FriendsModel.dart';
import 'package:free_indeed/configs/general_configs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FriendsListTile extends StatefulWidget {
  final FriendModel friendModel;
  final Function addFriend;

  const FriendsListTile(
      {Key? key, required this.friendModel, required this.addFriend})
      : super(key: key);

  @override
  _FriendsListTileState createState() => _FriendsListTileState();
}

class _FriendsListTileState extends State<FriendsListTile> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            widget.friendModel.username!,
            style: TextStyle(
                color: GeneralConfigs.SECONDARY_COLOR,
                fontSize: 16,
                fontWeight: FontWeight.w400),
          ),
          GestureDetector(
            onTap: () {
              widget.addFriend(widget.friendModel);
              setState(() {
                widget.friendModel.isFriend = !widget.friendModel.isFriend!;
              });
            },
            child: widget.friendModel.isFriend!
                ? SvgPicture.asset(
                    GeneralConfigs.ICONS_PATH + "addedFriend.svg",
                    width: 28,
                    height: 28,
                    fit: BoxFit.scaleDown,
                  )
                : SvgPicture.asset(
                    GeneralConfigs.ICONS_PATH + "addFriendChatIcon.svg",
                    width: 28,
                    height: 28,
                    fit: BoxFit.scaleDown,
                  ),
          ),
        ],
      ),
    );
  }
}
