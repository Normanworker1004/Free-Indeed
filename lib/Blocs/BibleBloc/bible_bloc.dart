import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../../Models/VerseModel.dart';
import '../../Models/versesCategoryModel.dart';
import '../../Repo/BibleRepo.dart';

part 'bible_event.dart';

part 'bible_state.dart';

class BibleBloc extends Bloc<BibleEvent, BibleState> {
  final BibleRepo bibleRepo;
  String accessToken = "";
  late List<VerseModel> verses;
  late List<VersesCategoriesModel> versesCategories;

  BibleBloc({required this.bibleRepo}) : super(BibleInitial()) {
    on<BibleInitialize>((event, emit) async {
      EasyLoading.show(status: "");
      accessToken = "";

      versesCategories = await bibleRepo.getVersesCategoriesData(accessToken);
      // emit(BibleLoading(categories: versesCategories));
      if (versesCategories.isNotEmpty) {
        versesCategories[0].selected = true;
      } else {
        verses = [];
      }
      EasyLoading.dismiss();
      emit(BibleReadyState(categories: versesCategories));
    });

    on<BibleGetVersesEvent>((event, emit) async {
      emit(BibleLoading(categories: versesCategories));
      // EasyLoading.show(status: "");

      for (int i = 0; i < versesCategories.length; i++) {
        if ((versesCategories[i].id!).compareTo(event.categoriesModel.id!) ==
            0) {
          versesCategories[i].selected = true;
        } else {
          versesCategories[i].selected = false;
        }
      }

      await Future.delayed(Duration(milliseconds: 100));
      emit(BibleReadyState(categories: versesCategories));
    });
  }

  Future<List<VerseModel>> getNextVerses(
      {required int pageNumber,
      required VersesCategoriesModel categoryId}) async {
    return await bibleRepo.getVersesData(
        accessToken: accessToken,
        pageNumber: pageNumber.toString(),
        categoryId: categoryId.id!);
  }
}
