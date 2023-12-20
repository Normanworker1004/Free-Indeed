
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:free_indeed/Managers/Implementation/Local-data-manager.impl.dart';
import 'package:free_indeed/Managers/LocalDataManager.dart';
import 'package:free_indeed/Managers/named-navigator.dart';
import 'package:free_indeed/Models/IRelapsedModel.dart';
import 'package:free_indeed/Models/iRelapsedTileObject.dart';
import 'package:free_indeed/Models/triggerModel.dart';
import 'package:free_indeed/Repo/StatsRepo.dart';

part 'irelapsed_event.dart';

part 'irelapsed_state.dart';

class IrelapsedBloc extends Bloc<IrelapsedEvent, IrelapsedState> {
  final NamedNavigator _namedNavigator;
  final RelapsedAndStatsRepo _relapsedRepo;
  List<IRelapsedTileObject> relapseList = [];
  List<TriggerObject> triggersList = [];
  late String accessToken;

  IrelapsedBloc(
      {required NamedNavigator namedNavigator,
      required RelapsedAndStatsRepo relapsedAndStatsRepo})
      : this._relapsedRepo = relapsedAndStatsRepo,
        this._namedNavigator = namedNavigator,
        super(IrelapsedInitial()) {
    on<IRelapsedInitialEvent>((event, emit) async {
      EasyLoading.show(status: "");
      accessToken =
           LocalDataManagerImpl().readString(CachingKey.ACCESS_TOKEN);
      relapseList = await _relapsedRepo.getRelapsesData(accessToken);

      triggersList = await _relapsedRepo.getTriggersData(accessToken);
      EasyLoading.dismiss();
      emit(IRelapsedReadyState(
          relapsesList: relapseList, triggersList: triggersList));
    });
    on<SubmitRelapseEvent>((event, emit) async {
      EasyLoading.show(status: "");
      bool success = await _relapsedRepo.submitRelapse(
          accessToken, event.iRelapsedTileObject!.toJson());
      if (success) {
        EasyLoading.dismiss();
        _namedNavigator.pop();
      } else {
        EasyLoading.dismiss();
        EasyLoading.showToast("Something went wrong .. please try again later");
      }
    });
  }
}
