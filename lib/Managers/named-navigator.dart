import 'package:flutter/cupertino.dart';

class Routes {
  static const SPLASH_ROUTER = "SPLASH_ROUTER";
  static const ON_BOARDING_ROUTER = "ON_BOARDING_ROUTER";
  static const SIGN_UP_ROUTER = "SIGN_UP_ROUTER";
  static const SIGN_IN_ROUTER = "SIGN_IN_ROUTER";
  static const LANDING_ROUTER = "LANDING_ROUTER";
  static const COMMUNITY_COMMENT_ROUTER = "COMMUNITY_COMMENT_ROUTER";
  static const FRIENDS_ROUTER = "FRIENDS_ROUTER";
  static const MY_STATS_ROUTER = "MY_STATS_ROUTER";
  static const I_RELAPSED_ROUTER = "I_RELAPSED_ROUTER";
  static const I_KINDA_WANNA_RELAPSE_ROUTER = "I_KINDA_WANNA_RELAPSE_ROUTER";
  static const MY_JOURNALS_ROUTER = "MY_JOURNALS_ROUTER";
  static const CREATE_JOURNAL_ROUTER = "CREATE_JOURNAL_ROUTER";
  static const CREATE_MESSAGE_ROUTER = "CREATE_MESSAGE_ROUTER";
  static const CREATE_BLOG_ROUTER = "CREATE_BLOG_ROUTER";
  static const VERIFICATION_ROUTER = "VERIFICATION_ROUTER";
  static const BLOG_ROUTER = "BLOG_ROUTER";
  static const CHAT_ROUTER = "CHAT_ROUTER";
  static const ADD_NEW_GROUP_ROUTER = "ADD_NEW_GROUP_ROUTER";
  static const ADD_NEW_PARTICIPANT_ROUTER = "ADD_NEW_PARTICIPANT_ROUTER";
  static const FORGET_PASSWORD_ROUTER = "FORGET_PASSWORD_ROUTER";
  static const APP_WEB_VIEW = "APP_WEB_VIEW";
}

enum PopupsTypes {
  GENERAL,
  SUBSCRIPTION_POPUP,
}

abstract class NamedNavigator {
  Future push(String routeName, {dynamic arguments, bool clean = false});

  void pop({dynamic result});

  Future<void> showPopup({
    required PopupsTypes type,
    required List<Widget> parameters,
    bool barrierDismissible = true,
  });
}

class RedirectionRoute {
  final String name;
  final dynamic arguments;

  RedirectionRoute({required this.name, this.arguments});

  @override
  String toString() {
    return '''RedirectionRoute(name: $name, arguments: $arguments)''';
  }
}
