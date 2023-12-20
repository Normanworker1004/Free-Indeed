import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:free_indeed/Blocs/JournalsBloc/journals_bloc.dart';
import 'package:free_indeed/Models/JournalModel.dart';
import 'package:free_indeed/configs/ScreenConfig.dart';
import 'package:free_indeed/configs/general_configs.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart';

class JournalInfiniteList extends StatefulWidget {
  final JournalsBloc journalBloc;
  final Function fetchData;
  final PagingController<int, JournalModel> pagingController;

  const JournalInfiniteList(
      {Key? key,
      required this.journalBloc,
      required this.fetchData,
      required this.pagingController})
      : super(key: key);

  @override
  State<JournalInfiniteList> createState() => _JournalInfiniteListState();
}

class _JournalInfiniteListState extends State<JournalInfiniteList> {
  @override
  void initState() {
    widget.pagingController.addPageRequestListener((pageKey) {
      widget.fetchData(pageKey);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: PagedListView<int, JournalModel>(
          pagingController: widget.pagingController,
          builderDelegate: PagedChildBuilderDelegate<JournalModel>(
            itemBuilder: (context, item, index) => Padding(
              padding: EdgeInsets.symmetric(vertical: 5),
              child: journalsTile(
                journal: item, context: context,
                // addFriend: (FriendModel cognitoId) {
                //   widget.deleteJournal(cognitoId);
                // },
              ),
            ),
          ),
          shrinkWrap: true,
        ));
  }

  Widget journalsTile(
      {required BuildContext context, required JournalModel journal}) {
    return GestureDetector(
      onTap: () {
        widget.journalBloc.add(UpdateJournalEvent(journal: journal));
      },
      onHorizontalDragEnd: (details) {
        if (details.primaryVelocity! < 0 && journal.showDelete != null) {
          setState(() {
            journal.showDelete = !journal.showDelete!;
          });
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: journal.color,
          borderRadius: BorderRadius.all(Radius.circular(6.0)),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 3 * ScreenConfig.screenWidth / 4,
                    child: Text(
                      journal.journalText != null ? journal.journalText! : "",
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: GeneralConfigs.SECONDARY_COLOR, fontSize: 15),
                    ),
                  ),
                  SizedBox(
                    height: 7,
                  ),
                  Text(
                    journal.timeStamp != null
                        ? DateFormat('MM/dd/yy h:mm a')
                            .format(DateTime.parse(journal.timeStamp!))
                        : "",
                    style: TextStyle(
                        color: GeneralConfigs.POST_TIME_STAMP_COLOR,
                        fontSize: 12),
                  ),
                ],
              ),
              journal.showDelete != null && journal.showDelete!
                  ? GestureDetector(
                      onTap: () {
                        widget.journalBloc
                            .add(DeleteJournalEvent(journalId: journal.id!));
                      },
                      child: SvgPicture.asset(
                        GeneralConfigs.ICONS_PATH + "deleteJournal.svg",
                        height: 18,
                        width: 18,
                        fit: BoxFit.scaleDown,
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
