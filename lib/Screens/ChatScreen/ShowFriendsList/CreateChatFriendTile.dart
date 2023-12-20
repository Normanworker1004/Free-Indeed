import 'package:free_indeed/Models/FriendsModel.dart';
import 'package:free_indeed/configs/general_configs.dart';
import 'package:flutter/material.dart';

class CreateChatFriendTile extends StatefulWidget {
  final FriendModel? contact;
  final Function onTap;
  final bool selected;

  const CreateChatFriendTile(
      {Key? key, this.contact, required this.onTap, required this.selected})
      : super(key: key);

  @override
  State<CreateChatFriendTile> createState() => _CreateChatFriendTileState();
}

class _CreateChatFriendTileState extends State<CreateChatFriendTile> {
  String avatarName = "";

  @override
  void initState() {
    try {
      List<String> name = [];
      name = widget.contact!.username!.split(" ");
      for (int i = 0; i < name.length; i++) {
        avatarName = avatarName + name[i][0];
      }
    } catch (e) {
      print(e);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        widget.onTap(widget.contact);
      },
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        backgroundColor: Colors.white,
        child: Text(
          avatarName,
          style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 18,
              color: GeneralConfigs.AVATAR_TEXT_NAME_COLOR),
        ),
      ),
      title: Padding(
        padding: EdgeInsets.symmetric(vertical: 4.0),
        child: Text(
          widget.contact!.username!,
          style: TextStyle(
              color: GeneralConfigs.SECONDARY_COLOR,
              fontWeight: FontWeight.w400,
              fontSize: 16),
        ),
      ),
      trailing: widget.selected
          ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  Icon(
                    Icons.check_circle,
                    color: GeneralConfigs.AVATAR_TEXT_NAME_COLOR,
                    size: 25,
                  ),
                  Icon(
                    Icons.check,
                    color: GeneralConfigs.SECONDARY_COLOR,
                    size: 15,
                  ),
                ],
              ),
            )
          : SizedBox(
              width: 10,
              height: 10,
            ),
    );
  }
}
