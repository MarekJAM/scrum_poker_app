import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/planning_room/planning_room_bloc.dart';
import 'widgets.dart';

class UserCardsContainer extends StatelessWidget {
  final Size deviceSize;

  UserCardsContainer({@required this.deviceSize});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: BlocBuilder<PlanningRoomBloc, PlanningRoomState>(
        buildWhen: (_, state) {
          return state is PlanningRoomRoomStatusLoaded;
        },
        builder: (_, state) {
          if (state is PlanningRoomRoomStatusLoaded) {
            return Wrap(
              alignment: WrapAlignment.start,
              direction: Axis.horizontal,
              children: [
                for (var estimatorCard
                    in state.planningRoomStatusInfo.estimatorCards)
                  UserCardArea(
                    card: estimatorCard,
                    deviceSize: deviceSize,
                    estimatedTask:
                        state.planningRoomStatusInfo.estimatedTaskInfo.taskId,
                  ),
                for (var spectatorCard
                    in state.planningRoomStatusInfo.spectatorCards)
                  UserCardArea(
                    card: spectatorCard,
                    deviceSize: deviceSize,
                    isSpectator: true,
                  )
              ],
            );
          }
          return Container();
        },
      ),
    );
  }
}
