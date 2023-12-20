import 'package:free_indeed/Managers/Implementation/named_navigator_impl.dart';
import 'package:free_indeed/configs/ScreenConfig.dart';
import 'package:free_indeed/configs/general_configs.dart';
import 'package:free_indeed/localization/localization.dart';
import 'package:flutter/material.dart';

class CreateNewPostArgs {
  final String titleKey;
  final String? initialText;
  final Function submitFunction;
  final bool isJournal;

  CreateNewPostArgs(
      {required this.submitFunction,
      required this.titleKey,
      this.initialText,
      required this.isJournal});
}

class CreateJournalScreen extends StatefulWidget {
  final CreateNewPostArgs newPostArgs;

  const CreateJournalScreen({Key? key, required this.newPostArgs})
      : super(key: key);

  @override
  _CreateJournalScreenState createState() => _CreateJournalScreenState();
}

class _CreateJournalScreenState extends State<CreateJournalScreen> {
  String _enteredText = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: GeneralConfigs.BACKGROUND_COLOR,
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  if (widget.newPostArgs.isJournal && _enteredText != "") {
                    submitJournal(context);
                  } else {
                    NamedNavigatorImpl().pop();
                  }
                },
                child: Row(children: [
                  SizedBox(
                      width: 24,
                      child: Icon(
                        Icons.arrow_back_ios_new,
                        color: GeneralConfigs.SECONDARY_COLOR,
                      )),
                  Text("Back",
                      style: TextStyle(
                          fontSize: 14, color: GeneralConfigs.SECONDARY_COLOR)),
                ]),
              ),
              Text(
                AppLocalization.of(context)!
                    .getLocalizedText(widget.newPostArgs.titleKey),
                style: TextStyle(fontSize: 16),
              ),
              widget.newPostArgs.isJournal
                  ? Container()
                  : GestureDetector(
                      onTap: _enteredText == ""
                          ? () {}
                          : () {
                              submitJournal(context);
                            },
                      child: Text(
                        AppLocalization.of(context)!.getLocalizedText(
                            "create_journal_screen_submit_button"),
                        style: TextStyle(
                            fontSize: 16,
                            color: _enteredText == ""
                                ? GeneralConfigs.SECONDARY_COLOR
                                    .withOpacity(0.3)
                                : GeneralConfigs.SECONDARY_COLOR,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
            ],
          ),
        ),
        backgroundColor: GeneralConfigs.BACKGROUND_COLOR,
        body: WillPopScope(
          onWillPop: () {
            if (widget.newPostArgs.isJournal && _enteredText.isNotEmpty) {
              widget.newPostArgs.submitFunction(_enteredText);
            }
            return Future.value(true);
          },
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                height: 200,
                padding: EdgeInsets.symmetric(vertical: 7),
                child: SizedBox(
                    height: 200,
                    width: ScreenConfig.screenWidth,
                    child: TextFormField(
                      maxLines: null,
                      style: TextStyle(color: GeneralConfigs.SECONDARY_COLOR),
                      initialValue: widget.newPostArgs.initialText != null
                          ? widget.newPostArgs.initialText!
                          : "",
                      onChanged: (value) {
                        setState(() {
                          _enteredText = value;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: AppLocalization.of(context)!
                            .getLocalizedText("create_journal_screen_hint"),
                        hintStyle: TextStyle(
                            color: GeneralConfigs.POST_TIME_STAMP_COLOR),
                        border: InputBorder.none,
                      ),
                    )),
              ),
            ),
          ),
        ));
  }

  void submitJournal(BuildContext context) {
    widget.newPostArgs.submitFunction(_enteredText);
  }
}
