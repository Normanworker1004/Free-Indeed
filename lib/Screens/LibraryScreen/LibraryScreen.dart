import 'package:free_indeed/Blocs/LibraryBloc/library_bloc.dart';
import 'package:free_indeed/Managers/Implementation/named_navigator_impl.dart';
import 'package:free_indeed/Repo/library_repo.dart';
import 'package:free_indeed/Screens/LibraryScreen/BiblePage.dart';
import 'package:free_indeed/Screens/LibraryScreen/FellowIndeedScreen.dart';
import 'package:free_indeed/Screens/LibraryScreen/MoreScreen.dart';
import 'package:free_indeed/Screens/commons/LoadingState.dart';
import 'package:free_indeed/configs/ScreenConfig.dart';
import 'package:free_indeed/configs/general_configs.dart';
import 'package:free_indeed/localization/localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../commons/TabBarWidget.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({Key? key}) : super(key: key);

  @override
  _LibraryPageState createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage>
    with SingleTickerProviderStateMixin {
  late int _activeTabIndex = 1;
  late TabController _tabController;
  late ScrollController _bibleScrollController;

  late ScrollController _versesScrollController;

  LibraryBloc _libraryBloc = LibraryBloc(
      namedNavigator: NamedNavigatorImpl(), libraryRepo: BlogRepo());

  @override
  void initState() {
    _libraryBloc.add(LibraryInitialEvent());
    _bibleScrollController = ScrollController();
    _versesScrollController = ScrollController();

    _tabController = TabController(
        length: 3,
        vsync: this,
        animationDuration: Duration.zero,
        initialIndex: 1);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
      } else {
        _setActiveTabIndex();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _bibleScrollController.dispose();
    _versesScrollController.dispose();

    super.dispose();
  }

  void _setActiveTabIndex() {
    setState(() {
      _activeTabIndex = _tabController.index;
      if (_activeTabIndex == 0) {
        _libraryBloc.add(LibraryGetFreeIndeedBlogsEvent());
      } else if (_activeTabIndex == 1) {
        // context.read<CommunityBloc>().add(CommunityMyFriendsEvent());
      } else {
        _libraryBloc.add(LibraryGetMoreTabBlogsEvent());
      }
      print("change tabBar Index to $_activeTabIndex");
    });
  }

  // VerseModel verseOfTheDay = VerseModel(
  //     id: "0",
  //     verse:
  //         "“Honour thy father and thy mother: that thy days may be long upon the land which the LORD thy give three.”",
  //     shahed: "Proverbs 1:8 KJV",
  //     success: true);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) {
        return _libraryBloc;
      },
      child: BlocBuilder<LibraryBloc, LibraryState>(
        builder: (context, state) {
          if (state is LibraryReadyState) {
            return Scaffold(
              appBar: AppBar(
                centerTitle: true,
                automaticallyImplyLeading: false,
                backgroundColor: GeneralConfigs.BACKGROUND_COLOR,
                title: Text(
                  AppLocalization.of(context)!
                      .getLocalizedText("library_screen_title"),
                  style: TextStyle(fontSize: 16),
                ),
              ),
              backgroundColor: GeneralConfigs.BACKGROUND_COLOR,
              body: SafeArea(
                child: SizedBox(
                  height: ScreenConfig.screenHeight - 100,
                  // padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    // shrinkWrap: true,
                    // mainAxisAlignment: MainAxisAlignment.start,
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _libraryCategories(context),
                      SizedBox(
                        height: 10,
                      ),
                      Flexible(
                          child:
                              TabBarView(controller: _tabController, children: [
                        FellowIndeedTabScreen(
                          blogs: state.fellowIndeedBlogs,
                          libraryBloc: _libraryBloc,
                        ),
                        BibleScreen(
                          scrollController: _versesScrollController,

                          ///If we added a Verse of the day again just push it here ..
                          // verseOfTheDay: verseOfTheDay,
                        ),
                        SizedBox(
                          height: ScreenConfig.screenHeight,
                          child: MoreTabScreen(
                            blogs: state.moreBlogs,
                            libraryBloc: _libraryBloc,
                          ),
                        ),
                      ])),
                    ],
                  ),
                ),
              ),
            );
          } else if (state is LibraryLoadingState) {
            return LoadingState();
          } else {
            Container();
          }
          return Container();
        },
      ),
    );
  }

  Widget _libraryCategories(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: GeneralConfigs.SECONDARY_COLOR.withOpacity(0.1),
              border: Border.all(
                  color: GeneralConfigs.BLACK_BOARDER_COLOR, width: 1),
            ),
            child: TabBar(
              indicator: BoxDecoration(color: GeneralConfigs.SECONDARY_COLOR),
              indicatorColor: Colors.transparent,
              tabs: [
                TabBarWidget(
                  textKey: 'library_screen_first_tab',
                  color: _activeTabIndex == 0
                      ? GeneralConfigs.BACKGROUND_COLOR
                      : GeneralConfigs.SECONDARY_COLOR,
                ),
                TabBarWidget(
                  textKey: 'library_screen_second_tab',
                  color: _activeTabIndex == 1
                      ? GeneralConfigs.BACKGROUND_COLOR
                      : GeneralConfigs.SECONDARY_COLOR,
                ),
                TabBarWidget(
                  textKey: 'library_screen_third_tab',
                  color: _activeTabIndex == 2
                      ? GeneralConfigs.BACKGROUND_COLOR
                      : GeneralConfigs.SECONDARY_COLOR,
                )
              ],
              controller: _tabController,
            ),
          ),
        ));
  }
}
