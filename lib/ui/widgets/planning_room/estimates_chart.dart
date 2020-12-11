import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/planning_room/planning_room_bloc.dart';
import 'circle_estimates_chart.dart';

class ExampleModel {
  int value;
  double frequency;
  Color color;

  ExampleModel(this.value, this.frequency, this.color);
}

class EstimatesChart extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => EstimatesChartState();
}

class EstimatesChartState extends State {
  List<ExampleModel> list = [
    // ExampleModel(1, 0, Colors.orange),
    // ExampleModel(1, 1, Colors.black),
    ExampleModel(2, 1, Colors.teal),
    ExampleModel(3, 3, Colors.purple),
    ExampleModel(4, 2, Colors.yellow),
    ExampleModel(5, 1, Colors.pink),
    ExampleModel(6, 2, Colors.orange),
    ExampleModel(7, 1, Colors.green[200]),
    ExampleModel(9, 1, Colors.red),
    // ExampleModel(2, 1, Colors.blue),
    // ExampleModel(2, 2, Colors.brown),
    // ExampleModel(3, 1, Colors.green)
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
                    sectionsSpace: 2,
                    centerSpaceRadius: 20,
                    sections: showingSections(),
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
              )
            ],
          );
        }
        return Container();
      },
    );
  }

  List<PieChartSectionData> showingSections() {
    return list
        .map((e) => PieChartSectionData(
              color: e.color,
              value: e.frequency,
              title: '${e.value}',
              radius: 40,
              titleStyle: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ))
        .toList();
  }
}
