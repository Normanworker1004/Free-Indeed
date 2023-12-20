import 'package:free_indeed/Blocs/CommunityBloc/community_bloc.dart';
import 'package:free_indeed/Managers/Implementation/named_navigator_impl.dart';
import 'package:free_indeed/Models/NotificationModel.dart';
import 'package:free_indeed/Models/PostModel.dart';
import 'package:free_indeed/Models/UserModel.dart';
import 'package:free_indeed/Repo/community_repo.dart';
import 'package:free_indeed/Repo/friendsRepo.dart';
import 'package:free_indeed/Repo/login_repo.dart';
import 'package:free_indeed/Screens/CommunityScreen/NotificationMenu/NotificationButton.dart';
import 'package:free_indeed/Screens/CommunityScreen/PostListComponent.dart';
import 'package:free_indeed/configs/ScreenConfig.dart';
import 'package:free_indeed/configs/general_configs.dart';
import 'package:free_indeed/localization/localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../commons/TabBarWidget.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({Key? key}) : super(key: key);

  @override
  _CommunityScreenState createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen>
    with SingleTickerProviderStateMixin {
  PagingController<int, PostModel> _pagingController =
      PagingController(firstPageKey: 1);

  PagingController<int, PostModel> _friendsPagingController =
      PagingController(firstPageKey: 1);
  PagingController<int, PostModel> _minePagingController =
      PagingController(firstPageKey: 1);
  PagingController<int, NotificationModel> _notificationPagingController =
      PagingController(firstPageKey: 1);
  int _activeTabIndex = 0;
  late TabController _tabController;

  void _setActiveTabIndex() {
    setState(() {
      _activeTabIndex = _tabController.index;
      print("change tabBar Index to $_activeTabIndex");
    });
  }

  CommunityBloc _communityBloc = CommunityBloc(
      loginRepo: LoginRepo(),
      friendsRepo: FriendsRepo(),
      namedNavigator: NamedNavigatorImpl(),
      communityRepo: CommunityRepo());

  @override
  void initState() {
    _communityBloc.add(CommunityInitialEvent());
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

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (BuildContext context) {
      return _communityBloc;
    }, child:
        BlocBuilder<CommunityBloc, CommunityState>(builder: (context, state) {
      if (state is CommunityInitial) {
        _activeTabIndex = 0;
        return Scaffold(
          backgroundColor: GeneralConfigs.BACKGROUND_COLOR,
          body: SafeArea(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
            ),
          ),
        );
      } else if (state is CommunityReadyState) {
        if (state.refreshData) {
          if (_activeTabIndex == 0) {
            _pagingController = PagingController(firstPageKey: 1);
          } else if (_activeTabIndex == 1) {
            _friendsPagingController = PagingController(firstPageKey: 1);
          } else {
            _pagingController = PagingController(firstPageKey: 1);
            _minePagingController = PagingController(firstPageKey: 1);
          }
        }
        if (state.changePostDetails != null && state.changePostDetails!) {
          _pagingController.itemList = state.everyonePosts;
          _friendsPagingController.itemList = state.friendsPosts;
          _minePagingController.itemList = state.myPosts;
        }
        return Scaffold(
          backgroundColor: GeneralConfigs.BACKGROUND_COLOR,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 10, bottom: 5, left: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            AppLocalization.of(context)!
                                .getLocalizedText("community_page_welcome_text")
                                .replaceAll("[@]", state.user.username!),
                            style: TextStyle(
                                color: GeneralConfigs.SECONDARY_COLOR, fontSize: 15),
                          ),
                          _topIcons(context, state.user),
                        ],
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              color: GeneralConfigs.SECONDARY_COLOR
                                  .withOpacity(0.1),
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
                                  textKey: 'community_page_tab_one_text',
                                  color: _activeTabIndex == 0
                                      ? GeneralConfigs.BACKGROUND_COLOR
                                      : GeneralConfigs.SECONDARY_COLOR,
                                ),
                                TabBarWidget(
                                  textKey: 'community_page_tab_two_text',
                                  color: _activeTabIndex == 1
                                      ? GeneralConfigs.BACKGROUND_COLOR
                                      : GeneralConfigs.SECONDARY_COLOR,
                                ),
                                TabBarWidget(
                                  textKey: 'community_page_tab_three_text',
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
                      height: ScreenConfig.screenHeight,
                      child: TabBarView(controller: _tabController, children: [
                        PostInfiniteList(
                            communityBloc: _communityBloc,
                            fetchData: (int pageNumber) async {
                              await _fetchEveryoneData(pageNumber);
                            },
                            isPostDetails: false,
                            openComments: (PostModel item, int index) {
                              _openComments(item, index);
                            },
                            activeTabIndex: _activeTabIndex,
                            editPostFunction: (String id, String postText) {
                              _editPost(id.toString(), postText);
                            },
                            pagingController: _pagingController),
                        PostInfiniteList(
                            communityBloc: _communityBloc,
                            fetchData: (int pageNumber) async {
                              await _fetchFriendsData(pageNumber);
                            },
                            isPostDetails: false,
                            openComments: (PostModel item, int index) {
                              _openComments(item, index);
                            },
                            activeTabIndex: _activeTabIndex,
                            editPostFunction: (String id, String postText) {
                              _editPost(id.toString(), postText);
                            },
                            pagingController: _friendsPagingController),
                        PostInfiniteList(
                            communityBloc: _communityBloc,
                            fetchData: (int pageNumber) async {
                              await _fetchMineData(pageNumber);
                            },
                            isPostDetails: false,
                            openComments: (PostModel item, int index) {
                              _openComments(item, index);
                            },
                            activeTabIndex: _activeTabIndex,
                            editPostFunction: (String id, String postText) {
                              _editPost(id.toString(), postText);
                            },
                            pagingController: _minePagingController),
                      ]),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      } else if (state is CommunityLoadingState) {
        return Scaffold(
          backgroundColor: GeneralConfigs.BACKGROUND_COLOR,
          body: SafeArea(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                // shrinkWrap: true,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 20, bottom: 5, left: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppLocalization.of(context)!
                              .getLocalizedText("community_page_welcome_text")
                              .replaceAll("[@]", state.user.username!),
                          style: TextStyle(
                              color: GeneralConfigs.SECONDARY_COLOR, fontSize: 15),
                        ),
                        _topIcons(context, state.user),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      } else {
        return Container();
      }
    }));
  }

  Future<void> _fetchEveryoneData(int pageNumber) async {
    List<PostModel> posts =
        await _communityBloc.getNextEveryonePage(pageNumber);
    final isLastPage = posts.length < GeneralConfigs.PAGE_LIMIT;
    if (isLastPage) {
      _pagingController.appendLastPage(posts);
    } else {
      final nextPageKey = pageNumber + 1;
      _pagingController.appendPage(posts, nextPageKey);
    }
  }

  Future<void> _fetchMineData(int pageNumber) async {
    List<PostModel> posts = await _communityBloc.getNextMinePage(pageNumber);
    final isLastPage = posts.length < GeneralConfigs.PAGE_LIMIT;
    if (isLastPage) {
      _minePagingController.appendLastPage(posts);
    } else {
      final nextPageKey = pageNumber + 1;
      _minePagingController.appendPage(posts, nextPageKey);
    }
  }

  Future<void> _fetchFriendsData(int pageNumber) async {
    List<PostModel> posts = await _communityBloc.getNextFriendsPage(pageNumber);
    final isLastPage = posts.length < GeneralConfigs.PAGE_LIMIT;
    if (isLastPage) {
      _friendsPagingController.appendLastPage(posts);
    } else {
      final nextPageKey = pageNumber + 1;
      _friendsPagingController.appendPage(posts, nextPageKey);
    }
  }

  Future<void> _fetchNotificationData(int pageNumber) async {
    List<NotificationModel> notifications =
        await _communityBloc.getNextNotificationPage(pageNumber);
    final isLastPage = notifications.length < GeneralConfigs.PAGE_LIMIT;
    if (isLastPage) {
      _notificationPagingController.appendLastPage(notifications);
    } else {
      final nextPageKey = pageNumber + 1;
      _notificationPagingController.appendPage(notifications, nextPageKey);
    }
  }

  Widget _topIcons(BuildContext context, UserModel userModel) {
    return Row(
      children: [
        NotificationButton(
            pagingController: _notificationPagingController,
            fetchData: (int pageNumber) async {
              await _fetchNotificationData(pageNumber);
            },
            hasNotifications: userModel.hasNotifications!),
        _getIcon("addFriendIcon.svg", _addFriends),
        _getIcon("addPostIcon.svg", _addPost),
        // GestureDetector(
        //   onTap: () {
        //     changeLanguage(context);
        //   },
        //   child: Text(
        //     AppLocalization.of(context)!
        //         .getLocalizedText("community_page_change_language_text"),
        //     style: TextStyle(color: Colors.white),
        //   ),
        // ),
      ],
    );
  }

  Widget _getIcon(String iconPath, Function onTap) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5),
      child: GestureDetector(
        onTap: () {
          onTap();
        },
        child: SvgPicture.asset(
          GeneralConfigs.ICONS_PATH + iconPath,
          height: 24,
          width: 24,
          color: GeneralConfigs.SECONDARY_COLOR,
          fit: BoxFit.scaleDown,
        ),
      ),
    );
  }

  void _openComments(PostModel post, int index) {
    _communityBloc.add(CommunityGoToCommentsEvent(
        post: post,
        activeIndex: _activeTabIndex,
        everyonePosts: _pagingController.itemList,
        friendsPosts: _friendsPagingController.itemList,
        postIndex: index,
        myPosts: _minePagingController.itemList));
  }

  void _addFriends() {
    print("open addFriends Function");
    _communityBloc.add(CommunityOpenFriendsEvent());
  }

  void _addPost() {
    _communityBloc.add(CommunityAddPostEvent());
    print("open addPost Function");
  }

  void _editPost(String postId, String newText) {
    _communityBloc.add(CommunityEditPostEvent(
        postId: postId,
        oldText: newText,
        activeIndex: _activeTabIndex,
        everyonePosts: _pagingController.itemList,
        friendsPosts: _friendsPagingController.itemList,
        myPosts: _minePagingController.itemList));
    print("open editPost Function");
  }
// void _changeLanguage(BuildContext context) {
//   if (AppLocalization.of(context)!.currentLanguage ==
//       AppLanguage.ENGLISH.code) {
//     LocalDataManagerImpl()
//         .writeData(CachingKey.APP_LANGUAGE, AppLanguage.ARABIC.code);
//   } else {
//     LocalDataManagerImpl()
//         .writeData(CachingKey.APP_LANGUAGE, AppLanguage.ENGLISH.code);
//   }
//   Phoenix.rebirth(context);
// }
}
