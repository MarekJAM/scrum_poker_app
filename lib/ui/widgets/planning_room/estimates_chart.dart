import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/planning_room/planning_room_bloc.dart';
import 'circle_estimates_chart.dart';
import '../../ui_models/pie_chart_data.dart';

class EstimatesChart extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => EstimatesChartState();
}

class EstimatesChartState extends State {
  List<PieChartDataModel> list = [
    PieChartDataModel(0, 1, Colors.grey),
    PieChartDataModel(1, 0, Colors.blue[300]),
    PieChartDataModel(2, 0, Colors.teal[300]),
    PieChartDataModel(3, 0, Colors.purple[300]),
    PieChartDataModel(4, 0, Colors.green[300]),
    PieChartDataModel(5, 0, Colors.pink[300]),
    PieChartDataModel(6, 0, Colors.orange[300]),
    PieChartDataModel(7, 0, Colors.red[300]),
    PieChartDataModel(8, 0, Colors.brown[300]),
    PieChartDataModel(9, 0, Colors.amber[300]),
    PieChartDataModel(10, 0, Colors.cyan[300]),
    PieChartDataModel(11, 0, Colors.indigo[300]),
    PieChartDataModel(12, 0, Colors.lightBlue),
    PieChartDataModel(13, 0, Colors.lightGreen[600]),
    PieChartDataModel(14, 0, Colors.lime[600]),
    PieChartDataModel(15, 0, Colors.purple[700]),
    PieChartDataModel(20, 0, Colors.teal[900]),
    PieChartDataModel(25, 0, Colors.deepOrange[600]),
    PieChartDataModel(30, 0, Colors.brown[900]),
    PieChartDataModel(40, 0, Colors.purple[900]),
    PieChartDataModel(50, 0, Colors.red[900]),
  ];
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
                  estimatedTaskId:
                      state.planningRoomStatusInfo.estimatedTaskInfo.taskId,
                  width: 150,
                  height: 150,
                  progressColor: Theme.of(context).accentColor,
                  chartProgress: chartProgress,
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
              color: e.color,
              value: e.frequency,
              title: (e.frequency > 0 && e.value > 0) ? '${e.value}' : "",
              radius: 40,
              titleStyle: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ))
        .toList();
  }

  void updateChart(Map<int, int> estimatesDistribution) {
    estimatesDistribution?.forEach((key, value) {
      list[0].frequency = 0;
      list[list.indexWhere((element) => element.value == key)].frequency =
          value.toDouble();
    });
  }

  void resetChart() {
    list.forEach((element) {
      if (element.value == 0) {
        element.frequency = 1;
      } else {
        element.frequency = 0;
      }
    });
  }
}
