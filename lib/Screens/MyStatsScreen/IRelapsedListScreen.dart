import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:free_indeed/Blocs/getRelapsesBloc/get_relapses_bloc.dart';
import 'package:free_indeed/Managers/Implementation/named_navigator_impl.dart';
import 'package:free_indeed/Repo/StatsRepo.dart';
import 'package:free_indeed/Screens/MyStatsScreen/components/RelapsesListTile.dart';
import 'package:free_indeed/configs/ScreenConfig.dart';
import 'package:free_indeed/configs/general_configs.dart';

class IRelapsedListPage extends StatefulWidget {
  const IRelapsedListPage({Key? key}) : super(key: key);

  @override
  State<IRelapsedListPage> createState() => _IRelapsedListPageState();
}

class _IRelapsedListPageState extends State<IRelapsedListPage> {
  GetRelapsesBloc _getRelapsesBloc = GetRelapsesBloc(
      relapsedAndStatsRepo: RelapsedAndStatsRepo(),
      namedNavigator: NamedNavigatorImpl());

  @override
  void initState() {
    _getRelapsesBloc.add(GetRelapseInitializeEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (BuildContext context) {
      return _getRelapsesBloc;
    }, child: BlocBuilder<GetRelapsesBloc, GetRelapsesState>(
        builder: (context, state) {
      if (state is GetRelapsesInitial) {
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 10),
        );
      } else if (state is GetRelapsesReadyState) {
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 10),
          child: state.relapses.isEmpty
              ? SizedBox(
                  height: ScreenConfig.screenHeight / 2,
                  child: Center(
                    child: Text(
                      "No relapses yet",
                      style: TextStyle(
                          fontSize: 15, color: GeneralConfigs.SECONDARY_COLOR),
                    ),
                  ),
                )
              : ListView.builder(
                  itemCount: state.relapses.length,
                  itemBuilder: (context, index) {
                    return RelapsesListTile(
                      relapse: state.relapses[index],
                      title: state.relapses[index][0].relapseDate!,
                      getRelapsesBloc: _getRelapsesBloc,
                    );
                  },
                ),
        );
      } else if (state is GetRelapsesLoadingState) {
        return Center(
          child: Text("Loading ..."),
        );
      } else {
        return Container();
      }
    }));
  }
}
