import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:free_indeed/Blocs/MessagingBloc/messaging_bloc.dart';
import 'package:free_indeed/Managers/Implementation/named_navigator_impl.dart';
import 'package:free_indeed/Models/MessagePreviewModel.dart';
import 'package:free_indeed/Repo/ChatsRepo.dart';
import 'package:free_indeed/Screens/MessagesScreen/MessageInfiniteList.dart';
import 'package:free_indeed/Screens/MessagesScreen/MessageTile.dart';
import 'package:free_indeed/Screens/commons/searchTextForm.dart';
import 'package:free_indeed/configs/ScreenConfig.dart';
import 'package:free_indeed/configs/general_configs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class MessagesPage extends StatefulWidget {
  const MessagesPage({Key? key}) : super(key: key);

  @override
  _MessagesPageState createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  TextEditingController _searchController = TextEditingController();
  PagingController<int, MessagePreviewModel> _pagingController =
      PagingController(firstPageKey: 1);

  MessagingBloc _messagingBloc = MessagingBloc(
      chatsRepo: ChatsRepo(), namedNavigator: NamedNavigatorImpl());

  @override
  void initState() {
    _messagingBloc.add(MessagingInitializeEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        return _messagingBloc;
      },
      child: BlocBuilder<MessagingBloc, MessagingState>(
        builder: (context, state) {
          if (state is MessagingReadyState) {
            if (state.refreshScreen) {
              if (_pagingController.itemList != null &&
                  _pagingController.itemList!.isNotEmpty) {
                _pagingController.itemList!.clear();
              }
              _pagingController.refresh();
            }
            return Scaffold(
              backgroundColor: GeneralConfigs.BACKGROUND_COLOR,
              body: SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SearchTextForm(
                          labelKey: "message_screen_search",
                          controller: _searchController,
                          searchFunction: () {
                            _searchChat();
                          }),
                      MessageInfiniteList(
                        fetchData: (int pageNumber) async {
                          List<MessagePreviewModel> kindaRelapses =
                              await _messagingBloc.getNextChats(pageNumber);
                          final isLastPage =
                              kindaRelapses.length < GeneralConfigs.PAGE_LIMIT;
                          if (isLastPage) {
                            _pagingController.appendLastPage(kindaRelapses);
                            _pagingController.itemList =
                                _pagingController.itemList?.toSet().toList();
                          } else {
                            final nextPageKey = pageNumber + 1;
                            _pagingController.appendPage(
                                kindaRelapses, nextPageKey);
                            _pagingController.itemList =
                                _pagingController.itemList?.toSet().toList();
                          }
                        },
                        pagingController: _pagingController,
                        openChat: (MessagePreviewModel model) {
                          _goToCertainChat(model);
                        },
                        deleteChat: (MessagePreviewModel message) {
                          _deleteIndividualChat(message);
                        },
                      )
                    ],
                  ),
                ),
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  _goToCreateMessage();
                },
                backgroundColor: GeneralConfigs.FLOATING_BUTTON_COLOR,
                child: SvgPicture.asset(
                  GeneralConfigs.ICONS_PATH + "addJournalIcon.svg",
                  width: 20,
                  height: 20,
                  color: Colors.white,
                  fit: BoxFit.fill,
                ),
              ),
            );
          } else if (state is MessagingSearchState) {
            return Scaffold(
              backgroundColor: GeneralConfigs.BACKGROUND_COLOR,
              body: SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SearchTextForm(
                          labelKey: "message_screen_search",
                          controller: _searchController,
                          searchFunction: () {
                            _searchChat();
                          }),
                      state.messages.isEmpty
                          ? SizedBox(
                              height: ScreenConfig.screenHeight / 2,
                              child: Center(
                                child: Text(
                                  "No items found",
                                  style: TextStyle(
                                      color: GeneralConfigs.SECONDARY_COLOR),
                                ),
                              ),
                            )
                          : Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: ListView.builder(
                                itemCount: state.messages.length,
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (BuildContext context, int index) {
                                  return ContactMessageTile(
                                    message: state.messages[index],
                                    onTap: () {
                                      _goToCertainChat(state.messages[index]);
                                    },
                                    deleteIndividualChat: () {
                                      _deleteIndividualChat(
                                          state.messages[index]);
                                    },
                                  );
                                },
                              ),
                            )
                    ],
                  ),
                ),
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  _goToCreateMessage();
                },
                backgroundColor: GeneralConfigs.FLOATING_BUTTON_COLOR,
                child: SvgPicture.asset(
                  GeneralConfigs.ICONS_PATH + "addJournalIcon.svg",
                  width: 20,
                  height: 20,
                  color: Colors.white,
                  fit: BoxFit.fill,
                ),
              ),
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }

  void _goToCreateMessage() {
    _messagingBloc.add(MessagingStartChatScreenEvent());
  }

  void _goToCertainChat(MessagePreviewModel message) {
    _messagingBloc
        .add(MessagingGoToIndividualChatScreenEvent(message: message));
  }

  void _deleteIndividualChat(MessagePreviewModel message) {
    _messagingBloc.add(MessagingDeleteChatEvent(message: message));
  }

  void _searchChat() {
    _messagingBloc.add(MessagingSearchScreenEvent(
      messagesList: _pagingController.itemList ?? [],
      searchTerm: _searchController.text,
    ));
    print("searchChat");
  }
}
