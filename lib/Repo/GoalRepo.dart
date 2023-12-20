import 'package:free_indeed/Models/GoalModel.dart';
import 'package:free_indeed/configs/Config.dart';
import 'package:free_indeed/configs/Network.dart';

class GoalRepo {
  Network network = Network();

  Future<bool> setGoalData(
      {required String accessToken,
      required int numberOfDays,
      required int goalProgress}) async {
    Map<String, dynamic>? jsonObject = await network.getDataPostMethod(
        UrlConfigurations().baseURL + UrlConfigurations().setGoalURL,
        {
          "numberOfDays": numberOfDays,
          "goalProgress": goalProgress,
        },
        token: accessToken);

    return jsonObject != null && jsonObject["success"] == "1";
  }

  Future<GoalModel> getGoalData({required String accessToken}) async {
    Map<String, dynamic>? jsonObject = await network.getDataGetMethod(
        UrlConfigurations().baseURL + UrlConfigurations().getGoalURL,
        token: accessToken);
    GoalModel? goalModel;
    if (jsonObject != null && jsonObject["success"] == "1") {
      goalModel = GoalModel.fromJson(jsonObject["data"]);
    }
    if (goalModel == null) {
      return GoalModel(
          id: "id",
          days: "0",
          hours: "0",
          minutes: "0",
          success: true,
          goalProgress: false,
          percentage: "100");
    } else {
      return goalModel;
    }
  }

  Future<int> getUserGoalData({required String accessToken}) async {
    Map<String, dynamic>? jsonObject = await network.getDataGetMethod(
        UrlConfigurations().baseURL + UrlConfigurations().getUserGoalURL,
        token: accessToken);
    if (jsonObject != null &&
        jsonObject["success"] == "1" &&
        jsonObject["data"] != null) {
      return jsonObject["data"];
    } else {
      return 1;
    }
  }

  Future<String> getFutureIndeedAccountId({required String accessToken}) async {
    Map<String, dynamic>? jsonObject = await network.getDataGetMethod(
        UrlConfigurations().baseURL +
            UrlConfigurations().getFreeIndeedUserIdURL,
        token: accessToken);
    if (jsonObject != null &&
        jsonObject["success"] == "1" &&
        jsonObject["data"] != null) {
      return jsonObject["data"];
    } else {
      return "";
    }
  }
}
