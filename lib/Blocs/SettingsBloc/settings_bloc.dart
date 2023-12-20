import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:free_indeed/Managers/Implementation/Local-data-manager.impl.dart';
import 'package:free_indeed/Managers/LocalDataManager.dart';
import 'package:free_indeed/Managers/named-navigator.dart';
import 'package:free_indeed/Repo/login_repo.dart';
import 'package:free_indeed/Screens/SubscriptionPopUp/SubscriptionPopUp.dart';
import 'package:free_indeed/configs/Config.dart';

import '../../Models/UserModel.dart';
import '../../Models/settingsModel.dart';
import '../../Repo/SettingsRepo.dart';

part 'settings_event.dart';

part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final SettingsRepo settingsRepo;
  final LoginRepo userRepo;
  final NamedNavigator namedNavigator;
  late UserModel userModel;
  List<SettingsModel>? settings;

  SettingsBloc(
      {required this.settingsRepo,
      required this.userRepo,
      required this.namedNavigator})
      : super(SettingsInitial()) {
    on<SettingsInitializeEvent>((event, emit) async {
      userModel = await userRepo.getUserDataFromCache();
      emit(SettingsReadyState(userModel: userModel));
      settings = await settingsRepo.getMySettings("");
    });
    on<SettingsChangeUserNameEvent>((event, emit) async {
      bool success = await settingsRepo.changeUserName("", event.newUserName);
      if (success) {
        await LocalDataManagerImpl()
            .writeData(CachingKey.USER_NAME, event.newUserName);
      } else {
        EasyLoading.showToast("Something went wrong .. Please try again later");
      }
    });
    on<SettingsNotificationEvent>((event, emit) async {});
    on<SettingsManageSubscriptionEvent>((event, emit) async {
      namedNavigator.showPopup(
          type: PopupsTypes.GENERAL,
          parameters: [SubscriptionPopUp(subscribeFunction: () {})],
          barrierDismissible: false);
    });
    on<SettingsContactUsEvent>((event, emit) async {
      if (settings != null) {
        for (var element in settings!) {
          if (element.machineName!.compareTo(SettingsType.CONTACT_US.value) ==
              0) {
            namedNavigator.push(Routes.APP_WEB_VIEW, arguments: element.url);
          }
        }
      }
    });
    on<SettingsRateUsEvent>((event, emit) async {});
    on<SettingsPrivacyPolicyEvent>((event, emit) async {
      if (settings != null) {
        for (var element in settings!) {
          if (element.machineName!
                  .compareTo(SettingsType.PRIVACY_POLICY.value) ==
              0) {
            namedNavigator.push(Routes.APP_WEB_VIEW, arguments: element.url);
          }
        }
      }
    });
    on<SettingsTermsAndConditionsEvent>((event, emit) async {
      if (settings != null) {
        for (var element in settings!) {
          if (element.machineName!
                  .compareTo(SettingsType.TERMS_AND_CONDITIONS.value) ==
              0) {
            namedNavigator.push(Routes.APP_WEB_VIEW, arguments: element.url);
          }
        }
      }
    });
    on<SettingsSignOutEvent>((event, emit) async {
      await LocalDataManagerImpl().removeData(CachingKey.ACCESS_TOKEN);
      await LocalDataManagerImpl().removeData(CachingKey.REFRESH_TOKEN);
      await LocalDataManagerImpl().removeData(CachingKey.ID_TOKEN);
      await LocalDataManagerImpl().removeData(CachingKey.USERNAME);
      namedNavigator.push(Routes.SIGN_IN_ROUTER, clean: true);
      await userRepo.logout();
    });
    on<SettingsDeleteUserEvent>((event, emit) async {});
  }
}
