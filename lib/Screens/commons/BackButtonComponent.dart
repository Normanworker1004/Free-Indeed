import 'package:flutter/material.dart';

import '../../configs/general_configs.dart';

class FreeIndeedBackButton extends StatelessWidget {
  const FreeIndeedBackButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Row(children: [
        SizedBox(
            width: 24,
            child: BackButton(
              color: GeneralConfigs.SECONDARY_COLOR,
            )),
        Text("Back",
            style:
                TextStyle(fontSize: 14, color: GeneralConfigs.SECONDARY_COLOR)),
      ]),
    );
  }
}
