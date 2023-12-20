import 'package:free_indeed/Models/PostModel.dart';
import 'package:free_indeed/configs/ScreenConfig.dart';
import 'package:free_indeed/configs/general_configs.dart';
import 'package:free_indeed/localization/localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class CommunityPostCard extends StatefulWidget {
  final PostModel postModel;
  final Function likeButton;
  final Function openComments;
  final int activeTabIndex;
  final Function? editPostFunction;
  final Function? deletePostFunction;
  final Function? addFriendFunction;
  final Function? muteUserFunction;
  final Function? reportFunction;
  final bool isPostDetails;

  const CommunityPostCard(
      {Key? key,
      required this.postModel,
      required this.likeButton,
      required this.openComments,
      this.editPostFunction,
      this.deletePostFunction,
      this.muteUserFunction,
      this.addFriendFunction,
      this.reportFunction,
      required this.isPostDetails,
      required this.activeTabIndex})
      : super(key: key);

  @override
  _CommunityPostCardState createState() => _CommunityPostCardState();
}

class _CommunityPostCardState extends State<CommunityPostCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
        color: GeneralConfigs.COMMUNITY_CARD_BACKGROUND_COLOR,
        borderOnForeground: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.postModel.username!,
                      style: TextStyle(
                        color: GeneralConfigs.SECONDARY_COLOR,
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                      ),
                    ),
                    widget.isPostDetails
                        ? Container()
                        : GestureDetector(
                            onTap: () {
                              widget.activeTabIndex == 0 &&
                                      widget.postModel.isMyPost != null &&
                                      widget.postModel.isMyPost!
                                  ? openBottomActionSheet(
                                      context, mineBottomListWidget(context))
                                  : widget.activeTabIndex == 0
                                      ? openBottomActionSheet(context,
                                          everyoneBottomListWidget(context))
                                      : widget.activeTabIndex == 1
                                          ? openBottomActionSheet(context,
                                              friendsBottomListWidget(context))
                                          : widget.activeTabIndex == 2
                                              ? openBottomActionSheet(context,
                                                  mineBottomListWidget(context))
                                              : () {};
                            },
                            child: Icon(
                              Icons.more_horiz,
                              color: GeneralConfigs.DISABLED_ICON_COLOR,
                            ),
                          ),
                  ],
                ),
                GestureDetector(
                  onTap: widget.isPostDetails
                      ? () {}
                      : () {
                          widget.openComments();
                        },
                  child: Container(
                    width: ScreenConfig.screenWidth,
                    margin: EdgeInsets.only(bottom: 20, top: 5),
                    child: widget.isPostDetails
                        ? Text(
                            widget.postModel.postText == null
                                ? ""
                                : widget.postModel.postText!,
                            style: TextStyle(
                              color: GeneralConfigs.SECONDARY_COLOR,
                              // wordSpacing: 1.2,
                              height: 1.5,
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                            ),
                          )
                        : Text(
                            widget.postModel.postText == null
                                ? ""
                                : widget.postModel.postText!,
                            style: TextStyle(
                              color: GeneralConfigs.SECONDARY_COLOR,
                              // wordSpacing: 1.2,
                              height: 1.5,
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                            ),
                            maxLines: 6,
                            overflow: TextOverflow.ellipsis,
                          ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 0.0),
                  child: Row(
                    children: [
                      Text(
                        // DateFormat('MM/dd/yy h:mm a').format(
                        //     DateTime.parse(widget.postModel.timeStamp!)),
                        widget.postModel.timeStampNew ?? "",
                        style: TextStyle(
                          color: GeneralConfigs.POST_TIME_STAMP_COLOR,
                          // wordSpacing: 1.2,
                          height: 1.5,
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                        ),
                      ),
                      Expanded(child: Container()),
                      likeAndCommentRow(
                          context,
                          widget.postModel.liked!
                              ? "likeIconActive.svg"
                              : "likeIconInactive.svg",
                          widget.postModel.numberOfLikes!.toString(),
                          _setLikedPost),
                      Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: likeAndCommentRow(
                            context,
                            "commentIcon.svg",
                            widget.postModel.numberOfComments!.toString(),
                            widget.openComments),
                      ),
                    ],
                  ),
                ),
              ]),
        ));
  }

  Widget likeAndCommentRow(
      BuildContext context, String iconPath, String label, Function onTap) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Row(
        children: [
          SvgPicture.asset(
            GeneralConfigs.ICONS_PATH + iconPath,
            height: 18,
            width: 18,
            fit: BoxFit.scaleDown,
          ),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                label,
                style: TextStyle(
                  color: GeneralConfigs.SECONDARY_COLOR,
                  // wordSpacing: 1.2,
                  height: 1.5,
                  fontWeight: FontWeight.w400,
                  fontSize: 11,
                ),
              )),
        ],
      ),
    );
  }

  List<Widget> everyoneBottomListWidget(BuildContext context) {
    return [
      bottomSheetButton(
          context,
          "community_page_comment_extra_options_list_tile_one",
          "addFriendCommentSheetIcon.svg",
          addFriend),
      Divider(
        thickness: 1,
        color: GeneralConfigs.COMMUNITY_BOTTOM_SHEET_CARD_DIVIDER_COLOR,
      ),
      bottomSheetButton(
          context,
          "community_page_comment_extra_options_list_tile_two",
          "mute.svg",
          muteUser),
      Divider(
        thickness: 1,
        color: GeneralConfigs.COMMUNITY_BOTTOM_SHEET_CARD_DIVIDER_COLOR,
      ),
      bottomSheetButton(
          context,
          "community_page_comment_extra_options_list_tile_three",
          "report.svg",
          reportUser),
      Container(
        height: 10,
      )
    ];
  }

  List<Widget> friendsBottomListWidget(BuildContext context) {
    return [
      bottomSheetButton(
          context,
          "community_page_comment_extra_options_list_tile_two",
          "mute.svg",
          muteUser),
      Divider(
        thickness: 1,
        color: GeneralConfigs.COMMUNITY_BOTTOM_SHEET_CARD_DIVIDER_COLOR,
      ),
      bottomSheetButton(
          context,
          "community_page_comment_extra_options_list_tile_three",
          "report.svg",
          reportUser),
      Container(
        height: 10,
      )
    ];
  }

  List<Widget> mineBottomListWidget(BuildContext context) {
    return [
      bottomSheetButton(
          context,
          "community_page_comment_extra_options_mine_list_tile_two",
          "editPostIcon.svg",
          editPost),
      Divider(
        thickness: 1,
        color: GeneralConfigs.COMMUNITY_BOTTOM_SHEET_CARD_DIVIDER_COLOR,
      ),
      bottomSheetButton(
          context,
          "community_page_comment_extra_options_mine_list_tile_one",
          "deletePostIcon.svg",
          deletePost),
      Container(
        height: 10,
      )
    ];
  }

  void openBottomActionSheet(BuildContext context, List<Widget> buttons) {
    showCupertinoModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent.withOpacity(0),
      clipBehavior: Clip.hardEdge,
      barrierColor: Colors.transparent,
      shadow: BoxShadow(color: Colors.transparent),
      isDismissible: true,
      builder: (context) {
        return GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            width: ScreenConfig.screenWidth,
            height: ScreenConfig.screenHeight,
            color: Colors.transparent,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: GeneralConfigs
                            .COMMUNITY_BOTTOM_SHEET_CARD_BACKGROUND_COLOR,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      child: Column(
                        children: buttons,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: GeneralConfigs.SECONDARY_COLOR,
                              elevation: 0,
                              fixedSize:
                                  Size(ScreenConfig.screenWidth - 50, 60),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              )),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            AppLocalization.of(context)!.getLocalizedText(
                                "community_page_comment_extra_options_button"),
                            style: TextStyle(
                                color: GeneralConfigs.BACKGROUND_COLOR,
                                fontSize: 16,
                                fontWeight: FontWeight.w500),
                          )),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget bottomSheetButton(
      BuildContext context, String title, String iconPath, Function onTap) {
    return Container(
      height: 50,
      width: ScreenConfig.screenWidth,
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: ListTile(
        onTap: () {
          onTap();
        },
        subtitle: SizedBox(
          height: 60,
          width: ScreenConfig.screenWidth,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalization.of(context)!.getLocalizedText(title),
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w500),
              ),
              SvgPicture.asset(
                GeneralConfigs.ICONS_PATH + iconPath,
                // color: Colors.black,
                width: 20,
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void addFriend() {
    widget.addFriendFunction!();
  }

  void reportUser() {
    widget.reportFunction!();
  }

  void muteUser() {
    widget.muteUserFunction!();
  }

  void deletePost() {
    widget.deletePostFunction!();
  }

  void editPost() {
    widget.editPostFunction!();
  }

  void _setLikedPost() {
    widget.likeButton();
    setState(() {
      if (!widget.postModel.liked!) {
        widget.postModel.numberOfLikes = widget.postModel.numberOfLikes! + 1;
      } else {
        widget.postModel.numberOfLikes = widget.postModel.numberOfLikes! - 1;
      }
      widget.postModel.liked = !widget.postModel.liked!;
    });
  }
}
