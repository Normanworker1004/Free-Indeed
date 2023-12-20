import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../Models/NotificationModel.dart';
import '../../../configs/ScreenConfig.dart';
import '../../../configs/general_configs.dart';
import 'NotificationMenu.dart';

class NotificationButton extends StatefulWidget {
  final PagingController<int, NotificationModel> pagingController;
  final Function fetchData;
  final bool hasNotifications;

  const NotificationButton(
      {Key? key,
      required this.pagingController,
      required this.fetchData,
      required this.hasNotifications})
      : super(key: key);

  @override
  State<NotificationButton> createState() => _NotificationButtonState();
}

class _NotificationButtonState extends State<NotificationButton> {
  String userHasNotification = "";

  @override
  void initState() {
    userHasNotification = widget.hasNotifications
        ? "notificationIcon.svg"
        : "notificationNoNotificationIcon.svg";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPopupMenu(
      showArrow: true,
      arrowSize: 15,
      position: PreferredPosition.bottom,
      menuBuilder: () {
        return SizedBox(
          width: ScreenConfig.screenWidth * 0.65,
          height: ScreenConfig.screenHeight / 2,
          child: ClipRRect(
            clipBehavior: Clip.antiAlias,
            borderRadius: BorderRadius.circular(6.0),
            child: NotificationMenu(
              pagingController: widget.pagingController,
              fetchData: (int pageNumber) async {
                await widget.fetchData(pageNumber);
              },
            ),
          ),
        );
      },
      pressType: PressType.singleClick,
      child: SvgPicture.asset(
        GeneralConfigs.ICONS_PATH + userHasNotification,
        height: 24,
        width: 24,
        fit: BoxFit.scaleDown,
      ),
    );
  }
}
