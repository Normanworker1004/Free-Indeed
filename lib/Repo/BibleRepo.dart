import 'package:free_indeed/Models/versesCategoryModel.dart';
import 'package:free_indeed/configs/Config.dart';
import 'package:free_indeed/configs/Network.dart';

import '../Models/VerseModel.dart';

class BibleRepo {
  Network network = Network();

  Future<List<VersesCategoriesModel>> getVersesCategoriesData(
      String accessToken) async {
    Map<String, dynamic>? jsonObject = await network.getDataGetMethod(
        UrlConfigurations().baseURL + UrlConfigurations().versesCategoriesURL,
        token: accessToken);
    List<VersesCategoriesModel> versesCategory = [];
    if (jsonObject != null && jsonObject["success"] == "1") {
      jsonObject["data"].forEach((v) {
        versesCategory.add(VersesCategoriesModel.fromJson(v));
      });
    }
    return versesCategory;
  }

  Future<List<VerseModel>> getVersesData(
      {required String accessToken,
      required String pageNumber,
      required String categoryId}) async {
    Map<String, dynamic>? jsonObject = await network.getDataGetMethod(
        UrlConfigurations().baseURL +
            UrlConfigurations()
                .categoryVersesURL
                .replaceAll("[@]", pageNumber)
                .replaceAll("[#]", categoryId),
        token: accessToken);
    List<VerseModel> versesModels = [];
    if (jsonObject != null && jsonObject["success"] == "1") {
      jsonObject["data"].forEach((v) {
        versesModels.add(VerseModel.fromJson(v));
      });
    }
    return versesModels;
  }
}
