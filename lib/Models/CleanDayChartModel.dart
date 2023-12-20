
class CleanDayChartModel {
  final int? numberOfStreaks;
  final List<int>? streaks;
  final List<String>? dates;
  final int? maxY;

  CleanDayChartModel({
    required this.numberOfStreaks,
    required this.streaks,
    required this.maxY,
    required this.dates,
  });

  factory CleanDayChartModel.fromJson(Map<String, dynamic> jsonObject) {
    int? numberOfStreaks;
    int? maxY;
    List<int>? streaks = [];
    List<String>? dates = [];

    numberOfStreaks = jsonObject["numberOfStreaks"];
    maxY = jsonObject["maxY"];
    if (jsonObject["streaks"] != null) {
      jsonObject["streaks"].forEach((val) {
        streaks.add(val);
      });
    }
    if (jsonObject["dates"] != null) {
      jsonObject["dates"].forEach((val) {
        dates.add(val);
      });
    }

    return CleanDayChartModel(
      streaks: streaks,
      maxY: maxY,
      dates: dates,
      numberOfStreaks: numberOfStreaks,
    );
  }

  @override
  String toString() {
    return '''CleanDayChartModel:
    streaks:$streaks
    numberOfStreaks: $numberOfStreaks,
    maxY: $maxY,
    dates: $dates,
    ''';
  }
}
