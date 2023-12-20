import 'dart:math';
import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:free_indeed/configs/general_configs.dart';

class JournalModel with EquatableMixin {
  final String? id;
  final String? journalText;
  final String? timeStamp;
  final bool? success;
  late Color? color;
  bool? showDelete;

  JournalModel({
    required this.id,
    required this.journalText,
    required this.timeStamp,
    required this.success,
    this.color,
    required this.showDelete,
  });

  factory JournalModel.fromJson(Map<String, dynamic> jsonObject) {
    String? id;
    String? journalText;
    String? timeStamp;
    Color color;

    Random random = Random();
    id = jsonObject["id"].toString();
    journalText = jsonObject["journalText"];
    timeStamp = jsonObject["timeStamp"];
    color = GeneralConfigs().journalColors[random.nextInt(5)];

    return JournalModel(
      id: id,
      journalText: journalText,
      timeStamp: timeStamp,
      color: color,
      showDelete: false,
      success: true,
    );
  }

  @override
  String toString() {
    return '''JournalModel:
    id: $id,
    username: $journalText,
    email: $timeStamp,
    success: $success,
    ''';
  }

  @override
  List<Object?> get props => [id];
}
