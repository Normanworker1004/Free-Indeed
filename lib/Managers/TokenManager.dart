import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:free_indeed/Managers/Implementation/Local-data-manager.impl.dart';
import 'package:free_indeed/Managers/LocalDataManager.dart';


class TokenManager {
  late String date;

  TokenManager() {
    date = LocalDataManagerImpl().readString(CachingKey.LAST_TOKEN_UPDATE);
  }

  Future<String> getCurrentToken() async {
    if (date.compareTo("") == 1) {
      // print(int.parse(getDifference(DateTime.parse(date))));
      if (int.parse(getDifference(DateTime.parse(date))) > 30) {
        await refreshToken();
      }
    }
    return LocalDataManagerImpl().readString(CachingKey.ACCESS_TOKEN);
  }

  String getDifference(DateTime date) {
    Duration duration = DateTime.now().difference(date);
    String differenceInMinutes = (duration.inMinutes).toString();
    return differenceInMinutes;
  }

  Future<void> refreshToken() async {
    final CognitoAuthSession result = await Amplify.Auth.fetchAuthSession(
        options: CognitoSessionOptions(
          getAWSCredentials: true,
        )).timeout(
      const Duration(seconds: 5),
    ) as CognitoAuthSession;
    if (result.isSignedIn) {
      await LocalDataManagerImpl().writeData(
          CachingKey.ACCESS_TOKEN, result.userPoolTokens!.accessToken);
      await LocalDataManagerImpl().writeData(
          CachingKey.REFRESH_TOKEN, result.userPoolTokens!.refreshToken);
      await LocalDataManagerImpl()
          .writeData(CachingKey.ID_TOKEN, result.userPoolTokens!.idToken);
      await LocalDataManagerImpl()
          .writeData(CachingKey.LAST_TOKEN_UPDATE, DateTime.now().toString());
    }
  }
}
