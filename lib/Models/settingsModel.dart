class SettingsModel {
  final String? title;
  final String? machineName;
  final String? id;
  final String? url;

  SettingsModel({
    required this.title,
    required this.id,
    required this.machineName,
    required this.url,
  });

  factory SettingsModel.fromJson(Map<String, dynamic> jsonObject) {
    String? id;
    String? machineName;
    String? title;
    String? url;

    id = jsonObject["id"].toString();
    machineName = jsonObject["machine_name"] ?? "";
    title = jsonObject["name"];
    url = jsonObject["url"];

    return SettingsModel(
      id: id,
      machineName: machineName,
      url: url,
      title: title,
    );
  }

  @override
  String toString() {
    return '''SettingsModel:
    id: $id,
    title: $title,
    machineName: $machineName,
    url: $url,
    ''';
  }
}
