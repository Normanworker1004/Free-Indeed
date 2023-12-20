class VersesCategoriesModel {
  final String? categoryLogo;
  final String? categoryName;
  final String? machineName;
  final String? id;
  bool? selected;

  VersesCategoriesModel( {
    required this.categoryLogo,
    required this.selected,
    required this.id,
    required this.categoryName,
    required this.machineName,
  });

  factory VersesCategoriesModel.fromJson(Map<String, dynamic> jsonObject) {
    String? id;
    String? machineName;
    String? categoryLogo;
    String? categoryName;

    id = jsonObject["id"].toString();
    machineName = jsonObject["categoryMachineName"] ?? "";
    categoryLogo = jsonObject["categoryLogo"];
    categoryName = jsonObject["categoryName"];

    return VersesCategoriesModel(
      id: id,
      categoryName: categoryName,
      selected: false,
      categoryLogo: categoryLogo,
      machineName: machineName
    );
  }

  @override
  String toString() {
    return '''VersesCategoriesModel:
    id: $id,
    title: $categoryLogo,
    machineName: $categoryName,
    selected: $selected,
    ''';
  }
}
