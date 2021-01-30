import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../configurable/estimates.dart';
import '../../../ui/widgets/planning_room/widgets.dart';
import '../../../bloc/planning_room/planning_room_bloc.dart';

class BottomCardsBar extends StatefulWidget {
  final Size deviceSize;

  BottomCardsBar({@required this.deviceSize});

  @override
  _BottomCardsBarState createState() => _BottomCardsBarState();
}

class _BottomCardsBarState extends State<BottomCardsBar>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      child: AnimatedSize(
        vsync: this,
        duration: Duration(milliseconds: 450),
        curve: Curves.linear,
        child: BlocBuilder<PlanningRoomBloc, PlanningRoomState>(
          builder: (_, state) {
            return AnimatedSwitcher(
              duration: Duration(milliseconds: 250),
              child: (state is PlanningRoomRoomStatusLoaded &&
                      !state.planningRoomStatusInfo.amSpectator &&
                      !state.planningRoomStatusInfo.alreadyEstimated &&
                      state.planningRoomStatusInfo.estimatedTaskInfo.taskId
                          .isNotEmpty)
                  ? Container(
                      key: ValueKey(1),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                      ),
                      padding: EdgeInsets.all(3),
                      height: widget.deviceSize.height * 0.12,
                      width: widget.deviceSize.width,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: Estimates.values.length,
                        itemBuilder: (context, index) {
                          if (index > 0) {
                            return GestureDetector(
                              onTap: () {
                                _showEstimateConfirmationDialog(
                                    context,
                                    state.planningRoomStatusInfo
                                        .estimatedTaskInfo.taskId,
                                    Estimates.values[index].value);
                              },
                              child: Card(
                                elevation: 5,
                                child: Container(
                                  child: Center(
                                    child: AutoSizeText(
                                      '${Estimates.values[index].value}',
                                      minFontSize: 24,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  width: widget.deviceSize.width * 0.12,
                                ),
                              ),
                            );
                          } else {
                            return Container();
                          }
                        },
                      ))
                  : Container(
                      key: ValueKey(2),
                    ),
            );
          },
        ),
      ),
    );
  }
}

void _showEstimateConfirmationDialog(
  BuildContext context,
  String estimatedTask,
  int estimate,
) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return BlocListener<PlanningRoomBloc, PlanningRoomState>(
        listener: (context, state) {
          if (state is PlanningRoomRoomStatusLoaded &&
              state.planningRoomStatusInfo.estimatedTaskInfo.taskId !=
                  estimatedTask) {
            Navigator.of(context).pop();
          }
        },
        child: ConfirmSendEstimateDialog(estimatedTask, estimate),
      );
    },
  );
}
