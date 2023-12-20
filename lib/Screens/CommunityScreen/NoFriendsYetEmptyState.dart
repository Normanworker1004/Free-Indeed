import 'package:flutter/cupertino.dart';
import 'package:free_indeed/configs/ScreenConfig.dart';

import '../../configs/general_configs.dart';
import '../../localization/localization.dart';

class FriendsPostsWidget extends StatelessWidget {
  const FriendsPostsWidget({Key? key}) : super(key: key);

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
              height: ScreenConfig.screenHeight * 0.12,
              child: Image.asset(
                GeneralConfigs.IMAGE_ASSETS_PATH +
                    "NoFriendsPostsEmptyState.png",
                fit: BoxFit.fill,
              ),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Text(
            AppLocalization.of(context)!
                .getLocalizedText("community_page_empty_friends_posts_state"),
            style: TextStyle(
                color: GeneralConfigs.BLACK_BOARDER_COLOR, fontSize: 21),
          ),
        ],
      ),
    );
  }
}
