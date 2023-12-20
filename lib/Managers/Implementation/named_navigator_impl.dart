import 'package:free_indeed/Managers/named-navigator.dart';
import 'package:free_indeed/Models/BlogModel.dart';
import 'package:free_indeed/Screens/AddNewGroupScreen/AddNewGroupScreen.dart';
import 'package:free_indeed/Screens/BlogScreen/BlogScreen.dart';
import 'package:free_indeed/Screens/ChatScreen/ChatScreen.dart';
import 'package:free_indeed/Screens/CommunityScreen/AddFriendsScreen/AddFriendsScreen.dart';
import 'package:free_indeed/Screens/CommunityScreen/Post/CommunityPostScreen.dart';
import 'package:free_indeed/Screens/LandingScreen/LandingScreen.dart';
import 'package:free_indeed/Screens/LibraryScreen/NewBlogScreen.dart';
import 'package:free_indeed/Screens/MessagesScreen/CreateMessageScreen.dart';
import 'package:free_indeed/Screens/MyJournalScreen/MyJournalsScreen.dart';
import 'package:free_indeed/Screens/MyJournalScreen/NewJournalScreen.dart';
import 'package:free_indeed/Screens/MyStatsScreen/MyStatsHomeScreen.dart';
import 'package:free_indeed/Screens/Onboarding/OnboardingScreen.dart';
import 'package:free_indeed/Screens/SettingsScreen/AppWebView.dart';
import 'package:free_indeed/Screens/SignUp/SignUpScreen.dart';
import 'package:free_indeed/Screens/SignUp/VerificationScreen.dart';
import 'package:free_indeed/Screens/SingIn/ForgetPasswordScreen.dart';
import 'package:free_indeed/Screens/SingIn/SingInScreen.dart';
import 'package:free_indeed/Screens/Splash/SplashScreen.dart';
import 'package:free_indeed/Screens/iKindaWannaRelapseScreen/iKindaWannaRelapnseScreen.dart';
import 'package:free_indeed/Screens/iRelapsedScreen/iRelapsedScreen.dart';
import 'package:flutter/material.dart';

import '../../Screens/AddNewGroupScreen/AddNewParticipantScreen.dart';
import '../../Screens/commons/GeneralPopup.dart';

class NamedNavigatorImpl implements NamedNavigator {
  static final GlobalKey<NavigatorState> navigatorState =
      GlobalKey<NavigatorState>();

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.SPLASH_ROUTER:
        return _fadeInRoute(page: SplashScreen());
      case Routes.ON_BOARDING_ROUTER:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => OnBoardingScreen(),
        );
      case Routes.SIGN_UP_ROUTER:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => SignUpPage(),
        );
      case Routes.SIGN_IN_ROUTER:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => SignInPage(),
        );
      case Routes.LANDING_ROUTER:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => LandingPage(),
        );
      case Routes.COMMUNITY_COMMENT_ROUTER:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => CommunityCommentScreen(
            post: settings.arguments as CommunityCommentScreenArgs,
          ),
        );
      case Routes.FRIENDS_ROUTER:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => AddFriendsScreen(),
        );
      case Routes.MY_STATS_ROUTER:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => MyStatsHomePage(),
        );
      case Routes.I_RELAPSED_ROUTER:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => IRelapsedScreen(
            iRelapsedArgs: settings.arguments as IRelapsedArgs,
          ),
        );
      case Routes.I_KINDA_WANNA_RELAPSE_ROUTER:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => IKindaWannaRelapseScreen(
            kindaWannaRelapseModel:
                settings.arguments as IKindaWannaRelapseArgs,
          ),
        );
      case Routes.MY_JOURNALS_ROUTER:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => MyJournalsScreen(),
        );
      case Routes.CREATE_JOURNAL_ROUTER:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => CreateJournalScreen(
            newPostArgs: settings.arguments as CreateNewPostArgs,
          ),
        );
      case Routes.CREATE_MESSAGE_ROUTER:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => CreateMessageScreen(),
        );
      case Routes.CREATE_BLOG_ROUTER:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => CreateBlogScreen(
            submit: settings.arguments as Function,
          ),
        );
      case Routes.VERIFICATION_ROUTER:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => VerificationScreen(
            verificationArgs: settings.arguments as VerificationArgs,
          ),
        );
      case Routes.BLOG_ROUTER:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => BlogScreen(
            blog: settings.arguments as BlogModel,
          ),
        );
      case Routes.CHAT_ROUTER:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => ChatScreen(
            chatScreenArgs: settings.arguments as ChatScreenArgs,
          ),
        );

      case Routes.ADD_NEW_PARTICIPANT_ROUTER:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) =>
              AddNewParticipantScreen(chatId: settings.arguments as String),
        );

      case Routes.ADD_NEW_GROUP_ROUTER:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => AddNewGroupScreen(),
        );
      case Routes.FORGET_PASSWORD_ROUTER:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => ForgetPasswordScreen(),
        );
      case Routes.APP_WEB_VIEW:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => AppWebView(url: settings.arguments as String),
        );
    }
    return MaterialPageRoute(settings: settings, builder: (_) => Container());
  }

  @override
  void pop({dynamic result}) {
    if (navigatorState.currentState!.canPop()) {
      navigatorState.currentState!.pop(result);
    }
  }

  @override
  Future push(String routeName, {arguments, bool clean = false}) {
    if (clean) {
      return navigatorState.currentState!.pushNamedAndRemoveUntil(
          routeName, (_) => false,
          arguments: arguments);
    }
    return navigatorState.currentState!
        .pushNamed(routeName, arguments: arguments);
  }

  // Helpers
  static PageRoute _fadeInRoute({Widget? page}) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => Scaffold(
          backgroundColor: Theme.of(context).backgroundColor, body: page),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    );
  }

  @override
  Future<void> showPopup({
    required PopupsTypes type,
    required List<Widget> parameters,
    bool barrierDismissible = true,
  }) async {
    Widget popup;
    switch (type) {
      case PopupsTypes.GENERAL:
        popup = GeneralPopup(parameters: parameters);
        break;
      case PopupsTypes.SUBSCRIPTION_POPUP:
        popup = GeneralPopup(
          parameters: parameters,
        );
        break;
    }

    await showDialog(
      context: navigatorState.currentContext!,
      barrierDismissible: barrierDismissible,
      barrierColor: Colors.black87,
      builder: (BuildContext context) {
        return popup;
      },
    );
  }
}
