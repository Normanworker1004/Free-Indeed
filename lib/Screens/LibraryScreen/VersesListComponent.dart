import 'package:flutter/material.dart';
import 'package:free_indeed/Models/VerseModel.dart';
import 'package:free_indeed/Screens/LibraryScreen/components/VersesTile.dart';
import 'package:free_indeed/configs/general_configs.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class VersesInfiniteList extends StatefulWidget {
  final Function fetchData;
  final PagingController<int, VerseModel> pagingController;
  final ScrollController scrollController;

  const VersesInfiniteList(
      {Key? key,
      required this.fetchData,
      required this.pagingController,
      required this.scrollController})
      : super(key: key);

  @override
  State<VersesInfiniteList> createState() => _VersesInfiniteListState();
}

class _VersesInfiniteListState extends State<VersesInfiniteList> {
  @override
  void initState() {
    widget.pagingController.addPageRequestListener((pageKey) {
      widget.fetchData(pageKey);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: PagedListView<int, VerseModel>(
          pagingController: widget.pagingController,
          scrollController: widget.scrollController,
          builderDelegate: PagedChildBuilderDelegate<VerseModel>(
            noItemsFoundIndicatorBuilder: (_) => Padding(
              padding: EdgeInsets.only(top: 40.0),
              child: Text(
                "No verses here yet ..",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 15,
                    color: GeneralConfigs.SECONDARY_COLOR),
              ),
            ),
            itemBuilder: (context, item, index) => Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: VersesTile(
                verse: item,
              ),
            ),
          ),
          // shrinkWrap: true,
        ));
  }
}
