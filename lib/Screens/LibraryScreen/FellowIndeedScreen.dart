import 'package:free_indeed/Models/BlogPreviewModel.dart';
import 'package:free_indeed/configs/ScreenConfig.dart';
import 'package:free_indeed/configs/general_configs.dart';
import 'package:flutter/material.dart';

import '../../Blocs/LibraryBloc/library_bloc.dart';

class FellowIndeedTabScreen extends StatefulWidget {
  final List<BlogPreviewModel> blogs;
  final LibraryBloc libraryBloc;

  const FellowIndeedTabScreen(
      {Key? key, required this.blogs, required this.libraryBloc})
      : super(key: key);

  @override
  State<FellowIndeedTabScreen> createState() => _FellowIndeedTabScreenState();
}

class _FellowIndeedTabScreenState extends State<FellowIndeedTabScreen> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: (115) * widget.blogs.length.toDouble(),
            width: ScreenConfig.screenWidth,
            child: GridView.builder(
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 6 / 7,
                  crossAxisSpacing: 10),
              // cacheExtent: 100,
              itemBuilder: (context, index) {
                return GestureDetector(
                    onTap: () {
                      widget.libraryBloc.add(
                          LibraryGoToBlogEvent(id: widget.blogs[index].id!));
                    },
                    child: blogPreviewTile(context, widget.blogs[index]));
              },
              itemCount: widget.blogs.length,
            ),
          ),
        ],
      ),
    );
  }

  Widget blogPreviewTile(BuildContext context, BlogPreviewModel blogPreview) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          child: SizedBox(
            height: ScreenConfig.screenHeight / 6,
            child: Image.network(
              blogPreview.imageURL!,
              fit: BoxFit.cover,
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
        Padding(
          padding: EdgeInsets.only(left: 9.0, right: 9, top: 12),
          child: Text(
            blogPreview.blogName!,
            maxLines: 2,
            style: TextStyle(
                fontSize: 16,
                color: GeneralConfigs.SECONDARY_COLOR,
                fontWeight: FontWeight.w400),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 9.0, right: 9, top: 6),
          child: Text(
            // DateFormat('MM/dd/yyyy')
            //     .format(DateTime.parse(blogPreview.timeStamp!)),
            blogPreview.timeStampNew ?? "",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                fontSize: 14,
                color: GeneralConfigs.BLOG_PREVIEW_TIMESTAMP_COLOR,
                fontWeight: FontWeight.w400),
          ),
        ),
      ],
    );
  }
}
