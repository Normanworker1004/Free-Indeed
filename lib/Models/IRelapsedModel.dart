import 'package:free_indeed/Models/iRelapsedTileObject.dart';
import 'package:free_indeed/Models/triggerModel.dart';

class IRelapsedModel {
  final String? startDate;
  final String? endDate;
  final String? whatHappened;
  final String? lowerTheChances;
  final List<TriggerObject>? triggers;
  final List<IRelapsedTileObject>? relapses;
  int? id;
  String? relapseDate;
  bool? selected;
  bool? showDelete;

  IRelapsedModel({
    required this.lowerTheChances,
    required this.triggers,
    required this.relapses,
    required this.startDate,
    required this.selected,
    required this.whatHappened,
    required this.endDate,
    required this.showDelete,
    this.id,
    this.relapseDate,
  });

  factory IRelapsedModel.fromJson(Map<String, dynamic> jsonObject) {
    String? startDate;
    String? endDate;
    String? whatHappened;
    String? lowerTheChances;
    String? startMonthYear;
    int? id;
    List<TriggerObject>? triggers = [];
    List<IRelapsedTileObject>? relapses = [];

    startDate = jsonObject["endDate"];
    startMonthYear = jsonObject["monthYear"];
    endDate = jsonObject["endDate"];
    whatHappened = jsonObject["whatHappened"];
    lowerTheChances = jsonObject["lowerTheChances"];
    id = jsonObject["id"];
    if (jsonObject["triggers"] != null) {
      jsonObject["triggers"].forEach((val) {
        triggers.add(TriggerObject.fromJson(val));
      });
    }
    if (jsonObject["relapses"] != null) {
      jsonObject["relapses"].forEach((val) {
        relapses.add(IRelapsedTileObject.fromJson(val));
      });
    }

    return IRelapsedModel(
      startDate: startDate,
      endDate: endDate,
      selected: false,
      whatHappened: whatHappened,
      relapseDate: startMonthYear,
      triggers: triggers,
      lowerTheChances: lowerTheChances,
      id: id,
      relapses: relapses,
      showDelete: false,
    );
  }

  Object toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['triggers'] = this.triggers!.map((v) => v.id).toList();
    data['relapses'] = this.relapses!.map((v) => v.id).toList();
    data['endDate'] = this.endDate;
    data['whatHappened'] = this.whatHappened;
    data['lowerTheChances'] = this.lowerTheChances;
    data['goalProgress'] = 0;
    data['success'] = 1;

    return data;
  }

  @override
  String toString() {
    return '''IRelapsedObject:
    id: $whatHappened,
    title: $startDate,
    machineName: $endDate,
    success: $selected,
    ''';
  }
}
