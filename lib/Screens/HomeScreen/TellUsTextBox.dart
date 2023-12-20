import 'package:flutter/material.dart';
import 'package:free_indeed/configs/ScreenConfig.dart';
import 'package:free_indeed/configs/general_configs.dart';

class TellUsAboutYourselfTextBox extends StatefulWidget {
  final Function sendText;
  final FocusNode focusNode;

  const TellUsAboutYourselfTextBox(
      {Key? key, required this.sendText, required this.focusNode})
      : super(key: key);

  @override
  State<TellUsAboutYourselfTextBox> createState() =>
      _TellUsAboutYourselfTextBoxState();
}

class _TellUsAboutYourselfTextBoxState
    extends State<TellUsAboutYourselfTextBox> {
  String _enteredText = "";

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Container(
          height: ScreenConfig.screenHeight * 0.23,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 7),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            border: Border.all(color: GeneralConfigs.BLACK_BOARDER_COLOR),
          ),
          child: SizedBox(
            height: ScreenConfig.screenHeight / 5,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                TextFormField(
                  style: TextStyle(color: GeneralConfigs.SECONDARY_COLOR),
                  // maxLength: 2000,
                  maxLines: 7,
                  focusNode: widget.focusNode,
                  // controller: tellUsController,
                  onChanged: (value) {
                    // tellUsController.text = value;
                    setState(() {
                      _enteredText = value;
                    });
                  },
                  // keyboardType: TextInputType.text,
                  // onFieldSubmitted: (val) {
                  //   focus.unfocus();
                  // },
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero),
                ),
                GestureDetector(
                  onTap: _enteredText.trim().isNotEmpty
                      ? () {
                          // context.read<HomeBloc>().add(
                          //     HomeTellUsAboutYourselfEvent(
                          //         tellYourselfText:
                          //         _enteredText.trim()));
                          widget.sendText(_enteredText.trim());
                        }
                      : () {},
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 0),
                    child: Icon(
                      Icons.send,
                      color: _enteredText.isNotEmpty
                          ? GeneralConfigs.SECONDARY_COLOR
                          : GeneralConfigs.SECONDARY_COLOR.withOpacity(0.3),
                      size: 20,
                    ),
                  ),
                )
              ],
            ),
          )),
    );
  }
}
