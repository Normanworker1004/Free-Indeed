import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:free_indeed/Models/CleanDayChartModel.dart';
import 'package:free_indeed/configs/ScreenConfig.dart';
import 'package:free_indeed/configs/general_configs.dart';

class StockChartWidget extends StatefulWidget {
  final CleanDayChartModel cleanStreakDays;

  const StockChartWidget({super.key, required this.cleanStreakDays});

  @override
  State<StockChartWidget> createState() => _StockChartWidgetState();
}

class _StockChartWidgetState extends State<StockChartWidget> {
  late List<FlSpot> points;

  @override
  void initState() {
    points = getPoints();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: GeneralConfigs.COMMUNITY_CARD_BACKGROUND_COLOR,
      padding: EdgeInsets.all(12),
      child: widget.cleanStreakDays.numberOfStreaks == 0
          ? Container(
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
            )
          : SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Container(
                width: widget.cleanStreakDays.numberOfStreaks! > 10
                    ? ScreenConfig.screenWidth *
                        widget.cleanStreakDays.numberOfStreaks! /
                        10
                    : ScreenConfig.screenWidth,
                height: ScreenConfig.screenHeight / 4,
                padding: EdgeInsets.only(
                  top: 24,
                ),
                child: LineChart(
                  mainData(),
                ),
              ),
            ),
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w500,
      fontSize: 10,
    );
    if (value.toInt() % 10 == 0 &&
        widget.cleanStreakDays.maxY != null &&
        widget.cleanStreakDays.maxY! < 100) {
      return Text(value.toInt().toString(),
          style: style, textAlign: TextAlign.left);
    } else if (value.toInt() % 50 == 0 &&
        widget.cleanStreakDays.maxY != null &&
        widget.cleanStreakDays.maxY! > 100) {
      return Text(value.toInt().toString(),
          style: style, textAlign: TextAlign.left);
    } else {
      return Container();
    }
  }

  LineChartData mainData() {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: 10,
        verticalInterval: 20,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: Colors.white.withOpacity(0.1),
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: Colors.white.withOpacity(0.1),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 25,
          ),
        ),
      ),
      lineTouchData: LineTouchData(
          enabled: true,
          touchTooltipData: LineTouchTooltipData(
              showOnTopOfTheChartBoxArea: false,
              tooltipBgColor: Colors.black.withOpacity(0.6),
              tooltipRoundedRadius: 20,
              getTooltipItems: (touchedSpots) {
                return touchedSpots.map((touchedSpot) {
                  return LineTooltipItem(
                      widget.cleanStreakDays.dates![touchedSpot.spotIndex],
                      TextStyle(color: GeneralConfigs.SECONDARY_COLOR));
                }).toList();
              })),
      borderData: FlBorderData(
        show: false,
        border: Border.all(color: Colors.white),
      ),
      minX: 0,
      maxX: widget.cleanStreakDays.streaks!.length.toDouble() + 0.5,
      minY: -8,
      maxY: widget.cleanStreakDays.maxY != null
          ? widget.cleanStreakDays.maxY!.toDouble()
          : 20,
      lineBarsData: [
        LineChartBarData(
          dotData: FlDotData(
            show: true,
            getDotPainter: (spot, percent, barData, index) {
              return FlDotCirclePainter(
                radius: 2,
                color: GeneralConfigs.STATS_CHART_DOT_COLOR,
              );
            },
          ),
          spots: points,
          // [
          //   FlSpot(1, 50),
          //   FlSpot(2, 100),
          //   FlSpot(3, 0),
          //   FlSpot(4, 10),
          //   FlSpot(5, 0),
          //   FlSpot(6, 200),
          //   FlSpot(7, 1),
          //   FlSpot(8, 4),
          //   FlSpot(9, 4),
          //   FlSpot(10, 4),
          //   FlSpot(11, 4),
          //   FlSpot(12, 4),
          // ],
          isCurved: false,
          barWidth: 1,
          color: GeneralConfigs.STATS_CHART_LINE_COLOR,
          isStrokeCapRound: false,
          belowBarData: BarAreaData(
            show: false,
          ),
        ),
      ],
    );
  }

  List<FlSpot> getPoints() {
    List<FlSpot> points = [];
    for (int i = 0; i < widget.cleanStreakDays.streaks!.length; i++) {
      points.add(FlSpot(
          i.toDouble() + 1,
          widget.cleanStreakDays.streaks![i].toDouble() > 0
              ? widget.cleanStreakDays.streaks![i].toDouble()
              : 0));
    }
    return points;
  }
}
