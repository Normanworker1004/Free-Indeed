import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:free_indeed/Managers/Implementation/named_navigator_impl.dart';
import 'package:free_indeed/Models/KindaWannaRelapseModel.dart';
import 'package:free_indeed/Repo/kindaWannaRelapseRepo.dart';
import 'package:free_indeed/Screens/commons/BackButtonComponent.dart';
import 'package:free_indeed/Screens/commons/LoadingState.dart';
import 'package:free_indeed/configs/ScreenConfig.dart';
import 'package:free_indeed/configs/general_configs.dart';
import 'package:free_indeed/localization/localization.dart';
import 'package:flutter/material.dart';

import '../../Blocs/KindaWannaRelapseResultsBloc/kinda_wanna_relapse_bloc.dart';

class IKindaWannaRelapseArgs {
  final bool isEditing;
  final KindaWannaRelapseModel? kindaWannaRelapseModel;
  final Function? editRelapse;

  IKindaWannaRelapseArgs(
      {required this.isEditing, this.kindaWannaRelapseModel, this.editRelapse});
}

class IKindaWannaRelapseScreen extends StatefulWidget {
  final IKindaWannaRelapseArgs? kindaWannaRelapseModel;

  const IKindaWannaRelapseScreen(
      {Key? key, required this.kindaWannaRelapseModel})
      : super(key: key);

  @override
  _IKindaWannaRelapseScreenState createState() =>
      _IKindaWannaRelapseScreenState();
}

class _IKindaWannaRelapseScreenState extends State<IKindaWannaRelapseScreen> {
  String _temptation = "";
  String _madeYouStart = "";
  String _feelingOnSecondRelapse = "";
  bool dataAdded = false;

  KindaWannaRelapseBloc _kindaWannaRelapseBloc = KindaWannaRelapseBloc(
      kindaWannaRelapseRepo: KindaWannaRelapseRepo(),
      namedNavigator: NamedNavigatorImpl());

  @override
  void initState() {
    _kindaWannaRelapseBloc.add(KindaWannaInitializeSubmitEvent());
    if (widget.kindaWannaRelapseModel!.kindaWannaRelapseModel != null &&
        !dataAdded) {
      _temptation =
          widget.kindaWannaRelapseModel!.kindaWannaRelapseModel!.temptation!;
      _madeYouStart =
          widget.kindaWannaRelapseModel!.kindaWannaRelapseModel!.madeYouStart!;
      _feelingOnSecondRelapse = widget.kindaWannaRelapseModel!
          .kindaWannaRelapseModel!.feelingOnSecondRelapse!;
      dataAdded = true;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        return _kindaWannaRelapseBloc;
      },
      child: BlocBuilder<KindaWannaRelapseBloc, KindaWannaRelapseState>(
        builder: (context, state) {
          if (state is KindaWannaRelapseInitial) {
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
            );
          } else if (state is KindaWannaSubmissionReadyState) {
            return Scaffold(
              appBar: AppBar(
                backgroundColor: GeneralConfigs.BACKGROUND_COLOR,
                leading: FreeIndeedBackButton(),
                centerTitle: true,
                title: Text(
                  AppLocalization.of(context)!
                      .getLocalizedText("i_kinda_wanna_relapse_screen_title"),
                  style: TextStyle(fontSize: 16),
                ),
              ),
              backgroundColor: GeneralConfigs.BACKGROUND_COLOR,
              body: GestureDetector(
                onTap: FocusScope.of(context).unfocus,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        widget.kindaWannaRelapseModel!.isEditing
                            ? Container()
                            : Padding(
                                padding: EdgeInsets.symmetric(vertical: 20.0),
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 20),
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    border: Border.all(
                                        color:
                                            GeneralConfigs.BLACK_BOARDER_COLOR),
                                  ),
                                  child: Text(
                                    AppLocalization.of(context)!.getLocalizedText(
                                        "i_kinda_wanna_relapse_screen_header"),
                                    style: TextStyle(
                                        color: GeneralConfigs.SECONDARY_COLOR,
                                        fontSize: 16),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                        Text(
                          AppLocalization.of(context)!.getLocalizedText(
                              "i_kinda_wanna_relapse_screen_why_do_you_think"),
                          style: TextStyle(
                              color: GeneralConfigs.SECONDARY_COLOR,
                              fontSize: 16),
                        ),
                        SizedBox(
                          height: 20,
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
                                style: TextStyle(
                                    color: GeneralConfigs.SECONDARY_COLOR),
                                maxLength: 200,
                                maxLines: 7,
                                initialValue: _temptation,
                                onChanged: (value) {
                                  setState(() {
                                    _temptation = value;
                                  });
                                },
                                decoration: InputDecoration(
                                    counterStyle: TextStyle(
                                        color: GeneralConfigs
                                            .POST_TIME_STAMP_COLOR),
                                    border: InputBorder.none,
                                    counterText:
                                        '${_temptation.length.toString()}/200'),
                              ),
                            )),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: Text(
                            AppLocalization.of(context)!.getLocalizedText(
                                "i_kinda_wanna_relapse_screen_remind_us"),
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
                                style: TextStyle(
                                    color: GeneralConfigs.SECONDARY_COLOR),
                                maxLength: 200,
                                maxLines: 7,
                                initialValue: _madeYouStart,
                                onChanged: (value) {
                                  setState(() {
                                    _madeYouStart = value;
                                  });
                                },
                                decoration: InputDecoration(
                                    counterStyle: TextStyle(
                                        color: GeneralConfigs
                                            .POST_TIME_STAMP_COLOR),
                                    border: InputBorder.none,
                                    counterText:
                                        '${_madeYouStart.length.toString()}/200'),
                              ),
                            )),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: Text(
                            AppLocalization.of(context)!.getLocalizedText(
                                "i_kinda_wanna_relapse_screen_based_on"),
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
                                style: TextStyle(
                                    color: GeneralConfigs.SECONDARY_COLOR),
                                maxLength: 200,
                                maxLines: 7,
                                initialValue: _feelingOnSecondRelapse,
                                onChanged: (value) {
                                  setState(() {
                                    _feelingOnSecondRelapse = value;
                                  });
                                },
                                decoration: InputDecoration(
                                    counterStyle: TextStyle(
                                        color: GeneralConfigs
                                            .POST_TIME_STAMP_COLOR),
                                    border: InputBorder.none,
                                    counterText:
                                        '${_feelingOnSecondRelapse.length.toString()}/200'),
                              ),
                            )),
                        SizedBox(
                          height: 10,
                        ),
                        widget.kindaWannaRelapseModel!.isEditing
                            ? Container()
                            : Container(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                child: Text(
                                  AppLocalization.of(context)!.getLocalizedText(
                                      "i_kinda_wanna_relapse_screen_mean_time"),
                                  style: TextStyle(
                                      color: GeneralConfigs.SECONDARY_COLOR,
                                      fontSize: 16),
                                ),
                              ),
                        widget.kindaWannaRelapseModel!.isEditing
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
                                  padding: const EdgeInsets.all(15),
                                  child: Text(
                                    AppLocalization.of(context)!.getLocalizedText(
                                        "i_kinda_wanna_relapse_screen_text_friend"),
                                    style: TextStyle(
                                        color: GeneralConfigs.SECONDARY_COLOR,
                                        fontSize: 16),
                                  ),
                                ),
                              ),
                        Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 30, vertical: 20),
                            child: SizedBox(
                              width: ScreenConfig.screenWidth,
                              height: 50,
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      primary: GeneralConfigs.SECONDARY_COLOR,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(26.0),
                                      )),
                                  onPressed: () {
                                    if (widget
                                        .kindaWannaRelapseModel!.isEditing) {
                                      editKindaWannaRelapseButton(context);
                                    } else {
                                      addKindaWannaRelapseButton(context);
                                    }
                                  },
                                  child: Text(
                                    AppLocalization.of(context)!.getLocalizedText(
                                        "i_kinda_wanna_relapse_screen_add_journal_button"),
                                    style: TextStyle(
                                        color: GeneralConfigs.BACKGROUND_COLOR,
                                        fontSize: 16,
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
          } else if (state is KindaWannaLoadingState) {
            return LoadingState();
          } else {
            return Container();
          }
        },
      ),
    );
  }

  void addKindaWannaRelapseButton(BuildContext context) {
    if (_temptation.trim().isNotEmpty &&
        _madeYouStart.trim().isNotEmpty &&
        _feelingOnSecondRelapse.trim().isNotEmpty) {
      KindaWannaRelapseModel model = KindaWannaRelapseModel(
          id: "",
          temptation: _temptation,
          madeYouStart: _madeYouStart,
          feelingOnSecondRelapse: _feelingOnSecondRelapse,
          reportName: ""
              "",
          success: true);
      _kindaWannaRelapseBloc
          .add(KindaWannaCreateEvent(kindaWannaRelapseModel: model));
    } else {
      EasyLoading.showToast("Make sure you filled all the data");
    }
  }

  void editKindaWannaRelapseButton(BuildContext context) {
    KindaWannaRelapseModel model = KindaWannaRelapseModel(
        id: widget.kindaWannaRelapseModel!.kindaWannaRelapseModel!.id,
        temptation: _temptation,
        madeYouStart: _madeYouStart,
        feelingOnSecondRelapse: _feelingOnSecondRelapse,
        reportName: "",
        success: true);
    _kindaWannaRelapseBloc
        .add(KindaWannaUpdateEvent(kindaWannaRelapseModel: model));
  }
}
