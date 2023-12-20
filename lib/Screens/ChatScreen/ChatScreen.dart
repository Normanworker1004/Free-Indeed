import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:free_indeed/Blocs/ChatBottomSheetBloc/chat_bottom_sheet_bloc.dart';
import 'package:free_indeed/Managers/Implementation/named_navigator_impl.dart';
import 'package:free_indeed/Models/ParticipantModel.dart';
import 'package:free_indeed/Models/UserModel.dart';
import 'package:free_indeed/Repo/ChatsRepo.dart';
import 'package:free_indeed/Repo/FirebaseRepo.dart';
import 'package:free_indeed/Screens/commons/BackButtonComponent.dart';
import 'package:free_indeed/configs/Config.dart';
import 'package:free_indeed/configs/ScreenConfig.dart';
import 'package:free_indeed/configs/general_configs.dart';
import 'package:free_indeed/localization/localization.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../../Models/ChatCreatedModel.dart';
import '../../Models/ChatModel.dart';

class ChatScreenArgs {
  final ChatCreatedModel chatCreatedModel;
  final UserModel userModel;

  ChatScreenArgs({
    required this.chatCreatedModel,
    required this.userModel,
  });
}

class ChatScreen extends StatefulWidget {
  final ChatScreenArgs chatScreenArgs;

  const ChatScreen({Key? key, required this.chatScreenArgs}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

bool initialize = true;

class _ChatScreenState extends State<ChatScreen> {
  ChatsRepo _chatsRepo = ChatsRepo();

  TextEditingController textEditingController = TextEditingController();
  FocusNode focusNode = FocusNode();

  late var listMessages;

  ScrollController scrollController = ScrollController();
  String newGroupName = "";

  @override
  void initState() {
    newGroupName = widget.chatScreenArgs.chatCreatedModel.displayName!;
    super.initState();
  }

  @override
  void dispose() {
    focusNode.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    EasyLoading.dismiss();
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: GeneralConfigs.BACKGROUND_COLOR,
          leading: FreeIndeedBackButton(),
          centerTitle: true,
          title: Text(
            newGroupName,
            style: TextStyle(fontSize: 16),
          ),
          actions: <Widget>[
            widget.chatScreenArgs.chatCreatedModel.isGroup!
                ? IconButton(
                    icon: Icon(
                      Icons.more_vert,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      openActionSheet(context);
                    },
                  )
                : Container()
          ],
        ),
        body: SafeArea(
            child: Stack(
                // crossAxisAlignment: CrossAxisAlignment.end,
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
              buildListMessage(context),
              Align(
                  alignment: Alignment.bottomCenter,
                  child: buildMessageInput(context))
            ])));
  }

  Widget buildListMessage(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      onPanUpdate: (details) {
        if (details.delta.dx > 0) {
          FocusScope.of(context).unfocus();
        }
      },
      child: Container(
        padding: EdgeInsets.only(bottom: 50),
        child: widget.chatScreenArgs.chatCreatedModel.id!.isNotEmpty
            ? StreamBuilder<QuerySnapshot>(
                stream: FirebaseRepo().getChatMessage(
                    widget.chatScreenArgs.chatCreatedModel.id!, 20),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData) {
                    listMessages = snapshot.data!.docs;
                    if (listMessages.isNotEmpty) {
                      return SizedBox(
                          height: ScreenConfig.screenHeight,
                          child: ListView.builder(
                            padding: const EdgeInsets.all(2),
                            controller: scrollController,
                            itemCount: snapshot.data?.docs.length,
                            shrinkWrap: true,
                            reverse: true,
                            itemBuilder: (context, index) {
                              return buildItem(
                                  index, snapshot.data?.docs[index], context);
                            },
                          ));
                    } else {
                      return Center(
                        child: Text(
                          '',
                          style:
                              TextStyle(color: GeneralConfigs.SECONDARY_COLOR),
                        ),
                      );
                    }
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: GeneralConfigs.SECONDARY_COLOR,
                      ),
                    );
                  }
                })
            : const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              ),
      ),
    );
  }

  Widget buildItem(
      int index, DocumentSnapshot? documentSnapshot, BuildContext context) {
    if (documentSnapshot != null) {
      ChatMessages chatMessages = ChatMessages.fromDocument(documentSnapshot);
      return Column(
        crossAxisAlignment: chatMessages.idFrom.compareTo(
                    widget.chatScreenArgs.chatCreatedModel.participantFrom!) ==
                0
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: chatMessages.idFrom.compareTo(widget
                        .chatScreenArgs.chatCreatedModel.participantFrom!) ==
                    0
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            children: [
              chatMessages.type == MessageType.LAST_MESSAGE.value
                  ? Container()
                  : messageBubble(
                      chatMessage: chatMessages,
                      context: context,
                    ),
            ],
          ),
          chatMessages.type == MessageType.LAST_MESSAGE.value
              ? Container()
              : Container(
                  margin: const EdgeInsets.only(
                      left: 5, right: 5, top: 6, bottom: 8),
                  child: Text(
                    DateFormat('MM/dd/yy HH:mm').format(
                      DateTime.fromMillisecondsSinceEpoch(
                        int.parse(chatMessages.timestamp),
                      ),
                    ),
                    style: const TextStyle(
                      color: GeneralConfigs.SECONDARY_COLOR,
                      fontSize: 10,
                    ),
                  ),
                ),
        ],
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget buildMessageInput(BuildContext context) {
    return Container(
      color: GeneralConfigs.BACKGROUND_COLOR,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 6 * ScreenConfig.screenWidth / 7,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: TextFormField(
                focusNode: focusNode,
                textInputAction: TextInputAction.send,
                maxLines: null,
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.sentences,
                // decoration: InputDecoration(),
                controller: textEditingController,
                cursorColor: GeneralConfigs.SECONDARY_COLOR,
                style: TextStyle(color: GeneralConfigs.SECONDARY_COLOR),
                decoration: InputDecoration.collapsed(
                    border: InputBorder.none,
                    hintText: 'Type here..',
                    hintStyle:
                        TextStyle(color: GeneralConfigs.SECONDARY_COLOR)),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 4),
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(30),
            ),
            child: IconButton(
              onPressed: () {
                onSendMessage(textEditingController.text, MessageType.TEXT);
              },
              icon: const Icon(Icons.send_rounded),
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  void onSendMessage(String content, MessageType type) {
    if (content.trim().isNotEmpty) {
      textEditingController.clear();
      FirebaseRepo().sendChatMessage(
          content,
          MessageType.TEXT.value,
          widget.chatScreenArgs.chatCreatedModel.id!,
          widget.chatScreenArgs.chatCreatedModel.participantFrom!,
          widget.chatScreenArgs.chatCreatedModel.participantTo!);
      // FirebaseRepo().saveLastMessage(
      //     content,
      //     MessageType.LAST_MESSAGE.value,
      //     widget.chatScreenArgs.chatCreatedModel.id!,
      //     widget.chatScreenArgs.chatCreatedModel.participantFrom!,
      //     widget.chatScreenArgs.chatCreatedModel.participantTo!);
      _chatsRepo.addLastMessage("", widget.chatScreenArgs.chatCreatedModel.id!,
          content, widget.chatScreenArgs.chatCreatedModel.participantFrom!);
      scrollController.animateTo(0,
          duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
    } else {
      EasyLoading.showToast('Nothing to send');
    }
  }

  Widget messageBubble(
      {required ChatMessages chatMessage, required BuildContext context}) {
    String participantName = "";
    bool isLongText = (double.parse((TextPainter(
          textDirection: AppLocalization.layoutDirection,
          text: TextSpan(text: chatMessage.content),
          maxLines: 1,
          textScaleFactor: MediaQuery.of(context).textScaleFactor,
        )..layout())
            .size
            .width
            .toString()) >
        (3 * ScreenConfig.screenWidth / 4));
    if (chatMessage.idFrom.compareTo(
            widget.chatScreenArgs.chatCreatedModel.participantFrom!) ==
        0) {
      participantName = "You";
    } else if (widget.chatScreenArgs.chatCreatedModel.isGroup! &&
        widget.chatScreenArgs.chatCreatedModel.groupParticipants != null) {
      for (int i = 0;
          i < widget.chatScreenArgs.chatCreatedModel.groupParticipants!.length;
          i++) {
        if (chatMessage.idFrom.compareTo(widget.chatScreenArgs.chatCreatedModel
                .groupParticipants![i].cognitoId!) ==
            0) {
          participantName = widget
              .chatScreenArgs.chatCreatedModel.groupParticipants![i].userName!;
        }
      }
    }
    return widget.chatScreenArgs.chatCreatedModel.isGroup! &&
            widget.chatScreenArgs.chatCreatedModel.groupParticipants != null
        ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    participantName,
                    style: TextStyle(
                        color:
                            GeneralConfigs.CHAT_BUBBLE_PARTICIPANT_NAME_COLOR,
                        fontSize: 14),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      color: GeneralConfigs.CHAT_BUBBLE_BACKGROUND_COLOR,
                      borderRadius: BorderRadius.all(
                        Radius.circular(6),
                      )),
                  padding: EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                  child: SizedBox(
                    width: isLongText ? 3 * ScreenConfig.screenWidth / 4 : null,
                    child: Text(
                      chatMessage.content,
                      maxLines: null,
                      style: TextStyle(
                          color: GeneralConfigs.SETTINGS_TILE_BACKGROUND_COLOR),
                    ),
                  ),
                )
              ],
            ),
          )
        : Container(
            decoration: BoxDecoration(
                color: GeneralConfigs.CHAT_BUBBLE_BACKGROUND_COLOR,
                borderRadius: BorderRadius.all(
                  Radius.circular(6),
                )),
            padding: EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            child: SizedBox(
              width: isLongText ? 3 * ScreenConfig.screenWidth / 4 : null,
              child: Text(
                chatMessage.content,
                maxLines: null,
                style: TextStyle(
                    color: GeneralConfigs.SETTINGS_TILE_BACKGROUND_COLOR),
              ),
            ),
          );
  }

  void openActionSheet(BuildContext context) {
    showCupertinoModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => BlocProvider(
        create: (context) {
          return ChatBottomSheetBloc(
              namedNavigator: NamedNavigatorImpl(), chatsRepo: ChatsRepo());
        },
        child: BlocBuilder<ChatBottomSheetBloc, ChatBottomSheetState>(
          builder: (context, state) {
            return GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                width: ScreenConfig.screenWidth,
                height: ScreenConfig.screenHeight,
                color: Colors.black.withOpacity(0.3),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                            color: GeneralConfigs
                                .COMMUNITY_BOTTOM_SHEET_CARD_BACKGROUND_COLOR,
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          child: Column(
                            children: [
                              Container(
                                height: 50,
                                width: ScreenConfig.screenWidth,
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: ListTile(
                                  subtitle: SizedBox(
                                    height: 60,
                                    width: ScreenConfig.screenWidth,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(
                                          width: ScreenConfig.screenWidth / 2,
                                          child: TextFormField(
                                            initialValue: newGroupName,
                                            decoration: InputDecoration(
                                              enabledBorder:
                                                  UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors
                                                        .black), //<-- SEE HERE
                                              ),
                                              focusedBorder:
                                                  UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: GeneralConfigs
                                                        .BACKGROUND_COLOR
                                                        .withOpacity(
                                                            0.3)), //<-- SEE HERE
                                              ),
                                            ),
                                            onChanged: (value) {
                                              newGroupName = value;
                                            },
                                            onEditingComplete: () {
                                              editGroupName(context);
                                            },
                                            cursorColor: Colors.black,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                        SvgPicture.asset(
                                          GeneralConfigs.ICONS_PATH +
                                              "editPostIcon.svg",
                                          // color: Colors.black,
                                          width: 20,
                                          height: 20,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Divider(
                                thickness: 1,
                                color: GeneralConfigs
                                    .COMMUNITY_BOTTOM_SHEET_CARD_DIVIDER_COLOR,
                              ),
                              ListView.builder(
                                itemCount: widget.chatScreenArgs
                                    .chatCreatedModel.groupParticipants!.length,
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return bottomSheetButton(
                                    context: context,
                                    title: widget
                                        .chatScreenArgs
                                        .chatCreatedModel
                                        .groupParticipants![index]
                                        .userName!,
                                    iconPath: "deleteJournal.svg",
                                    onTap: widget
                                                .chatScreenArgs
                                                .chatCreatedModel
                                                .isGroupAdmin! &&
                                            widget
                                                    .chatScreenArgs
                                                    .chatCreatedModel
                                                    .groupParticipants![index]
                                                    .cognitoId!
                                                    .compareTo(widget
                                                        .chatScreenArgs
                                                        .userModel
                                                        .cognitoId!) ==
                                                1
                                        ? () {
                                            removeParticipant(
                                                context,
                                                widget
                                                    .chatScreenArgs
                                                    .chatCreatedModel
                                                    .groupParticipants![index]);
                                          }
                                        : () {},
                                    isParticipant: false,
                                    showIcon: widget.chatScreenArgs
                                            .chatCreatedModel.isGroupAdmin! &&
                                        widget
                                                .chatScreenArgs
                                                .chatCreatedModel
                                                .groupParticipants![index]
                                                .cognitoId!
                                                .compareTo(widget.chatScreenArgs
                                                    .userModel.cognitoId!) ==
                                            1,
                                  );
                                },
                              ),
                              Divider(
                                thickness: 1,
                                color: GeneralConfigs
                                    .COMMUNITY_BOTTOM_SHEET_CARD_DIVIDER_COLOR,
                              ),
                              widget.chatScreenArgs.chatCreatedModel
                                      .isGroupAdmin!
                                  ? bottomSheetButton(
                                      context: context,
                                      title: AppLocalization.of(context)!
                                          .getLocalizedText(
                                              "chat_screen_add_participant_bottom_sheet"),
                                      iconPath: "addFriendCommentSheetIcon.svg",
                                      onTap: () {
                                        addParticipant(context);
                                      },
                                      isParticipant: false,
                                      showIcon: true,
                                    )
                                  : Container(),
                              widget.chatScreenArgs.chatCreatedModel
                                      .isGroupAdmin!
                                  ? Divider(
                                      thickness: 1,
                                      color: GeneralConfigs
                                          .COMMUNITY_BOTTOM_SHEET_CARD_DIVIDER_COLOR,
                                    )
                                  : Container(),
                              widget.chatScreenArgs.chatCreatedModel
                                      .isGroupAdmin!
                                  ? bottomSheetButton(
                                      context: context,
                                      title: AppLocalization.of(context)!
                                          .getLocalizedText(
                                              "chat_screen_delete_chat_bottom_sheet"),
                                      iconPath: "deleteChatIcon.svg",
                                      onTap: () {
                                        deleteChat(context);
                                      },
                                      isParticipant: false,
                                      showIcon: true,
                                    )
                                  : Container(),
                              widget.chatScreenArgs.chatCreatedModel
                                      .isGroupAdmin!
                                  ? Divider(
                                      thickness: 1,
                                      color: GeneralConfigs
                                          .COMMUNITY_BOTTOM_SHEET_CARD_DIVIDER_COLOR,
                                    )
                                  : Container(),
                              widget.chatScreenArgs.chatCreatedModel
                                      .isGroupAdmin!
                                  ? Container()
                                  : bottomSheetButton(
                                      context: context,
                                      title: AppLocalization.of(context)!
                                          .getLocalizedText(
                                              "chat_screen_leave_chat_bottom_sheet"),
                                      iconPath: "leaveChatIcon.svg",
                                      onTap: () {
                                        leaveChat(context);
                                      },
                                      showIcon: true,
                                      isParticipant: false),
                              Container(
                                height: 10,
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: GeneralConfigs.SECONDARY_COLOR,
                                  elevation: 0,
                                  fixedSize:
                                      Size(ScreenConfig.screenWidth - 50, 60),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  )),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                AppLocalization.of(context)!.getLocalizedText(
                                    "community_page_comment_extra_options_button"),
                                style: TextStyle(
                                    color: GeneralConfigs.BACKGROUND_COLOR,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500),
                              )),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget bottomSheetButton(
      {required BuildContext context,
      required String title,
      required String iconPath,
      required Function onTap,
      required bool isParticipant,
      required bool showIcon}) {
    return Container(
      height: 50,
      width: ScreenConfig.screenWidth,
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: ListTile(
        onTap: () {
          onTap();
        },
        subtitle: SizedBox(
          height: 60,
          width: ScreenConfig.screenWidth,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight:
                        isParticipant ? FontWeight.w400 : FontWeight.w500),
              ),
              showIcon
                  ? SvgPicture.asset(
                      GeneralConfigs.ICONS_PATH + iconPath,
                      // color: Colors.black,
                      width: 20,
                      height: 20,
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }

  void addParticipant(BuildContext context) {
    context.read<ChatBottomSheetBloc>().add(ChatBottomSheetAddParticipant(
        chatId: widget.chatScreenArgs.chatCreatedModel.id!,
        chatCreatedModel: widget.chatScreenArgs.chatCreatedModel));

    print("addParticipant");
  }

  void leaveChat(BuildContext context) {
    context.read<ChatBottomSheetBloc>().add(ChatBottomSheetLeaveChat(
        chatId: widget.chatScreenArgs.chatCreatedModel.id!));

    print("leaveChat");
  }

  void deleteChat(BuildContext context) {
    context.read<ChatBottomSheetBloc>().add(ChatBottomSheetDeleteChat(
        chatId: widget.chatScreenArgs.chatCreatedModel.id!));

    print("deleteChat");
  }

  void removeParticipant(
      BuildContext context, ParticipantModel participantModel) {
    context.read<ChatBottomSheetBloc>().add(ChatBottomSheetDeleteParticipant(
        chatId: widget.chatScreenArgs.chatCreatedModel.id!,
        participantId: participantModel.cognitoId!));

    widget.chatScreenArgs.chatCreatedModel.groupParticipants!
        .remove(participantModel);

    print("removeParticipant with id ${participantModel.cognitoId}");
  }

  void editGroupName(BuildContext context) {
    if (newGroupName.trim().isNotEmpty) {
      context.read<ChatBottomSheetBloc>().add(ChatBottomSheetChangeGroupName(
          chatId: widget.chatScreenArgs.chatCreatedModel.id!,
          newGroupName: newGroupName));

      setState(() {});

      print("new Group name $newGroupName");
    }
    // print("removeParticipant with id ${participantModel.cognitoId}");
  }

// bool isMessageSent(int index) {
//   if ((index > 0 &&
//           listMessages[index - 1].get(FirestoreConstants.idFrom.value) !=
//               widget.chatScreenArgs.chatCreatedModel.participantFrom!) ||
//       index == 0) {
//     return true;
//   } else {
//     return false;
//   }
// }
//
// bool isMessageReceived(int index) {
//   if ((index > 0 &&
//           listMessages[index - 1].get(FirestoreConstants.idFrom.value) ==
//               widget.chatScreenArgs.chatCreatedModel.participantFrom!) ||
//       index == 0) {
//     return true;
//   } else {
//     return false;
//   }
// }
}
