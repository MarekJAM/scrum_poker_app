import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../ui/ui_models/estimate.dart';
import '../../../bloc/planning_room/planning_room_bloc.dart';
import 'circle_estimates_chart.dart';
import '../../ui_models/pie_chart_data.dart';
import '../../../configurable/estimates.dart';

class EstimatesChart extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => EstimatesChartState();
}

class EstimatesChartState extends State {
  List<PieChartDataModelUI> list = [];

  @override
  void initState() {
    super.initState();
    Estimates.values.forEach((el) {
      list.add(
        PieChartDataModelUI(EstimateUI(value: el.value, color: el.color),
            el.value == 0 ? 1 : 0),
      );
    });
  }

  var chartProgress = 0.0;
  String taskId;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlanningRoomBloc, PlanningRoomState>(
      buildWhen: (_, state) {
        if (state is PlanningRoomRoomStatusLoaded) {
          if (state.planningRoomStatusInfo.estimatedTaskInfo.taskId != taskId &&
              state
                  .planningRoomStatusInfo.estimatedTaskInfo.taskId.isNotEmpty &&
              taskId != null) {
            taskId = state.planningRoomStatusInfo.estimatedTaskInfo.taskId;
            chartProgress = 0.0;
          }
          return true;
        }
        return false;
      },
      builder: (context, state) {
        if (state is PlanningRoomRoomStatusLoaded) {
          return Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                height: 160,
                width: 160,
                child: PieChart(
                  PieChartData(
                    borderData: FlBorderData(
                      show: false,
                    ),
                    sectionsSpace: 0,
                    centerSpaceRadius: 20,
                    sections: showingSections(state.planningRoomStatusInfo
                        .estimatedTaskInfo.estimatesDistribution),
                  ),
                ),
              ),
              Center(
                child: CircleEstimatesChart(
                  usersEstimatedNumber: state.planningRoomStatusInfo
                      .estimatedTaskInfo.estimatesReceived,
                  usersTotalNumber: state.planningRoomStatusInfo
                      .estimatedTaskInfo.estimatesExpected,
                  width: 150,
                  height: 150,
                  progressColor: Theme.of(context).accentColor,
                ),
              ),
            ],
          );
        }
        return Container();
      },
    );
  }

  List<PieChartSectionData> showingSections(
      Map<int, int> estimatesDistribution) {
    if (estimatesDistribution == null) {
      resetChart();
    }

    updateChart(estimatesDistribution);

    return list
        .map((e) => PieChartSectionData(
              color: e.estimateUI.color,
              value: e.frequency,
              title: (e.frequency > 0 && e.estimateUI.value > 0)
                  ? '${e.estimateUI.value}'
                  : "",
              radius: 40,
              titleStyle: TextStyle(
                color: Theme.of(context).textTheme.bodyText1.color,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ))
        .toList();
  }

  void updateChart(Map<int, int> estimatesDistribution) {
    estimatesDistribution?.forEach((key, value) {
      list[0].frequency = 0;
      list[list.indexWhere((element) => element.estimateUI.value == key)]
          .frequency = value.toDouble();
    });
  }

  void resetChart() {
    list.forEach((element) {
      if (element.estimateUI.value == 0) {
        element.frequency = 1;
      } else {
        element.frequency = 0;
      }
    });
  }
}
