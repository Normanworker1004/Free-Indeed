class BlogModel {
  final String? id;
  final String? imageURL;
  final String? timeStamp;
  final String? timeStampNew;
  final String? blogName;
  final String? blogdata;
  final bool? success;

  BlogModel({
    required this.id,
    required this.imageURL,
    required this.timeStamp,
    required this.timeStampNew,
    required this.blogName,
    required this.blogdata,
    required this.success,
  });

  factory BlogModel.fromJson(Map<String, dynamic> jsonObject) {
    String? id;
    String? imageURL;
    String? timeStamp;
    String? blogName;
    String? timeStampNew;

    //TODO:NEED TO BE GOTTEN FROM BACKEND
    String blogData =
        "Medical assistants—key professionals supporting physician practices have not been studied with regard to burnout and professional fulfillment, which may affect other healthcare professionals. This study examined the factors associated with burnout among medical assistants in an academic healthcare organization while validating the use of a tool previously used to assess burnout in physicians.";

    id = jsonObject["id"].toString();
    imageURL = jsonObject["image"];
    blogName = jsonObject["title"];
    timeStamp = jsonObject["timeStamp"];
    timeStampNew = jsonObject["timeStampNew"];

    return BlogModel(
      id: id,
      imageURL: imageURL,
      timeStamp: timeStamp,
      timeStampNew: timeStampNew,
      blogName: blogName,
      blogdata: blogData,
      success: true,
    );
  }

  @override
  String toString() {
    return '''BlogModel:
    id: $id,
    username: $imageURL,
    email: $timeStamp,
    success: $success,
    lastMessage: $blogName,
    timeStampNew: $timeStampNew,
    ''';
  }
}
