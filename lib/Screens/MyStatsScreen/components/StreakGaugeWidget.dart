import 'package:free_indeed/configs/general_configs.dart';
import 'package:free_indeed/localization/localization.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class StreakGauge extends StatefulWidget {
  final double progress;
  final String numberOfDoneDays;
  final String numberOfDoneHours;
  final String numberOfDoneMin;
  final bool showData;

  const StreakGauge(
      {Key? key,
      required this.progress,
      required this.numberOfDoneDays,
      required this.numberOfDoneHours,
      required this.showData,
      required this.numberOfDoneMin})
      : super(key: key);

  @override
  _StreakGaugeState createState() => _StreakGaugeState();
}

class _StreakGaugeState extends State<StreakGauge> {
  @override
  Widget build(BuildContext context) {
    return SfRadialGauge(axes: <RadialAxis>[
      RadialAxis(
          minimum: 0,
          tickOffset: 25,
          minorTicksPerInterval: 0,
          showLabels: false,
          canScaleToFit: true,
          axisLineStyle: AxisLineStyle(
            color: Colors.grey,
            thickness: 20,
            cornerStyle: CornerStyle.bothCurve,
          ),
          // labelsPosition: ElementsPosition.outside,
          majorTickStyle: MajorTickStyle(
              thickness: 3,
              length: 8,
              color: GeneralConfigs.GAUGE_INDICATOR_COLOR),
          pointers: <GaugePointer>[
            RangePointer(
              value: widget.progress,
              width: 20,
              animationDuration: 1000,
              enableAnimation: true,
              cornerStyle: CornerStyle.bothCurve,
              color: GeneralConfigs.GAUGE_INDICATOR_COLOR,
            ),
            MarkerPointer(
                value: widget.progress - 0.15,
                enableDragging: false,
                color: Colors.white,
                markerHeight: 8,
                markerWidth: 8,
                animationDuration: 1000,
                enableAnimation: true,
                markerType: MarkerType.circle,
                overlayRadius: 15),
          ],
          annotations: <GaugeAnnotation>[
            GaugeAnnotation(
                widget: widget.showData
                    ? Column(children: [
                        getDaysText(
                            context: context,
                            firstText: widget.numberOfDoneDays,
                            secondText: AppLocalization.of(context)!
                                .getLocalizedText("home_page_gauge_text_days")),
                        SizedBox(
                          height: 5,
                        ),
                        getDaysText(
                            context: context,
                            firstText: widget.numberOfDoneHours,
                            secondText: AppLocalization.of(context)!
                                .getLocalizedText(
                                    "home_page_gauge_text_hours")),
                        SizedBox(
                          height: 5,
                        ),
                        getDaysText(
                            context: context,
                            firstText: widget.numberOfDoneMin,
                            secondText: AppLocalization.of(context)!
                                .getLocalizedText("home_page_gauge_text_min")),
                        SizedBox(
                          height: 5,
                        ),
                      ])
                    : Container(),
                angle: 90,
                positionFactor: 0.7)
          ])
    ]);
  }

  Widget getDaysText(
      {required BuildContext context,
      required String firstText,
      required String secondText}) {
    return RichText(
      text: TextSpan(
          text: firstText,
          style: TextStyle(
            color: GeneralConfigs.SECONDARY_COLOR,
            fontSize: 30,
            fontWeight: FontWeight.w700,
          ),
          children: <TextSpan>[
            TextSpan(
              text: secondText,
              style: TextStyle(
                color: GeneralConfigs.SECONDARY_COLOR,
                fontSize: 20,
                fontWeight: FontWeight.w400,
              ),
            )
          ]),
    );
  }
}
