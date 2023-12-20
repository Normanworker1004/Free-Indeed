class IRelapsedTileObject {
  final String? title;
  final String? machineName;
  final String? id;
  bool? selected;

  IRelapsedTileObject({
    required this.title,
    required this.selected,
    required this.id,
    required this.machineName,
  });

  factory IRelapsedTileObject.fromJson(Map<String, dynamic> jsonObject) {
    String? id;
    String? machineName;
    String? title;

    id = jsonObject["id"].toString();
    machineName = jsonObject["relapseMachineName"];
    title = jsonObject["relapseName"];

    return IRelapsedTileObject(
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
    success: $selected,
    ''';
  }
}
