import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:free_indeed/Blocs/GoalBloc/goal_bloc.dart';
import 'package:free_indeed/Managers/Implementation/named_navigator_impl.dart';
import 'package:free_indeed/Repo/GoalRepo.dart';
import 'package:free_indeed/Screens/commons/PrimaryButton.dart';
import 'package:free_indeed/configs/ScreenConfig.dart';
import 'package:free_indeed/configs/general_configs.dart';
import 'package:free_indeed/localization/localization.dart';

class GoalPopUp extends StatefulWidget {
  final int userGoal;

  const GoalPopUp({Key? key, required this.userGoal}) : super(key: key);

  @override
  State<GoalPopUp> createState() => _GoalPopUpState();
}

class _GoalPopUpState extends State<GoalPopUp> {
  bool isGoal = true;
  int goalSelected = 1;
  List<DropdownMenuItem<int>> daysItems = [];
  GoalBloc goalBloc =
      GoalBloc(goalRepo: GoalRepo(), namedNavigator: NamedNavigatorImpl());

  @override
  void initState() {
    goalSelected = widget.userGoal;
    goalBloc.add(GoalInitializeEvent());
    for (int i = 1; i < 366; i++) {
      daysItems.add(DropdownMenuItem(value: i, child: Text(i.toString())));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        return goalBloc;
      },
      child: BlocBuilder<GoalBloc, GoalState>(
        builder: (context, state) {
          if (state is GoalReadyState) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  AppLocalization.of(context)!
                      .getLocalizedText("my_goal_pop_up_title"),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
                SizedBox(height: 15),
                DropdownButton(
                    items: daysItems,
                    value: goalSelected,
                    iconEnabledColor: Colors.white,
                    underline: Container(),
                    alignment: AlignmentDirectional.center,
                    dropdownColor: GeneralConfigs.BACKGROUND_COLOR,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold),
                    onChanged: (int? choice) {
                      setState(() {
                        goalSelected = choice!;
                      });
                    }),
                Text(
                  AppLocalization.of(context)!
                      .getLocalizedText("my_goal_pop_up_days"),
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w400),
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      AppLocalization.of(context)!
                          .getLocalizedText("my_goal_pop_up_show_progress"),
                      style: TextStyle(
                        color: GeneralConfigs.SECONDARY_COLOR,
                        fontSize: 16,
                      ),
                    ),
                    CupertinoSwitch(
                      value: isGoal,
                      // changes the state of the switch
                      onChanged: (value) => setState(() => isGoal = value),
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.symmetric(
                    vertical: 15,
                  ),
                  width: ScreenConfig.screenWidth / 2,
                  child: SizedBox(
                    height: 48,
                    child: PrimaryButton(
                        onTap: () {
                          goalBloc.add(GoalSetGoalEvent(
                              goalDays: goalSelected,
                              showProgress: isGoal ? 1 : 0));
                        },
                        buttonText: "my_goal_pop_up_button"),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
              ],
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
