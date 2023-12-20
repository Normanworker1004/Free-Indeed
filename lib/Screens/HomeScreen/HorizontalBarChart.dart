import 'package:flutter/material.dart';
import 'package:free_indeed/Models/RelapsesPerDayChartModel.dart';
import 'package:free_indeed/configs/ScreenConfig.dart';
import 'package:free_indeed/configs/general_configs.dart';
import 'package:free_indeed/localization/localization.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class HorizontalBarChart extends StatefulWidget {
  final List<RelapsesPerDayChartModel> numberOfRelapsesPerDay;

  const HorizontalBarChart({Key? key, required this.numberOfRelapsesPerDay})
      : super(key: key);

  @override
  _HorizontalBarChartState createState() => _HorizontalBarChartState();
}

class _HorizontalBarChartState extends State<HorizontalBarChart> {
  late List<_ChartData> data;
  late TooltipBehavior _tooltip;
  late int maximum = 0;

  @override
  void initState() {
    data = [];
    if (widget.numberOfRelapsesPerDay.isNotEmpty) {
      for (int i = 0; i < widget.numberOfRelapsesPerDay.length; i++) {
        if (widget.numberOfRelapsesPerDay[i].numberOfRelapses! > maximum) {
          maximum = widget.numberOfRelapsesPerDay[i].numberOfRelapses!;
        }
        data.add(_ChartData(widget.numberOfRelapsesPerDay[i].day!,
            widget.numberOfRelapsesPerDay[i].numberOfRelapses!.toDouble()));
      }
    }
    _tooltip = TooltipBehavior(enable: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return Container(
        width: ScreenConfig.screenWidth,
        height: ScreenConfig.screenHeight / 4,
        padding: EdgeInsets.only(
          top: 24,
        ),
        child: Center(
            child: Text(
          "No relapses yet",
          style: TextStyle(color: GeneralConfigs.SECONDARY_COLOR),
        )),
      );
    } else {
      return SfCartesianChart(
          primaryXAxis: CategoryAxis(
              minimum: 0,
              maximum: data.length.toDouble() - 1,
              interval: 1,
              majorGridLines: MajorGridLines(
                  width: 0.5,
                  dashArray: <double>[6, 3],
                  color: GeneralConfigs.STATS_CHART_BAR_CHART_DASH_LINE_COLOR),
              majorTickLines: MajorTickLines(size: 0),
              axisLine: AxisLine(width: 0),
              labelStyle: TextStyle(
                  color: GeneralConfigs.BLOG_PREVIEW_TIMESTAMP_COLOR,
                  fontWeight: FontWeight.w400,
                  fontSize: 12)),
          plotAreaBorderWidth: 0,
          backgroundColor: GeneralConfigs.COMMUNITY_CARD_BACKGROUND_COLOR,
          primaryYAxis: NumericAxis(
              minimum: 0,
              maximum: maximum.toDouble() + 5,
              interval: 5,
              axisLine: AxisLine(width: 0),
              majorGridLines: MajorGridLines(width: 0),
              majorTickLines: MajorTickLines(size: 0),
              labelStyle: TextStyle(
                  color: GeneralConfigs.BLOG_PREVIEW_TIMESTAMP_COLOR,
                  fontWeight: FontWeight.w400,
                  fontSize: 12)),
          tooltipBehavior: _tooltip,
          series: <ChartSeries<_ChartData, String>>[
            BarSeries<_ChartData, String>(
                dataSource: data,
                xValueMapper: (_ChartData data, _) => data.x,
                yValueMapper: (_ChartData data, _) => data.y,
                name: AppLocalization.of(context)!
                    .getLocalizedText("my_stats_page_relapses_per_day_title"),
                width: 0.2,
                dashArray: <double>[6, 3],
                isTrackVisible: false,
                trackColor:
                    GeneralConfigs.STATS_CHART_BAR_CHART_DASH_LINE_COLOR,
                trackPadding: 0,
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(5),
                    topRight: Radius.circular(5)),
                color: GeneralConfigs.STATS_CHART_LINE_COLOR)
          ]);
    }
  }
}

class _ChartData {
  _ChartData(this.x, this.y);

  final String x;
  final double y;
}
