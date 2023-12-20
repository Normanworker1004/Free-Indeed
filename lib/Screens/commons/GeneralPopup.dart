import 'package:flutter/widgets.dart';
import 'package:free_indeed/Screens/commons/PopUp.dart';
import 'package:free_indeed/localization/localization.dart';

class GeneralPopup extends StatelessWidget {
  final List<Widget>? _parameters;

  const GeneralPopup({
    Key? key,
    required List<Widget>? parameters,
  })  : _parameters = parameters,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopUp(
      title: AppLocalization.of(context)!.getLocalizedText(""),
      context: context,
      implicitDismiss: false,
      body: _parameters!,
    );
  }
}
