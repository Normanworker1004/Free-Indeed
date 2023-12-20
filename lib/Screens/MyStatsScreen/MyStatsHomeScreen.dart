import 'package:flutter/material.dart';
import 'package:free_indeed/Screens/HomeScreen/MyStatsScreen.dart';
import 'package:free_indeed/Screens/MyStatsScreen/CloseCallsScreen.dart';
import 'package:free_indeed/Screens/MyStatsScreen/IRelapsedListScreen.dart';
import 'package:free_indeed/Screens/commons/BackButtonComponent.dart';
import 'package:free_indeed/configs/ScreenConfig.dart';
import 'package:free_indeed/configs/general_configs.dart';
import 'package:free_indeed/localization/localization.dart';

import '../commons/TabBarWidget.dart';

class MyStatsHomePage extends StatefulWidget {
  const MyStatsHomePage({Key? key}) : super(key: key);

  @override
  State<MyStatsHomePage> createState() => _MyStatsHomePageState();
}

class _MyStatsHomePageState extends State<MyStatsHomePage>
    with SingleTickerProviderStateMixin {
  late int _activeTabIndex = 0;
  late TabController _tabController;

  @override
  void initState() {
    _tabController =
        TabController(length: 3, vsync: this, animationDuration: Duration.zero);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
      } else {
        _setActiveTabIndex();
      }
    });
    super.initState();
  }

  void _setActiveTabIndex() {
    setState(() {
      _activeTabIndex = _tabController.index;
      // if (_activeTabIndex == 0) {
      //   // context.read<CommunityBloc>().add(CommunityEveryoneEvent());
      // } else if (_activeTabIndex == 1) {
      //   // context.read<CommunityBloc>().add(CommunityMyFriendsEvent());
      // } else {
      //   // context.read<CommunityBloc>().add(CommunityMineEvent());
      // }
      print("change tabBar Index to $_activeTabIndex");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GeneralConfigs.BACKGROUND_COLOR,
      appBar: AppBar(
        backgroundColor: GeneralConfigs.BACKGROUND_COLOR,
        leading: FreeIndeedBackButton(),
        centerTitle: true,
        title: Text(
          AppLocalization.of(context)!
              .getLocalizedText("i_relapsed_page_title_text"),
          style: TextStyle(fontSize: 16),
        ),
      ),
      body: SafeArea(
        child: Container(
          height: ScreenConfig.screenHeight,
          margin: EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            // shrinkWrap: true,
            children: [
              Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: GeneralConfigs.SECONDARY_COLOR.withOpacity(0.1),
                        border: Border.all(
                            color: GeneralConfigs.BLACK_BOARDER_COLOR,
                            width: 1),
                      ),
                      child: TabBar(
                        indicator: BoxDecoration(
                            color: GeneralConfigs.SECONDARY_COLOR),
                        indicatorColor: Colors.transparent,
                        tabs: [
                          TabBarWidget(
                            textKey: 'my_stats_home_page_first_tab',
                            color: _activeTabIndex == 0
                                ? GeneralConfigs.BACKGROUND_COLOR
                                : GeneralConfigs.SECONDARY_COLOR,
                          ),
                          TabBarWidget(
                            textKey: 'my_stats_home_page_second_tab',
                            color: _activeTabIndex == 1
                                ? GeneralConfigs.BACKGROUND_COLOR
                                : GeneralConfigs.SECONDARY_COLOR,
                          ),
                          TabBarWidget(
                            textKey: 'my_stats_home_page_third_tab',
                            color: _activeTabIndex == 2
                                ? GeneralConfigs.BACKGROUND_COLOR
                                : GeneralConfigs.SECONDARY_COLOR,
                          )
                        ],
                        controller: _tabController,
                      ),
                    ),
                  )),
              SizedBox(
                height: ScreenConfig.screenHeight - 230,
                child: TabBarView(controller: _tabController, children: [
                  SingleChildScrollView(child: MyStatsScreen()),
                  CloseCallsScreen(),
                  IRelapsedListPage(),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget getTab(BuildContext context, int index, String text,
      {bool? first, bool? last}) {
    return GestureDetector(
      onTap: () {
        _setActiveTabIndex();
      },
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: _activeTabIndex == index
              ? GeneralConfigs.SECONDARY_COLOR
              : GeneralConfigs.SECONDARY_COLOR.withOpacity(0.1),
          borderRadius: first != null && first
              ? BorderRadius.only(
                  topLeft: Radius.circular(10), bottomLeft: Radius.circular(10))
              : last != null && last
                  ? BorderRadius.only(
                      topRight: Radius.circular(10),
                      bottomRight: Radius.circular(10))
                  : BorderRadius.all(Radius.zero),
        ),
        width: ScreenConfig.screenWidth / 3 - 10,
        child: Tab(
          child: Text(
            AppLocalization.of(context)!.getLocalizedText(text),
            style: TextStyle(
                color: _activeTabIndex == index
                    ? GeneralConfigs.BACKGROUND_COLOR
                    : GeneralConfigs.SECONDARY_COLOR),
          ),
        ),
      ),
    );
  }
}
