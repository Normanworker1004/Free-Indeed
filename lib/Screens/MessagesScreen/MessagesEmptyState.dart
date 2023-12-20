import 'package:flutter/cupertino.dart';
import 'package:free_indeed/configs/ScreenConfig.dart';

import '../../configs/general_configs.dart';
import '../../localization/localization.dart';

class MessagingEmptyState extends StatelessWidget {
  const MessagingEmptyState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: ScreenConfig.screenHeight / 2,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {},
            child: SizedBox(
              height: ScreenConfig.screenHeight * 0.08,
              child: Image.asset(
                GeneralConfigs.IMAGE_ASSETS_PATH + "NoMessagesYet.png",
                fit: BoxFit.fill,
              ),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Text(
            AppLocalization.of(context)!
                .getLocalizedText("messaging_page_empty_no_messages_state"),
            textAlign: TextAlign.center,
            style: TextStyle(
                color: GeneralConfigs.BLACK_BOARDER_COLOR, fontSize: 18),
          ),
        ],
      ),
    );
  }
}
