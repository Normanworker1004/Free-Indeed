import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:free_indeed/Blocs/HomeBloc/home_bloc.dart';
import 'package:free_indeed/Managers/Implementation/named_navigator_impl.dart';
import 'package:free_indeed/Models/GoalModel.dart';
import 'package:free_indeed/Repo/ChatsRepo.dart';
import 'package:free_indeed/Repo/FirebaseRepo.dart';
import 'package:free_indeed/Repo/GoalRepo.dart';
import 'package:free_indeed/Repo/login_repo.dart';
import 'package:free_indeed/Screens/HomeScreen/GoalWidget.dart';
import 'package:free_indeed/Screens/commons/LoadingState.dart';
import 'package:free_indeed/configs/ScreenConfig.dart';
import 'package:free_indeed/configs/general_configs.dart';
import 'package:free_indeed/localization/localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'TellUsTextBox.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  HomeBloc homeBloc = HomeBloc(
      goalRepo: GoalRepo(),
      namedNavigator: NamedNavigatorImpl(),
      firebaseRepo: FirebaseRepo(),
      loginRepo: LoginRepo(),
      chatsRepo: ChatsRepo());
  GoalModel? haveGoal;
  FocusNode tellUsFocus = FocusNode();
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    homeBloc.add(HomeInitializeEvent());
    super.initState();
  }

  @override
  void dispose() {
    tellUsFocus.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        return homeBloc;
      },
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if (state is HomeInitial) {
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
            );
          } else if (state is HomeLoading) {
            return LoadingState();
          } else if (state is HomeReadyState) {
            return SafeArea(
              child: Scaffold(
                backgroundColor: GeneralConfigs.BACKGROUND_COLOR,
                body: SingleChildScrollView(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  child: GestureDetector(
                    onTap: () {
                      tellUsFocus.unfocus();
                    },
                    onPanUpdate: (details) {
                      if (details.delta.dx < 0) {
                        tellUsFocus.unfocus();
                      }
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        GoalMeterWidget(
                            goal: state.goal,
                            showData: true,
                            getUserGoal: () async {
                              haveGoal ??= await homeBloc.getUserGoal();
                              return Future.value(haveGoal!);
                            },
                            onChangeGoal: () {
                              setGoalButton();
                              haveGoal = null;
                            }),

                        // Text(
                        //     AppLocalization.of(context)!
                        //         .getLocalizedText("home_page_percentage_text"),
                        //     style: TextStyle(
                        //         color: GeneralConfigs.SECONDARY_COLOR,
                        //         fontSize: 15,
                        //         fontWeight: FontWeight.w400)),
                        SizedBox(
                          height: 30,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            homeButton(
                              context,
                              height: 50,
                              width: 150,
                              label: 'home_page_relapsed_button_text',
                              iconPath: 'relapseIcon.svg',
                              onTap: relapseButton,
                              buttonColor: GeneralConfigs.SECONDARY_COLOR,
                            ),
                            homeButton(
                              context,
                              height: 50,
                              width: 150,
                              label: 'home_page_my_stats_button_text',
                              iconPath: 'statsIcon.svg',
                              onTap: myStatsButton,
                              borderColor: GeneralConfigs.SECONDARY_COLOR,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 19, vertical: 12),
                          child: SizedBox(
                            width: ScreenConfig.screenWidth,
                            child: Text(
                              AppLocalization.of(context)!
                                  .getLocalizedText("home_page_tell_us_title"),
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: GeneralConfigs.SECONDARY_COLOR),
                            ),
                          ),
                        ),
                        TellUsAboutYourselfTextBox(
                          focusNode: tellUsFocus,
                          sendText: (String text) {
                            // print(text);
                            homeBloc.add(HomeTellUsAboutYourselfEvent(
                                tellYourselfText: text));
                          },
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 25),
                          child: homeButton(
                            context,
                            height: 50,
                            width: 250,
                            label: 'home_page_wanna_relapse_button_text',
                            onTap: wannaRelapseButton,
                            borderColor: GeneralConfigs.SECONDARY_COLOR,
                          ),
                        ),
                        homeButton(
                          context,
                          height: 50,
                          width: 250,
                          label: 'home_page_my_journal_button_text',
                          onTap: myJournalsButton,
                          buttonColor: GeneralConfigs.SECONDARY_COLOR,
                        ),
                        SizedBox(
                          height: 20,
                        )
                      ],
                    ),
                  ),
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

  Widget homeButton(BuildContext context,
      {String? iconPath,
      required String label,
      required Function onTap,
      required double height,
      required double width,
      Color? buttonColor,
      Color? borderColor,
      Color? labelColor}) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
            color: buttonColor ?? Colors.transparent,
            borderRadius: BorderRadius.all(Radius.circular(24)),
            border: Border.all(color: borderColor ?? Colors.transparent)),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              iconPath != null
                  ? SvgPicture.asset(
                      GeneralConfigs.ICONS_PATH + iconPath,
                      width: 15,
                      height: 20,
                      fit: BoxFit.scaleDown,
                    )
                  : Container(),
              iconPath != null
                  ? SizedBox(
                      width: 16,
                    )
                  : Container(),
              Text(
                AppLocalization.of(context)!.getLocalizedText(label),
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: borderColor == null
                        ? GeneralConfigs.BACKGROUND_COLOR
                        : GeneralConfigs.SECONDARY_COLOR),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void relapseButton() {
    homeBloc.add(HomeGoToIRelapsedEvent());
    haveGoal = null;
    print("relapseButton Function");
  }

  void myStatsButton() {
    print("myStatsButton Function");
    homeBloc.add(HomeGoToStatsEvent());
    haveGoal = null;
  }

  void wannaRelapseButton() {
    print("wannaRelapseButton");
    homeBloc.add(HomeGoToKindaWannaRelapseEvent());
  }

  void myJournalsButton() {
    print("myJournalsButton");
    homeBloc.add(HomeGoToMyJournalsEvent());
  }

  void setGoalButton() {
    print("setGoalButton");
    homeBloc.add(HomeSetGoalEvent());
    haveGoal = null;
  }
}
