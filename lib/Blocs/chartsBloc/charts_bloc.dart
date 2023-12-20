import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:free_indeed/Models/CleanDayChartModel.dart';
import 'package:free_indeed/Models/RelapsesPerDayChartModel.dart';
import 'package:free_indeed/Models/RelapsesPerMonthChartModel.dart';
import 'package:free_indeed/Models/iRelapsedTileObject.dart';

import '../../Models/TriggersChartModel.dart';
import '../../Repo/StatsRepo.dart';

part 'charts_event.dart';

part 'charts_state.dart';

class ChartsBloc extends Bloc<ChartsEvent, ChartsState> {
  final RelapsedAndStatsRepo _statsRepo;
  late String accessToken;
  late CleanDayChartModel cleanDaysStreak;
  late List<RelapsesPerDayChartModel> relapsesPerDay;
  late List<TriggersChartModel> triggersNumbers;
  late List<RelapsesPerChartModel> relapsesPerMonth;
  late List<IRelapsedTileObject> triggers;

  ChartsBloc({required RelapsedAndStatsRepo relapsedAndStatsRepo})
      : this._statsRepo = relapsedAndStatsRepo,
        super(ChartsInitial()) {
    on<ChartsInitializeEvent>((event, emit) async {
      EasyLoading.show(status: "");
      accessToken = "";
      triggers = await _statsRepo.getRelapsesData(accessToken);
      triggers.insert(
          0,
          IRelapsedTileObject(
              title: "All", selected: false, id: "", machineName: "All"));
      EasyLoading.dismiss();
      emit(ChartsReadyState(triggers: triggers));
    });
    on<ChartsSelectRelapsePerEvent>((event, emit) async {
      emit(ChartsLoadingState());
      EasyLoading.show(status: "");
      relapsesPerMonth = await _statsRepo.getRelapsesPerMonth(
          accessToken: accessToken, id: (event.choice! + 1).toString());
      EasyLoading.dismiss();
      emit(ChartsReadyState(triggers: triggers));
    });
  }

  Future<CleanDayChartModel> getCleanDayChart() async {
    return await _statsRepo.getCleanDaysStreaks(accessToken: accessToken);
  }

  Future<List<RelapsesPerDayChartModel>> getRelapsesPerDayChart() async {
    return await _statsRepo.getRelapsesPerDay(accessToken: accessToken);
  }

  Future<List<TriggersChartModel>> getTriggerChart() async {
    return await _statsRepo.getTriggersChart(accessToken: accessToken);
  }

  Future<List<RelapsesPerChartModel>> getRelapsesPerMonthChart(
      int choice) async {
    return await _statsRepo.getRelapsesPerMonth(
        accessToken: accessToken, id: (choice + 1).toString());
  }
}
