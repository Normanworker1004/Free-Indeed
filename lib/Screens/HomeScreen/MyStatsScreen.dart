import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:free_indeed/Blocs/chartsBloc/charts_bloc.dart';
import 'package:free_indeed/Models/CleanDayChartModel.dart';
import 'package:free_indeed/Models/RelapsesPerDayChartModel.dart';
import 'package:free_indeed/Models/TriggersChartModel.dart';
import 'package:free_indeed/Repo/StatsRepo.dart';
import 'package:free_indeed/Screens/HomeScreen/HorizontalBarChart.dart';
import 'package:free_indeed/Screens/HomeScreen/RelapsesPerMonthSection.dart';
import 'package:free_indeed/Screens/MyStatsScreen/components/HorizontalBarChartTopLabel.dart';
import 'package:free_indeed/Screens/commons/LoadingState.dart';
import 'package:free_indeed/configs/general_configs.dart';
import 'package:free_indeed/localization/localization.dart';
import 'package:flutter/material.dart';

import '../MyStatsScreen/components/StockChartWidget.dart';

class MyStatsScreen extends StatefulWidget {
  const MyStatsScreen({Key? key}) : super(key: key);

  @override
  _MyStatsScreenState createState() => _MyStatsScreenState();
}

class _MyStatsScreenState extends State<MyStatsScreen> {
  ChartsBloc chartsBloc =
      ChartsBloc(relapsedAndStatsRepo: RelapsedAndStatsRepo());
  List<DropdownMenuItem<int>> triggerItems = [];

  @override
  void initState() {
    chartsBloc.add(ChartsInitializeEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) {
        return chartsBloc;
      },
      child: BlocConsumer<ChartsBloc, ChartsState>(listener: (context, state) {
        if (state is ChartsReadyState) {
          for (int i = 0; i < state.triggers.length; i++) {
            triggerItems.add(DropdownMenuItem(
                value: i, child: Text(state.triggers[i].title!)));
          }
        }
      }, builder: (context, state) {
        if (state is ChartsLoadingState) {
          return LoadingState();
        } else if (state is ChartsReadyState) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ///CLEAN DAYS STREAK CHART
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                child: Text(
                  AppLocalization.of(context)!
                      .getLocalizedText("my_stats_page_clean_days_title"),
                  style: TextStyle(
                      color: GeneralConfigs.SECONDARY_COLOR,
                      fontSize: 16,
                      fontWeight: FontWeight.w400),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: FutureBuilder<CleanDayChartModel>(
                    future: chartsBloc.getCleanDayChart(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return StockChartWidget(
                          cleanStreakDays: snapshot.data!,
                        );
                      } else {
                        return Container(
                          margin: EdgeInsets.zero,
                          child: StockChartWidget(
                            cleanStreakDays: CleanDayChartModel(
                                numberOfStreaks: 0,
                                streaks: [],
                                maxY: 0,
                                dates: []),
                          ),
                        );
                      }
                    }),
              ),

              SizedBox(
                height: 15,
              ),

              ///RELAPSES PER DAY CHART
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                child: Text(
                  AppLocalization.of(context)!
                      .getLocalizedText("my_stats_page_relapses_per_day_title"),
                  style: TextStyle(
                      color: GeneralConfigs.SECONDARY_COLOR,
                      fontSize: 16,
                      fontWeight: FontWeight.w400),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: FutureBuilder<List<RelapsesPerDayChartModel>>(
                    future: chartsBloc.getRelapsesPerDayChart(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return HorizontalBarChart(
                          numberOfRelapsesPerDay: snapshot.data!,
                        );
                      } else {
                        return Container(
                          margin: EdgeInsets.zero,
                          child: HorizontalBarChart(
                            numberOfRelapsesPerDay: [],
                          ),
                        );
                      }
                    }),
              ),

              SizedBox(
                height: 15,
              ),

              ///RELAPSES PER MONTH CHART
              RelapsesPerMonthSection(
                  chartsBloc: chartsBloc, triggerItems: triggerItems),

              SizedBox(
                height: 15,
              ),

              ///TRIGGERS CHART
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                child: Text(
                  AppLocalization.of(context)!.getLocalizedText(
                      "my_stats_page_relapses_triggers_title"),
                  style: TextStyle(
                      color: GeneralConfigs.SECONDARY_COLOR,
                      fontSize: 16,
                      fontWeight: FontWeight.w400),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: FutureBuilder<List<TriggersChartModel>>(
                    future: chartsBloc.getTriggerChart(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return HorizontalBarChartTopChartLabel(
                          numberOfRelapsesPerDay: snapshot.data!,
                        );
                      } else {
                        return Container(
                          margin: EdgeInsets.zero,
                          child: HorizontalBarChartTopChartLabel(
                            numberOfRelapsesPerDay: [],
                          ),
                        );
                      }
                    }),
              ),

              SizedBox(
                height: 15,
              ),
            ],
          );
        } else {
          return Container();
        }
      }),
    );
  }
}
