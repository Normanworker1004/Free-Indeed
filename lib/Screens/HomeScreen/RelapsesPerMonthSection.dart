import 'package:flutter/material.dart';
import 'package:free_indeed/Blocs/chartsBloc/charts_bloc.dart';

import '../../Models/RelapsesPerMonthChartModel.dart';
import '../../configs/general_configs.dart';
import '../../localization/localization.dart';
import '../MyStatsScreen/components/VerticalBarChart.dart';

class RelapsesPerMonthSection extends StatefulWidget {
  final ChartsBloc chartsBloc;
  final List<DropdownMenuItem<int>> triggerItems;

  const RelapsesPerMonthSection(
      {Key? key, required this.chartsBloc, required this.triggerItems})
      : super(key: key);

  @override
  State<RelapsesPerMonthSection> createState() =>
      _RelapsesPerMonthSectionState();
}

class _RelapsesPerMonthSectionState extends State<RelapsesPerMonthSection> {
  List<RelapsesPerChartModel> relapsesPerMonth = [];
  int triggerSelected = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              child: Text(
                AppLocalization.of(context)!
                    .getLocalizedText("my_stats_page_relapses_per_month_title"),
                style: TextStyle(
                    color: GeneralConfigs.SECONDARY_COLOR,
                    fontSize: 16,
                    fontWeight: FontWeight.w400),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 20, right: 20, bottom: 10),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 5),
                color: GeneralConfigs.BLOG_PREVIEW_BORDER_COLOR,
                child: DropdownButton(
                    value: triggerSelected,
                    items: widget.triggerItems,
                    dropdownColor: GeneralConfigs.BLOG_PREVIEW_BORDER_COLOR,
                    underline: Container(),
                    style: TextStyle(
                        color: GeneralConfigs
                            .COMMUNITY_BOTTOM_SHEET_CARD_BACKGROUND_COLOR),
                    onChanged: (int? choice) {
                      setState(() {
                        triggerSelected = choice!;
                      });
                      // getChartDataFromChoice();
                    }),
              ),
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: FutureBuilder<List<RelapsesPerChartModel>>(
              future:
                  widget.chartsBloc.getRelapsesPerMonthChart(triggerSelected),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  relapsesPerMonth = snapshot.data!;
                  return VerticalBarChart(
                    relapsesPerMonth: relapsesPerMonth,
                  );
                } else {
                  return Container(
                    margin: EdgeInsets.zero,
                    child: VerticalBarChart(
                      relapsesPerMonth: [],
                    ),
                  );
                }
              }),
        ),
      ],
    );
  }
}
