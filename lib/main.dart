import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:free_indeed/Blocs/GlobalBlocObserver.dart';
import 'package:free_indeed/Managers/Implementation/named_navigator_impl.dart';
import 'package:free_indeed/Managers/named-navigator.dart';
import 'package:free_indeed/Models/fellow_indeed_app_model.dart';
import 'package:free_indeed/configs/app_language.dart';
import 'package:free_indeed/configs/general_configs.dart';
import 'package:free_indeed/localization/localization.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:scoped_model/scoped_model.dart';

import 'Managers/Implementation/Local-data-manager.impl.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await LocalDataManagerImpl.init();
  // ignore: deprecated_member_use
  BlocOverrides.runZoned(
    () {
      if (defaultTargetPlatform == TargetPlatform.android) {
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
      }
      runApp(Phoenix(child: OverlaySupport.global(child: MyApp())));
    },
    blocObserver: MyGlobalObserver(),
  );
  // runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    EasyLoading.instance
      ..loadingStyle = EasyLoadingStyle.custom
      ..indicatorSize = 50
      ..textColor = GeneralConfigs.SECONDARY_COLOR
      ..indicatorColor = GeneralConfigs.SECONDARY_COLOR
      ..backgroundColor = GeneralConfigs.BACKGROUND_COLOR
      ..userInteractions = false
      ..dismissOnTap = false
      ..boxShadow = <BoxShadow>[];

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent, // Color for Android
        statusBarBrightness:
            Brightness.dark // Dark == white status bar -- for IOS.
        ));
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.bottom]);
    return ScopedModel<FreeIndeedAppModel>(
      model: FreeIndeedAppModel(),
      child: ScopedModelDescendant<FreeIndeedAppModel>(
          builder: (context, child, model) {
        return MaterialApp(
          title: 'Fellow Indeed',
          locale: model.appLocal,
          theme: ThemeData(
              backgroundColor: Color(0xFF131313),
              brightness: Brightness.dark,
              fontFamily: 'Roboto',
              accentColor: Colors.transparent),
          initialRoute: Routes.SPLASH_ROUTER,
          onGenerateRoute: NamedNavigatorImpl.onGenerateRoute,
          navigatorKey: NamedNavigatorImpl.navigatorState,
          builder: EasyLoading.init(),
          supportedLocales: [
            const Locale('en', ''), // English
            const Locale('ar', '')
          ],
          localizationsDelegates: [
            //For Arabic Text Selection localization
            GlobalCupertinoLocalizations.delegate,
            AppLocalizationDelegate(
              localizationPath: GeneralConfigs.LOCALIZATION_PATH,
              supportedLanguages: [
                AppLanguage.ENGLISH.code,
                AppLanguage.ARABIC.code
              ],
            ),
            // Built-in localization of basic text for Material widgets
            GlobalMaterialLocalizations.delegate,
            // Built-in localization for text direction LTR/RTL
            GlobalWidgetsLocalizations.delegate,
          ],
        );
      }),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required FreeIndeedAppModel appModel})
      : this.appModel = appModel,
        super(key: key);

  final FreeIndeedAppModel appModel;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter(BuildContext context) {
    setState(() {
      if (AppLocalization.of(context)!.currentLanguage ==
          AppLanguage.ENGLISH.code) {
        widget.appModel.changeAppLanguage(
          languageCode: AppLanguage.ARABIC.code,
        );
      } else {
        widget.appModel
            .changeAppLanguage(languageCode: AppLanguage.ENGLISH.code);
      }
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Fellow Indeed"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              AppLocalization.of(context)!
                  .getLocalizedText("internal_test_build"),
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
            ElevatedButton(
                onPressed: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //       builder: (context) => LoginPageWithFlutterBloc()),
                  // );
                },
                child: Text("login Page with Flutter Bloc")),
            ElevatedButton(
                onPressed: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //       builder: (context) => LoginPageWithFlutterBloc()),
                  // );
                },
                child: Text("Start App"))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _incrementCounter(context);
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
