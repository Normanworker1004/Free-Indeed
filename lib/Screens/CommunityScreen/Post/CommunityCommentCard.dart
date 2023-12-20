import 'package:free_indeed/Models/CommentModel.dart';
import 'package:free_indeed/configs/general_configs.dart';
import 'package:flutter/material.dart';

class CommunityCommentCard extends StatefulWidget {
  final CommentModel commentModel;
  final Function deleteComment;

  const CommunityCommentCard({
    Key? key,
    required this.commentModel,
    required this.deleteComment,
  }) : super(key: key);

  @override
  _CommunityCommentCardState createState() => _CommunityCommentCardState();
}

class _CommunityCommentCardState extends State<CommunityCommentCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
        color: GeneralConfigs.BACKGROUND_COLOR,
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.commentModel.username!,
                      style: TextStyle(
                        color: GeneralConfigs.SECONDARY_COLOR,
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                      ),
                    ),
                    Expanded(child: Container()),
                    widget.commentModel.isMyComment != null &&
                            widget.commentModel.isMyComment!
                        ? Padding(
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            child: SizedBox(
                              height: 20,
                              width: 20,
                              child: IconButton(
                                padding: EdgeInsets.zero,
                                onPressed: () {
                                  widget.deleteComment();
                                },
                                color: GeneralConfigs.DISABLED_ICON_COLOR,
                                icon: Icon(
                                  Icons.delete,
                                  size: 20,
                                ),
                              ),
                            ),
                          )
                        : Container(),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(right: 20),
                  child: Text(
                    widget.commentModel.commentText == null
                        ? ""
                        : widget.commentModel.commentText!,
                    style: TextStyle(
                      color: GeneralConfigs.SECONDARY_COLOR,
                      // wordSpacing: 1.2,
                      height: 1.5,
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 5.0),
                  child: Row(
                    children: [
                      Text(
                        // DateFormat('MM/dd/yy h:mm a').format(
                        //     DateTime.parse(widget.commentModel.timeStamp!)),
                        widget.commentModel.timeStampNew ?? "",
                        style: TextStyle(
                          color: GeneralConfigs.POST_TIME_STAMP_COLOR,
                          // wordSpacing: 1.2,
                          height: 1.5,
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ]),
        ));
  }
}
