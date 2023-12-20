import 'package:free_indeed/Models/ContactModel.dart';
import 'package:free_indeed/Models/MessagePreviewModel.dart';
import 'package:free_indeed/configs/general_configs.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ContactMessageTile extends StatefulWidget {
  final MessagePreviewModel? message;
  final ContactModel? contact;
  final Function onTap;
  final Function deleteIndividualChat;

  const ContactMessageTile(
      {Key? key,
      this.contact,
      this.message,
      required this.onTap,
      required this.deleteIndividualChat})
      : super(key: key);

  @override
  State<ContactMessageTile> createState() => _ContactMessageTileState();
}

class _ContactMessageTileState extends State<ContactMessageTile> {
  bool showDeleteButton = false;

  @override
  Widget build(BuildContext context) {
    String avatarName = "";
    // if (widget.contact != null) {
    //   onlineStatus = widget.contact!.contactStatus.value
    //       .compareTo(ContactStatus.ONLINE.value);
    // }
    try {
      List<String> name = [];
      name = widget.message != null
          ? widget.message!.displayName!.split(" ")
          : widget.contact != null
              ? widget.contact!.contactName!.split(" ")
              : [];
      for (int i = 0; i < name.length; i++) {
        avatarName = avatarName + name[i][0];
      }
    } catch (e) {
      print(e);
    }

    return GestureDetector(
      onHorizontalDragEnd: (details) {
        if (details.primaryVelocity! < 0) {
          setState(() {
            showDeleteButton = !showDeleteButton;
          });
        }
      },
      child: ListTile(
        onTap: () {
          widget.onTap();
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
        title: messagePreview(context),
        subtitle: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            widget.message != null && widget.message!.lastMessage != null
                ? Padding(
                    padding: EdgeInsets.symmetric(vertical: 4.0),
                    child: Text(
                      widget.message!.lastMessage!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: GeneralConfigs.MESSAGE_PREVIEW_COLOR,
                          fontWeight: FontWeight.w400,
                          fontSize: 16),
                    ),
                  )
                : Container(),
            widget.message!.isGroup != null &&
                    !widget.message!.isGroup! &&
                    showDeleteButton
                ? GestureDetector(
                    onTap: () {
                      widget.deleteIndividualChat();
                    },
                    child: Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                  )
                : Container()
          ],
        ),
      ),
    );
  }

  Widget messagePreview(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.message != null && widget.message!.groupName != null
            ? Text(
                widget.message!.groupName!,
                style: TextStyle(
                    color: GeneralConfigs.SECONDARY_COLOR,
                    fontWeight: FontWeight.w400,
                    fontSize: 17),
              )
            : widget.message != null && widget.message!.displayName != null
                ? Text(
                    widget.message!.displayName!,
                    style: TextStyle(
                        color: GeneralConfigs.SECONDARY_COLOR,
                        fontWeight: FontWeight.w400,
                        fontSize: 17),
                  )
                : Container(),
        widget.message != null &&
                widget.message!.lastMessageDateTime != null &&
                widget.message!.lastMessageDateTime!.isNotEmpty
            ? Padding(
                padding: EdgeInsets.symmetric(vertical: 4.0),
                child: Text(
                  DateFormat('HH:MM').format(
                    DateTime.parse(widget.message!.lastMessageDateTime!),
                  ),
                  style: TextStyle(
                      color: GeneralConfigs.SECONDARY_COLOR,
                      fontWeight: FontWeight.w400,
                      fontSize: 14),
                ),
              )
            : Container(),
      ],
    );
  }
}
