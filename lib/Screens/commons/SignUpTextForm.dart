import 'package:free_indeed/configs/general_configs.dart';
import 'package:free_indeed/localization/localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SignUpTextFormField extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final bool showIcon;
  final Function? iconFunction;
  final bool? obscure;

  const SignUpTextFormField(
      {Key? key,
      required this.label,
      required this.controller,
      required this.showIcon,
      this.obscure,
      this.iconFunction})
      : super(key: key);

  @override
  State<SignUpTextFormField> createState() => _SignUpTextFormFieldState();
}

class _SignUpTextFormFieldState extends State<SignUpTextFormField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 4),
            child: Text(
              AppLocalization.of(context)!.getLocalizedText(widget.label),
              style: TextStyle(color: GeneralConfigs.LABEL_COLOR, fontSize: 14),
            ),
          ),
          Container(
            decoration: BoxDecoration(
                border: Border.all(color: GeneralConfigs.LABEL_COLOR),
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                )),
            child: TextFormField(
              controller: widget.controller,
              cursorColor: GeneralConfigs.BOARDER_COLOR,
              style: TextStyle(fontSize: 14, color: Colors.black),
              onChanged: (value) {
                setState(() {
                  // userInput.text = value.toString();
                });
              },
              obscureText: widget.obscure ?? false,
              decoration: InputDecoration(
                suffixIcon: widget.showIcon
                    ? GestureDetector(
                        onTap: () {
                          setState(() {
                            widget.iconFunction!();
                          });
                        },
                        child: SvgPicture.asset(
                          GeneralConfigs.ICONS_PATH + "showPassword.svg",
                          height: 18,
                          width: 18,
                          fit: BoxFit.scaleDown,
                        ),
                      )
                    : SizedBox(
                        width: 1,
                        height: 1,
                      ),
                focusColor: Colors.white,
                fillColor: Colors.white,
                suffixIconColor: GeneralConfigs.BOARDER_COLOR,
                contentPadding: EdgeInsets.symmetric(horizontal: 20),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(
                      color: GeneralConfigs.BOARDER_COLOR.withOpacity(0.8)),
                  // borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
