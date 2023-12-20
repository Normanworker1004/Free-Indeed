import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:free_indeed/Models/RelapsesPerMonthChartModel.dart';
import 'package:free_indeed/configs/ScreenConfig.dart';
import 'package:free_indeed/configs/general_configs.dart';

class VerticalBarChart extends StatefulWidget {
  final List<RelapsesPerChartModel> relapsesPerMonth;

  const VerticalBarChart({Key? key, required this.relapsesPerMonth})
      : super(key: key);

  @override
  State<VerticalBarChart> createState() => _VerticalBarChartState();
}

class _VerticalBarChartState extends State<VerticalBarChart> {
  ScrollController controller = ScrollController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.relapsesPerMonth.isEmpty) {
      return SizedBox(
        width: widget.relapsesPerMonth.length > 6
            ? widget.relapsesPerMonth.length * ScreenConfig.screenWidth / 6
            : ScreenConfig.screenWidth - 50,
        height: ScreenConfig.screenHeight / 4,
        child: Center(
          child: Text(
            "No Data to show",
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }
    return Container(
      padding: const EdgeInsets.all(2.0),
      color: GeneralConfigs.COMMUNITY_CARD_BACKGROUND_COLOR,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        controller: controller,
        child: Stack(
          children: [
            SizedBox(
              width: widget.relapsesPerMonth.length > 6
                  ? widget.relapsesPerMonth.length *
                      ScreenConfig.screenWidth /
                      6
                  : ScreenConfig.screenWidth - 50,
              height: ScreenConfig.screenHeight / 4,
              child: BarChart(
                BarChartData(
                  barTouchData: BarTouchData(
                    enabled: false,
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        getTitlesWidget: getTitles,
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: false,
                  ),
                  barGroups: blueBars(),
                  backgroundColor:
                      GeneralConfigs.COMMUNITY_CARD_BACKGROUND_COLOR,
                  gridData: FlGridData(show: false),
                  alignment: BarChartAlignment.spaceAround,
                  maxY: 40,
                ),
              ),
            ),
            SizedBox(
              width: widget.relapsesPerMonth.length > 6
                  ? widget.relapsesPerMonth.length *
                      ScreenConfig.screenWidth /
                      6
                  : ScreenConfig.screenWidth - 50,
              height: ScreenConfig.screenHeight / 4,
              child: BarChart(
                BarChartData(
                  barTouchData: BarTouchData(
                    enabled: false,
                    // touchTooltipData: BarTouchTooltipData(
                    //   tooltipBgColor: Colors.transparent,
                    //   tooltipPadding: EdgeInsets.zero,
                    //   tooltipMargin: 8,
                    // ),
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 60,
                        getTitlesWidget: getTitles1,
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: false,
                  ),
                  barGroups: overBarTextBars(),
                  backgroundColor: Colors.transparent,
                  gridData: FlGridData(show: false),
                  alignment: BarChartAlignment.spaceAround,
                  maxY: 40,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w400,
      fontSize: 14,
    );
    String text = widget.relapsesPerMonth[value.toInt()].monthYear!;

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 4,
      child: Text(text, style: style),
    );
  }

  Widget getTitles1(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w400,
      fontSize: 14,
    );
    String text =
        widget.relapsesPerMonth[value.toInt()].numberOfRelapses.toString();

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 4,
      child: Text(text, style: style),
    );
  }

  BarChartRodData barChartRod(double y) {
    return BarChartRodData(
        toY: y,
        color: GeneralConfigs.STATS_CHART_LINE_COLOR,
        width: 25,
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(5), bottomRight: Radius.circular(5)));
  }

  List<BarChartGroupData> blueBars() {
    List<BarChartGroupData> bars = [];
    for (int i = 0; i < widget.relapsesPerMonth.length; i++) {
      bars.add(BarChartGroupData(
        x: i,
        barRods: [
          barChartRod(widget.relapsesPerMonth[i].numberOfRelapses!.toDouble())
        ],
      ));
    }
    return bars;
  }

  List<BarChartGroupData> overBarTextBars() {
    List<BarChartGroupData> bars = [];
    for (int i = 0; i < widget.relapsesPerMonth.length; i++) {
      bars.add(BarChartGroupData(
        x: i,
        barRods: [barChartRod(0)],
      ));
    }
    return bars;
  }
}
