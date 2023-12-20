import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:free_indeed/Managers/named-navigator.dart';
import 'package:free_indeed/Models/JournalModel.dart';
import 'package:free_indeed/Repo/journalsRepo.dart';
import 'package:free_indeed/Screens/MyJournalScreen/NewJournalScreen.dart';

part 'journals_event.dart';

part 'journals_state.dart';

class JournalsBloc extends Bloc<JournalsEvent, JournalsState> {
  final JournalsRepo _journalsRepo;
  late String accessToken;

  JournalsBloc({
    required NamedNavigator namedNavigator,
    required JournalsRepo journalsRepo,
  })  : this._journalsRepo = journalsRepo,
        super(JournalsInitial()) {
    on<JournalInitialEvent>((event, emit) async {
      accessToken = "";
      emit(JournalReadyState(refresh: false));
    });

    on<CreateJournalEvent>((event, emit) async {
      emit(JournalsLoading());
      await namedNavigator.push(Routes.CREATE_JOURNAL_ROUTER,
          arguments: CreateNewPostArgs(
              submitFunction: (String val) async {
                EasyLoading.show(status: '');
                bool success = await _journalsRepo.addJournal(accessToken, val);
                if (success) {
                  namedNavigator.pop();
                  EasyLoading.dismiss();
                } else {
                  EasyLoading.showToast(
                      "Something went wrong .. please try again later");
                }
              },
              titleKey: "create_journal_screen_title",
              isJournal: true));
      EasyLoading.dismiss();
      emit(JournalReadyState(refresh: true));
    });
    on<UpdateJournalEvent>((event, emit) async {
      emit(JournalsLoading());
      await namedNavigator.push(Routes.CREATE_JOURNAL_ROUTER,
          arguments: CreateNewPostArgs(
              submitFunction: (String val) async {
                EasyLoading.show(status: '');
                bool success = await _journalsRepo.editJournal(
                    accessToken, val, event.journal.id.toString());
                if (success) {
                  namedNavigator.pop();
                  EasyLoading.dismiss();
                } else {
                  EasyLoading.showToast(
                      "Something went wrong .. please try again later");
                }
              },
              initialText: event.journal.journalText,
              titleKey: "create_journal_screen_title",
              isJournal: true));
      EasyLoading.dismiss();
      emit(JournalReadyState(refresh: true));
    });
    on<DeleteJournalEvent>((event, emit) async {
      // EasyLoading.show(status: '');
      emit(JournalsLoading());
      bool success =
          await _journalsRepo.deleteJournal(accessToken, event.journalId);
      if (success) {
        // EasyLoading.dismiss();
        emit(JournalReadyState(refresh: true));
      } else {
        EasyLoading.showToast("Something went wrong .. please try again later");
      }
    });
  }

  Future<List<JournalModel>> getNextJournals(int pageNumber) async {
    return await _journalsRepo.getMyJournals(accessToken, pageNumber);
  }
}
