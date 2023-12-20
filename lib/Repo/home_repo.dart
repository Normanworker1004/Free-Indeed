
import 'package:free_indeed/configs/Config.dart';
import 'package:free_indeed/configs/Network.dart';

class HomeRepo {
  Network network = Network();


  Future<void> submitTellingUsAboutYourself(
      String accessToken, String relapseModel) async {
    await network.getDataPostMethod(UrlConfigurations().baseURL, {
      "accessToken": accessToken,
    });
  }

}
