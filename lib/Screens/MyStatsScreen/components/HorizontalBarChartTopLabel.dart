import 'package:flutter/material.dart';
import 'package:free_indeed/configs/general_configs.dart';
import 'package:free_indeed/localization/localization.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../Models/TriggersChartModel.dart';

class HorizontalBarChartTopChartLabel extends StatefulWidget {
  final List<TriggersChartModel> numberOfRelapsesPerDay;

  const HorizontalBarChartTopChartLabel(
      {Key? key, required this.numberOfRelapsesPerDay})
      : super(key: key);

  @override
  _HorizontalBarChartTopChartLabelState createState() =>
      _HorizontalBarChartTopChartLabelState();
}

class _HorizontalBarChartTopChartLabelState
    extends State<HorizontalBarChartTopChartLabel> {
  late List<_ChartData> data;

  late int maximum = 0;

  @override
  void initState() {
    data = [];
    for (int i = 0; i < widget.numberOfRelapsesPerDay.length; i++) {
      if (widget.numberOfRelapsesPerDay[i].numberOfTimes! > maximum) {
        maximum = widget.numberOfRelapsesPerDay[i].numberOfTimes!;
      }
      data.add(_ChartData(widget.numberOfRelapsesPerDay[i].trigger!,
          widget.numberOfRelapsesPerDay[i].numberOfTimes!.toDouble()));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
        primaryXAxis: CategoryAxis(
          minimum: 0,
          maximum: widget.numberOfRelapsesPerDay.length.toDouble() - 1,
          interval: 1,
          majorGridLines: MajorGridLines(width: 0),
          majorTickLines: MajorTickLines(size: 0),
          axisLine: AxisLine(width: 0),
          labelStyle: TextStyle(
              color: Colors.white, fontWeight: FontWeight.w400, fontSize: 12),
        ),
        plotAreaBorderWidth: 0,
        backgroundColor: GeneralConfigs.COMMUNITY_CARD_BACKGROUND_COLOR,
        primaryYAxis: NumericAxis(
            minimum: 0,
            maximum: maximum + 10,
            interval: 10,
            axisLine: AxisLine(width: 0),
            majorGridLines: MajorGridLines(width: 0),
            majorTickLines: MajorTickLines(size: 0),
            labelStyle: TextStyle(
                color: GeneralConfigs.COMMUNITY_CARD_BACKGROUND_COLOR,
                fontWeight: FontWeight.w400,
                fontSize: 12)),
        series: <ChartSeries<_ChartData, String>>[
          BarSeries<_ChartData, String>(
              dataSource: data,
              xValueMapper: (_ChartData data, _) => data.x,
              yValueMapper: (_ChartData data, _) => data.y,
              dataLabelMapper: (_ChartData data, _) => data.y.toInt().toString(),
              dataLabelSettings: DataLabelSettings(
                  isVisible: true,
                  textStyle: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.white)),
              name: AppLocalization.of(context)!
                  .getLocalizedText("my_stats_page_relapses_per_day_title"),
              width: 0.2,
              borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(5),
                  topRight: Radius.circular(5)),
              color: GeneralConfigs.STATS_CHART_LINE_COLOR)
        ]);
  }
}

class _ChartData {
  _ChartData(this.x, this.y);

  final String x;
  final double y;
}
