
class RelapsesPerChartModel {
  final int? numberOfRelapses;
  final String? monthYear;

  RelapsesPerChartModel({
    required this.numberOfRelapses,
    required this.monthYear,
  });

  factory RelapsesPerChartModel.fromJson(Map<String, dynamic> jsonObject) {
    int? numberOfRelapses;
    String? monthYear;

    numberOfRelapses = jsonObject["numberOfRelapses"];
    monthYear = jsonObject["monthYear"];

    return RelapsesPerChartModel(
      numberOfRelapses: numberOfRelapses,
      monthYear: monthYear,
    );
  }

  @override
  String toString() {
    return '''RelapsesPerChartModel:
    numberOfRelapses:$numberOfRelapses
    dates: $monthYear,
    ''';
  }
}
