import 'package:free_indeed/Screens/CommunityScreen/CommunityPage.dart';
import 'package:free_indeed/Screens/HomeScreen/HomeScreen.dart';
import 'package:free_indeed/Screens/LibraryScreen/LibraryScreen.dart';
import 'package:free_indeed/Screens/MessagesScreen/MessagesScreen.dart';
import 'package:free_indeed/Screens/SettingsScreen/SettingsScreen.dart';
import 'package:free_indeed/configs/ScreenConfig.dart';
import 'package:free_indeed/configs/general_configs.dart';
import 'package:free_indeed/localization/localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  static List<Widget> _widgetOptions = [];
  int _selectedIndex = 0;

  static final Widget _communityPage = CommunityScreen();
  static final Widget _messagingPage = MessagesPage();
  static final Widget _homeScreen = HomeScreen();
  static final Widget _libraryPage = LibraryPage();
  static final Widget _settingsPage = SettingsPage();

  @override
  Widget build(BuildContext context) {
    _widgetOptions = <Widget>[
      _communityPage,
      _messagingPage,
      _homeScreen,
      _libraryPage,
      _settingsPage,
    ];
    return Scaffold(
      backgroundColor: GeneralConfigs.BACKGROUND_COLOR,
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar:  ClipRRect(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(15), topLeft: Radius.circular(15)),
        child: SizedBox(
          height: ScreenConfig.screenHeight * 0.12,
          child: BottomNavigationBar(
            backgroundColor: GeneralConfigs.NAVIGATION_BAR_COLOR,
            unselectedItemColor: GeneralConfigs.DISABLED_ICON_COLOR,
            selectedItemColor: GeneralConfigs.SECONDARY_COLOR,
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(bottom: 10.0),
                  child: SvgPicture.asset(
                    GeneralConfigs.ICONS_PATH + "communityIcon.svg",
                    width: 20,
                    height: 20,
                    color: _selectedIndex == 0
                        ? GeneralConfigs.SECONDARY_COLOR
                        : GeneralConfigs.DISABLED_ICON_COLOR,
                  ),
                ),
                label: AppLocalization.of(context)!
                    .getLocalizedText("landing_page_community_icon_text"),
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: SvgPicture.asset(
                    GeneralConfigs.ICONS_PATH + "messagesIcon.svg",
                    width: 20,
                    height: 20,
                    color: _selectedIndex == 1
                        ? GeneralConfigs.SECONDARY_COLOR
                        : GeneralConfigs.DISABLED_ICON_COLOR,
                  ),
                ),
                label: AppLocalization.of(context)!
                    .getLocalizedText("landing_page_message_icon_text"),
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: SvgPicture.asset(
                    GeneralConfigs.ICONS_PATH + "homeIcon.svg",
                    width: 20,
                    height: 20,
                    color: _selectedIndex == 2
                        ? GeneralConfigs.SECONDARY_COLOR
                        : GeneralConfigs.DISABLED_ICON_COLOR,
                  ),
                ),
                label: AppLocalization.of(context)!
                    .getLocalizedText("landing_page_home_icon_text"),
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: SvgPicture.asset(
                    GeneralConfigs.ICONS_PATH + "libraryIcon.svg",
                    width: 20,
                    height: 20,
                    color: _selectedIndex == 3
                        ? GeneralConfigs.SECONDARY_COLOR
                        : GeneralConfigs.DISABLED_ICON_COLOR,
                  ),
                ),
                label: AppLocalization.of(context)!
                    .getLocalizedText("landing_page_library_icon_text"),
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: SvgPicture.asset(
                    GeneralConfigs.ICONS_PATH + "settingsIcon.svg",
                    width: 20,
                    height: 20,
                    color: _selectedIndex == 4
                        ? GeneralConfigs.SECONDARY_COLOR
                        : GeneralConfigs.DISABLED_ICON_COLOR,
                  ),
                ),
                label: AppLocalization.of(context)!
                    .getLocalizedText("landing_page_settings_icon_text"),
              ),
            ],
            currentIndex: _selectedIndex,
            type: BottomNavigationBarType.fixed,
            onTap: (int s) {
              _onItemTapped(s);
            },
          ),
        ),
      ),
      resizeToAvoidBottomInset: false,
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
