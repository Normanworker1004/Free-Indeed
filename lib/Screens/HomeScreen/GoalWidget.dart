import 'package:flutter/material.dart';
import 'package:free_indeed/Models/GoalModel.dart';
import 'package:free_indeed/Screens/MyStatsScreen/components/StreakGaugeWidget.dart';
import 'package:free_indeed/configs/ScreenConfig.dart';
import 'package:free_indeed/configs/general_configs.dart';
import 'package:free_indeed/localization/localization.dart';

class GoalMeterWidget extends StatefulWidget {
  final GoalModel goal;
  final bool showData;
  final Function onChangeGoal;
  final Function getUserGoal;

  const GoalMeterWidget(
      {Key? key,
      required this.goal,
      required this.showData,
      required this.getUserGoal,
      required this.onChangeGoal})
      : super(key: key);

  @override
  State<GoalMeterWidget> createState() => _GoalMeterWidgetState();
}

class _GoalMeterWidgetState extends State<GoalMeterWidget> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<GoalModel>(
      future: widget.getUserGoal(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return goalWidget(context, snapshot.data!, true);
        } else {
          return goalWidget(
            context,
            widget.goal,
            false,
          );
        }
      },
    );
  }

  Widget goalWidget(BuildContext context, GoalModel goal, bool showData) {
    return Column(
      children: [
        Center(
          child: SizedBox(
              width: ScreenConfig.screenWidth,
              height: ScreenConfig.screenHeight * 0.33,
              child: StreakGauge(
                showData: showData,
                numberOfDoneDays: goal.days!,
                progress: double.parse(goal.percentage!.replaceAll("%", "")),
                numberOfDoneHours: goal.hours!,
                numberOfDoneMin: goal.minutes!,
              )),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            goal.goalProgress != null && goal.goalProgress!
                ? RichText(
                    text: TextSpan(
                        text: goal.percentage!,
                        style: TextStyle(
                          color: GeneralConfigs.SECONDARY_COLOR,
                          fontSize: 25,
                          fontWeight: FontWeight.w500,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: AppLocalization.of(context)!
                                .getLocalizedText("home_page_percentage_text"),
                            style: TextStyle(
                              color: GeneralConfigs.SECONDARY_COLOR,
                              fontSize: 21,
                              fontWeight: FontWeight.w400,
                            ),
                          )
                        ]),
                  )
                : Container(),
            GestureDetector(
              onTap: () {
                widget.onChangeGoal();
              },
              child: Icon(
                Icons.more_vert,
                color: Colors.white,
                size: 35,
              ),
            )
          ],
        ),
      ],
    );
  }
}
