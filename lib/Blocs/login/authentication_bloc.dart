// ignore: depend_on_referenced_packages
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:free_indeed/Managers/Implementation/Local-data-manager.impl.dart';
import 'package:free_indeed/Managers/LocalDataManager.dart';
import 'package:free_indeed/Managers/named-navigator.dart';
import 'package:free_indeed/Models/LoginModel.dart';
import 'package:free_indeed/Repo/login_repo.dart';

import '../../Repo/FirebaseRepo.dart';

part 'authentication_event.dart';

part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final LoginRepo _loginRepo;
  final NamedNavigator _namedNavigator;
  final FirebaseRepo _firebaseRepo;

  AuthenticationBloc(
      {required LoginRepo loginRepo,
      required NamedNavigator namedNavigator,
      required FirebaseRepo firebaseRepo})
      : this._loginRepo = loginRepo,
        this._namedNavigator = namedNavigator,
        this._firebaseRepo = firebaseRepo,
        super(AuthenticationInitial()) {
    on<AuthenticationInitializeEvent>((event, emit) {
      emit(AuthenticationReady());
    });
    on<AuthenticationInitializeForgetPasswordEvent>((event, emit) {
      emit(AuthenticationForgetPasswordReady(enterPassword: false));
      // emit(AuthenticationLoading());
    });

    on<AuthenticationForgetPasswordEmailConfirm>((event, emit) async {
      emit(AuthenticationLoading());
      EasyLoading.show(status: "");
      await _loginRepo.forgetPassword(event.username);
      EasyLoading.dismiss();
      EasyLoading.showToast("Please check your email to get the code");
      emit(AuthenticationForgetPasswordReady(enterPassword: true));
    });
    on<AuthenticationForgetPasswordNewPasswordConfirm>((event, emit) async {
      try {
        await _loginRepo.resetPassword(
            event.username, event.newPassword, event.code);
        EasyLoading.showToast("Password reset successfully");

        _namedNavigator.pop();
      } catch (e) {
        if (e is AuthException) {
          EasyLoading.showToast(e.message);
        } else {
          EasyLoading.showToast(
              "Make sure you entered the right password and code");
        }
      }
    });

    on<AuthenticationLoginEvent>((event, emit) async {
      EasyLoading.show(status: "");
      LoginModel? loginModel =
          await _loginRepo.login(event.userName, event.password);
      if (loginModel != null) {
        await LocalDataManagerImpl()
            .writeData(CachingKey.ACCESS_TOKEN, loginModel.accessToken);
        await LocalDataManagerImpl()
            .writeData(CachingKey.REFRESH_TOKEN, loginModel.refreshToken);
        await LocalDataManagerImpl()
            .writeData(CachingKey.ID_TOKEN, loginModel.idToken);
        await LocalDataManagerImpl()
            .writeData(CachingKey.USERNAME, loginModel.username);
        await _loginRepo.cacheUserData();
        String? fcmToken = await _firebaseRepo.firebaseMessaging.getToken();
        if (fcmToken != null) {
          await _firebaseRepo.sendNotificationTokenBackend(fcmToken);
        }
        print(loginModel);
        _namedNavigator.push(Routes.LANDING_ROUTER, clean: true);
        EasyLoading.dismiss();
      } else {
        EasyLoading.dismiss();
      }
      // emit(AuthenticationLoggedIn());
    });

    on<AuthenticationGoToSignUp>((event, emit) {
      _namedNavigator.push(Routes.SIGN_UP_ROUTER, clean: true);
      // emit(AuthenticationLoggedIn());
    });

    on<AuthenticationGoToForgetPassword>((event, emit) {
      _namedNavigator.push(Routes.FORGET_PASSWORD_ROUTER);
    });
  }
}
