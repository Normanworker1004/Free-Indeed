import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:free_indeed/Managers/Implementation/Local-data-manager.impl.dart';
import 'package:free_indeed/Managers/Implementation/named_navigator_impl.dart';
import 'package:free_indeed/Managers/LocalDataManager.dart';
import 'package:free_indeed/Managers/named-navigator.dart';
import 'package:free_indeed/Models/SignUpModel.dart';
import 'package:free_indeed/Models/UserModel.dart';
import 'package:free_indeed/Screens/SignUp/VerificationScreen.dart';
import 'package:free_indeed/configs/Config.dart';
import 'package:free_indeed/Models/LoginModel.dart';
import 'package:free_indeed/configs/Network.dart';

class LoginRepo {
  Network network = Network();

  Future<LoginModel?> login(String userName, String password) async {
    Map<String, dynamic>? jsonObject;
    try {
      SignInResult signInResult =
          await Amplify.Auth.signIn(username: userName, password: password);
      print(signInResult);

      jsonObject = await network.getDataPostMethod(
          UrlConfigurations().baseURL + UrlConfigurations().loginURL, {
        "username": userName,
        "password": password,
      });
      UserCredential user = await FirebaseAuth.instance.signInAnonymously();
      await LocalDataManagerImpl()
          .writeData(CachingKey.FIREBASE_ID, user.user!.uid);
      await LocalDataManagerImpl()
          .writeData(CachingKey.LAST_TOKEN_UPDATE, DateTime.now().toString());
    } catch (e) {
      if (e is UserNotConfirmedException) {
        EasyLoading.showToast(e.message);
        await LocalDataManagerImpl()
            .writeData(CachingKey.TEMP_PASSWORD, password);
        VerificationArgs verificationArgs =
            VerificationArgs(email: userName, fromSignIn: true);
        EasyLoading.dismiss();
        NamedNavigatorImpl()
            .push(Routes.VERIFICATION_ROUTER, arguments: verificationArgs);
      }
      if (e is InvalidStateException) {
        await Amplify.Auth.signOut();
      } else if (e is AuthException) {
        EasyLoading.showToast(e.message);
      } else {
        await Amplify.Auth.signOut();
      }
      print(e);
      return null;
    }

    return jsonObject != null
        ? LoginModel.fromJson(jsonObject)
        : LoginModel(
            id: "",
            username: "",
            email: "",
            accessToken: "",
            success: false,
            message: "",
            idToken: "",
            refreshToken: '');
  }

  Future<bool> signUp(SignUpModel signUpModel) async {
    await LocalDataManagerImpl()
        .writeData(CachingKey.TEMP_PASSWORD, signUpModel.password);
    Map<String, dynamic>? jsonObject = await network.getDataPostMethod(
        UrlConfigurations().baseURL + UrlConfigurations().signUpURL, {
      "userName": signUpModel.username,
      "password": signUpModel.password,
      "email": signUpModel.email,
    });
    if (jsonObject != null &&
        jsonObject["success"] != "1" &&
        jsonObject["msg"] != null) {
      EasyLoading.showToast(jsonObject["msg"].toString());
    }
    return jsonObject != null && jsonObject["success"] == "1";
  }

  Future<void> verify(String email, String code) async {
    final result = await Amplify.Auth.confirmSignUp(
        username: email, confirmationCode: code);
    print(result);
  }

  Future<void> resendCode(String email) async {
    final result = await Amplify.Auth.resendSignUpCode(username: email);
    print(result);
  }

  Future<UserModel> getUserData(String accessToken) async {
    Map<String, dynamic>? jsonObject = await network.getDataGetMethod(
        UrlConfigurations().baseURL + UrlConfigurations().getUserDataURL,
        token: accessToken);
    return jsonObject != null
        ? UserModel.fromJson(jsonObject)
        : UserModel(
            id: "",
            username: "",
            cognitoId: "",
            hasNotifications: true,
            success: true,
            subscribed: true);
  }

  Future<void> cacheUserData() async {
    String token = LocalDataManagerImpl().readString(CachingKey.ACCESS_TOKEN);
    UserModel userModel = await getUserData(token);
    await LocalDataManagerImpl()
        .writeData(CachingKey.USER_NAME, userModel.username);
    await LocalDataManagerImpl().writeData(CachingKey.USER_ID, userModel.id);
    await LocalDataManagerImpl()
        .writeData(CachingKey.IS_USER_SUBSCRIBED, userModel.subscribed);
    await LocalDataManagerImpl().writeData(
        CachingKey.IS_USER_HAS_NOTIFICATIONS, userModel.hasNotifications);
    await LocalDataManagerImpl()
        .writeData(CachingKey.USER_COGNITO_ID, userModel.cognitoId);
  }

  Future<UserModel> getUserDataFromCache() async {
    String username = LocalDataManagerImpl().readString(CachingKey.USER_NAME);
    String userCognitoId =
        LocalDataManagerImpl().readString(CachingKey.USER_COGNITO_ID);
    String userId = LocalDataManagerImpl().readString(CachingKey.USER_ID);
    bool isSubscribed =
        LocalDataManagerImpl().readBoolean(CachingKey.IS_USER_SUBSCRIBED);
    bool hasNotifications = LocalDataManagerImpl()
        .readBoolean(CachingKey.IS_USER_HAS_NOTIFICATIONS);
    return UserModel(
        id: userId,
        username: username,
        hasNotifications: hasNotifications,
        cognitoId: userCognitoId,
        success: true,
        subscribed: isSubscribed);
  }

  Future<void> logout() async {
    // await network.getDataGetMethod(UrlConfigurations().baseURL,
    //     token: accessToken);
    await Amplify.Auth.signOut();
    await FirebaseAuth.instance.signOut();
    await LocalDataManagerImpl().removeData(CachingKey.LAST_TOKEN_UPDATE);
    await LocalDataManagerImpl().removeData(CachingKey.USER_NAME);
    await LocalDataManagerImpl().removeData(CachingKey.USER_ID);
    await LocalDataManagerImpl().removeData(CachingKey.IS_USER_SUBSCRIBED);
    await LocalDataManagerImpl()
        .removeData(CachingKey.IS_USER_HAS_NOTIFICATIONS);
  }

  Future<void> forgetPassword(String username) async {
    try {
      await Amplify.Auth.resetPassword(
        username: username,
      );
    } catch (e) {
      if (e is AuthException) {
        EasyLoading.showToast(e.message);
      } else {
        EasyLoading.showToast("Something went wrong .. Please try again later");
      }
    }
  }

  Future<void> resetPassword(
      String username, String newPassword, String code) async {
    await Amplify.Auth.confirmResetPassword(
        username: username, newPassword: newPassword, confirmationCode: code);
  }
}
