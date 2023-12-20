import 'package:flutter/material.dart';

import '../../../configs/ScreenConfig.dart';
import '../../../configs/general_configs.dart';

class BibleTile extends StatelessWidget {
  final Color tileColor;
  final Color textColor;
  final String iconPath;
  final String text;

  const BibleTile(
      {Key? key,
      required this.tileColor,
      required this.iconPath,
      required this.text,
      required this.textColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4),
      height: ScreenConfig.screenHeight * 0.1,
      width: ScreenConfig.screenWidth * 0.2,
      decoration: BoxDecoration(
        color: tileColor,
        borderRadius: BorderRadius.all(Radius.circular(40)),
        border: Border.all(color: GeneralConfigs.LIBRARY_ICON_BORDER_COLOR),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 1),
          Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              color: GeneralConfigs.BACKGROUND_COLOR,
              borderRadius: BorderRadius.all(Radius.circular(40)),
              border:
                  Border.all(color: GeneralConfigs.LIBRARY_ICON_BORDER_COLOR),
            ),
            child: Image.network(
              iconPath,
              width: 40,
              height: 40,
              loadingBuilder: (BuildContext context, Widget child,
                  ImageChunkEvent? loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                        : null,
                    color: GeneralConfigs.SECONDARY_COLOR,
                  ),
                );
              },
            ),
          ),
          SizedBox(
            width: ScreenConfig.screenWidth,
            child: Center(
              child: Text(
                text,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 15,
                    color: textColor),
              ),
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
