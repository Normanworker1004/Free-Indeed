import 'package:flutter/material.dart';

import '../../localization/localization.dart';

class TabBarWidget extends StatelessWidget {
  final Color color;
  final String textKey;

  const TabBarWidget({Key? key, required this.color, required this.textKey})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Tab(
      child: Text(
        AppLocalization.of(context)!.getLocalizedText(textKey),
        style:
            TextStyle(color: color, fontSize: 14, fontWeight: FontWeight.w500),
      ),
    );
  }
}
