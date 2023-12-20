import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:free_indeed/Blocs/getRelapsesBloc/get_relapses_bloc.dart';
import 'package:free_indeed/Models/IRelapsedModel.dart';
import 'package:free_indeed/configs/ScreenConfig.dart';
import 'package:free_indeed/configs/general_configs.dart';
import 'package:intl/intl.dart';

class RelapsesListTile extends StatefulWidget {
  final List<IRelapsedModel> relapse;
  final String title;
  final GetRelapsesBloc getRelapsesBloc;

  const RelapsesListTile(
      {Key? key,
      required this.relapse,
      required this.title,
      required this.getRelapsesBloc})
      : super(key: key);

  @override
  State<RelapsesListTile> createState() => _RelapsesListTileState();
}

class _RelapsesListTileState extends State<RelapsesListTile> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      clipBehavior: Clip.antiAlias,
      borderRadius: BorderRadius.circular(6.0),
      child: Container(
        color: GeneralConfigs.COMMUNITY_CARD_BACKGROUND_COLOR,
        child: ExpansionTile(
          collapsedBackgroundColor: Colors.transparent,
          iconColor: GeneralConfigs.SECONDARY_COLOR,
          textColor: GeneralConfigs.COMMUNITY_CARD_BACKGROUND_COLOR,
          collapsedIconColor: GeneralConfigs.SECONDARY_COLOR,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                widget.title,
                style: TextStyle(
                    color: GeneralConfigs.SECONDARY_COLOR,
                    fontSize: 15,
                    fontWeight: FontWeight.w500),
              ),
              CircleAvatar(
                radius: 12,
                backgroundColor: GeneralConfigs.SECONDARY_COLOR,
                child: Text(
                  widget.relapse.length.toString(),
                  style: TextStyle(
                      color: GeneralConfigs.BACKGROUND_COLOR, fontSize: 15),
                ),
              ),
            ],
          ),
          //header title
          children: [
            ListView.builder(
              itemCount: widget.relapse.length,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return tileData(
                  context: context,
                  model: widget.relapse[index],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget tileData(
      {required BuildContext context, required IRelapsedModel model}) {
    String triggers = "";
    for (int i = 0; i < model.triggers!.length; i++) {
      triggers = triggers + model.triggers![i].title! + ", ";
    }
    return GestureDetector(
      onTap: () {
        widget.getRelapsesBloc
            .add(GetRelapseOpenRelapseEvent(iRelapsedModel: model));
      },
      onHorizontalDragEnd: (details) {
        if (details.primaryVelocity! < 0 && model.showDelete != null) {
          setState(() {
            model.showDelete = !model.showDelete!;
          });
        }
      },
      child: Container(
        color: GeneralConfigs.BACKGROUND_COLOR,
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    DateFormat('MM/dd/yy')
                        .format(DateTime.parse(model.endDate!)),
                    style: TextStyle(
                        color: GeneralConfigs.SECONDARY_COLOR, fontSize: 14),
                  ),
                  model.showDelete != null && model.showDelete!
                      ? GestureDetector(
                          onTap: () {
                            widget.getRelapsesBloc.add(
                                GetRelapseDeleteRelapseEvent(
                                    iRelapsedModel: model));
                          },
                          child: SvgPicture.asset(
                            GeneralConfigs.ICONS_PATH + "deleteJournal.svg",
                            width: 18,
                            height: 18,
                            color: Colors.red,
                            fit: BoxFit.fill,
                          ),
                        )
                      : Container(),
                ],
              ),
            ),
            Text(
              triggers,
              style: TextStyle(
                  color: GeneralConfigs.RELAPSES_LIST_TEXT_DATA, fontSize: 14),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.notes,
                    color: Colors.white,
                    size: 16,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: SizedBox(
                      width: 2 * ScreenConfig.screenWidth / 3,
                      child: Text(
                        model.whatHappened!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: GeneralConfigs.RELAPSES_LIST_TEXT_DATA,
                            fontSize: 14),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              thickness: 1,
              color: GeneralConfigs.COMMUNITY_CARD_BACKGROUND_COLOR,
            )
          ],
        ),
      ),
    );
  }
}
