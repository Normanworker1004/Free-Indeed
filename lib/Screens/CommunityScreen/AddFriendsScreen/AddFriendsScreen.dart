import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:free_indeed/Blocs/FriendsBloc/friends_bloc.dart';
import 'package:free_indeed/Managers/Implementation/named_navigator_impl.dart';
import 'package:free_indeed/Models/FriendsModel.dart';
import 'package:free_indeed/Repo/friendsRepo.dart';
import 'package:free_indeed/configs/ScreenConfig.dart';
import 'package:free_indeed/configs/general_configs.dart';
import 'package:free_indeed/localization/localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import 'FriendsListComponent.dart';

class AddFriendsScreen extends StatefulWidget {
  const AddFriendsScreen({Key? key}) : super(key: key);

  @override
  _AddFriendsScreenState createState() => _AddFriendsScreenState();
}

class _AddFriendsScreenState extends State<AddFriendsScreen> {
  final PagingController<int, FriendModel> _pagingController =
      PagingController(firstPageKey: 1);
  PagingController<int, FriendModel> _friendsOnlyPagingController =
      PagingController(firstPageKey: 1);
  PagingController<int, FriendModel> _searchPagingController =
      PagingController(firstPageKey: 1);

  List<FriendModel> friends = [];
  String accessToken = "";
  bool initialized = true;
  bool isSearch = false;
  FriendsBloc friendsBloc = FriendsBloc(
      namedNavigator: NamedNavigatorImpl(), friendsRepo: FriendsRepo());

  // bool isFriendsOnly = false;

  @override
  void dispose() {
    _pagingController.dispose();
    _searchPagingController.dispose();
    _friendsOnlyPagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GeneralConfigs.BACKGROUND_COLOR,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: GeneralConfigs.BACKGROUND_COLOR,
        leading: GestureDetector(
          onTap: () {
            if (isSearch) {
              setState(() {
                isSearch = false;
              });
            } else if (!isSearch) {
              Navigator.pop(context);
            }
          },
          child: Row(children: [
            SizedBox(
                width: 24,
                child: Icon(
                  Icons.arrow_back_ios_new,
                  color: GeneralConfigs.SECONDARY_COLOR,
                )),
            Text("Back",
                style: TextStyle(
                    fontSize: 14, color: GeneralConfigs.SECONDARY_COLOR)),
          ]),
        ),
        centerTitle: true,
        title: Text(
          "",
          style: TextStyle(fontSize: 16),
        ),
      ),
      body: BlocProvider(
        create: (context) {
          return friendsBloc;
        },
        child: BlocBuilder<FriendsBloc, FriendsState>(
          builder: (context, state) {
            if (initialized) {
              context.read<FriendsBloc>().add(FriendsInitializeEvent());
              initialized = false;
            }
            if (state is FriendsReadyState) {
              if (!isSearch) {
                return Column(
                  children: [
                    tabBarWidget(context),
                    searchWidget(context),
                    Container(
                        height: 2 * ScreenConfig.screenHeight / 3,
                        padding: EdgeInsets.only(left: 20, right: 20),
                        child: FriendsInfiniteList(
                          pagingController: _pagingController,
                          fetchData: (int pageNumber) async {
                            // context.read<FriendsBloc>().add(
                            //     GetNextFriendsEvent(pageNumber: pageNumber));
                            // await Future.delayed(Duration(seconds: 1));
                            List<FriendModel> newFriendsList =
                                await friendsBloc.getNextUsers(pageNumber);
                            final isLastPage = newFriendsList.length <
                                GeneralConfigs.PAGE_LIMIT;
                            if (isLastPage) {
                              _pagingController.appendLastPage(newFriendsList);
                            } else {
                              final nextPageKey = pageNumber + 1;
                              _pagingController.appendPage(
                                  newFriendsList, nextPageKey);
                            }
                          },
                          addFriend: (FriendModel cognitoId) {
                            addFriend(context, cognitoId);
                          },
                        )),
                  ],
                );
              } else {
                return Container(
                  padding: EdgeInsets.zero,
                  child: Column(
                    children: [
                      tabBarWidget(context),
                      searchWidget(context),
                      Container(
                          height: 2 * ScreenConfig.screenHeight / 3,
                          padding: EdgeInsets.only(left: 20, right: 20),
                          child: FriendsInfiniteList(
                            pagingController: _searchPagingController,
                            fetchData: (int pageNumber) async {
                              context.read<FriendsBloc>().add(
                                  GetNextSearchEvent(pageNumber: pageNumber));
                              await Future.delayed(Duration(seconds: 1));
                              final isLastPage = state.newFriendsList.length <
                                  GeneralConfigs.PAGE_LIMIT;
                              if (isLastPage) {
                                _searchPagingController
                                    .appendLastPage(state.newFriendsList);
                              } else {
                                final nextPageKey = pageNumber + 1;
                                _searchPagingController.appendPage(
                                    state.newFriendsList, nextPageKey);
                              }
                            },
                            addFriend: (FriendModel cognitoId) {
                              addFriend(context, cognitoId);
                            },
                          )),
                    ],
                  ),
                );
              }
            } else if (state is FriendsFriendsOnlyReadyState) {
              return Column(
                children: [
                  tabBarWidget(context),
                  Padding(
                    padding: const EdgeInsets.all(0),
                    child: Container(
                        height: 2 * ScreenConfig.screenHeight / 3,
                        padding: EdgeInsets.only(left: 20, right: 20),
                        child: FriendsInfiniteList(
                          pagingController: _friendsOnlyPagingController,
                          fetchData: (int pageNumber) async {
                            // context.read<FriendsBloc>().add(
                            //     GetNextFriendsOnlyEvent(pageNumber: pageNumber));
                            // await Future.delayed(Duration(seconds: 1));
                            List<FriendModel> newFriendsList =
                                await friendsBloc.getNextFriends(pageNumber);
                            final isLastPage = newFriendsList.length <
                                GeneralConfigs.PAGE_LIMIT;
                            if (isLastPage) {
                              _friendsOnlyPagingController
                                  .appendLastPage(newFriendsList);
                            } else {
                              final nextPageKey = pageNumber + 1;
                              _friendsOnlyPagingController.appendPage(
                                  newFriendsList, nextPageKey);
                            }
                          },
                          addFriend: (FriendModel cognitoId) {
                            addFriend(context, cognitoId);
                          },
                        )),
                  ),
                ],
              );
            } else if (state is FriendsInitial) {
              return Column(
                children: [
                  tabBarWidget(context),
                ],
              );
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }

  String _searchWord = "";

  Widget searchWidget(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 10, right: 10, top: 10),
      child: TextFormField(
        style: TextStyle(fontSize: 17, color: GeneralConfigs.SECONDARY_COLOR),
        decoration: InputDecoration(
          suffixIcon: SvgPicture.asset(
            GeneralConfigs.ICONS_PATH + "searchIcon.svg",
            width: 10,
            height: 10,
            fit: BoxFit.scaleDown,
          ),
          // contentPadding:
          //     EdgeInsets.only(top: 10,left: 10),
          hintText: AppLocalization.of(context)!
              .getLocalizedText("add_friends_page_search_hint"),
          hintStyle: TextStyle(color: GeneralConfigs.SECONDARY_COLOR),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent),
            // borderRadius:  BorderRadius.circular(25.7),
          ),
          disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent),
            // borderRadius:  BorderRadius.circular(25.7),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent),
            // borderRadius:  BorderRadius.circular(25.7),
          ),
        ),
        cursorColor: GeneralConfigs.SECONDARY_COLOR,
        initialValue: _searchWord,
        validator: (value) {
          return null;
        },
        onChanged: (val) {
          _searchWord = val;
        },
        onFieldSubmitted: (val) {
          if (val.isNotEmpty) {
            search(context, val);
          }
        },
      ),
    );
  }

  late int _activeTabIndex = 0;

  void _setActiveTabIndex(BuildContext context, int index) {
    setState(() {
      _activeTabIndex = index;
      if (_activeTabIndex == 0) {
        // isFriendsOnly = false;

        context.read<FriendsBloc>().add(FriendsInitializeEvent());
      } else if (_activeTabIndex == 1) {
        // isFriendsOnly = true;
        context.read<FriendsBloc>().add(FriendsInitializeMyFriendsEvent());
      } else {
        // context.read<CommunityBloc>().add(CommunityMineEvent());
      }
      print("change tabBar Index to $_activeTabIndex");
    });
  }

  Widget tabBarWidget(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          getTab(context, 0, "add_friends_page_title", first: true),
          getTab(context, 1, "add_friends_page_my_friends_tile", last: true),
        ],
      ),
    );
  }

  Widget getTab(BuildContext context, int index, String text,
      {bool? first, bool? last}) {
    return GestureDetector(
      onTap: () {
        _setActiveTabIndex(context, index);
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

  void addFriend(BuildContext context, FriendModel cognitoId) async {
    context.read<FriendsBloc>().add(AddFriendEvent(friendId: cognitoId));
    print(cognitoId);
  }

  void search(BuildContext context, String friendName) {
    context.read<FriendsBloc>().add(SearchFriendsEvent(friendName: friendName));
    _searchPagingController.dispose();
    _searchPagingController = PagingController(firstPageKey: 2);
    isSearch = true;
    print("Search Function");
  }
}
