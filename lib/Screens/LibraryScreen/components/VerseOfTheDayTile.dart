import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:free_indeed/Models/VerseModel.dart';

import '../../../configs/general_configs.dart';
import '../../../localization/localization.dart';
import '../DailyVerseBackgroundPainter.dart';

class VerseOfTheDayTile extends StatelessWidget {
  final VerseModel verse;
  const VerseOfTheDayTile({Key? key,required this.verse}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // MyPainter(color: Colors.white),
        CustomPaint(
          painter: DailyVerseBackgroundPainter(
              color: GeneralConfigs.LIBRARY_ICON_BORDER_COLOR,
              context: context),
        ),
        SizedBox(
          height: 155,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        GeneralConfigs.ICONS_PATH + "bible.svg",
                        height: 20,
                        width: 30,
                        fit: BoxFit.scaleDown,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: Text(
                          AppLocalization.of(context)!.getLocalizedText(
                              "library_screen_bible_tab_verse_of_the_day"),
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    verse.verse!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                        fontSize: 16),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 12),
                  height: 30,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border:
                    Border.all(color: Colors.white.withOpacity(0.25)),
                    borderRadius: BorderRadius.all(Radius.circular(14)),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: 6.0, horizontal: 12),
                    child: Text(
                      verse.shahed!,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                          fontSize: 13),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
