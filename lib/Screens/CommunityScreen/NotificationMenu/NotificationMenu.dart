import 'package:flutter/material.dart';
import 'package:free_indeed/Models/NotificationModel.dart';
import 'package:free_indeed/Screens/CommunityScreen/NotificationMenu/NotificationTile.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../configs/ScreenConfig.dart';
import '../../../configs/general_configs.dart';

class NotificationMenu extends StatefulWidget {
  final PagingController<int, NotificationModel> pagingController;
  final Function fetchData;

  const NotificationMenu(
      {required this.pagingController, required this.fetchData, Key? key})
      : super(key: key);

  @override
  State<NotificationMenu> createState() => _NotificationMenuState();
}

class _NotificationMenuState extends State<NotificationMenu> {
  @override
  void initState() {
    widget.pagingController.addPageRequestListener((pageKey) {
      widget.fetchData(pageKey);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PagedListView<int, NotificationModel>(
      pagingController: widget.pagingController,
      padding: EdgeInsets.zero,
      builderDelegate: PagedChildBuilderDelegate<NotificationModel>(
        noItemsFoundIndicatorBuilder: (_) => Container(
          color: GeneralConfigs.BLOG_PREVIEW_BORDER_COLOR,
          width: ScreenConfig.screenWidth * 0.65,
          height: ScreenConfig.screenHeight / 2,
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 3),
            child: Center(
              child: Text(
                "No Notifications. Yet!",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: GeneralConfigs.SECONDARY_COLOR, fontSize: 14),
              ),
            ),
          ),
        ),
        itemBuilder: (context, item, index) =>
            NotificationTile(notification: item),
      ),
    );
  }
}
