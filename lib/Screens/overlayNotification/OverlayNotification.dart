import 'package:flutter/cupertino.dart';
import 'package:free_indeed/configs/general_configs.dart';

class OverlayNotification extends StatelessWidget {
  final String title;

  const OverlayNotification({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(color: GeneralConfigs.SECONDARY_COLOR, fontSize: 12),
    );
  }
}
