import 'package:free_indeed/configs/general_configs.dart';
import 'package:free_indeed/localization/localization.dart';
import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {

  final Function onTap;
  final String buttonText;

  const PrimaryButton({Key? key, required this.onTap, required this.buttonText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            primary: GeneralConfigs.SECONDARY_COLOR,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25.0),
            )),
        onPressed: () {
          onTap();
        },
        child: Text(
          AppLocalization.of(context)!
              .getLocalizedText(buttonText),
          style: TextStyle(
              color: GeneralConfigs.BACKGROUND_COLOR,
              fontSize: 16,
              fontWeight: FontWeight.w500),
        ));
  }
}
