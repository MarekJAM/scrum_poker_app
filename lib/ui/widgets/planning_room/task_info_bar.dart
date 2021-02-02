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

  TextEditingController taskController = TextEditingController();
  TextEditingController medianController = TextEditingController();
  TextEditingController averageController = TextEditingController();

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
                    taskController.text = state
                            .planningRoomStatusInfo.estimatedTaskInfo?.taskId ??
                        '-';
                    medianController.text = state
                            .planningRoomStatusInfo.estimatedTaskInfo.median
                            ?.toString() ??
                        '-';
                    averageController.text = state
                            .planningRoomStatusInfo.estimatedTaskInfo.average
                            ?.toString() ??
                        '-';

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
                                  Expanded(child: EstimatesChart()),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      child: Column(
                                        children: [
                                          TextFormField(
                                            textAlign: TextAlign.center,
                                            decoration: InputDecoration(
                                              labelText: 'Task',
                                              labelStyle: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20),
                                              border: OutlineInputBorder(),
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                horizontal: 10,
                                                vertical: 20,
                                              ),
                                            ),
                                            readOnly: true,
                                            style: TextStyle(
                                              fontSize: 17,
                                            ),
                                            controller: taskController,
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(top: 5),
                                          ),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: TextFormField(
                                                  textAlign: TextAlign.center,
                                                  decoration: InputDecoration(
                                                    labelText: 'Median',
                                                    labelStyle:
                                                        TextStyle(fontSize: 18),
                                                    border:
                                                        OutlineInputBorder(),
                                                    contentPadding:
                                                        EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 20,
                                                    ),
                                                  ),
                                                  readOnly: true,
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                  ),
                                                  controller: medianController,
                                                ),
                                              ),
                                              Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 2)),
                                              Expanded(
                                                child: TextFormField(
                                                  textAlign: TextAlign.center,
                                                  decoration: InputDecoration(
                                                    labelText: 'Average',
                                                    labelStyle:
                                                        TextStyle(fontSize: 18),
                                                    border:
                                                        OutlineInputBorder(),
                                                    contentPadding:
                                                        EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 20,
                                                    ),
                                                  ),
                                                  readOnly: true,
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                  ),
                                                  controller: averageController,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
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
