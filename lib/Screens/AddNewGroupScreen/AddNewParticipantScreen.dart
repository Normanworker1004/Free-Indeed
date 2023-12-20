import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:free_indeed/Blocs/AddNewGroupBloc/add_new_group_bloc.dart';
import 'package:free_indeed/Managers/Implementation/named_navigator_impl.dart';
import 'package:free_indeed/Models/FriendsModel.dart';
import 'package:free_indeed/Repo/ChatsRepo.dart';
import 'package:free_indeed/Screens/ChatScreen/ShowFriendsList/FriendsChatListComponent.dart';
import 'package:free_indeed/configs/general_configs.dart';
import 'package:free_indeed/localization/localization.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class AddNewParticipantScreen extends StatefulWidget {
  final String chatId;

  const AddNewParticipantScreen({Key? key, required this.chatId})
      : super(key: key);

  @override
  State<AddNewParticipantScreen> createState() =>
      _AddNewParticipantScreenState();
}

class _AddNewParticipantScreenState extends State<AddNewParticipantScreen> {
  bool initialized = true;

  PagingController<int, FriendModel> pagingController =
      PagingController(firstPageKey: 1);

  List<FriendModel> selectedFriends = [];
  AddNewGroupBloc addNewGroupBloc = AddNewGroupBloc(
      chatsRepo: ChatsRepo(), namedNavigator: NamedNavigatorImpl());

  @override
  void initState() {
    addNewGroupBloc.add(AddNewGroupInitializeEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GeneralConfigs.BACKGROUND_COLOR,
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: GeneralConfigs.BACKGROUND_COLOR,
        leading: BackButton(
          onPressed: () {
            Navigator.pop(context);
          },
        ),
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
                  child: Column(
                    children: [
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                              List<FriendModel> friends = await addNewGroupBloc
                                  .getNextFriends(pageNumber);
                              final isLastPage =
                                  friends.length < GeneralConfigs.PAGE_LIMIT;
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
                      SizedBox(
                        height: 50,
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

  void selectFriend(BuildContext context, FriendModel model) {
    addNewGroupBloc.add(
        AddNewParticipantToChatEvent(friends: model, chatId: widget.chatId));
  }
}
