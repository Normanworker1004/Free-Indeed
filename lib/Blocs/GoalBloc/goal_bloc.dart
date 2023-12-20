
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:free_indeed/Managers/named-navigator.dart';

import '../../Repo/GoalRepo.dart';

part 'goal_event.dart';

part 'goal_state.dart';

class GoalBloc extends Bloc<GoalEvent, GoalState> {
  final GoalRepo goalRepo;
  final NamedNavigator namedNavigator;
  late String accessToken;

  GoalBloc({required this.goalRepo, required this.namedNavigator})
      : super(GoalInitial()) {
    on<GoalInitializeEvent>((event, emit) async {
      accessToken ="";
      emit(GoalReadyState());
    });
    on<GoalSetGoalEvent>((event, emit) async {
      EasyLoading.show(status: "");
      bool success = await goalRepo.setGoalData(
          accessToken: accessToken,
          numberOfDays: event.goalDays,
          goalProgress: event.showProgress);
      if (success) {
        EasyLoading.dismiss();
        namedNavigator.pop();
      } else {
        EasyLoading.dismiss();
        EasyLoading.showToast("Something went wrong .. please try again later");
      }
    });
  }
}
