import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:free_indeed/Managers/named-navigator.dart';
import 'package:free_indeed/Models/IRelapsedModel.dart';
import 'package:free_indeed/Repo/StatsRepo.dart';
import 'package:free_indeed/Screens/iRelapsedScreen/iRelapsedScreen.dart';

part 'get_relapses_event.dart';

part 'get_relapses_state.dart';

class GetRelapsesBloc extends Bloc<GetRelapsesEvent, GetRelapsesState> {
  final NamedNavigator _namedNavigator;
  final RelapsedAndStatsRepo _relapsedAndStatsRepo;
  late String accessToken;
  late List<List<IRelapsedModel>> relapses;

  GetRelapsesBloc({
    required NamedNavigator namedNavigator,
    required RelapsedAndStatsRepo relapsedAndStatsRepo,
  })  : this._namedNavigator = namedNavigator,
        this._relapsedAndStatsRepo = relapsedAndStatsRepo,
        super(GetRelapsesInitial()) {
    on<GetRelapseInitializeEvent>((event, emit) async {
      EasyLoading.show(status: "");
      accessToken = "";
      relapses = await _relapsedAndStatsRepo.getMyRelapses(accessToken);
      EasyLoading.dismiss();
      emit(GetRelapsesReadyState(relapses: relapses));
    });
    on<GetRelapseDeleteRelapseEvent>((event, emit) async {
      bool success = await _relapsedAndStatsRepo.deleteRelapse(
          accessToken, event.iRelapsedModel!.id!);
      if (success) {
        emit(GetRelapsesLoadingState());
        relapses = await _relapsedAndStatsRepo.getMyRelapses(accessToken);
        emit(GetRelapsesReadyState(relapses: relapses));
      } else {
        EasyLoading.showToast("Something went wrong .. please try again later");
      }
    });
    on<GetRelapseOpenRelapseEvent>((event, emit) async {
      emit(GetRelapsesLoadingState());
      EasyLoading.show(status: "");
      await _namedNavigator.push(Routes.I_RELAPSED_ROUTER,
          arguments: IRelapsedArgs(
              isEditing: true,
              iRelapsedModel: event.iRelapsedModel,
              editRelapse: (IRelapsedModel model) {
                editRelapse(model);
              }));
      EasyLoading.dismiss();
      emit(GetRelapsesReadyState(relapses: relapses));
    });
  }

  void editRelapse(IRelapsedModel model) async {
    bool success = await _relapsedAndStatsRepo.editRelapse(
        accessToken, model.toJson(), model.id!);
    if (success) {
      relapses = await _relapsedAndStatsRepo.getMyRelapses(accessToken);
      _namedNavigator.pop();
    } else {
      EasyLoading.showToast("Something went wrong .. please try again later");
    }
  }
}
