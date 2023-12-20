// ignore: depend_on_referenced_packages
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:free_indeed/Managers/Implementation/Local-data-manager.impl.dart';
import 'package:free_indeed/Managers/LocalDataManager.dart';
import 'package:free_indeed/Managers/named-navigator.dart';
import 'package:free_indeed/Models/LoginModel.dart';
import 'package:free_indeed/Models/SignUpModel.dart';
import 'package:free_indeed/Repo/login_repo.dart';
import 'package:free_indeed/Screens/SignUp/VerificationScreen.dart';

part 'sign_up_event.dart';

part 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final LoginRepo _loginRepo;
  final NamedNavigator _namedNavigator;

  SignUpBloc(
      {required LoginRepo loginRepo, required NamedNavigator namedNavigator})
      : this._loginRepo = loginRepo,
        this._namedNavigator = namedNavigator,
        super(SignUpInitialState()) {
    on<SigningUpEvent>((event, emit) async {
      EasyLoading.show(status: "");
      SignUpModel signUpModel = SignUpModel(
          id: "",
          username: event.userName,
          email: event.email,
          password: event.password,
          success: true,
          message: "",
          refreshToken: "");
      try {
        bool success = await _loginRepo.signUp(signUpModel);
        await LocalDataManagerImpl()
            .writeData(CachingKey.TEMP_PASSWORD, event.password);
        if (success) {
          VerificationArgs verificationArgs =
              VerificationArgs(email: event.email, fromSignIn: false);
          EasyLoading.dismiss();
          _namedNavigator.push(Routes.VERIFICATION_ROUTER,
              arguments: verificationArgs);
        } else {
          EasyLoading.dismiss();
          // EasyLoading.showToast("something went wrong");
        }
      } catch (e) {
        print(e);
        EasyLoading.dismiss();
      }
    });

    on<SignUpGoToSignInEvent>((event, emit) async {
      _namedNavigator.push(Routes.SIGN_IN_ROUTER);
    });
    on<SignUpResendCodeEvent>((event, emit) async {
      await _loginRepo.resendCode(event.email);
    });

    on<VerifyCodeEvent>((event, emit) async {
      EasyLoading.show(status: "");
      try {
        await _loginRepo.verify(event.email, event.code);

        String tempPassword =
            LocalDataManagerImpl().readString(CachingKey.TEMP_PASSWORD);
        if (tempPassword.isEmpty) {
          _namedNavigator.push(Routes.SIGN_IN_ROUTER);
        } else {
          try {
            await loginRepo.logout();
          } catch (r) {
            print(r);
          }
          LoginModel? loginModel =
              await _loginRepo.login(event.email, tempPassword);
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
            // throw Exception("test");
            print(loginModel);
            _namedNavigator.push(Routes.LANDING_ROUTER, clean: true);
            EasyLoading.dismiss();
          } else {
            EasyLoading.dismiss();
            _namedNavigator.push(Routes.SIGN_IN_ROUTER);
          }
        }
      } catch (e) {
        if (e is CodeMismatchException) {
          EasyLoading.dismiss();
          EasyLoading.showToast(e.message);
        } else {
          EasyLoading.dismiss();
          _namedNavigator.push(Routes.SIGN_IN_ROUTER);
        }
      }
    });
  }
}
