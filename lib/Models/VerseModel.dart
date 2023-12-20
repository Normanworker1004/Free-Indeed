class VerseModel {
  final String? id;
  final String? verse;
  final String? shahed;
  final bool? success;

  VerseModel({
    required this.id,
    required this.verse,
    required this.shahed,
    required this.success,
  });

  factory VerseModel.fromJson(Map<String, dynamic> jsonObject) {
    String? id;
    String? verse;
    String? shahed;

    id = jsonObject["id"].toString();
    verse = jsonObject["description"];
    shahed = jsonObject["author"];

    return VerseModel(
      id: id,
      verse: verse,
      shahed: shahed,
      success: true,
    );
  }

  @override
  String toString() {
    return '''VerseModel:
    id: $id,
    verse: $verse,
    shahed: $shahed,
    success: $success,
    ''';
  }
}
