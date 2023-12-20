import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:free_indeed/Models/KindaWannaRelapseModel.dart';
import 'package:free_indeed/configs/ScreenConfig.dart';
import 'package:free_indeed/configs/general_configs.dart';
import 'package:free_indeed/localization/localization.dart';

class KindaWannaRelapseListTile extends StatefulWidget {
  final KindaWannaRelapseModel kindaRelapses;
  final String title;
  final Function openRelapse;
  final Function deleteRelapse;

  const KindaWannaRelapseListTile(
      {Key? key,
      required this.kindaRelapses,
      required this.title,
      required this.openRelapse,
      required this.deleteRelapse})
      : super(key: key);

  @override
  State<KindaWannaRelapseListTile> createState() =>
      _KindaWannaRelapseListTileState();
}

class _KindaWannaRelapseListTileState extends State<KindaWannaRelapseListTile> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      clipBehavior: Clip.antiAlias,
      borderRadius: BorderRadius.circular(6.0),
      child: Container(
        color: GeneralConfigs.COMMUNITY_CARD_BACKGROUND_COLOR,
        child: ExpansionTile(
          collapsedBackgroundColor: Colors.transparent,
          iconColor: GeneralConfigs.SECONDARY_COLOR,
          textColor: GeneralConfigs.COMMUNITY_CARD_BACKGROUND_COLOR,
          collapsedIconColor: GeneralConfigs.SECONDARY_COLOR,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                widget.title,
                style: TextStyle(
                    color: GeneralConfigs.SECONDARY_COLOR,
                    fontSize: 15,
                    fontWeight: FontWeight.w500),
              ),
              Expanded(
                child: Container(),
              ),
              // GestureDetector(
              //   onTap: () {},
              //   child: SvgPicture.asset(
              //     GeneralConfigs.ICONS_PATH + "editPostIcon.svg",
              //     width: 18,
              //     height: 18,
              //     color: Colors.white,
              //     fit: BoxFit.fill,
              //   ),
              // ),
              // SizedBox(
              //   width: 20,
              // ),
              GestureDetector(
                onTap: () {
                  widget.deleteRelapse();
                },
                child: SvgPicture.asset(
                  GeneralConfigs.ICONS_PATH + "deleteJournal.svg",
                  width: 18,
                  height: 18,
                  color: Colors.red,
                  fit: BoxFit.fill,
                ),
              ),
            ],
          ),
          //header title
          children: [
            tileData(context: context),
          ],
        ),
      ),
    );
  }

  Widget tileData({required BuildContext context}) {
    return GestureDetector(
      onTap: () {
        widget.openRelapse();
      },
      child: Container(
        color: GeneralConfigs.BACKGROUND_COLOR,
        width: ScreenConfig.screenWidth,
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 12,
            ),
            Text(
              AppLocalization.of(context)!.getLocalizedText(
                  "i_kinda_wanna_relapse_screen_why_do_you_think"),
              style: TextStyle(
                  color: GeneralConfigs.SECONDARY_COLOR, fontSize: 14),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              widget.kindaRelapses.temptation!,
              // maxLines: 3,
              // overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: GeneralConfigs.RELAPSES_LIST_TEXT_DATA, fontSize: 14),
            ),
            SizedBox(
              height: 12,
            ),
            Text(
              AppLocalization.of(context)!
                  .getLocalizedText("i_kinda_wanna_relapse_screen_remind_us"),
              // maxLines: 3,
              // overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: GeneralConfigs.SECONDARY_COLOR, fontSize: 14),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              widget.kindaRelapses.madeYouStart!,
              // maxLines: 3,
              // overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: GeneralConfigs.RELAPSES_LIST_TEXT_DATA, fontSize: 14),
            ),
            SizedBox(
              height: 12,
            ),
            Text(
              AppLocalization.of(context)!
                  .getLocalizedText("i_kinda_wanna_relapse_screen_based_on"),
              style: TextStyle(
                  color: GeneralConfigs.SECONDARY_COLOR, fontSize: 14),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              widget.kindaRelapses.feelingOnSecondRelapse!,
              style: TextStyle(
                  color: GeneralConfigs.RELAPSES_LIST_TEXT_DATA, fontSize: 14),
            ),
            SizedBox(
              height: 12,
            ),
          ],
        ),
      ),
    );
  }
}
