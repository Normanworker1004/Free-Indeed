
class TriggersChartModel {
  final int? numberOfTimes;
  final String? trigger;

  TriggersChartModel({
    required this.numberOfTimes,
    required this.trigger,
  });

  factory TriggersChartModel.fromJson(Map<String, dynamic> jsonObject) {
    int? numberOfTimes;
    String? trigger;

    numberOfTimes = jsonObject["numberOfTimes"];
    trigger = jsonObject["trigger"];

    return TriggersChartModel(
      numberOfTimes: numberOfTimes,
      trigger: trigger,
    );
  }

  @override
  String toString() {
    return '''TriggersChartModel:
    numberOfTimes:$numberOfTimes
    trigger: $trigger,
    ''';
  }
}
