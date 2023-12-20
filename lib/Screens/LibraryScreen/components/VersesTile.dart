import 'package:flutter/material.dart';
import 'package:free_indeed/Models/VerseModel.dart';

import '../../../configs/ScreenConfig.dart';
import '../../../configs/general_configs.dart';

class VersesTile extends StatelessWidget {
  final VerseModel verse;

  const VersesTile({Key? key, required this.verse}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        children: [
          VerticalDivider(
            color: GeneralConfigs.SECONDARY_COLOR,
            thickness: 2,
            endIndent: 3,
          ),
          SizedBox(
            width: 10,
          ),
          Container(
            width: ScreenConfig.screenWidth - 100,
            padding: EdgeInsets.symmetric(horizontal: 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  verse.verse!,
                  maxLines: null,
                  style: TextStyle(
                      color: GeneralConfigs.SECONDARY_COLOR,
                      fontSize: 15,
                      fontWeight: FontWeight.w400),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  verse.shahed!,
                  maxLines: null,
                  style: TextStyle(
                      color: GeneralConfigs.POST_TIME_STAMP_COLOR,
                      fontSize: 13,
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
