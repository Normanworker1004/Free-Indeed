import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:free_indeed/Blocs/KindaWannaRelapseResultsBloc/kinda_wanna_relapse_bloc.dart';
import 'package:free_indeed/Managers/Implementation/named_navigator_impl.dart';
import 'package:free_indeed/Models/KindaWannaRelapseModel.dart';
import 'package:free_indeed/Repo/kindaWannaRelapseRepo.dart';
import 'package:free_indeed/Screens/commons/LoadingState.dart';
import 'package:free_indeed/Screens/iKindaWannaRelapseScreen/KindaWannaRelapseInfiniteList.dart';
import 'package:free_indeed/configs/general_configs.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class CloseCallsScreen extends StatefulWidget {
  const CloseCallsScreen({Key? key}) : super(key: key);

  @override
  State<CloseCallsScreen> createState() => _CloseCallsScreenState();
}

class _CloseCallsScreenState extends State<CloseCallsScreen> {
  PagingController<int, KindaWannaRelapseModel> _pagingController =
      PagingController(firstPageKey: 1);
  KindaWannaRelapseBloc _kindaWannaRelapseBloc = KindaWannaRelapseBloc(
      kindaWannaRelapseRepo: KindaWannaRelapseRepo(),
      namedNavigator: NamedNavigatorImpl());

  @override
  void initState() {
    _kindaWannaRelapseBloc.add(KindaWannaInitializeEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (BuildContext context) {
          return _kindaWannaRelapseBloc;
        },
        child: BlocConsumer<KindaWannaRelapseBloc, KindaWannaRelapseState>(
            listener: (context, state) {
          if (state is KindaWannaReadyState) {
            if (state.refresh) {
              _pagingController.itemList!.clear();
              _pagingController.refresh();
            }
          }
        }, builder: (context, state) {
          if (state is KindaWannaRelapseInitial) {
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
            );
          } else if (state is KindaWannaReadyState) {
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              child: KindaWannaRelapseInfiniteList(
                pagingController: _pagingController,
                kindaWannaRelapseBloc: _kindaWannaRelapseBloc,
                deleteKindaRelapse: (KindaWannaRelapseModel model, int index) {
                  _kindaWannaRelapseBloc.add(KindaWannaDeleteEvent(
                      kindaWannaRelapseModel: model,
                      index: index,
                      allRelapses: _pagingController.itemList!));
                },
                fetchData: (int pageNumber) async {
                  List<KindaWannaRelapseModel> kindaRelapses =
                      await _kindaWannaRelapseBloc
                          .getNextKindaRelapses(pageNumber);
                  final isLastPage =
                      kindaRelapses.length < GeneralConfigs.PAGE_LIMIT;
                  if (isLastPage) {
                    _pagingController.appendLastPage(kindaRelapses);
                    _pagingController.itemList =
                        _pagingController.itemList?.toSet().toList();
                  } else {
                    final nextPageKey = pageNumber + 1;
                    _pagingController.appendPage(kindaRelapses, nextPageKey);
                    _pagingController.itemList =
                        _pagingController.itemList?.toSet().toList();
                  }
                },
              ),
            );
            // }
          } else if (state is KindaWannaLoadingState) {
            return LoadingState();
          } else {
            return Container();
          }
        }));
  }
}
