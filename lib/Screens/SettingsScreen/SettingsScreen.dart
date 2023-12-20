import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:free_indeed/Managers/Implementation/named_navigator_impl.dart';
import 'package:free_indeed/Repo/login_repo.dart';
import 'package:free_indeed/configs/ScreenConfig.dart';
import 'package:free_indeed/configs/general_configs.dart';
import 'package:free_indeed/localization/localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../Blocs/SettingsBloc/settings_bloc.dart';
import '../../Repo/SettingsRepo.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notifications = false;

  SettingsBloc _settingsBloc = SettingsBloc(
      settingsRepo: SettingsRepo(),
      userRepo: LoginRepo(),
      namedNavigator: NamedNavigatorImpl());

  String _userName = "";
  bool _editingUserName = false;
  FocusNode _focus = FocusNode();

  @override
  void dispose() {
    _focus.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _settingsBloc.add(SettingsInitializeEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _settingsBloc,
      child: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
          if (state is SettingsReadyState) {
            return Scaffold(
              appBar: PreferredSize(
                preferredSize:
                    Size.fromHeight(ScreenConfig.screenHeight * 0.07),
                child: AppBar(
                  automaticallyImplyLeading: false,
                  backgroundColor: GeneralConfigs.SETTINGS_APP_BAR_COLOR,
                  title: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: ScreenConfig.screenWidth / 2,
                            child: TextFormField(
                              initialValue: state.userModel.username!,
                              focusNode: _focus,
                              enabled: _editingUserName,
                              onChanged: (val) {
                                _userName = val;
                              },
                              style: TextStyle(
                                  fontSize: 17,
                                  color: GeneralConfigs.SECONDARY_COLOR),
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              setState(() {
                                if (_editingUserName && _userName.isNotEmpty) {
                                  editUsername();
                                } else {}
                                _editingUserName = !_editingUserName;
                              });
                              if (_editingUserName) {
                                await Future.delayed(
                                    Duration(milliseconds: 200));
                                _focus.requestFocus();
                              }
                            },
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  _editingUserName
                                      ? AppLocalization.of(context)!
                                          .getLocalizedText(
                                              "settings_screen_submit_button")
                                      : AppLocalization.of(context)!
                                          .getLocalizedText(
                                              "settings_screen_edit_button"),
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: GeneralConfigs.SECONDARY_COLOR,
                                      fontWeight: FontWeight.w400),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                _editingUserName
                                    ? Icon(
                                        Icons.check_sharp,
                                        size: 18,
                                        color: GeneralConfigs.SECONDARY_COLOR,
                                      )
                                    : SvgPicture.asset(
                                        GeneralConfigs.ICONS_PATH +
                                            "editPostIcon.svg",
                                        width: 18,
                                        height: 18,
                                        color: Colors.white,
                                        fit: BoxFit.fill,
                                      ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              backgroundColor: GeneralConfigs.BACKGROUND_COLOR,
              body: SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20),
                      Text(
                        AppLocalization.of(context)!
                            .getLocalizedText("settings_screen_settings_title"),
                        style: TextStyle(
                            fontSize: 16,
                            color: GeneralConfigs.SECONDARY_COLOR,
                            fontWeight: FontWeight.w500),
                      ),
                      Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: settingsPart(context)),
                      Text(
                        AppLocalization.of(context)!
                            .getLocalizedText("settings_screen_subscription"),
                        style: TextStyle(
                            fontSize: 16,
                            color: GeneralConfigs.SECONDARY_COLOR,
                            fontWeight: FontWeight.w500),
                      ),
                      Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: subscriptionPart(context)),
                      Text(
                        AppLocalization.of(context)!
                            .getLocalizedText("settings_screen_other"),
                        style: TextStyle(
                            fontSize: 16,
                            color: GeneralConfigs.SECONDARY_COLOR,
                            fontWeight: FontWeight.w500),
                      ),
                      Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: otherPart(context)),
                      Text(
                        AppLocalization.of(context)!
                            .getLocalizedText("settings_screen_account"),
                        style: TextStyle(
                            fontSize: 16,
                            color: GeneralConfigs.SECONDARY_COLOR,
                            fontWeight: FontWeight.w500),
                      ),
                      Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: accountPart(context)),
                    ],
                  ),
                ),
              ),
            );
          } else {
            return Scaffold(
                appBar: PreferredSize(
                  preferredSize: Size.fromHeight(80.0),
                  child: AppBar(
                    automaticallyImplyLeading: false,
                    backgroundColor: GeneralConfigs.SETTINGS_APP_BAR_COLOR,
                    title: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "",
                              style: TextStyle(
                                  fontSize: 17,
                                  color: GeneralConfigs.SECONDARY_COLOR),
                            ),
                            GestureDetector(
                              onTap: () {},
                              child: Row(
                                children: [
                                  Text(
                                    AppLocalization.of(context)!
                                        .getLocalizedText(
                                            "settings_screen_edit_button"),
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: GeneralConfigs.SECONDARY_COLOR,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  SvgPicture.asset(
                                    GeneralConfigs.ICONS_PATH +
                                        "editPostIcon.svg",
                                    width: 18,
                                    height: 18,
                                    color: Colors.white,
                                    fit: BoxFit.fill,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "",
                          style: TextStyle(
                              fontSize: 15,
                              color: Colors.green,
                              fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                  ),
                ),
                backgroundColor: GeneralConfigs.BACKGROUND_COLOR,
                body: Container());
          }
        },
      ),
    );
  }

  Widget settingsPart(BuildContext context) {
    return Container(
      color: GeneralConfigs.BACKGROUND_COLOR,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppLocalization.of(context)!
                  .getLocalizedText("settings_screen_notifications"),
              style: TextStyle(
                  fontSize: 15,
                  color: GeneralConfigs.SECONDARY_COLOR,
                  fontWeight: FontWeight.w400),
            ),
            CupertinoSwitch(
              value: _notifications,
              // changes the state of the switch
              onChanged: (value) => setState(() => _notifications = value),
            ),
          ],
        ),
      ),
    );
  }

  Widget subscriptionPart(BuildContext context) {
    return Column(
      children: [
        settingsTile(
            context: context,
            iconPath: "ManageSubscriptionIcon.svg",
            onTap: () {
              manageSubscriptions();
            },
            textKey: "settings_screen_manage_subscription")
      ],
    );
  }

  Widget otherPart(BuildContext context) {
    return Column(
      children: [
        settingsTile(
            context: context,
            iconPath: "contact.svg",
            onTap: () {
              contactUs();
            },
            textKey: "settings_screen_contact_us"),
        settingDivider(),
        settingsTile(
            context: context,
            iconPath: "rate.svg",
            onTap: () {
              rateUs();
            },
            textKey: "settings_screen_rate_us"),
        settingDivider(),
        settingsTile(
            context: context,
            iconPath: "privacy.svg",
            onTap: () {
              privacyPolicy();
            },
            textKey: "settings_screen_privacy_policy"),
        settingDivider(),
        settingsTile(
            context: context,
            iconPath: "terms.svg",
            onTap: () {
              termsAndConditions();
            },
            textKey: "settings_screen_terms_and_conditions"),
      ],
    );
  }

  Widget accountPart(BuildContext context) {
    return Column(
      children: [
        settingsTile(
            context: context,
            iconPath: "signout.svg",
            onTap: () {
              signOut();
            },
            textKey: "settings_screen_sign_out"),
        settingDivider(),
        settingsTile(
            context: context,
            iconPath: "delete.svg",
            onTap: () {
              deactivateAccount();
            },
            textKey: "settings_screen_deactivate_account"),
      ],
    );
  }

  Widget settingsTile({
    required BuildContext context,
    required String iconPath,
    required String textKey,
    required Function onTap,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      tileColor: GeneralConfigs.BACKGROUND_COLOR,
      onTap: () {
        onTap();
      },
      trailing: SvgPicture.asset(
        GeneralConfigs.ICONS_PATH + iconPath,
        width: 28,
        height: 28,
        color: GeneralConfigs.SECONDARY_COLOR,
        fit: BoxFit.scaleDown,
      ),
      title: Text(
        AppLocalization.of(context)!.getLocalizedText(textKey),
        style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            color: GeneralConfigs.SECONDARY_COLOR),
      ),
    );
  }

  Widget settingDivider() {
    return Divider(
      color: GeneralConfigs.COMMUNITY_CARD_BACKGROUND_COLOR,
      thickness: 1,
      height: 1,
      indent: 10,
      endIndent: 10,
    );
  }

  void signOut() async {
    _settingsBloc.add(SettingsSignOutEvent());

    print("signOut");
  }

  void deactivateAccount() {
    _settingsBloc.add(SettingsDeleteUserEvent());

    print("deactivateAccount");
  }

  void termsAndConditions() {
    _settingsBloc.add(SettingsTermsAndConditionsEvent());

    print("termsAndConditions");
  }

  void privacyPolicy() {
    _settingsBloc.add(SettingsPrivacyPolicyEvent());

    print("privacyPolicy");
  }

  void rateUs() {
    _settingsBloc.add(SettingsRateUsEvent());

    print("rateUs");
  }

  void contactUs() {
    _settingsBloc.add(SettingsContactUsEvent());

    print("contactUs");
  }

  void manageSubscriptions() {
    _settingsBloc.add(SettingsManageSubscriptionEvent());
    print("manageSubscriptions");
  }

  void editUsername() {
    _settingsBloc.add(SettingsChangeUserNameEvent(newUserName: _userName));
    print("editUsername");
  }
}
