class TriggerObject {
  final String? title;
  final String? machineName;
  final String? id;
  bool? selected;

  TriggerObject({
    required this.title,
    required this.selected,
    required this.id,
    required this.machineName,
  });

  factory TriggerObject.fromJson(Map<String, dynamic> jsonObject) {
    String? id;
    String? machineName;
    String? title;

    id = jsonObject["id"].toString();
    machineName = jsonObject["triggerMachineName"] ?? "";
    title = jsonObject["triggerName"];

    return TriggerObject(
      id: id,
      machineName: machineName,
      selected: false,
      title: title,
    );
  }

  @override
  String toString() {
    return '''IRelapsedObject:
    id: $id,
    title: $title,
    machineName: $machineName,
    selected: $selected,
    ''';
  }
}
