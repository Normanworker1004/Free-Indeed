import 'package:equatable/equatable.dart';

class GoalModel with EquatableMixin {
  final String? id;
  final String? days;
  final String? hours;
  final String? minutes;
  final bool? success;
  final bool? goalProgress;
  final String? percentage;

  GoalModel({
    required this.id,
    required this.days,
    required this.hours,
    required this.minutes,
    required this.success,
    required this.goalProgress,
    required this.percentage,
  });

  factory GoalModel.fromJson(Map<String, dynamic> jsonObject) {
    String? id;
    String? days;
    String? hours;
    String? percentage;
    String? minutes;
    bool? goalProgress;

    id = jsonObject["id"].toString();
    days = jsonObject["days"].toString();
    hours = jsonObject["hours"].toString();
    percentage = jsonObject["percentage"];
    goalProgress = jsonObject["goalProgress"] == 1;
    minutes = jsonObject["minutes"].toString();

    return GoalModel(
      id: id,
      days: days,
      hours: hours,
      percentage: percentage,
      minutes: minutes,
      goalProgress: goalProgress,
      success: true,
    );
  }

  @override
  String toString() {
    return '''GoalModel:
    id: $id,
    username: $days,
    email: $hours,
    email: $minutes,
    success: $success,
    ''';
  }

  @override
  List<Object?> get props => [id, minutes, hours, days];
}
