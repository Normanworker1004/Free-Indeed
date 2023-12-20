import 'package:free_indeed/Models/KindaWannaRelapseModel.dart';
import 'package:free_indeed/configs/Config.dart';
import 'package:free_indeed/configs/Network.dart';

class KindaWannaRelapseRepo {
  Network network = Network();

  Future<List<KindaWannaRelapseModel>> getMyKindaRelapses(
      String accessToken, int pageNumber) async {
    Map<String, dynamic>? jsonObject = await network.getDataGetMethod(
      UrlConfigurations().baseURL +
          UrlConfigurations()
              .getKindaWannaRelapseURL
              .replaceAll("[@]", pageNumber.toString()),
      token: accessToken,
    );
    List<KindaWannaRelapseModel> kindaRelapsesList = [];
    if (jsonObject != null && jsonObject["success"] == "1") {
      jsonObject["data"].forEach((v) {
        kindaRelapsesList.add(KindaWannaRelapseModel.fromJson(v));
      });
    }
    return kindaRelapsesList;
  }

  Future<bool> addKindaRelapse(
      String accessToken, KindaWannaRelapseModel model) async {
    Map<String, dynamic>? jsonObject = await network.getDataPostMethod(
      UrlConfigurations().baseURL +
          UrlConfigurations().createKindaWannaRelapseURL,
      model.toJson(),
      token: accessToken,
    );
    return jsonObject != null && jsonObject["success"] == "1";
  }

  Future<bool> editKindaRelapse(
      String accessToken, KindaWannaRelapseModel model, String modelId) async {
    Map<String, dynamic>? jsonObject = await network.editDataPutMethod(
      UrlConfigurations().baseURL +
          UrlConfigurations().updateKindaWannaRelapseURL.replaceAll("[@]", modelId),
      model.toJson(),
      token: accessToken,
    );
    return jsonObject != null && jsonObject["success"] == "1";
  }

  Future<bool> deleteKindaRelapse(String accessToken, String journalId) async {
    Map<String, dynamic>? jsonObject = await network.deleteDataDeleteMethod(
      UrlConfigurations().baseURL +
          UrlConfigurations().deleteKindaWannaRelapseURL.replaceAll("[@]", journalId),
      {},
      token: accessToken,
    );
    return jsonObject != null && jsonObject["success"] == "1";
  }
}
