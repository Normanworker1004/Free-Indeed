import 'package:free_indeed/Models/JournalModel.dart';
import 'package:free_indeed/configs/Config.dart';
import 'package:free_indeed/configs/Network.dart';

class JournalsRepo {
  Network network = Network();

  Future<List<JournalModel>> getMyJournals(
      String accessToken, int pageNumber) async {
    Map<String, dynamic>? jsonObject = await network.getDataGetMethod(
      UrlConfigurations().baseURL +
          UrlConfigurations()
              .getMyJournalsURL
              .replaceAll("[@]", pageNumber.toString()),
      token: accessToken,
    );
    List<JournalModel> journalist = [];
    if (jsonObject != null && jsonObject["success"] == "1") {
      jsonObject["data"].forEach((v) {
        journalist.add(JournalModel.fromJson(v));
      });
    }
    return journalist;
  }

  Future<bool> addJournal(String accessToken, String journalText) async {
    Map<String, dynamic>? jsonObject = await network.getDataPostMethod(
      UrlConfigurations().baseURL + UrlConfigurations().addJournalsURL,
      {
        "journalText": journalText,
      },
      token: accessToken,
    );
    return jsonObject != null && jsonObject["success"] == "1";
  }

  Future<bool> editJournal(
      String accessToken, String journalText, String journalId) async {
    Map<String, dynamic>? jsonObject = await network.editDataPutMethod(
      UrlConfigurations().baseURL +
          UrlConfigurations().editJournalsURL.replaceAll("[@]", journalId),
      {
        "journalText": journalText,
      },
      token: accessToken,
    );
    return jsonObject != null && jsonObject["success"] == "1";
  }

  Future<bool> deleteJournal(String accessToken, String journalId) async {
    Map<String, dynamic>? jsonObject = await network.deleteDataDeleteMethod(
      UrlConfigurations().baseURL +
          UrlConfigurations().deleteJournalsURL.replaceAll("[@]", journalId),
      {},
      token: accessToken,
    );
    return jsonObject != null && jsonObject["success"] == "1";
  }
}
