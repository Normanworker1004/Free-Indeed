import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:free_indeed/Blocs/JournalsBloc/journals_bloc.dart';
import 'package:free_indeed/Managers/Implementation/named_navigator_impl.dart';
import 'package:free_indeed/Managers/named-navigator.dart';
import 'package:free_indeed/Models/JournalModel.dart';
import 'package:free_indeed/Repo/journalsRepo.dart';
import 'package:free_indeed/Screens/MyJournalScreen/JournalsListComponent.dart';
import 'package:free_indeed/Screens/commons/BackButtonComponent.dart';
import 'package:free_indeed/configs/general_configs.dart';
import 'package:free_indeed/localization/localization.dart';
import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class MyJournalsScreen extends StatefulWidget {
  const MyJournalsScreen({Key? key}) : super(key: key);

  @override
  _MyJournalsScreenState createState() => _MyJournalsScreenState();
}

class _MyJournalsScreenState extends State<MyJournalsScreen> {
  NamedNavigator namedNavigator = NamedNavigatorImpl();
  PagingController<int, JournalModel> _pagingController =
      PagingController(firstPageKey: 1);

  JournalsBloc _journalsBloc = JournalsBloc(
      namedNavigator: NamedNavigatorImpl(), journalsRepo: JournalsRepo());

  @override
  void initState() {
    _journalsBloc.add(JournalInitialEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) {
        return _journalsBloc;
      },
      child: BlocBuilder<JournalsBloc, JournalsState>(
        builder: (context, state) {
          if (state is JournalReadyState) {
            if (state.refresh) {
              // _pagingController.itemList!.clear();
              _pagingController = PagingController(firstPageKey: 1);
            }
            return Scaffold(
                appBar: AppBar(
                  backgroundColor: GeneralConfigs.BACKGROUND_COLOR,
                  leading: FreeIndeedBackButton(),
                  centerTitle: true,
                  title: Text(
                    AppLocalization.of(context)!
                        .getLocalizedText("my_journal_screen_title"),
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                backgroundColor: GeneralConfigs.BACKGROUND_COLOR,
                body: JournalInfiniteList(
                  pagingController: _pagingController,
                  fetchData: (int pageNumber) async {
                    // context
                    //     .read<JournalsBloc>()
                    //     .add(GetNextJournalsEvent(pageNumber: pageNumber));
                    // await Future.delayed(Duration(seconds: 1));
                    List<JournalModel> journals =
                        await _journalsBloc.getNextJournals(pageNumber);
                    final isLastPage =
                        journals.length < GeneralConfigs.PAGE_LIMIT;
                    if (isLastPage) {
                      _pagingController.appendLastPage(journals);
                      _pagingController.itemList =
                          _pagingController.itemList?.toSet().toList();
                    } else {
                      final nextPageKey = pageNumber + 1;
                      _pagingController.appendPage(journals, nextPageKey);
                      _pagingController.itemList =
                          _pagingController.itemList?.toSet().toList();
                    }
                  },
                  journalBloc: _journalsBloc,
                ),
                floatingActionButton: FloatingActionButton(
                  onPressed: () {
                    _goToCreateJournal();
                  },
                  backgroundColor: GeneralConfigs.FLOATING_BUTTON_COLOR,
                  child: SvgPicture.asset(
                    GeneralConfigs.ICONS_PATH + "addJournalIcon.svg",
                    width: 20,
                    height: 20,
                    color: Colors.white,
                    fit: BoxFit.fill,
                  ),
                ));
          } else {
            return Scaffold(
                appBar: AppBar(
                  backgroundColor: GeneralConfigs.BACKGROUND_COLOR,
                  leading: FreeIndeedBackButton(),
                  centerTitle: true,
                  title: Text(
                    AppLocalization.of(context)!
                        .getLocalizedText("my_journal_screen_title"),
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                backgroundColor: GeneralConfigs.BACKGROUND_COLOR,
                body: Container());
          }
        },
      ),
    );
  }

  void _goToCreateJournal() {
    _pagingController.dispose();
    _pagingController = PagingController(firstPageKey: 1);
    _journalsBloc.add(CreateJournalEvent());
  }
}
