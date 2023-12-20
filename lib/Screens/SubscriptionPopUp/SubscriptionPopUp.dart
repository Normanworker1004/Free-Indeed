import 'package:flutter/material.dart';
import 'package:free_indeed/Screens/commons/PrimaryButton.dart';
import 'package:free_indeed/configs/ScreenConfig.dart';
import 'package:free_indeed/configs/general_configs.dart';
import 'package:free_indeed/localization/localization.dart';

class SubscriptionPopUp extends StatefulWidget {
  final Function subscribeFunction;

  const SubscriptionPopUp({Key? key, required this.subscribeFunction})
      : super(key: key);

  @override
  State<SubscriptionPopUp> createState() => _SubscriptionPopUpState();
}

class _SubscriptionPopUpState extends State<SubscriptionPopUp> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          AppLocalization.of(context)!
              .getLocalizedText("subscription_popup_title"),
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
        SizedBox(
          height: 15,
        ),
        Container(
          decoration: BoxDecoration(
              color: GeneralConfigs.POP_UP_BACKGROUND_COLOR.withOpacity(0.3),
              borderRadius: BorderRadius.all(
                Radius.circular(4),
              )),
          padding: EdgeInsets.symmetric(vertical: 11),
          margin: EdgeInsets.symmetric(horizontal: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                AppLocalization.of(context)!
                    .getLocalizedText("subscription_popup_money_part_one"),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                AppLocalization.of(context)!
                    .getLocalizedText("subscription_popup_money_part_two"),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 15,
        ),
        getTextWidget(
            context: context, key: "subscription_popup_body_part_one"),
        getTextWidget(
            context: context, key: "subscription_popup_body_part_two"),
        getTextWidget(
            context: context, key: "subscription_popup_body_part_three"),
        Container(
          margin: EdgeInsets.symmetric(
            vertical: 15,
          ),
          width: ScreenConfig.screenWidth / 2,
          child: SizedBox(
            height: 48,
            child: PrimaryButton(
                onTap: widget.subscribeFunction,
                buttonText: "subscription_popup_subscribe_button"),
          ),
        ),
        SizedBox(
          height: 15,
        ),
      ],
    );
  }

  Widget getTextWidget({required BuildContext context, required String key}) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.only(top: 10, bottom: 10),
          child: Text(
            AppLocalization.of(context)!.getLocalizedText(key),
            textAlign: TextAlign.center,
            style: TextStyle(
                color: GeneralConfigs.SECONDARY_COLOR,
                fontSize: 15,
                fontWeight: FontWeight.w400),
          ),
        ),
        Container(
            margin: EdgeInsets.symmetric(horizontal: 35),
            child: Divider(
              color: GeneralConfigs.POP_UP_DIVIDER_COLOR.withOpacity(0.2),
              thickness: 1,
            ))
      ],
    );
  }
}
