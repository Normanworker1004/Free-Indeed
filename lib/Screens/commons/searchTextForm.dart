import 'package:free_indeed/configs/general_configs.dart';
import 'package:free_indeed/localization/localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SearchTextForm extends StatefulWidget {
  final String labelKey;
  final Function searchFunction;
  final TextEditingController controller;

  const SearchTextForm(
      {Key? key,
      required this.labelKey,
      required this.controller,
      required this.searchFunction})
      : super(key: key);

  @override
  State<SearchTextForm> createState() => _SearchTextFormState();
}

class _SearchTextFormState extends State<SearchTextForm> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: GeneralConfigs.BLACK_BOARDER_COLOR,
          width: 2,
        ),
        borderRadius: BorderRadius.all(Radius.circular(6)),
        color: GeneralConfigs.SECONDARY_COLOR.withOpacity(0.1),
      ),
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: TextFormField(
        controller: widget.controller,
        cursorColor: GeneralConfigs.BOARDER_COLOR,
        onFieldSubmitted: (value) {
          widget.searchFunction();
        },
        style: TextStyle(fontSize: 14, color: GeneralConfigs.SECONDARY_COLOR),
        onChanged: (value) {
          setState(() {
            // userInput.text = value.toString();
          });
        },
        decoration: InputDecoration(
          hintText:
              AppLocalization.of(context)!.getLocalizedText(widget.labelKey),
          hintStyle: TextStyle(
            color: GeneralConfigs.SECONDARY_COLOR,
            fontSize: 17,
            fontWeight: FontWeight.w400,
          ),
          suffixIcon: SvgPicture.asset(
            GeneralConfigs.ICONS_PATH + "searchIcon.svg",
            height: 18,
            width: 18,
            fit: BoxFit.scaleDown,
          ),
          suffixIconColor: GeneralConfigs.BOARDER_COLOR,
          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
