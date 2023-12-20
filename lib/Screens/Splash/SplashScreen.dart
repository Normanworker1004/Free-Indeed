import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:free_indeed/Blocs/SplashBloc/splash_bloc.dart';
import 'package:free_indeed/Managers/Implementation/named_navigator_impl.dart';
import 'package:free_indeed/Repo/FirebaseRepo.dart';
import 'package:free_indeed/Repo/login_repo.dart';
import 'package:free_indeed/configs/ScreenConfig.dart';
import 'package:free_indeed/configs/general_configs.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  SplashBloc _splashBloc = SplashBloc(
      firebaseRepo: FirebaseRepo(),
      loginRepo: LoginRepo(),
      namedNavigator: NamedNavigatorImpl());

  @override
  void initState() {
    _splashBloc.add(SplashInitializeEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ScreenConfig().init(context);
    return BlocProvider(
      create: (context) => _splashBloc,
      child: BlocBuilder<SplashBloc, SplashState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: GeneralConfigs.BACKGROUND_COLOR,
            body: Center(
                child: Image.asset(
              GeneralConfigs.IMAGE_ASSETS_PATH + 'logo.png',
              width: MediaQuery.of(context).size.width * 0.38,
              height: MediaQuery.of(context).size.height * 0.16,
            )),
          );
        },
      ),
    );
  }
}
