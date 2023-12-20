import 'package:flutter/material.dart';
import 'package:free_indeed/Models/MessagePreviewModel.dart';
import 'package:free_indeed/Screens/MessagesScreen/MessageTile.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import 'MessagesEmptyState.dart';

class MessageInfiniteList extends StatefulWidget {
  final Function openChat;
  final Function deleteChat;
  final Function fetchData;
  final PagingController<int, MessagePreviewModel> pagingController;

  const MessageInfiniteList(
      {Key? key,
      required this.fetchData,
      required this.deleteChat,
      required this.pagingController,
      required this.openChat})
      : super(key: key);

  @override
  State<MessageInfiniteList> createState() => _MessageInfiniteListState();
}

class _MessageInfiniteListState extends State<MessageInfiniteList> {
  @override
  void initState() {
    widget.pagingController.addPageRequestListener((pageKey) {
      widget.fetchData(pageKey);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: PagedListView<int, MessagePreviewModel>(
      pagingController: widget.pagingController,
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      builderDelegate: PagedChildBuilderDelegate<MessagePreviewModel>(
        noItemsFoundIndicatorBuilder: (context) {
          return Padding(
            padding: EdgeInsets.only(top: 20.0),
            child: Center(child: MessagingEmptyState()),
          );
        },
        itemBuilder: (context, item, index) => Padding(
          padding: EdgeInsets.symmetric(vertical: 5),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: ContactMessageTile(
              message: item,
              onTap: () {
                widget.openChat(item);
              },
              deleteIndividualChat: () {
                widget.deleteChat(item);
              },
            ),
          ),
        ),
      ),
    ));
  }
}
