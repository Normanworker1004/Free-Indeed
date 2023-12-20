import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:free_indeed/Managers/Implementation/Local-data-manager.impl.dart';
import 'package:free_indeed/Managers/LocalDataManager.dart';
import 'package:free_indeed/Managers/named-navigator.dart';
import 'package:free_indeed/Models/KindaWannaRelapseModel.dart';
import 'package:free_indeed/Screens/iKindaWannaRelapseScreen/iKindaWannaRelapnseScreen.dart';

import '../../Repo/kindaWannaRelapseRepo.dart';

part 'kinda_wanna_relapse_event.dart';

part 'kinda_wanna_relapse_state.dart';

class KindaWannaRelapseBloc
    extends Bloc<KindaWannaRelapseEvent, KindaWannaRelapseState> {
  final KindaWannaRelapseRepo kindaWannaRelapseRepo;
  final NamedNavigator namedNavigator;
  late String accessToken;

  KindaWannaRelapseBloc(
      {required this.kindaWannaRelapseRepo, required this.namedNavigator})
      : super(KindaWannaRelapseInitial()) {
    on<KindaWannaInitializeEvent>((event, emit) async {
      accessToken = "";
      emit(KindaWannaReadyState(refresh: false));
    });
    on<KindaWannaInitializeSubmitEvent>((event, emit) async {
      accessToken = LocalDataManagerImpl().readString(CachingKey.ACCESS_TOKEN);
      emit(KindaWannaSubmissionReadyState());
    });
    on<KindaWannaCreateEvent>((event, emit) async {
      EasyLoading.show(status: "");
      bool success = await kindaWannaRelapseRepo.addKindaRelapse(
          accessToken, event.kindaWannaRelapseModel);
      if (success) {
        EasyLoading.dismiss();
        // EasyLoading.showToast("Kinda wanna relapse submitted successfully");
        namedNavigator.pop();
      } else {
        EasyLoading.dismiss();
        // EasyLoading.showToast("Kinda wanna relapse submitted successfully");
      }
    });
    on<KindaWannaUpdateEvent>((event, emit) async {
      EasyLoading.show(status: "");
      bool success = await kindaWannaRelapseRepo.editKindaRelapse(accessToken,
          event.kindaWannaRelapseModel, event.kindaWannaRelapseModel.id!);
      if (success) {
        EasyLoading.dismiss();
        // EasyLoading.showToast("Kinda wanna relapse edited successfully");
        namedNavigator.pop();
      } else {
        EasyLoading.dismiss();
        EasyLoading.showToast("Something went wrong");
      }
    });
    on<KindaWannaDeleteEvent>((event, emit) async {
      EasyLoading.show(status: "");
      bool success = await kindaWannaRelapseRepo.deleteKindaRelapse(
          accessToken, event.kindaWannaRelapseModel.id!);
      if (success) {
        EasyLoading.dismiss();
        emit(KindaWannaRelapseInitial());
        await Future.delayed(Duration(milliseconds: 100));
        emit(KindaWannaReadyState(refresh: true));
      } else {
        EasyLoading.dismiss();
      }
    });
    on<KindaWannaOpenEditEvent>((event, emit) async {
      await namedNavigator.push(Routes.I_KINDA_WANNA_RELAPSE_ROUTER,
          arguments: IKindaWannaRelapseArgs(
              isEditing: true,
              kindaWannaRelapseModel: event.kindaWannaRelapseModel));

      emit(KindaWannaRelapseInitial());
      await Future.delayed(Duration(milliseconds: 100));

      emit(KindaWannaReadyState(refresh: true));
    });
  }

  Future<List<KindaWannaRelapseModel>> getNextKindaRelapses(
      int pageNumber) async {
    return await kindaWannaRelapseRepo.getMyKindaRelapses(
        accessToken, pageNumber);
  }
}
