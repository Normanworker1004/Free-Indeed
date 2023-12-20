import 'package:flutter/cupertino.dart';
import 'package:free_indeed/configs/ScreenConfig.dart';

import '../../configs/general_configs.dart';
import '../../localization/localization.dart';

class MineEmptyStateWidget extends StatelessWidget {
  const MineEmptyStateWidget({Key? key}) : super(key: key);

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
                GeneralConfigs.IMAGE_ASSETS_PATH + "NoPostsYet.png",
                fit: BoxFit.fill,
              ),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Text(
            AppLocalization.of(context)!
                .getLocalizedText("community_page_empty_mine_state"),
            style: TextStyle(
                color: GeneralConfigs.BLACK_BOARDER_COLOR, fontSize: 21),
          ),
        ],
      ),
    );
  }
}
