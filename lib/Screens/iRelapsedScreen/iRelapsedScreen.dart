import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:free_indeed/Managers/Implementation/named_navigator_impl.dart';
import 'package:free_indeed/Models/IRelapsedModel.dart';
import 'package:free_indeed/Models/iRelapsedTileObject.dart';
import 'package:free_indeed/Repo/StatsRepo.dart';
import 'package:free_indeed/Screens/commons/BackButtonComponent.dart';
import 'package:free_indeed/configs/general_configs.dart';
import 'package:free_indeed/localization/localization.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../Blocs/iRelapsed-Bloc/irelapsed_bloc.dart';
import '../../Models/triggerModel.dart';

class IRelapsedArgs {
  final bool isEditing;
  final IRelapsedModel? iRelapsedModel;
  final Function? editRelapse;

  IRelapsedArgs(
      {required this.isEditing, this.iRelapsedModel, this.editRelapse});
}

class IRelapsedScreen extends StatefulWidget {
  final IRelapsedArgs iRelapsedArgs;

  const IRelapsedScreen({Key? key, required this.iRelapsedArgs})
      : super(key: key);

  @override
  _IRelapsedScreenState createState() => _IRelapsedScreenState();
}

class _IRelapsedScreenState extends State<IRelapsedScreen> {
  bool dataAdded = false;

  DateTime? fromDate;
  DateTime? toDate;
  bool isFromDate = true;
  String _walkYourselfText = "";
  String _lowerChancesText = "";
  bool isGoal = false;
  FocusNode walkYourselfNode = FocusNode();
  FocusNode lowerChancesNode = FocusNode();
  IrelapsedBloc _iRelapsedBloc = IrelapsedBloc(
      namedNavigator: NamedNavigatorImpl(),
      relapsedAndStatsRepo: RelapsedAndStatsRepo());

  @override
  void initState() {
    _iRelapsedBloc.add(IRelapsedInitialEvent(
        iRelapsedTileObject: widget.iRelapsedArgs.iRelapsedModel));
    super.initState();
  }

  @override
  void dispose() {
    walkYourselfNode.dispose();
    lowerChancesNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        return _iRelapsedBloc;
      },
      child: BlocConsumer<IrelapsedBloc, IrelapsedState>(
        listener: (context, state) {
          if (state is IRelapsedReadyState) {
            if (widget.iRelapsedArgs.iRelapsedModel != null && !dataAdded) {
              toDate =
                  DateTime.parse(widget.iRelapsedArgs.iRelapsedModel!.endDate!);
              _walkYourselfText =
                  widget.iRelapsedArgs.iRelapsedModel!.whatHappened!;
              _lowerChancesText =
                  widget.iRelapsedArgs.iRelapsedModel!.lowerTheChances!;
              for (int i = 0;
                  i < widget.iRelapsedArgs.iRelapsedModel!.triggers!.length;
                  i++) {
                for (int j = 0; j < state.triggersList.length; j++) {
                  if (state.triggersList[j].id ==
                      widget.iRelapsedArgs.iRelapsedModel!.triggers![i].id) {
                    state.triggersList[j].selected = true;
                  }
                }
              }
              for (int i = 0;
                  i < widget.iRelapsedArgs.iRelapsedModel!.relapses!.length;
                  i++) {
                for (int j = 0; j < state.relapsesList.length; j++) {
                  if (state.relapsesList[j].id ==
                      widget.iRelapsedArgs.iRelapsedModel!.relapses![i].id) {
                    state.relapsesList[j].selected = true;
                  }
                }
              }
              dataAdded = true;
            }
          }
        },
        builder: (context, state) {
          if (state is IRelapsedReadyState) {
            return Scaffold(
              appBar: AppBar(
                backgroundColor: GeneralConfigs.BACKGROUND_COLOR,
                leading: FreeIndeedBackButton(),
                centerTitle: true,
                title: Text(
                  AppLocalization.of(context)!
                      .getLocalizedText("i_relapsed_page_title_text"),
                  style: TextStyle(fontSize: 16),
                ),
              ),
              backgroundColor: GeneralConfigs.BACKGROUND_COLOR,
              body: SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  child: GestureDetector(
                    onTap: () {
                      walkYourselfNode.unfocus();
                      lowerChancesNode.unfocus();
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              // calenderTile(
                              //     context,
                              //     AppLocalization.of(context)!.getLocalizedText(
                              //         "i_relapsed_page_calender_start_text"),
                              //     fromDate == null
                              //         ? AppLocalization.of(context)!.getLocalizedText(
                              //             "i_relapsed_page_calender_generic_text")
                              //         : DateFormat('dd-MM-yyyy')
                              //             .format(fromDate!)
                              //             .toString(),
                              //     true),
                              calenderTile(
                                  context,
                                  AppLocalization.of(context)!.getLocalizedText(
                                      "i_relapsed_page_calender_end_text"),
                                  toDate == null
                                      ? AppLocalization.of(context)!
                                          .getLocalizedText(
                                              "i_relapsed_page_calender_generic_text")
                                      : DateFormat('MM-dd-yyyy  HH:MM')
                                          .format(toDate!)
                                          .toString(),
                                  false),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Text(
                            AppLocalization.of(context)!.getLocalizedText(
                                "i_relapsed_page_describe_relapse_text"),
                            style: TextStyle(
                                color: GeneralConfigs.SECONDARY_COLOR,
                                fontSize: 16),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: GridView.builder(
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            physics: NeverScrollableScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    childAspectRatio: 3,
                                    crossAxisSpacing: 10),
                            itemBuilder: (_, index) {
                              return choicesListTile(
                                  context,
                                  state.relapsesList[index].title!,
                                  state.relapsesList[index].selected!, () {
                                setState(() {
                                  state.relapsesList[index].selected =
                                      !state.relapsesList[index].selected!;
                                });
                              });
                            },
                            itemCount: state.relapsesList.length,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Text(
                            AppLocalization.of(context)!.getLocalizedText(
                                "i_relapsed_page_triggers_text"),
                            style: TextStyle(
                                color: GeneralConfigs.SECONDARY_COLOR,
                                fontSize: 16),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: GridView.builder(
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            physics: NeverScrollableScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    childAspectRatio: 3,
                                    crossAxisSpacing: 10,
                                    mainAxisSpacing: 10),
                            itemBuilder: (_, index) {
                              return choicesListTile(
                                  context,
                                  state.triggersList[index].title!,
                                  state.triggersList[index].selected!, () {
                                setState(() {
                                  state.triggersList[index].selected =
                                      !state.triggersList[index].selected!;
                                });
                              });
                            },
                            itemCount: state.triggersList.length,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: Text(
                            AppLocalization.of(context)!.getLocalizedText(
                                "i_relapsed_page_walk_yourself_through_text"),
                            style: TextStyle(
                                color: GeneralConfigs.SECONDARY_COLOR,
                                fontSize: 16),
                          ),
                        ),
                        Container(
                            height: 200,
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 7),
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              border: Border.all(
                                  color: GeneralConfigs.BLACK_BOARDER_COLOR),
                            ),
                            child: SizedBox(
                              height: 200,
                              child: TextFormField(
                                initialValue: _walkYourselfText,
                                style: TextStyle(
                                    color: GeneralConfigs.SECONDARY_COLOR),
                                maxLength: 2000,
                                maxLines: 7,
                                focusNode: walkYourselfNode,
                                onChanged: (value) {
                                  setState(() {
                                    _walkYourselfText = value;
                                  });
                                },
                                decoration: InputDecoration(
                                    counterStyle: TextStyle(
                                        color: GeneralConfigs
                                            .POST_TIME_STAMP_COLOR),
                                    border: InputBorder.none,
                                    counterText:
                                        '${_walkYourselfText.length.toString()}/2000'),
                              ),
                            )),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: Text(
                            AppLocalization.of(context)!.getLocalizedText(
                                "i_relapsed_page_next_relapse_text"),
                            style: TextStyle(
                                color: GeneralConfigs.SECONDARY_COLOR,
                                fontSize: 16),
                          ),
                        ),
                        Container(
                            height: 200,
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 7),
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              border: Border.all(
                                  color: GeneralConfigs.BLACK_BOARDER_COLOR),
                            ),
                            child: SizedBox(
                              height: 200,
                              child: TextFormField(
                                initialValue: _lowerChancesText,
                                style: TextStyle(
                                    color: GeneralConfigs.SECONDARY_COLOR),
                                maxLength: 2000,
                                maxLines: 7,
                                focusNode: lowerChancesNode,
                                onChanged: (value) {
                                  setState(() {
                                    _lowerChancesText = value;
                                  });
                                },
                                decoration: InputDecoration(
                                    counterStyle: TextStyle(
                                        color: GeneralConfigs
                                            .POST_TIME_STAMP_COLOR),
                                    border: InputBorder.none,
                                    counterText:
                                        '${_lowerChancesText.length.toString()}/2000'),
                              ),
                            )),
                        SizedBox(
                          height: 30,
                        ),
                        // Padding(
                        //   padding: EdgeInsets.symmetric(vertical: 10),
                        //   child: Row(
                        //     crossAxisAlignment: CrossAxisAlignment.start,
                        //     mainAxisAlignment: MainAxisAlignment.start,
                        //     children: [
                        //       SvgPicture.asset(
                        //         GeneralConfigs.ICONS_PATH + "clockIcon.svg",
                        //         width: 28,
                        //         height: 28,
                        //         fit: BoxFit.scaleDown,
                        //       ),
                        //       Padding(
                        //         padding: EdgeInsets.symmetric(
                        //             vertical: 5, horizontal: 5),
                        //         child: Text(
                        //           AppLocalization.of(context)!.getLocalizedText(
                        //               "i_relapsed_page_goal_progress_text"),
                        //           style: TextStyle(
                        //               color: GeneralConfigs.SECONDARY_COLOR,
                        //               fontSize: 16),
                        //         ),
                        //       ),
                        //       Expanded(child: Container()),
                        //       CupertinoSwitch(
                        //         value: isGoal,
                        //         // changes the state of the switch
                        //         onChanged: (value) =>
                        //             setState(() => isGoal = value),
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        widget.iRelapsedArgs.isEditing
                            ? Container()
                            : Container(
                                decoration: BoxDecoration(
                                  color: GeneralConfigs.BACKGROUND_COLOR,
                                  border: Border.all(
                                      width: 2,
                                      color: GeneralConfigs.SECONDARY_COLOR
                                          .withOpacity(0.2)),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(6)),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 5),
                                  child: Text(
                                    AppLocalization.of(context)!.getLocalizedText(
                                        "i_relapsed_page_encouragement_text"),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: GeneralConfigs.SECONDARY_COLOR,
                                        fontSize: 16),
                                  ),
                                ),
                              ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: Center(
                            child: Container(
                              width: 200,
                              height: 48,
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(26)),
                                border: Border.all(
                                    color: GeneralConfigs.SECONDARY_COLOR),
                              ),
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      primary: GeneralConfigs.BACKGROUND_COLOR,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(26.0),
                                      )),
                                  onPressed: () {
                                    List<TriggerObject> selectedTriggers = [];
                                    List<IRelapsedTileObject> selectedRelapses =
                                        [];
                                    for (int i = 0;
                                        i < state.triggersList.length;
                                        i++) {
                                      if (state.triggersList[i].selected!) {
                                        selectedTriggers
                                            .add(state.triggersList[i]);
                                      }
                                    }
                                    for (int i = 0;
                                        i < state.relapsesList.length;
                                        i++) {
                                      if (state.relapsesList[i].selected!) {
                                        selectedRelapses
                                            .add(state.relapsesList[i]);
                                      }
                                    }

                                    if (widget.iRelapsedArgs.isEditing) {
                                      IRelapsedModel model = IRelapsedModel(
                                          lowerTheChances: _lowerChancesText,
                                          triggers: selectedTriggers,
                                          relapses: selectedRelapses,
                                          startDate: fromDate.toString(),
                                          selected: false,
                                          showDelete: false,
                                          id: widget.iRelapsedArgs
                                              .iRelapsedModel!.id!,
                                          whatHappened: _walkYourselfText,
                                          endDate: toDate.toString());
                                      widget.iRelapsedArgs.editRelapse!(model);
                                    } else {
                                      if (toDate != null) {
                                        IRelapsedModel model = IRelapsedModel(
                                            lowerTheChances: _lowerChancesText,
                                            triggers: selectedTriggers,
                                            relapses: selectedRelapses,
                                            startDate: fromDate.toString(),
                                            selected: false,
                                            whatHappened: _walkYourselfText,
                                            showDelete: false,
                                            endDate: toDate.toString());
                                        _submitData(model);
                                      } else {
                                        EasyLoading.showToast(
                                            "Enter a Valid date");
                                      }
                                    }
                                  },
                                  child: Text(
                                    AppLocalization.of(context)!.getLocalizedText(
                                        "i_relapsed_page_submit_button_text"),
                                    style: TextStyle(
                                        color: GeneralConfigs.SECONDARY_COLOR,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500),
                                  )),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 50,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          } else if (state is IRelapsedLoadingState) {
            return Container();
          } else {
            return Scaffold(
              appBar: AppBar(
                backgroundColor: GeneralConfigs.BACKGROUND_COLOR,
                leading: FreeIndeedBackButton(),
                centerTitle: true,
                title: Text(
                  AppLocalization.of(context)!
                      .getLocalizedText("i_relapsed_page_title_text"),
                  style: TextStyle(fontSize: 16),
                ),
              ),
              backgroundColor: GeneralConfigs.BACKGROUND_COLOR,
              body: Container(),
            );
          }
        },
      ),
    );
  }

  Widget calenderTile(
      BuildContext context, String label, String dateLabel, bool isFromDate) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Text(
              label,
              style: TextStyle(
                  color: GeneralConfigs.SECONDARY_COLOR, fontSize: 15),
            )),
        Container(
          height: 40,
          width: 180,
          padding: EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            border: Border.all(
                width: 2,
                color: isFromDate && fromDate == null
                    ? GeneralConfigs.BLACK_BOARDER_COLOR
                    : !isFromDate && toDate == null
                        ? GeneralConfigs.BLACK_BOARDER_COLOR
                        : GeneralConfigs.SECONDARY_COLOR),
            borderRadius: BorderRadius.all(Radius.circular(6)),
          ),
          child: Theme(
            data: ThemeData(
                primaryColor: GeneralConfigs.SECONDARY_COLOR,
                colorScheme:
                    ColorScheme.dark(primary: GeneralConfigs.SECONDARY_COLOR),
                buttonTheme:
                    ButtonThemeData(textTheme: ButtonTextTheme.primary),
                inputDecorationTheme: InputDecorationTheme(
                  border: InputBorder.none,
                  alignLabelWithHint: true,
                  labelStyle: TextStyle(
                      color: GeneralConfigs.SECONDARY_COLOR, fontSize: 14),
                  hintStyle: TextStyle(
                      color: GeneralConfigs.SECONDARY_COLOR, fontSize: 14),
                  floatingLabelAlignment: FloatingLabelAlignment.start,
                  floatingLabelStyle: TextStyle(
                      color: GeneralConfigs.SECONDARY_COLOR, fontSize: 16),
                )),
            child: DateTimePicker(
              type: DateTimePickerType.dateTime,

              dateMask: '',
              // initialValue: DateTime.now().toString(),
              firstDate: DateTime(2023),
              lastDate: DateTime.now(),
              icon: Icon(
                Icons.calendar_month_outlined,
                color: GeneralConfigs.SECONDARY_COLOR,
                size: 15,
              ),
              dateLabelText: dateLabel,
              onChanged: (date) {
                setState(() {
                  isFromDate
                      ? fromDate = DateTime.parse(date)
                      : toDate = DateTime.parse(date);
                });
                print(date);
              },
              validator: (val) {
                print(val);
                return null;
              },
              onSaved: (date) {
                setState(() {
                  isFromDate
                      ? fromDate = DateTime.parse(date!)
                      : toDate = DateTime.parse(date!);
                });
                print(date);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget choicesListTile(
      BuildContext context, String name, bool isSelected, Function onTap) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Container(
          height: 40,
          width: 180,
          decoration: BoxDecoration(
            color: isSelected
                ? GeneralConfigs.SECONDARY_COLOR
                : GeneralConfigs.BACKGROUND_COLOR,
            border: Border.all(
                width: 2,
                color: !isSelected
                    ? GeneralConfigs.SECONDARY_COLOR.withOpacity(0.2)
                    : GeneralConfigs.SECONDARY_COLOR),
            borderRadius: BorderRadius.all(Radius.circular(6)),
          ),
          child: Stack(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 6),
                child: Center(
                  child: Text(
                    name,
                    textAlign: isSelected ? TextAlign.start : TextAlign.center,
                    style: TextStyle(
                        color: isSelected
                            ? Colors.black
                            : GeneralConfigs.SECONDARY_COLOR),
                  ),
                ),
              ),

              ///TODO: Remove after revision that they won't need it back
              // isSelected
              //     ? Align(
              //         alignment: AlignmentDirectional.centerEnd,
              //         child: Container(
              //           padding: EdgeInsets.only(right: 3),
              //           color: GeneralConfigs.SECONDARY_COLOR,
              //           child: Icon(
              //             Icons.check_circle_outline,
              //             color: GeneralConfigs.BACKGROUND_COLOR,
              //             size: 20,
              //           ),
              //         ))
              //     : Container(),
            ],
          )),
    );
  }

  void _submitData(IRelapsedModel model) {
    _iRelapsedBloc.add(SubmitRelapseEvent(iRelapsedTileObject: model));
  }
}
