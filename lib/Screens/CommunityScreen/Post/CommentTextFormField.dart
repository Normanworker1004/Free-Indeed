import 'package:flutter/material.dart';

import '../../../configs/ScreenConfig.dart';
import '../../../configs/general_configs.dart';
import '../../../localization/localization.dart';

class CommentTextFormField extends StatefulWidget {
  final Function addComment;
  final TextEditingController controller;

  const CommentTextFormField(
      {Key? key, required this.addComment, required this.controller})
      : super(key: key);

  @override
  State<CommentTextFormField> createState() => _CommentTextFormFieldState();
}

class _CommentTextFormFieldState extends State<CommentTextFormField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: GeneralConfigs.BACKGROUND_COLOR,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 6 * ScreenConfig.screenWidth / 7,
            color: GeneralConfigs.SECONDARY_COLOR,
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            child: TextFormField(
              // focusNode: focusNode,
              textInputAction: TextInputAction.send,
              maxLines: null,
              keyboardType: TextInputType.text,
              onChanged: (val) {
                setState(() {});
              },
              textCapitalization: TextCapitalization.sentences,
              // decoration: InputDecoration(),
              controller: widget.controller,
              cursorColor: GeneralConfigs.BACKGROUND_COLOR,
              style: TextStyle(color: GeneralConfigs.BACKGROUND_COLOR),
              decoration: InputDecoration.collapsed(
                  border: InputBorder.none,
                  hintText: AppLocalization.of(context)!.getLocalizedText(
                      "community_comment_page_comment_text_box_hint"),
                  hintStyle: TextStyle(
                      color: GeneralConfigs.BACKGROUND_COLOR.withOpacity(0.3))),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 4),
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(30),
            ),
            child: IconButton(
              onPressed: () {
                widget.addComment();
                // onSendMessage(textEditingController.text, MessageType.TEXT);
              },
              icon: Text(
                AppLocalization.of(context)!.getLocalizedText(
                    "community_comment_page_comment_text_box_button"),
                style: TextStyle(
                    color: widget.controller.text.isNotEmpty
                        ? GeneralConfigs.SECONDARY_COLOR
                        : GeneralConfigs.SECONDARY_COLOR.withOpacity(0.3)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
