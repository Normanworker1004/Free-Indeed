class BlogPreviewModel {
  final String? id;
  final String? imageURL;
  final String? timeStamp;
  final String? timeStampNew;
  final String? blogName;
  final bool? success;

  BlogPreviewModel({
    required this.id,
    required this.imageURL,
    required this.timeStamp,
    required this.blogName,
    required this.timeStampNew,
    required this.success,
  });

  factory BlogPreviewModel.fromJson(Map<String, dynamic> jsonObject) {
    String? id;
    String? imageURL;
    String? timeStamp;
    String? timeStampNew;
    String? blogName;

    id = jsonObject["id"].toString();
    imageURL = jsonObject["image"];
    blogName = jsonObject["title"];
    timeStampNew = jsonObject["timeStampNew"];
    timeStamp = jsonObject["timeStamp"];

    return BlogPreviewModel(
      id: id,
      imageURL: imageURL,
      timeStamp: timeStamp,
      timeStampNew: timeStampNew,
      blogName: blogName,
      success: true,
    );
  }

  @override
  String toString() {
    return '''BlogPreviewModel:
    id: $id,
    username: $imageURL,
    email: $timeStamp,
    success: $success,
    timeStampNew: $timeStampNew,
    lastMessage: $blogName,
    ''';
  }
}
