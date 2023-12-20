import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:free_indeed/Blocs/CreateChatBloc/create_chat_bloc.dart';
import 'package:free_indeed/Managers/Implementation/named_navigator_impl.dart';
import 'package:free_indeed/Models/FriendsModel.dart';
import 'package:free_indeed/Repo/ChatsRepo.dart';
import 'package:free_indeed/Screens/ChatScreen/ShowFriendsList/CreateChatFriendTile.dart';
import 'package:free_indeed/Screens/ChatScreen/ShowFriendsList/FriendsChatListComponent.dart';
import 'package:free_indeed/Screens/commons/searchTextForm.dart';
import 'package:free_indeed/configs/general_configs.dart';
import 'package:free_indeed/localization/localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class CreateMessageScreen extends StatefulWidget {
  const CreateMessageScreen({Key? key}) : super(key: key);

  @override
  State<CreateMessageScreen> createState() => _CreateMessageScreenState();
}

class _CreateMessageScreenState extends State<CreateMessageScreen> {
  TextEditingController _searchController = TextEditingController();
  bool isSearch = false;
  List<FriendModel> friendsSearchList = [];

  PagingController<int, FriendModel> pagingController =
      PagingController(firstPageKey: 1);

  CreateChatBloc _createChatBloc = CreateChatBloc(
      chatsRepo: ChatsRepo(), namedNavigator: NamedNavigatorImpl());

  @override
  void initState() {
    _createChatBloc.add(CreateChatInitializeEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    EasyLoading.dismiss();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: GeneralConfigs.BACKGROUND_COLOR,
        leading: GestureDetector(
          onTap: () {
            if (isSearch) {
              setState(() {
                _searchController.text = "";
                isSearch = false;
              });
            } else {
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
      ),
      backgroundColor: GeneralConfigs.BACKGROUND_COLOR,
      body: BlocProvider(
        create: (context) {
          return _createChatBloc;
        },
        child: BlocBuilder<CreateChatBloc, CreateChatState>(
          builder: (context, state) {
            if (state is CreateChatReadyState) {
              return SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SearchTextForm(
                          labelKey: "message_screen_search",
                          controller: _searchController,
                          searchFunction: () {
                            if (_searchController.text.trim().isNotEmpty) {
                              friendsSearchList = [];
                              friendsSearchList = _createChatBloc.searchFriends(
                                  pagingController.itemList!,
                                  _searchController.text.trim());

                              setState(() {
                                isSearch = true;
                              });
                            }
                          }),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _createNewButtonTile(context, "createGroupIcon.svg",
                                "message_screen_create_message_create_group_chat",
                                () {
                              _addNewGroup(context);
                            }),
                            // createNewButtonTile(context, "addFriendChatIcon.svg",
                            //     "message_screen_create_message_add_friend_chat",
                            //     () {
                            //   addNewParticipant(context);
                            // }),
                          ],
                        ),
                      ),
                      isSearch
                          ? Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: ListView.builder(
                                itemCount: friendsSearchList.length,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  return CreateChatFriendTile(
                                    contact: friendsSearchList[index],
                                    selected: false,
                                    onTap: (FriendModel id) {
                                      _startNewChat(context, id);
                                    },
                                  );
                                },
                              ),
                            )
                          : Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: FriendsChatsInfiniteList(
                                  startChatWithFriend: (FriendModel id) {
                                    _startNewChat(context, id);
                                  },
                                  selectedFriends: [],
                                  fetchData: (int pageNumber) async {
                                    List<FriendModel> friends =
                                        await _createChatBloc
                                            .getNextFriends(pageNumber);
                                    final isLastPage = friends.length <
                                        GeneralConfigs.PAGE_LIMIT;
                                    if (isLastPage) {
                                      pagingController.appendLastPage(friends);
                                    } else {
                                      final nextPageKey = pageNumber + 1;
                                      pagingController.appendPage(
                                          friends, nextPageKey);
                                    }
                                  },
                                  pagingController: pagingController),
                            ),
                    ],
                  ),
                ),
              );
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }

  Widget _createNewButtonTile(
      BuildContext context, String iconPath, String textKey, Function onTap) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Row(
        children: [
          SvgPicture.asset(
            GeneralConfigs.ICONS_PATH + iconPath,
            width: 18,
            height: 18,
            color: Colors.white,
            fit: BoxFit.fill,
          ),
          SizedBox(
            width: 10,
          ),
          Text(
            AppLocalization.of(context)!.getLocalizedText(textKey),
            style: TextStyle(
                color: GeneralConfigs.SECONDARY_COLOR,
                fontSize: 16,
                fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  void _addNewGroup(BuildContext context) {
    _createChatBloc.add(CreateChatGoToNewGroupScreenEvent());
  }

  void _startNewChat(BuildContext context, FriendModel friend) {
    _createChatBloc.add(
        CreateChatStartChatScreenEvent(otherParticipant: friend.cognitoId!));
    print("startNewChat");
  }
}
