import 'package:flutter/material.dart';
import 'package:free_indeed/Blocs/KindaWannaRelapseResultsBloc/kinda_wanna_relapse_bloc.dart';
import 'package:free_indeed/Models/KindaWannaRelapseModel.dart';
import 'package:free_indeed/Screens/iKindaWannaRelapseScreen/KindaWannaRelapseListTile.dart';
import 'package:free_indeed/configs/general_configs.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class KindaWannaRelapseInfiniteList extends StatefulWidget {
  final KindaWannaRelapseBloc kindaWannaRelapseBloc;
  final Function deleteKindaRelapse;
  final Function fetchData;
  final PagingController<int, KindaWannaRelapseModel> pagingController;

  const KindaWannaRelapseInfiniteList(
      {Key? key,
      required this.fetchData,
      required this.pagingController,
      required this.deleteKindaRelapse,
      required this.kindaWannaRelapseBloc})
      : super(key: key);

  @override
  State<KindaWannaRelapseInfiniteList> createState() =>
      _KindaWannaRelapseInfiniteListState();
}

class _KindaWannaRelapseInfiniteListState
    extends State<KindaWannaRelapseInfiniteList> {
  @override
  void initState() {
    widget.pagingController.addPageRequestListener((pageKey) {
      widget.fetchData(pageKey);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: PagedListView<int, KindaWannaRelapseModel>(
        pagingController: widget.pagingController,
        physics: NeverScrollableScrollPhysics(),
        builderDelegate: PagedChildBuilderDelegate<KindaWannaRelapseModel>(
          noItemsFoundIndicatorBuilder: (context) {
            return Padding(
              padding: EdgeInsets.only(top: 20.0),
              child: Center(
                child: Text(
                  "No close calls submitted yet",
                  style: TextStyle(
                      color: GeneralConfigs.SECONDARY_COLOR, fontSize: 14),
                ),
              ),
            );
          },
          itemBuilder: (context, item, index) => Padding(
            padding: EdgeInsets.symmetric(vertical: 5),
            child: KindaWannaRelapseListTile(
                kindaRelapses: item,
                title: "Report " + (index + 1).toString(),
                openRelapse: () {
                  widget.kindaWannaRelapseBloc.add(
                      KindaWannaOpenEditEvent(kindaWannaRelapseModel: item));
                },
                deleteRelapse: () {
                  widget.deleteKindaRelapse(item, index);
                }),
          ),
        ),
        // shrinkWrap: true,
      ),
    );
  }
}
