import 'package:flutter/cupertino.dart';
import 'package:free_indeed/Blocs/BibleBloc/bible_bloc.dart';

import '../../../Models/versesCategoryModel.dart';
import '../../../configs/ScreenConfig.dart';
import '../../../configs/general_configs.dart';
import '../../../localization/localization.dart';
import 'BibleTile.dart';

class BibleCategoriesList extends StatefulWidget {
  final ScrollController scrollController;
  final List<VersesCategoriesModel> versesCategories;
  final Function setCategory;
  final BibleBloc bibleBloc;

  const BibleCategoriesList(
      {Key? key,
      required this.scrollController,
      required this.setCategory,
      required this.bibleBloc,
      required this.versesCategories})
      : super(key: key);

  @override
  State<BibleCategoriesList> createState() => _BibleCategoriesListState();
}

class _BibleCategoriesListState extends State<BibleCategoriesList> {
  VersesCategoriesModel? selectedCategory;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: ScreenConfig.screenWidth,
          height: ScreenConfig.screenHeight / 6,
          child: ListView.builder(
            itemCount: widget.versesCategories.length,
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            controller: widget.scrollController,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  // _selectEmotionCategoryIndex(widget.versesCategories[index]);
                  widget.setCategory(index);
                  selectedCategory = widget.versesCategories[index];
                },
                child: BibleTile(
                  iconPath: widget.versesCategories[index].categoryLogo!,
                  text: widget.versesCategories[index].categoryName!,
                  tileColor: widget.versesCategories[index].selected!
                      ? GeneralConfigs.SECONDARY_COLOR
                      : GeneralConfigs.BACKGROUND_COLOR,
                  textColor: widget.versesCategories[index].selected!
                      ? GeneralConfigs.BACKGROUND_COLOR
                      : GeneralConfigs.SECONDARY_COLOR,
                ),
              );
            },
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            AppLocalization.of(context)!
                .getLocalizedText("library_screen_bible_tab_title"),
            style: TextStyle(
                color: GeneralConfigs.SECONDARY_COLOR,
                fontSize: 16,
                fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }
}
