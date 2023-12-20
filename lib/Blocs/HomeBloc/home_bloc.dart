import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:free_indeed/Managers/named-navigator.dart';
import 'package:free_indeed/Models/ChatCreatedModel.dart';
import 'package:free_indeed/Models/UserModel.dart';
import 'package:free_indeed/Repo/ChatsRepo.dart';
import 'package:free_indeed/Repo/FirebaseRepo.dart';
import 'package:free_indeed/Repo/login_repo.dart';
import 'package:free_indeed/Screens/ChatScreen/ChatScreen.dart';
import 'package:free_indeed/Screens/GoalPopUp/GoalPopUp.dart';
import 'package:free_indeed/Screens/iKindaWannaRelapseScreen/iKindaWannaRelapnseScreen.dart';
import 'package:free_indeed/Screens/iRelapsedScreen/iRelapsedScreen.dart';
import 'package:free_indeed/configs/Config.dart';

import '../../Models/GoalModel.dart';
import '../../Repo/GoalRepo.dart';

part 'home_event.dart';

part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final NamedNavigator namedNavigator;
  final GoalRepo goalRepo;
  final ChatsRepo chatsRepo;
  final LoginRepo loginRepo;
  final FirebaseRepo firebaseRepo;

  late String accessToken = "";
  late GoalModel goal;
  int? userGoal;

  HomeBloc(
      {required this.namedNavigator,
      required this.goalRepo,
      required this.loginRepo,
      required this.firebaseRepo,
      required this.chatsRepo})
      : super(HomeReadyState(
            goal: GoalModel(
          id: "",
          days: "",
          hours: "",
          minutes: "",
          success: true,
          goalProgress: false,
          percentage: "0%",
        ))) {
    on<HomeInitializeEvent>((event, emit) async {
      goal = GoalModel(
        id: "",
        days: "",
        hours: "",
        minutes: "",
        success: true,
        goalProgress: false,
        percentage: "0%",
      );

      EasyLoading.dismiss();
      emit(HomeReadyState(goal: goal));
      userGoal = await goalRepo.getUserGoalData(accessToken: accessToken);
    });
    on<HomeGoToIRelapsedEvent>((event, emit) async {
      await namedNavigator.push(Routes.I_RELAPSED_ROUTER,
          arguments: IRelapsedArgs(isEditing: false));
    });
    on<HomeGoToStatsEvent>((event, emit) async {
      //TODO:REFRESH GOAL AFTER ADDING RELAPSE AND REFRESH GOAL AFTER COMING BACK FROM STATS..
      await namedNavigator.push(Routes.MY_STATS_ROUTER);
    });
    on<HomeGoToKindaWannaRelapseEvent>((event, emit) {
      namedNavigator.push(Routes.I_KINDA_WANNA_RELAPSE_ROUTER,
          arguments: IKindaWannaRelapseArgs(isEditing: false));
    });
    on<HomeGoToMyJournalsEvent>((event, emit) {
      namedNavigator.push(Routes.MY_JOURNALS_ROUTER);
    });

    on<HomeTellUsAboutYourselfEvent>((event, emit) async {
      EasyLoading.show(status: "");
      String freeIndeedId =
          await goalRepo.getFutureIndeedAccountId(accessToken: accessToken);
      UserModel userModel = await loginRepo.getUserDataFromCache();

      ChatCreatedModel chatModel = await chatsRepo.startIndividualChat(
          accessToken, [userModel.cognitoId!, freeIndeedId]);
      chatModel.isGroup = false;
      firebaseRepo.sendChatMessage(
          event.tellYourselfText,
          MessageType.TEXT.value,
          chatModel.id!,
          chatModel.participantFrom!,
          chatModel.participantTo!);
      chatsRepo.addLastMessage("", chatModel.id!, event.tellYourselfText,
          chatModel.participantFrom!);
      EasyLoading.dismiss();
      namedNavigator.push(Routes.CHAT_ROUTER,
          arguments: ChatScreenArgs(
              chatCreatedModel: chatModel, userModel: userModel));
    });
    on<HomeSetGoalEvent>((event, emit) async {
      await namedNavigator.showPopup(
          type: PopupsTypes.GENERAL,
          parameters: [
            GoalPopUp(
              userGoal: userGoal ?? 1,
            )
          ],
          barrierDismissible: false);
      emit(HomeInitial());
      userGoal = await goalRepo.getUserGoalData(accessToken: accessToken);
      emit(HomeReadyState(goal: goal));
    });
  }

  Future<GoalModel> getUserGoal() async {
    return await goalRepo.getGoalData(accessToken: accessToken);
  }
}
