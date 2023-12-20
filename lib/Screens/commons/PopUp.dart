import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:free_indeed/configs/ScreenConfig.dart';
import 'package:free_indeed/configs/general_configs.dart';

class PopUp extends StatefulWidget {
  final List<Widget> _body;

  const PopUp({
    Key? key,
    required String title,
    required BuildContext context,
    required List<Widget> body,
    bool implicitDismiss = true,
  })  : _body = body,
        super(key: key);

  @override
  State<PopUp> createState() => _PopUpState();
}

class _PopUpState extends State<PopUp> {
  bool initialize = false;

  @override
  Widget build(BuildContext context) {
    if (!initialize) {
      widget._body.insert(
          0,
          Padding(
            padding: EdgeInsets.only(top: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: SvgPicture.asset(
                        GeneralConfigs.ICONS_PATH + "popUpClose.svg"))
              ],
            ),
          ));
      initialize = true;
    }
    return Center(
        child: Container(
      margin: EdgeInsets.symmetric(
          horizontal: ScreenConfig.screenWidth * 0.1),
      decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          )),
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: ScreenConfig.screenWidth * 0.1),
        decoration: BoxDecoration(
            color: GeneralConfigs.POP_UP_BACKGROUND_COLOR.withOpacity(0.2),
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            )),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: widget._body,
        ),
      ),
    ));
  }
}
