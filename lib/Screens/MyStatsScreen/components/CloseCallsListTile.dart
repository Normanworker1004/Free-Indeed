import 'package:flutter/cupertino.dart';
import 'package:free_indeed/Models/KindaWannaRelapseModel.dart';

class CloseCallsTile extends StatefulWidget {
  final List<KindaWannaRelapseModel> kindaRelapse;
  final String title;
  final Function openRelapse;
  final Function deleteRelapse;

  const CloseCallsTile(
      {Key? key,
      required this.title,
      required this.kindaRelapse,
      required this.openRelapse,
      required this.deleteRelapse})
      : super(key: key);

  @override
  State<CloseCallsTile> createState() => _CloseCallsTileState();
}

class _CloseCallsTileState extends State<CloseCallsTile> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
