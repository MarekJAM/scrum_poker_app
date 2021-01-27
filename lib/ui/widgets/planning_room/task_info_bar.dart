import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../utils/notifier.dart';
import '../../../configurable/keys.dart';
import '../../../bloc/planning_room/planning_room_bloc.dart';
import '../../../ui/widgets/planning_room/widgets.dart';

class TaskInfoBar extends StatefulWidget {
  final Size deviceSize;

  TaskInfoBar({@required this.deviceSize});

  @override
  _TaskInfoBarState createState() => _TaskInfoBarState();
}

class _TaskInfoBarState extends State<TaskInfoBar> {
  final double taskInfoBarHeight = 155;
  String taskId;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Container(
        child: Wrap(
          children: [
            Center(
              child: BlocConsumer<PlanningRoomBloc, PlanningRoomState>(
                listener: (_, state) {
                  if (state is PlanningRoomRoomStatusLoaded) {
                    if (state.planningRoomStatusInfo.estimatedTaskInfo.taskId !=
                            taskId &&
                        state.planningRoomStatusInfo.estimatedTaskInfo.taskId
                            .isNotEmpty &&
                        !state.planningRoomStatusInfo.amAdmin &&
                        taskId != null) {
                      Notifier.notify();
                    }
                  }
                },
                buildWhen: (_, state) {
                  return state is PlanningRoomRoomStatusLoaded;
                },
                builder: (_, state) {
                  if (state is PlanningRoomRoomStatusLoaded) {
                    taskId =
                        state.planningRoomStatusInfo.estimatedTaskInfo.taskId;
                    return taskId.isEmpty
                        ? Container(
                            height: taskInfoBarHeight,
                            child: Center(
                              child: Text(
                                "No estimation in progress.",
                                style: TextStyle(fontSize: 20),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          )
                        : Container(
                            width: widget.deviceSize.width,
                            child: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(left: 30),
                                  ),
                                  Expanded(child: EstimatesChart()),
                                  Expanded(
                                    child: Column(
                                      children: [
                                        Text(
                                          "${state.planningRoomStatusInfo.estimatedTaskInfo.taskId}",
                                          style: TextStyle(
                                              fontSize: 22,
                                              fontWeight: FontWeight.bold),
                                          textAlign: TextAlign.center,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(top: 5),
                                        ),
                                        Text(
                                          "Median: ${state.planningRoomStatusInfo.estimatedTaskInfo.median ?? '-'}\nAverage: ${state.planningRoomStatusInfo.estimatedTaskInfo.average ?? '-'}",
                                          key: Key(Keys.textMedianAndAverage),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                  }
                  return Container();
                },
              ),
            ),
          ],
        ),
        height: taskInfoBarHeight,
      ),
    );
  }
}
