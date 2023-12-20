import 'package:free_indeed/Models/IRelapsedModel.dart';
import 'package:free_indeed/Models/RelapsesPerDayChartModel.dart';
import 'package:free_indeed/Models/RelapsesPerMonthChartModel.dart';
import 'package:free_indeed/Models/TriggersChartModel.dart';
import 'package:free_indeed/Models/iRelapsedTileObject.dart';
import 'package:free_indeed/Models/triggerModel.dart';
import 'package:free_indeed/configs/Config.dart';
import 'package:free_indeed/configs/Network.dart';

import '../Models/CleanDayChartModel.dart';

class RelapsedAndStatsRepo {
  Network network = Network();

  Future<List<IRelapsedTileObject>> getRelapsesData(String accessToken) async {
    Map<String, dynamic>? jsonObject = await network.getDataGetMethod(
        UrlConfigurations().baseURL + UrlConfigurations().getRelapsesListURL,
        token: accessToken);
    List<IRelapsedTileObject> relapsesModels = [];
    if (jsonObject != null && jsonObject["success"] == "1") {
      jsonObject["data"].forEach((v) {
        relapsesModels.add(IRelapsedTileObject.fromJson(v));
      });
    }
    return relapsesModels;
  }

  Future<List<TriggerObject>> getTriggersData(String accessToken) async {
    Map<String, dynamic>? jsonObject = await network.getDataGetMethod(
        UrlConfigurations().baseURL + UrlConfigurations().getTriggersListURL,
        token: accessToken);
    List<TriggerObject> triggersModels = [];
    if (jsonObject != null && jsonObject["success"] == "1") {
      jsonObject["data"].forEach((v) {
        triggersModels.add(TriggerObject.fromJson(v));
      });
    }
    return triggersModels;
  }

  Future<bool> submitRelapse(String accessToken, Object body) async {
    Map<String, dynamic>? jsonObject = await network.getDataPostMethod(
        UrlConfigurations().baseURL + UrlConfigurations().createIRelapsedURL,
        body,
        token: accessToken);

    return jsonObject != null && jsonObject["success"] == "1";
  }

  Future<bool> editRelapse(String accessToken, Object body, int id) async {
    Map<String, dynamic>? jsonObject = await network.editDataPutMethod(
        UrlConfigurations().baseURL +
            UrlConfigurations()
                .editIRelapsedURL
                .replaceAll("[@]", id.toString()),
        body,
        token: accessToken);

    return jsonObject != null && jsonObject["success"] == "1";
  }

  Future<bool> deleteRelapse(String accessToken, int id) async {
    Map<String, dynamic>? jsonObject = await network.deleteDataDeleteMethod(
        UrlConfigurations().baseURL +
            UrlConfigurations()
                .deleteIRelapsedURL
                .replaceAll("[@]", id.toString()),
        {},
        token: accessToken);

    return jsonObject != null && jsonObject["success"] == "1";
  }

  Future<List<List<IRelapsedModel>>> getMyRelapses(String accessToken) async {
    Map<String, dynamic>? jsonObject = await network.getDataGetMethod(
        UrlConfigurations().baseURL + UrlConfigurations().iRelapsedListURL,
        token: accessToken);
    List<List<IRelapsedModel>> relapsesList = [];
    if (jsonObject != null && jsonObject["success"] == "1") {
      jsonObject["data"].forEach((v) {
        if (v["data"] != null) {
          List<IRelapsedModel> monthRelapses = [];
          v["data"].forEach((v1) {
            monthRelapses.add(IRelapsedModel.fromJson(v1));
          });
          relapsesList.add(monthRelapses);
        }
      });
    }
    return relapsesList;
  }

  Future<CleanDayChartModel> getCleanDaysStreaks(
      {required String accessToken}) async {
    Map<String, dynamic>? jsonObject = await network.getDataGetMethod(
        UrlConfigurations().baseURL + UrlConfigurations().cleanDaysStreakChartURL,
        token: accessToken);
    CleanDayChartModel? relapsesList;
    if (jsonObject != null && jsonObject["success"] == "1") {
        relapsesList = CleanDayChartModel.fromJson( jsonObject["data"]);
    }
    return Future.value(relapsesList);
  }

  Future<List<RelapsesPerDayChartModel>> getRelapsesPerDay({required String accessToken}) async {
    Map<String, dynamic>? jsonObject = await network.getDataGetMethod(
        UrlConfigurations().baseURL + UrlConfigurations().relapsesPerDayChartURL,
        token: accessToken);
    List<RelapsesPerDayChartModel> relapsesList = [];
    if (jsonObject != null && jsonObject["success"] == "1") {
      jsonObject["data"].forEach((v) {
        relapsesList.add(RelapsesPerDayChartModel.fromJson(v));
      });
    }
    return relapsesList;
  }

  Future<List<RelapsesPerChartModel>> getRelapsesPerMonth(
      {required String accessToken, required String id}) async {
    Map<String, dynamic>? jsonObject = await network.getDataGetMethod(
        UrlConfigurations().baseURL +
            UrlConfigurations().relapsesPerChartURL.replaceAll("[@]", id),
        token: accessToken);
    List<RelapsesPerChartModel> relapsesList = [];
    if (jsonObject != null && jsonObject["success"] == "1") {
      jsonObject["data"].forEach((v) {
        relapsesList.add(RelapsesPerChartModel.fromJson(v));
      });
    }
    return relapsesList;
  }

  Future<List<TriggersChartModel>> getTriggersChart(
      {required String accessToken}) async {
    Map<String, dynamic>? jsonObject = await network.getDataGetMethod(
        UrlConfigurations().baseURL + UrlConfigurations().triggersChartURL,
        token: accessToken);
    List<TriggersChartModel> relapsesList = [];
    if (jsonObject != null && jsonObject["success"] == "1") {
      jsonObject["data"].forEach((v) {
        relapsesList.add(TriggersChartModel.fromJson(v));
      });
    }
    return relapsesList;
  }
}
