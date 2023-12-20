import 'package:equatable/equatable.dart';

class KindaWannaRelapseModel extends Equatable {
  final String? id;
  final String? temptation;
  final String? madeYouStart;
  final String? feelingOnSecondRelapse;
  final String? reportName;
  final bool? success;

  const KindaWannaRelapseModel({
    required this.id,
    required this.temptation,
    required this.madeYouStart,
    required this.feelingOnSecondRelapse,
    required this.reportName,
    required this.success,
  });

  factory KindaWannaRelapseModel.fromJson(Map<String, dynamic> jsonObject) {
    String? id;
    String? temptation;
    String? madeYouStart;
    String? feelingOnSecondRelapse;

    id = jsonObject["id"].toString();
    temptation = jsonObject["temptation"];
    madeYouStart = jsonObject["madeYouStart"];
    feelingOnSecondRelapse = jsonObject["feelingOnSecondRelapse"];

    return KindaWannaRelapseModel(
      id: id,
      temptation: temptation,
      madeYouStart: madeYouStart,
      feelingOnSecondRelapse: feelingOnSecondRelapse,
      reportName: "",
      success: true,
    );
  }

  Object toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['temptation'] = this.temptation;
    data['madeYouStart'] = this.madeYouStart;
    data['feelingOnSecondRelapse'] = this.feelingOnSecondRelapse;

    return data;
  }

  @override
  String toString() {
    return '''KindaWannaRelapseModel:
    id: $id,
    yourRelapse: $temptation,
    trigger: $madeYouStart,
    whatHappened: $feelingOnSecondRelapse,
    lowerChances: $reportName,
    success: $success,
    ''';
  }

  @override
  List<Object?> get props => [id];
}
