
class RelapsesPerDayChartModel {
  final int? numberOfRelapses;
  final String? day;

  RelapsesPerDayChartModel({
    required this.numberOfRelapses,
    required this.day,
  });

  factory RelapsesPerDayChartModel.fromJson(Map<String, dynamic> jsonObject) {
    int? numberOfRelapses;
    String? day;

    numberOfRelapses = jsonObject["numberOfRelapses"];
    day = jsonObject["day"];

    return RelapsesPerDayChartModel(
      numberOfRelapses: numberOfRelapses,
      day: day,
    );
  }

  @override
  String toString() {
    return '''RelapsesPerChartModel:
    numberOfRelapses:$numberOfRelapses
    dates: $day,
    ''';
  }
}
