import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:free_indeed/Blocs/AddNewGroupBloc/add_new_group_bloc.dart';
import 'package:free_indeed/Managers/Implementation/named_navigator_impl.dart';
import 'package:free_indeed/Models/FriendsModel.dart';
import 'package:free_indeed/Repo/ChatsRepo.dart';
import 'package:free_indeed/Screens/ChatScreen/ShowFriendsList/FriendsChatListComponent.dart';
import 'package:free_indeed/Screens/commons/BackButtonComponent.dart';
import 'package:free_indeed/configs/ScreenConfig.dart';
import 'package:free_indeed/configs/general_configs.dart';
import 'package:free_indeed/localization/localization.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class AddNewGroupScreen extends StatefulWidget {
  const AddNewGroupScreen({Key? key}) : super(key: key);

  @override
  State<AddNewGroupScreen> createState() => _AddNewGroupScreenState();
}

class _AddNewGroupScreenState extends State<AddNewGroupScreen> {
  PagingController<int, FriendModel> pagingController =
      PagingController(firstPageKey: 1);

  List<FriendModel> selectedFriends = [];
  String? _groupName;
  FocusNode _focusNode = FocusNode();
  AddNewGroupBloc addNewGroupBloc = AddNewGroupBloc(
      chatsRepo: ChatsRepo(), namedNavigator: NamedNavigatorImpl());

  @override
  void initState() {
    addNewGroupBloc.add(AddNewGroupInitializeEvent());
    super.initState();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GeneralConfigs.BACKGROUND_COLOR,
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: GeneralConfigs.BACKGROUND_COLOR,
        leading: FreeIndeedBackButton(),
        title: Text(
          AppLocalization.of(context)!
              .getLocalizedText("add_new_group_screen_app_bar"),
          style: TextStyle(fontSize: 16),
        ),
      ),
      body: BlocProvider(
        create: (context) {
          return addNewGroupBloc;
        },
        child: BlocBuilder<AddNewGroupBloc, AddNewGroupState>(
          builder: (context, state) {
            if (state is AddNewGroupReadyState) {
              return SafeArea(
                child: SingleChildScrollView(
                  child: GestureDetector(
                    onTap: FocusScope.of(context).unfocus,
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 20),
                          child: TextFormField(
                            maxLines: 1,
                            focusNode: _focusNode,
                            style: TextStyle(
                                color: GeneralConfigs.SECONDARY_COLOR),
                            onChanged: (value) {
                              setState(() {
                                _groupName = value;
                              });
                            },
                            onEditingComplete: () {
                              _focusNode.unfocus();
                            },
                            onFieldSubmitted: (value) {
                              _focusNode.unfocus();
                            },
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.zero,
                              hintText: AppLocalization.of(context)!
                                  .getLocalizedText(
                                      "add_new_group_screen_group_name"),
                              hintStyle: TextStyle(
                                  color: GeneralConfigs.SECONDARY_COLOR
                                      .withOpacity(0.3)),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        selectedFriends.isEmpty
                            ? Container()
                            : Container(
                                width: ScreenConfig.screenWidth,
                                padding: EdgeInsets.symmetric(horizontal: 20.0),
                                child: GridView.builder(
                                  itemCount: selectedFriends.length,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                          childAspectRatio: 4 / 1,
                                          mainAxisSpacing: 8,
                                          crossAxisSpacing: 8),
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    return _friendTile(
                                      context: context,
                                      model: selectedFriends[index],
                                    );
                                  },
                                )),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: FriendsChatsInfiniteList(
                              startChatWithFriend: (FriendModel id) {
                                selectFriend(context, id);
                              },
                              selectedFriends: selectedFriends,
                              fetchData: (int pageNumber) async {
                                // context.read<AddNewGroupBloc>().add(
                                //     AddNewGroupGetNextFriendsEvent(
                                //         pageNumber: pageNumber));
                                // await Future.delayed(Duration(seconds: 1));
                                List<FriendModel> friends =
                                    await addNewGroupBloc
                                        .getNextFriends(pageNumber);
                                final isLastPage =
                                    friends.length < GeneralConfigs.PAGE_LIMIT;
                                if (isLastPage) {
                                  pagingController.appendLastPage(friends);
                                  pagingController.itemList!.toSet().toList();
                                } else {
                                  final nextPageKey = pageNumber + 1;
                                  pagingController.appendPage(
                                      friends, nextPageKey);
                                  pagingController.itemList!.toSet().toList();
                                }
                              },
                              pagingController: pagingController),
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        GestureDetector(
                          onTap: () {
                            startNewChat(context);
                          },
                          child: Container(
                            height: 48,
                            width: ScreenConfig.screenWidth / 3,
                            decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(24)),
                                border: Border.all(
                                    color: GeneralConfigs.SECONDARY_COLOR)),
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    AppLocalization.of(context)!.getLocalizedText(
                                        "add_new_group_screen_submit_button"),
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: GeneralConfigs.SECONDARY_COLOR),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
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

  Widget _friendTile(
      {required BuildContext context, required FriendModel model}) {
    return GestureDetector(
      onTap: () {
        selectFriend(context, model);
      },
      child: SizedBox(
        height: 48,
        child: Container(
          decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.all(Radius.circular(4)),
              border: Border.all(color: GeneralConfigs.BLACK_BOARDER_COLOR)),
          child: ListView(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Icon(
                  Icons.close,
                  color: GeneralConfigs.SECONDARY_COLOR,
                  size: 15,
                ),
              ),
              Center(
                child: Text(
                  model.username!,
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: GeneralConfigs.SECONDARY_COLOR),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void selectFriend(BuildContext context, FriendModel model) {
    // FocusScope.of(context).unfocus;
    setState(() {
      // FocusScope.of(context).unfocus;

      if (selectedFriends.contains(model)) {
        selectedFriends.remove(model);
      } else {
        selectedFriends.add(model);
      }
      print("selectFriend");
    });
  }

  void startNewChat(BuildContext context) {
    FocusScope.of(context).unfocus;
    if (_groupName == null || _groupName!.trim().isEmpty) {
      EasyLoading.showToast("Please write a valid group name");
    } else if (selectedFriends.isEmpty || selectedFriends.length == 1) {
      EasyLoading.showToast("Please select more than two or more friends");
    } else {
      addNewGroupBloc.add(AddNewGroupStartChatEvent(
          friends: selectedFriends, groupName: _groupName!));
    }
    print("startNewChat");
  }
}
