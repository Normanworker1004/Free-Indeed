import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:free_indeed/Blocs/BibleBloc/bible_bloc.dart';
import 'package:free_indeed/Models/VerseModel.dart';
import 'package:free_indeed/Models/versesCategoryModel.dart';
import 'package:free_indeed/Screens/LibraryScreen/VersesListComponent.dart';
import 'package:free_indeed/Screens/LibraryScreen/components/BibleCategoriesList.dart';
import 'package:free_indeed/configs/ScreenConfig.dart';
import 'package:free_indeed/configs/general_configs.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../Repo/BibleRepo.dart';

class BibleScreen extends StatefulWidget {
  final VerseModel? verseOfTheDay;
  final ScrollController scrollController;

  const BibleScreen({
    Key? key,
    this.verseOfTheDay,
    required this.scrollController,
  }) : super(key: key);

  @override
  State<BibleScreen> createState() => _BibleScreenState();
}

class _BibleScreenState extends State<BibleScreen> {
  PagingController<int, VerseModel> _pagingController =
      PagingController(firstPageKey: 1);

  VersesCategoriesModel? selectedCategory;
  BibleBloc _bibleBloc = BibleBloc(bibleRepo: BibleRepo());

  void _selectEmotionCategoryIndex(VersesCategoriesModel model) async {
    _bibleBloc.add(BibleGetVersesEvent(categoriesModel: model));
    _pagingController.dispose();
    _pagingController = PagingController(firstPageKey: 1);
  }

  @override
  void initState() {
    _bibleBloc.add(BibleInitialize());
    super.initState();
  }

  ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        return _bibleBloc;
      },
      child: BlocBuilder<BibleBloc, BibleState>(
        builder: (context, state) {
          if (state is BibleReadyState) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BibleCategoriesList(
                    scrollController: _scrollController,
                    setCategory: (int index) {
                      _selectEmotionCategoryIndex(state.categories[index]);
                      selectedCategory = state.categories[index];
                    },
                    bibleBloc: _bibleBloc,
                    versesCategories: state.categories),
                //TODO: MAY NEED REVISION
                SizedBox(
                  height: ScreenConfig.screenHeight * 0.45,
                  child: VersesInfiniteList(
                      scrollController: widget.scrollController,
                      fetchData: (int pageNumber) async {
                        List<VerseModel> verses =
                            await _bibleBloc.getNextVerses(
                                pageNumber: pageNumber,
                                categoryId:
                                    selectedCategory ?? state.categories[0]);
                        final isLastPage =
                            verses.length < GeneralConfigs.PAGE_LIMIT;
                        if (isLastPage) {
                          _pagingController.appendLastPage(verses);
                        } else {
                          final nextPageKey = pageNumber + 1;
                          _pagingController.appendPage(verses, nextPageKey);
                        }
                      },
                      pagingController: _pagingController),
                )
              ],
            );
          } else if (state is BibleLoading) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BibleCategoriesList(
                    scrollController: _scrollController,
                    setCategory: (int index) {
                      _selectEmotionCategoryIndex(state.categories[index]);
                      selectedCategory = state.categories[index];
                    },
                    bibleBloc: _bibleBloc,
                    versesCategories: state.categories),
              ],
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
