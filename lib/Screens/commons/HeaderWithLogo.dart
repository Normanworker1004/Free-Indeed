import 'package:free_indeed/configs/general_configs.dart';
import 'package:free_indeed/localization/localization.dart';
import 'package:flutter/material.dart';

class HeaderWithLogo extends StatelessWidget {
  final String headerTitle;
  final String? headerText;

  const HeaderWithLogo({Key? key, required this.headerTitle, this.headerText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 50),
          child: Center(
            child: SizedBox(
              width: 75,
              height: 75,
              child: Image.asset(
                GeneralConfigs.IMAGE_ASSETS_PATH + "logo.png",
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Text(
            AppLocalization.of(context)!
                .getLocalizedText("sign_up_page_welcome_title"),
            style: TextStyle(
              color: GeneralConfigs.TEXT_COLOR,
              wordSpacing: 1.25,
              fontSize: 17,
              height: 1.5,
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 20, bottom: 10),
          child: Text(
            AppLocalization.of(context)!.getLocalizedText(headerTitle),
            style: TextStyle(
              color: GeneralConfigs.SECONDARY_COLOR,
              wordSpacing: 1.25,
              fontSize: 32,
              height: 1.5,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        headerText != null
            ? Text(
                AppLocalization.of(context)!.getLocalizedText(headerText),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: GeneralConfigs.TEXT_COLOR,
                  wordSpacing: 1.25,
                  fontSize: 15,
                  height: 1.5,
                  fontWeight: FontWeight.w400,
                ),
              )
            : Container(),
      ],
    );
  }
}
