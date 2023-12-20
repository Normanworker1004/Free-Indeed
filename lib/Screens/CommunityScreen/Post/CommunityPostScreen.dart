import 'package:free_indeed/Models/CommentModel.dart';
import 'package:free_indeed/Models/PostModel.dart';
import 'package:free_indeed/Screens/CommunityScreen/CommunityPostCard.dart';
import 'package:free_indeed/Screens/CommunityScreen/Post/CommunityCommentCard.dart';
import 'package:free_indeed/Screens/commons/BackButtonComponent.dart';
import 'package:free_indeed/configs/general_configs.dart';
import 'package:flutter/material.dart';

import 'CommentTextFormField.dart';

class CommunityCommentScreenArgs {
  final PostModel post;
  List<CommentModel> comments;
  final Function addComment;
  final Function deleteComment;
  final Function likePost;

  CommunityCommentScreenArgs(
      {required this.post,
      required this.comments,
      required this.addComment,
      required this.likePost,
      required this.deleteComment});
}

class CommunityCommentScreen extends StatefulWidget {
  final CommunityCommentScreenArgs post;

  const CommunityCommentScreen({
    Key? key,
    required this.post,
  }) : super(key: key);

  @override
  _CommunityCommentScreenState createState() => _CommunityCommentScreenState();
}

class _CommunityCommentScreenState extends State<CommunityCommentScreen> {
  TextEditingController controller = TextEditingController();

  void _addComment(BuildContext context, List<CommentModel> comments) {
    setState(() {
      widget.post.comments = comments;
      controller.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    widget.post.post.numberOfComments = widget.post.comments.length;
    return Scaffold(
      backgroundColor: GeneralConfigs.BACKGROUND_COLOR,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: GeneralConfigs.BACKGROUND_COLOR,
        leading: FreeIndeedBackButton(),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CommunityPostCard(
                      activeTabIndex: 4,
                      postModel: widget.post.post,
                      isPostDetails: true,
                      likeButton: () {
                        widget.post.likePost(widget.post.post.liked,
                            widget.post.post.id.toString());
                      },
                      openComments: () {}),
                  ListView.builder(
                    itemCount: widget.post.comments.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CommunityCommentCard(
                            commentModel: widget.post.comments[index],
                            deleteComment: () async {
                              List<CommentModel> comments = await widget.post
                                  .deleteComment(
                                      widget.post.post.id!.toString(),
                                      widget.post.comments[index].id
                                          .toString());
                              _addComment(context, comments);
                            },
                          ),
                          Divider(
                            thickness: 1,
                            color: Colors.white.withOpacity(0.2),
                            indent: 20,
                            endIndent: 20,
                          ),
                        ],
                      );
                    },
                  ),
                  SizedBox(
                    height: 50,
                  ),
                ],
              ),
            ),
            Align(
              alignment: AlignmentDirectional.bottomCenter,
              child: CommentTextFormField(
                addComment: () async {
                  List<CommentModel> comments =
                      await widget.post.addComment(controller.text);
                  _addComment(context, comments);
                },
                controller: controller,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
