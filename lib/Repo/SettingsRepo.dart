import 'package:free_indeed/Models/settingsModel.dart';
import 'package:free_indeed/configs/Config.dart';
import 'package:free_indeed/configs/Network.dart';

class SettingsRepo {
  Network network = Network();

  Future<bool> changeUserName(String accessToken, String newUserName) async {
    Map<String, dynamic>? jsonObject = await network.editDataPutMethod(
        UrlConfigurations().baseURL + UrlConfigurations().editUserNameURL,
        {
          "userName": newUserName,
        },
        token: accessToken);
    return jsonObject != null && jsonObject["success"] == "1";
  }

  Future<List<SettingsModel>> getMySettings(String accessToken) async {
    Map<String, dynamic>? jsonObject = await network.getDataGetMethod(
      UrlConfigurations().baseURL + UrlConfigurations().getSettingsURL,
      token: accessToken,
    );
    List<SettingsModel> settingsData = [];
    if (jsonObject != null && jsonObject["success"] == "1") {
      jsonObject["data"].forEach((v) {
        settingsData.add(SettingsModel.fromJson(v));
      });
    }
    return settingsData;
  }
}
