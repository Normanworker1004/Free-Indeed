import 'package:free_indeed/Models/BlogPreviewModel.dart';
import 'package:free_indeed/configs/ScreenConfig.dart';
import 'package:free_indeed/configs/general_configs.dart';
import 'package:free_indeed/localization/localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../Blocs/LibraryBloc/library_bloc.dart';
import 'NoBlogsYetScreen.dart';

class MoreTabScreen extends StatefulWidget {
  final List<BlogPreviewModel> blogs;
  final LibraryBloc libraryBloc;

  const MoreTabScreen(
      {Key? key, required this.libraryBloc, required this.blogs})
      : super(key: key);

  @override
  State<MoreTabScreen> createState() => _MoreTabScreenState();
}

class _MoreTabScreenState extends State<MoreTabScreen> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              widget.libraryBloc.add(LibrarySubmitBlogEvent());
            },
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    GeneralConfigs.ICONS_PATH + "addJournalIcon.svg",
                    width: 30,
                    height: 30,
                    color: Colors.white,
                    fit: BoxFit.fill,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    AppLocalization.of(context)!
                        .getLocalizedText("library_screen_more_tab_submit"),
                    style: TextStyle(
                        color: GeneralConfigs.SECONDARY_COLOR,
                        fontSize: 18,
                        fontWeight: FontWeight.w400),
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          widget.blogs.isEmpty
              ? BlogsEmptyState()
              : Flexible(
                  child: ListView.builder(
                    itemCount: widget.blogs.length,
                    // shrinkWrap: true,
                    // physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          widget.libraryBloc.add(LibraryGoToUserBlogEvent(
                              id: widget.blogs[index].id!));
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 6),
                          child: blogTile(context, widget.blogs[index], () {
                            widget.libraryBloc.add(LibraryGoToUserBlogEvent(
                                id: widget.blogs[index].id!));
                          }),
                        ),
                      );
                    },
                  ),
                ),
        ],
      ),
    );
  }

  Widget blogTile(BuildContext context, BlogPreviewModel blog, Function onTap) {
    return Container(
      padding: EdgeInsets.all(14),
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(6)),
        border:
            Border.all(color: GeneralConfigs.COMMUNITY_CARD_BACKGROUND_COLOR),
        color: GeneralConfigs.COMMUNITY_CARD_BACKGROUND_COLOR,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: 65,
            width: 65,
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              child: Image.network(
                blog.imageURL!,
                fit: BoxFit.fitHeight,
                loadingBuilder: (BuildContext context, Widget child,
                    ImageChunkEvent? loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                      color: GeneralConfigs.SECONDARY_COLOR,
                    ),
                  );
                },
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: ScreenConfig.screenWidth - 160,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 9.0, vertical: 2),
                  child: Text(
                    blog.blogName!,
                    maxLines: 2,
                    style: TextStyle(
                        fontSize: 16,
                        color: GeneralConfigs.SECONDARY_COLOR,
                        fontWeight: FontWeight.w400),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 9.0, vertical: 6),
                child: Text(
                  // DateFormat('MM/dd/yyyy')
                  //     .format(DateTime.parse(blog.timeStamp!)),
                  blog.timeStampNew ?? "",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: 14,
                      color: GeneralConfigs.BLOG_PREVIEW_TIMESTAMP_COLOR,
                      fontWeight: FontWeight.w400),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
