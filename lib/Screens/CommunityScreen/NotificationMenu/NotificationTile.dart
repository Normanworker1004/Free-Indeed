import 'package:flutter/material.dart';
import 'package:free_indeed/Models/NotificationModel.dart';
import 'package:free_indeed/configs/general_configs.dart';

class NotificationTile extends StatelessWidget {
  final NotificationModel notification;

  const NotificationTile({Key? key, required this.notification})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: GeneralConfigs.BLOG_PREVIEW_BORDER_COLOR,
      padding: EdgeInsets.only(left: 10, right: 10, top: 5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 3),
            child: Text(
              notification.notificationText != null
                  ? notification.notificationText!
                  : "",
              style: TextStyle(
                  color: GeneralConfigs.SECONDARY_COLOR, fontSize: 14),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 5),
            child: Text(
              notification.timeStampNew ?? "",
              style: TextStyle(
                  color: GeneralConfigs.POST_TIME_STAMP_COLOR, fontSize: 12),
            ),
          ),
          Divider(
            color: GeneralConfigs.COMMUNITY_CARD_BACKGROUND_COLOR,
            thickness: 1,
            height: 3,
          )
        ],
      ),
    );
  }
}
