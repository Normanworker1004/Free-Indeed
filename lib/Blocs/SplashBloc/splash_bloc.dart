
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:free_indeed/Managers/TokenManager.dart';

import '../../AWSConfiguations/AWSConfig.dart';
import '../../Managers/Implementation/Local-data-manager.impl.dart';
import '../../Managers/LocalDataManager.dart';
import '../../Managers/named-navigator.dart';
import '../../Repo/FirebaseRepo.dart';
import '../../Repo/login_repo.dart';

part 'splash_event.dart';

part 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  NamedNavigator namedNavigator;
  LoginRepo loginRepo;
  FirebaseRepo firebaseRepo;

  SplashBloc(
      {required this.loginRepo,
      required this.namedNavigator,
      required this.firebaseRepo})
      : super(SplashInitial()) {

    on<SplashInitializeEvent>((event, emit) async {
      await AWSConfig().configureAmplify();
      await firebaseRepo.initializeFireBaseMessaging();
      bool oldUser = LocalDataManagerImpl().readBoolean(CachingKey.OLD_USER);
      String accessToken =
          LocalDataManagerImpl().readString(CachingKey.ACCESS_TOKEN);
      if (!oldUser) {
        namedNavigator.push(Routes.ON_BOARDING_ROUTER, clean: true);
      } else if (oldUser && accessToken != "") {
        try {
          // await loginRepo.refreshToken();
          await TokenManager().refreshToken();
          await loginRepo.cacheUserData();
        } catch (e) {
          namedNavigator.push(Routes.SIGN_IN_ROUTER, clean: true);
        }
        namedNavigator.push(Routes.LANDING_ROUTER, clean: true);
      } else {
        namedNavigator.push(Routes.SIGN_IN_ROUTER, clean: true);
      }
    });
  }
}
